SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_END_OF_WEEK]
(
	@DATE			datetime,
	-- Sun = 1, Mon = 2, Tue = 3, Wed = 4
	-- Thu = 5, Fri = 6, Sat = 7
	-- Default to Sunday
	@WEEK_START_DAY		int	= 1	
)
/*
Function: F_END_OF_WEEK
	Finds start of last day of week at 00:00:00.000
	for input datetime, @DAY, for a week that started
	on the day of week of @WEEK_START_DAY.
	Returns a null if the end of week date would
	be after 9999-12-31.
*/
returns		datetime
as
begin
declare	 @END_OF_WEEK_DATE	datetime
declare	 @FIRST_BOW		datetime
declare	 @LAST_EOW		datetime

-- Check for valid day of week, and return null if invalid
if not @WEEK_START_DAY between 1 and 7 return null

-- Find the last end of week for the passed day of week
select @LAST_EOW =convert(datetime,2958457+((@WEEK_START_DAY+6)%7))

-- Return null if end of week for date passed is after 9999-12-31
if @DATE > @LAST_EOW return null

-- Find the first valid beginning of week for the date passed.
select @FIRST_BOW = convert(datetime,-53690+((@WEEK_START_DAY+5)%7))

-- If date is before the first beginning of week for the passed day of week
-- return the day before the first beginning of week
if @DATE < @FIRST_BOW
	begin
	set @END_OF_WEEK_DATE = dateadd(dd,-1,@FIRST_BOW)
	return @END_OF_WEEK_DATE
	end

-- Find end of week for the normal case as 6 days after the beginning of week
select @END_OF_WEEK_DATE = 
	dateadd(dd,((datediff(dd,@FIRST_BOW,@DATE)/7)*7)+6,@FIRST_BOW)

return @END_OF_WEEK_DATE

end
GO

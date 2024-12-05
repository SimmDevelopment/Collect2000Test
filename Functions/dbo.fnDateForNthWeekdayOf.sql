SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fnDateForNthWeekdayOf](
	@iNth int,
	@iWeekDay int,
	@iMonth int,
	@iYear int
) RETURNS datetime
BEGIN

/*	Examples:

	-- 2nd Sunday in March of 2007.
	SELECT dbo.fnDateForNthWeekdayOf(2, 1, 3, 2007)
	
	-- 1st Sunday in November of 2009.
	SELECT dbo.fnDateForNthWeekdayOf(1, 1, 11, 2009)
*/

DECLARE	@dt datetime,		-- working variable + return value.
	@iWeekDayOnFirst int,	-- Weekday number of the first of the month (ex: DatePart(dw, '3/1/2007') if @iMonth is 3 and @iYear is 2007)
	@iDays int		-- Number of days to add to the first of the month in order to get the Nth occurrence of @iWeekDay.

	
SELECT	-- Start with 1st of the given month.
	@dt = convert(datetime, 
		convert(varchar(2),@iMonth) + '/1/' +
		convert(char(4), @iYear)
	),
	-- Get the weekday of the date above.
	@iWeekDayOnFirst = DATEPART( dw, @dt ),
	-- Figure out how many days to add to the first to get the Nth occurrence of the given week day.
	@iDays = ( (7 - (@iWeekDayOnFirst - @iWeekDay)) % 7 ) + ((7 * @iNth) - 7),
	-- Add the number of days to the first of the given month to get the return value.
	@dt = DATEADD( d, @iDays, @dt )

RETURN	@dt

END

GO

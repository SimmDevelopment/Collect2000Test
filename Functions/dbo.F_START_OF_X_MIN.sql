SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_X_MIN]
	(
	@DAY datetime,
	@INTERVAL int
	)
returns  datetime
as
/*
Function: F_START_OF_X_MIN
	Finds beginning of @INTERVAL minute period
	for input datetime, @DAY.
	If @INTERVAL = zero, returns @DAY.
	Valid for all SQL Server datetimes.
*/
begin

-- Prevent divide by zero error
if @INTERVAL = 0 return @DAY

declare @BASE_DAY datetime
set  @BASE_DAY = dateadd(dd,datediff(dd,0,@Day),0)

return  dateadd(mi,(datediff(mi,@BASE_DAY,@Day)/@INTERVAL)*@INTERVAL,@BASE_DAY)

end
GO

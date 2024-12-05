SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_YEAR]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_YEAR
	Finds start of first day of year at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(yy,datediff(yy,0,@DAY),0)

end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_05_MIN]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_05_MIN
	Finds beginning of 5 minute period
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(mi,(datepart(mi,@Day)/5)*5,dateadd(hh,datediff(hh,0,@Day),0))

end
GO

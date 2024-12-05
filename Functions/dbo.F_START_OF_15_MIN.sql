SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_15_MIN]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_15_MIN
	Finds beginning of 15 minute period
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(mi,(datepart(mi,@Day)/15)*15,dateadd(hh,datediff(hh,0,@Day),0))

end
GO

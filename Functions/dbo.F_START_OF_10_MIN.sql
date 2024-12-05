SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_10_MIN]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_10_MIN
	Finds beginning of 10 minute period
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(mi,(datepart(mi,@Day)/10)*10,dateadd(hh,datediff(hh,0,@Day),0))

end
GO

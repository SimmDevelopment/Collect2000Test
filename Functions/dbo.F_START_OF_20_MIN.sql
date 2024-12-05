SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_20_MIN]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_20_MIN
	Finds beginning of 20 minute period
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(mi,(datepart(mi,@Day)/20)*20,dateadd(hh,datediff(hh,0,@Day),0))

end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_HOUR]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_HOUR
	Finds beginning of hour
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return   dateadd(hh,datediff(hh,0,@DAY),0)

end
GO

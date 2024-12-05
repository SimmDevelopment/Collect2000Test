SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_END_OF_YEAR]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_END_OF_YEAR
	Finds start of last day of year at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(yy,datediff(yy,-1,@DAY),-1)

end
GO

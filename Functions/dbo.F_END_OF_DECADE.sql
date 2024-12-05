SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_END_OF_DECADE]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_END_OF_DECADE
	Finds start of last day of decade at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes
*/
begin

return   dateadd(yy,9-(year(@day)%10),dateadd(yy,datediff(yy,-1,@DAY),-1))

end
GO

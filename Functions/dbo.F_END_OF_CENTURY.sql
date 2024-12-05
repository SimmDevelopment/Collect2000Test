SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_END_OF_CENTURY]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_END_OF_CENTURY
	Finds start of last day of century at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes
*/
begin

return   dateadd(yy,99-(year(@day)%100),dateadd(yy,datediff(yy,-1,@DAY),-1))

end
GO

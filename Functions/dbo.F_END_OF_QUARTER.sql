SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_END_OF_QUARTER]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_END_OF_QUARTER
	Finds start of last day of quarter at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return   dateadd(qq,datediff(qq,-1,@DAY),-1)

end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_MINUTE]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_MINUTE
	Finds beginning of minute
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return   dateadd(ms,-(datepart(ss,@DAY)*1000)-datepart(ms,@DAY),@DAY)

end
GO

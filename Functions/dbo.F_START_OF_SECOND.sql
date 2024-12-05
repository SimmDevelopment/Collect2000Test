SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_SECOND]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_SECOND
	Finds beginning of second
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return   dateadd(ms,-datepart(ms,@DAY),@DAY)

end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_DECADE]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_DECADE
	Finds start of first day of decade at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes >= 1760-01-01 00:00:00.000
	Returns null if @DAY < 1760-01-01 00:00:00.000
*/
begin

declare @BASE_DAY datetime
select  @BASE_DAY = '17600101'

IF @DAY < @BASE_DAY return null 

return   dateadd(yy,(datediff(yy,@BASE_DAY,@DAY)/10)*10,@BASE_DAY)	

end
GO

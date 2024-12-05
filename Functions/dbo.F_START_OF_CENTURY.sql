SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[F_START_OF_CENTURY]
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_CENTURY
	Finds start of first day of century at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes >= 1800-01-01 00:00:00.000
	Returns null if @DAY < 1800-01-01 00:00:00.000
*/
begin

declare @BASE_DAY datetime
select  @BASE_DAY = '18000101'

IF @DAY < @BASE_DAY return null 

return   dateadd(yy,(datediff(yy,@BASE_DAY,@DAY)/100)*100,@BASE_DAY)	

end
GO

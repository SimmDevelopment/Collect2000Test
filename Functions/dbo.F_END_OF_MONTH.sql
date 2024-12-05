SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[F_END_OF_MONTH]
	( @DAY datetime )
returns  datetime
as
/*
	Function: F_END_OF_MONTH
	Finds start of last day of month at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/

/* Changes
	BGM 5/2/2016 Changed method to end of month at 11:59:00.000 instead of 00:00:00.000
*/


begin
		--New Mehod returns last day of month up to 11:59:59.000 PM
return  DATEADD(mm, 1, DATEADD(ss, -1, @DAY))
--Old Method returns end of month at 00:00:00.000
--dateadd(mm,datediff(mm,-1,@DAY),-1)

end
GO

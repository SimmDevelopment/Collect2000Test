SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [collector].[Custom_Report_ArrowActivity]
@Customer varchar(7),
@startDate datetime,
@endDate datetime
AS

BEGIN
SELECT 
LoggedDateTime as [Date],
FTE,
Hours,
Calls,
Contacts,
Promises
FROM 
ArrowActivityReport
WHERE
Customer = @Customer and loggeddatetime >= @startdate and loggeddatetime <= @enddate
ORder by loggeddatetime asc
END
GO

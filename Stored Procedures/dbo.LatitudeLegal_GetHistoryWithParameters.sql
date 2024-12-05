SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LatitudeLegal_GetHistoryWithParameters]
@type varchar(15),
@startdate datetime,
@enddate datetime


AS

--Get Headers
SELECT
LLHistoryID as [History ID],
Type as [Type],
EndedDateTime as [Date],
SentReconciliation as [Sent Reconciliation],
Test as [Test],
LatitudeUserName as [User]

FROM
LatitudeLegal_History 

WHERE
Type = @type and EndedDateTime between @startdate and @enddate

ORDER BY Endeddatetime desc

--Get Details
SELECT
d.LLHistoryDetailID as [Detail ID],
d.LLHistoryID as [History ID],
d.FileName as [File Name],
CASE d.attorneyid WHEN -1 THEN 'All Applicable' ELSE a.name END as [Attorney]

FROM 
LatitudeLegal_HistoryDetail d WITH (NOLOCK) JOIN LatitudeLegal_History h WITH (NOLOCK)
ON d.llhistoryid = h.llhistoryid LEFT OUTER JOIN attorney a WITH (NOLOCK) ON a.attorneyid = d.attorneyid

WHERE
h.Type = @type and h.endeddatetime between @startdate and @enddate

ORDER BY h.endeddatetime desc



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_NCO_Report_Acknowledgement]
@customerList varchar(8000),
@startDate datetime,
@endDate datetime
AS

SELECT account, isnull(m.id2,m.account) as id2, fw.TheData ForwarderID, fm.TheData FirmID, received
FROM master m INNER JOIN status s
	on m.status = s.code INNER JOIN MiscExtra fw
	ON m.number = fw.Number AND fw.Title = 'Forw_Id' INNER JOIN MiscExtra fm 
	ON m.number = fm.number AND fm.Title = 'Firm_Id'
WHERE customer IN (SELECT string FROM dbo.StringToSet(@customerList, '|'))
	 AND received BETWEEN @startDate AND @endDate

GO

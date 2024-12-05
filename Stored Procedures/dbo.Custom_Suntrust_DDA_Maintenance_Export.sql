SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Suntrust_DDA_Maintenance_Export] 
	-- Add the parameters for the stored procedure here
	
	@invoice VARCHAR(8000),
	@startDate DATETIME,
	@endDate DATETIME	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SET @startDate = DATEADD(dd, 0, dbo.date(@startDate))
SET @endDate =  DATEADD(s, -1, DATEADD(dd, 1, dbo.date(@endDate)))



    -- Insert statements for procedure here
	SELECT '005' AS recfmt, 'V0085' AS vendid, (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'pla.0.bank') AS bank,
m.account, CASE WHEN batchtype = 'pu' AND status <> 'sif' THEN '02' WHEN batchtype = 'pu' AND m.status = 'sif' THEN '03' 
	WHEN batchtype LIKE 'pc' THEN '10' WHEN batchtype = 'pur' THEN '04'  END AS transcode, p.Invoiced AS transdate,
	p.paid1 AS amount, '' AS addr1, '' AS addr2, '' AS addr3, '' AS city, '' AS STATE, '' AS zip, '' AS homeph, '' AS workph, '' AS notes
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE p.customer = '0001037' AND batchtype IN ('pu', 'pur', 'pc') AND invoice IN (select string from dbo.CustomStringToSet(@invoice, '|'))

UNION ALL

SELECT '005' AS recfmt, 'V0085' AS vendid, (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'pla.0.bank') AS bank,
m.account, CASE WHEN m.status = 'aty' then '11' else '05' end AS transcode, m.closed AS transdate,
	'' AS amount, '' AS addr1, '' AS addr2, '' AS addr3, '' AS city, '' AS STATE, '' AS zip, '' AS homeph, '' AS workph, '' AS notes
FROM master m WITH (NOLOCK)
WHERE customer = '0001037' AND status IN ('cnd', 'cad', 'aex', 'rsk', 'aty') AND closed BETWEEN @startDate AND @endDate

UNION ALL

SELECT '005' AS recfmt, 'V0085' AS vendid, (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'pla.0.bank') AS bank,
m.account, '06' AS transcode, m.closed AS transdate,
	'' AS amount, '' AS addr1, '' AS addr2, '' AS addr3, '' AS city, '' AS STATE, '' AS zip, '' AS homeph, '' AS workph, '' AS notes
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
  LEFT OUTER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE m.customer = '0001037' AND m.status IN ('bky', 'b07', 'b11', 'b13') AND closed BETWEEN @startDate AND @endDate

UNION ALL

SELECT '005' AS recfmt, 'V0085' AS vendid, (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'pla.0.bank') AS bank,
m.account, '20' AS transcode, ah.DateChanged AS transdate,
	'' AS amount, ah.NewStreet1 AS addr1, ah.NewStreet2 AS addr2, '' AS addr3, ah.NewCity AS city, ah.NewState AS STATE, ah.NewZipcode AS zip, '' AS homeph, '' AS workph, '' AS notes
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
	WHERE m.customer = '0001037' AND ah.DateChanged BETWEEN @startDate AND @endDate
	
UNION ALL

SELECT '005' AS recfmt, 'V0085' AS vendid, (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'pla.0.bank') AS bank,
m.account, '20' AS transcode, pm.DateAdded AS transdate,
	'' AS amount, '' AS addr1, '' AS addr2, '' AS addr3, '' AS city, '' AS STATE, '' AS zip, CASE WHEN pm.PhoneTypeID = 1 THEN pm.PhoneNumber ELSE '' end AS homeph, CASE WHEN pm.PhoneTypeID = 2 THEN pm.phonenumber else '' END AS workph, '' AS notes
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	LEFT OUTER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON d.DebtorID = pm.DebtorID
WHERE m.customer = '0001037' AND (dbo.date(pm.DateAdded) = '20141013' AND pm.LoginName <> 'sync') AND pm.DateAdded BETWEEN @startDate AND @endDate

END
GO

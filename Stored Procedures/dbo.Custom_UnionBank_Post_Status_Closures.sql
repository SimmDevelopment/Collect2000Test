SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 12/16/2020
-- Description:	Export Union Bank Closed accounts for the date range.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_UnionBank_Post_Status_Closures]
	-- Add the parameters for the stored procedure here
	@startdate DATETIME,
	@enddate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT m.account AS [Account Number], d.lastName AS [Last Name], d.firstName AS [First Name], m.original AS [Assignment Balance], m.closed AS [Date Reported],
s.Description AS [Status/Closure reason], '' AS Comments, ISNULL(da.Firm, '') AS [Attorney Firm],
ISNULL(da.Name, '') AS [Informant/Attorney], ISNULL(da.Phone, '') AS [Contact #], ISNULL(CONVERT(VARCHAR(10), COALESCE(d2.dod, b.DischargeDate, b.DateFiled), 101), '') AS [Date of Death/BK],
ISNULL(b.CaseNumber, '') AS [BK Case], ISNULL(CONVERT(VARCHAR(2), b.Chapter), '') AS [BK Chapter],
CASE WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') AND customer = '0001118' THEN '1B' 
			WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') AND customer = '0002570' THEN '2B'
			WHEN m.status IN ('CAD', 'CND') THEN 'CD'
			WHEN m.status IN ('DEC') AND customer = '0001118' THEN '1D'
			WHEN m.status IN ('DEC') AND customer = '0002570' THEN '2D'
			WHEN m.status = 'PIF' THEN 'ZP'
			WHEN m.status = 'SIF' THEN 'ZP'
			WHEN m.status IN ('RSK') AND customer = '0001118' THEN '1L'
			WHEN m.status IN ('RSK') AND customer = '0002570' THEN '2L'
			ELSE '  ' END AS [SIMM UPC 14 Update]
FROM dbo.master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN dbo.status s WITH (NOLOCK) ON m.status = s.code
LEFT OUTER JOIN dbo.DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
LEFT OUTER JOIN dbo.Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID
LEFT OUTER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE customer = '0001118' AND (( m.status NOT IN ('SIF', 'PIF') AND closed BETWEEN @startdate AND @enddate ) OR
(m.status in ('SIF','PIF') AND CAST(m.closed AS DATE) BETWEEN CAST(DATEADD(dd, -10, @startdate) AS DATE) AND CAST(DATEADD(dd, -10, @enddate) AS DATE)))

--SELECT m.account AS [Account Number], d.lastName AS [Last Name], d.firstName AS [First Name], m.original AS [Assignment Balance], m.closed AS [Date Reported],
--s.Description AS [Status/Closure reason], '' AS Comments, ISNULL(da.Firm, '') AS [Attorney Firm],
--ISNULL(da.Name, '') AS [Informant/Attorney], ISNULL(da.Phone, '') AS [Contact #], ISNULL(COALESCE(d2.dod, b.DischargeDate, b.DateFiled), '') AS [Date of Death/BK],
--ISNULL(b.CaseNumber, '') AS [BK Case], ISNULL(b.Chapter, '') AS [BK Chapter]
--FROM dbo.master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
--INNER JOIN dbo.status s WITH (NOLOCK) ON m.status = s.code
--LEFT OUTER JOIN dbo.DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
--LEFT OUTER JOIN dbo.Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID
--LEFT OUTER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
--WHERE customer = '0001118' AND closed BETWEEN @startdate AND @enddate

END
GO

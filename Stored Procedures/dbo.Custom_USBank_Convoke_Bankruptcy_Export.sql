SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Convoke_Bankruptcy_Export]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT m.account AS AccountNumber, m.number AS ExternalUniqueIdentifier, CONVERT(VARCHAR(10), b.DateFiled, 120) AS FilingDate,
CASE b.Chapter WHEN 7 THEN 'Chapter7' WHEN 11 THEN 'Chapter11' WHEN 13 THEN 'Chapter13' ELSE 'Other' END AS ChapterFiling,
b.CaseNumber AS BKCaseNumber, REPLACE(isnull(CONVERT(VARCHAR(10), b.DismissalDate, 120), ''), '1900-01-01', '') AS DismissalDate, '' AS NotificationOfDismassalDate,
REPLACE(ISNULL(CONVERT(VARCHAR(10), b.DischargeDate, 120), ''), '1900-01-01', '') AS DischargeDate, '' NotificationOfDischargeDate, 'simmsa' AS PartnerIdentifier,
ISNULL(da.Name, '') AS BKAttorneyName, coalesce(b.courtdistrict, b.CourtDivision) AS BKCourtName
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE customer = '0001063'--IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 289)
AND m.status IN ('BKY', 'B07', 'B11', 'B13') AND closed BETWEEN @startDate AND @endDate

END
GO

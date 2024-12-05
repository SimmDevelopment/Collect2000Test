SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Convoke_ScrubLog_Export]
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

SELECT m.account AS AccountNumber, 'simmsa' AS PartnerIdentifier, m.number AS ExternalUniqueIdentifier, 
CONVERT(VARCHAR(10), sh.CreationDate, 120) AS ScrubDate, 
CASE (SELECT TOP 1 T_Z FROM Zipcodes WITH (NOLOCK) WHERE m.state = STATE) WHEN 4 THEN 'Atlantic' WHEN 5 THEN 'Eastern' WHEN 6 THEN 'Central' WHEN 7 THEN 'Mountain' WHEN 8 THEN 'Pacific' WHEN 9 THEN 'Alaskan' WHEN 10 THEN 'Hawaiian' END AS TimeZone,
CASE WHEN sh.serviceid = 5024 THEN 'Bankruptcy' ELSE 'Probate' END AS ScrubType,
CASE WHEN serviceid = '5024' AND (SELECT TOP 1 requestid FROM Services_TLO_Bankruptcy WHERE sh.RequestID = RequestID) IS NOT NULL THEN 'Positive'
WHEN serviceid = '5025' AND (SELECT TOP 1 requestid FROM Services_TLO_Deceased WHERE sh.RequestID = RequestID) IS NOT NULL THEN 'Positive' ELSE 'Negative' END  AS ScrubResult, 
CASE WHEN serviceid = '5025' THEN ISNULL((SELECT CONVERT(VARCHAR(10), DateOfDeath, 120) FROM Services_TLO_Deceased  WITH (NOLOCK) WHERE sh.requestid = requestid), '')  ELSE '' END AS DateOfDeath, CASE WHEN serviceid = 5024 THEN ISNULL((SELECT CONVERT(VARCHAR(10),  FileDate, 120) FROM services_tlo_bankruptcy WITH (NOLOCK) WHERE sh.requestid = requestid), '') ELSE '' END AS BankruptcyFilingDate
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN ServiceHistory sh WITH (NOLOCK) ON m.number = sh.AcctID
WHERE customer = '0001063'--IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 289)
AND sh.CreationDate BETWEEN @startDate AND @endDate AND ServiceID IN (5024, 5025) --(5023, 5024)

END
GO

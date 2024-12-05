SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/30/2018
-- Description:	Creates Status File for BrighTree
-- =============================================
CREATE PROCEDURE [dbo].[Custom_BrighTree_Export_CollectionStatus_File]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--Modify the start and end dates to the start of the day 00:00:00 and end of day 23:59:59
SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

--Get Account information
SELECT DISTINCT m.id1 AS AgencyPlacementID, m.Account AS PatientAccountNo, m.originalcreditor AS CreditorName, m.name AS RSPName,
--Get any Address or phone changes
CASE WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate then m.street1 ELSE '' end AS NewAddress1,
CASE WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate then m.street2 ELSE '' end  AS Newaddress2,
CASE WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate then m.city ELSE '' end  AS NewCity,
CASE WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate then m.STATE ELSE '' end  AS NewState,
CASE WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate then m.zipcode ELSE '' end  AS NewPostalCode,
CASE WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate then m.homephone ELSE '' end  AS NewPhone,
--Get Status Change Information, this information is always required for all records in the file.
CASE WHEN received BETWEEN @startDate AND @endDate THEN CONVERT(VARCHAR(10), received, 101) 
WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate THEN ISNULL((SELECT TOP 1 CONVERT(VARCHAR(10), DateChanged, 101) FROM master ma WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON ma.number = sh.AccountID WHERE m.number = ma.number ORDER BY sh.DateChanged DESC), CONVERT(varchar(10), m.received, 101))
ELSE (SELECT TOP 1 CONVERT(VARCHAR(10), DateChanged, 101) FROM master ma WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON ma.number = sh.AccountID WHERE m.number = ma.number AND sh.DateChanged BETWEEN @startDate AND @endDate ORDER BY sh.DateChanged DESC) END AS DateChanged,
CASE WHEN received BETWEEN @startDate AND @endDate THEN 'NEW' 
WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate THEN ISNULL((SELECT TOP 1 NewStatus FROM master ma WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON ma.number = sh.AccountID WHERE m.number = ma.number ORDER BY sh.DateChanged DESC), 'NEW')
ELSE (SELECT TOP 1 NewStatus FROM master ma WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON ma.number = sh.AccountID WHERE m.number = ma.number ORDER BY sh.DateChanged DESC) END AS StatusCode,
CASE WHEN received BETWEEN @startDate AND @endDate THEN 'NEW STATUS' 
WHEN ah.DateChanged BETWEEN @startDate AND @endDate OR ph.DateChanged BETWEEN @startDate AND @endDate THEN ISNULL((SELECT TOP 1 s.Description FROM master ma WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON ma.number = sh.AccountID INNER JOIN status s WITH (NOLOCK) ON sh.NewStatus = s.code WHERE m.number = ma.number ORDER BY sh.DateChanged DESC), 'NEW STATUS')
ELSE (SELECT TOP 1 s.Description FROM master ma WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON ma.number = sh.AccountID INNER JOIN status s WITH (NOLOCK) ON sh.NewStatus = s.code WHERE m.number = ma.number ORDER BY sh.DateChanged DESC) END AS StatusDesc,
--Decease Information
ISNULL(CONVERT(VARCHAR(10), d.dod, 101), '') AS DeceasedDate,
--Credit Bureau reported information
ISNULL((SELECT TOP 1 CONVERT(varchar(10), datereported, 101) FROM cbr_metro2_accounts WITH (NOLOCK) WHERE accountID = m.number AND accountStatus = '93' ORDER BY dateReported), '') AS CreditBureauSentDate,
ISNULL((SELECT TOP 1 CONVERT(varchar(10), datereported, 101) FROM cbr_metro2_accounts WITH (NOLOCK) WHERE accountID = m.number AND accountStatus = 'DA' ORDER BY dateReported DESC), '') AS CreditBureauRemovedDate,
--Bankruptcy information
ISNULL(CONVERT(VARCHAR(2), b.Chapter), '') AS BankruptcyChapter,
ISNULL(b.CaseNumber, '') AS BankruptcyCase,
ISNULL(CONVERT(VARCHAR(10), b.DateFiled, 101), '') AS BankruptcyDate,
CASE WHEN b.chapter IS NOT NULL THEN ISNULL(da.Name, '') ELSE '' END AS BankruptcyAttorney,
CASE WHEN b.chapter IS NOT NULL THEN ISNULL(da.Phone, '') ELSE '' END AS BankruptcyAttorneyPhone,
--Balance and SIF information
CASE WHEN m.status = 'SIF' THEN 0 ELSE m.current0 END AS CurrentBalance,
CASE WHEN m.status = 'SIF' THEN m.current0 ELSE '' END AS SettlementAdjustment
FROM master m WITH (NOLOCK) 
LEFT OUTER JOIN Deceased d WITH (NOLOCK) ON m.number = d.AccountID
LEFT OUTER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID
LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON m.number = da.AccountID
LEFT OUTER JOIN AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID
LEFT OUTER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
LEFT OUTER JOIN cbr_metro2_accounts cma WITH (NOLOCK) ON m.number = cma.accountID
LEFT OUTER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
INNER JOIN status s1 WITH (NOLOCK) ON m.status = s1.code
WHERE customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 102)
AND (received BETWEEN @startDate AND @endDate OR ah.DateChanged BETWEEN @startDate AND @endDate 
	OR ph.DateChanged BETWEEN @startDate AND @endDate OR d.TransmittedDate BETWEEN @startDate AND @endDate
	OR b.TransmittedDate BETWEEN @startDate AND @endDate OR cma.dateReported BETWEEN @startDate AND @endDate
	OR sh.DateChanged BETWEEN @startDate AND @endDate)
--AND closed IS null

END
GO

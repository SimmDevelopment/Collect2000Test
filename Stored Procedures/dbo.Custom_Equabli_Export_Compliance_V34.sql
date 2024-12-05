SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 12/06/2023
-- Description:	Export via Exchange Compliance doc for Equabli
-- Changes:		12/18/2023 BGM Updated Compliance Reason field to send data as needed.
--							   Updated BK Money fields to return Prin, Int, Fees  When BK reported
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Compliance_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Exec Custom_Equabli_Export_Compliance_V34 '20231201', '20231219'


SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
	SELECT 'compliance' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.equabliClientID') AS equabliClientId
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Con.' + CONVERT(VARCHAR(2), d.Seq) + '.clientConsumerNumber') AS clientConsumerNumber
, d.DebtorMemo AS equabliConsumerId
, CASE WHEN m.status IN ('DEC', 'VRD', 'ALV') THEN 'DC'
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate) THEN 'BK'
		WHEN m.status IN ('CND', 'CAD') THEN 'CD'
		WHEN m.status = 'MIL' THEN 'SC'
		WHEN m.status IN ('RSK', 'LIT') THEN 'LT'
		WHEN m.status IN ('FRD', 'EFD') THEN 'DI'
		END AS complianceType
, CASE WHEN m.status = 'DEC' THEN ''
		WHEN m.status IN ('BKY', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate AND b.Chapter = '')  THEN 'BU'
		WHEN m.status IN ('B07', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate AND b.Chapter = '7' AND b.HasAsset = 1)  THEN '7A'
		WHEN m.status IN ('B07', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate AND b.Chapter = '7')  THEN 'B7'
		WHEN m.status IN ('B11', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate AND b.Chapter = '11')  THEN 'B1'
		WHEN m.status IN ('B13', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate) AND b.Chapter = '13'  THEN 'B3'
		WHEN m.status IN ('CND', 'CAD') THEN 'MO'
		WHEN m.status IN ('VCD') THEN 'VC'
		WHEN m.status IN ('WCD') THEN 'WC'
		WHEN m.status = 'MIL' THEN ''
		WHEN m.status = 'RSK' THEN ''
		WHEN m.status = 'FRD' THEN ''
		ELSE '' 
		END AS complianceSubType
, CASE WHEN m.status = 'DEC' THEN 'Debtor is Deceased'
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate)  THEN 'Bankruptcy Found'
		WHEN m.status IN ('PBK') THEN 'Bankruptcy Pending'
		WHEN m.status IN ('CND', 'CAD') THEN 'Cease and Desist Requested'
		WHEN m.status = 'MIL' THEN 'Active Duty Military'
		WHEN m.status = 'RSK' THEN 'Litigious Debtor'
		WHEN m.status IN ('EFD', 'FRD') THEN 'Fraud'
		WHEN m.status = 'VRD' THEN 'Verbal Notification of Deceased'
		WHEN m.status = 'ALV' THEN 'Debtor is Alive'
		ELSE ''
		END AS description
, CASE WHEN m.status = 'DEC' THEN FORMAT(d1.DOD, 'yyyy-MM-dd')
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate)  THEN FORMAT(b.DateFiled, 'yyyy-MM-dd')
		WHEN m.status IN ('CND', 'CAD') THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'MIL' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'RSK' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'FRD' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'EFD' THEN FORMAT(GETDATE(), 'yyyy-MM-dd')
		WHEN m.status = 'VRD' THEN FORMAT(GETDATE(), 'yyyy-MM-dd')
		WHEN m.status = 'ALV' THEN FORMAT(GETDATE(), 'yyyy-MM-dd')
		ELSE ''
		END AS filingDate
, CASE WHEN m.status = 'DEC' THEN 'OT'
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate)  THEN 'LT'
		WHEN m.status IN ('CND', 'CAD') THEN 'VC'
		WHEN m.status = 'MIL' THEN 'LT'
		WHEN m.status = 'RSK' THEN 'OT'
		WHEN m.status IN ('EFD', 'FRD', 'PBK', 'VRD', 'ALV') THEN 'VC'
		ELSE 'UN'
		END AS complianceChannel
, CASE WHEN m.status = 'DEC' THEN 'U'
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate)  THEN 'W'
		WHEN m.status IN ('CND', 'CAD') THEN 'V'
		WHEN m.status = 'MIL' THEN 'W'
		WHEN m.status = 'RSK' THEN 'U'
		WHEN m.status IN ('EFD', 'FRD', 'PBK', 'VRD', 'ALV') THEN 'V'
		ELSE 'U'
		END AS complianceCreationMode
, CASE WHEN m.status = 'DEC' THEN 'CS'
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate)  THEN 'CS'
		WHEN m.status IN ('CND', 'CAD') THEN 'CN'
		WHEN m.status = 'MIL' THEN 'CS'
		WHEN m.status = 'RSK' THEN 'CS'
		WHEN m.status = 'FRD' THEN 'CS'
		WHEN m.status IN ('EFD', 'PBK') THEN 'NW'
		WHEN m.status = 'VRD' THEN 'IP'
		WHEN m.status = 'AVL' THEN 'CN'
		ELSE 'NW'
		END AS complianceStatus
, '' AS resolutionNote
, CASE WHEN m.status = 'DEC' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status IN ('CND', 'CAD') THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'MIL' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'RSK' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate THEN FORMAT(b.UpdatedDate, 'yyyy-MM-dd')
		WHEN m.status = 'FRD' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'ALV' THEN FORMAT(GETDATE(), 'yyyy-MM-dd')
		ELSE ''
		END AS resolvedDate
, '' AS contactDetails
, CASE WHEN m.status IN ('FRD', 'EFD') THEN 'FD'
		ELSE ''
		END AS complianceReason
, 'N' AS validationRequiredFlag
, '' AS remark
, CASE WHEN m.status = 'DEC' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status IN ('CND', 'CAD') THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'MIL' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'RSK' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate THEN FORMAT(b.UpdatedDate, 'yyyy-MM-dd')
		WHEN m.status = 'FRD' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status IN ('EFD', 'PBK', 'VRD', 'ALV') THEN FORMAT(GETDATE(), 'yyyy-MM-dd')
		ELSE ''
		END AS raisedDate
, '' AS regulatoryBody
, '' AS firstSLADate
, '' AS secondSLADate
, ISNULL(b.CaseNumber, '') AS caseFileNumber
, CASE WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate) THEN m.current1 ELSE '' END AS bkPrincipal
, CASE WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate) THEN m.current2 ELSE '' END AS bkInterest
, CASE WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate) THEN (ISNULL(m.current3, 0) + ISNULL(m.current4, 0) + ISNULL(m.current5, 0) + ISNULL(m.current8, 0)) ELSE '' END AS bkFees
, CASE WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'PBK') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate) THEN m.current0 ELSE '' END AS totalAmount
, ISNULL(b.CourtCity, '') AS courtCity
, '' AS externalSystemId
, d.SSN AS consumerIdentificationNumber
, '' AS bankruptcyType
, '' AS complianceAction
, '' AS defendant
, '' AS balanceAtTimeOfEvent
, CASE WHEN da.debtorid IS NOT NULL THEN 'Y' ELSE '' END AS attorneyRetained
, ISNULL(FORMAT(da.DateCreated, 'yyyy-MM-dd'), '') AS attorneyDate
, CASE WHEN m.status IN ('PBK', 'BKY', 'B07', 'B11', 'B13') THEN 'BK' ELSE '' END AS attorneyType
, ISNULL(da.Fax, '') AS attorneyOfficeFax
, '' AS dueClaimProofDate
, '' AS filedClaimProofDate
, CASE WHEN m.status = 'DEC' THEN FORMAT(d1.DOD, 'yyyy-MM-dd')
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate)  THEN FORMAT(b.DateFiled, 'yyyy-MM-dd')
		WHEN m.status IN ('CND', 'CAD') THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'MIL' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'RSK' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status = 'FRD' THEN FORMAT(m.closed, 'yyyy-MM-dd')
		WHEN m.status IN ('EFD', 'PBK', 'VRD', 'ALV') THEN FORMAT(getdate(), 'yyyy-MM-dd')
		ELSE ''
		END AS eventDate
, '' AS balanceAtTimeOfNotification
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
LEFT OUTER JOIN Deceased d1 WITH (NOLOCK) ON d.DebtorID = d1.DebtorID
LEFT OUTER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE customer IN (3101, 3102, 3103, 3104, 3105)
AND (
(m.status IN ('DEC', 'BKY', 'B07', 'B11', 'B13', 'CND', 'CAD', 'MIL', 'RSK', 'FRD', 'LIT')
AND CAST(closed AS DATE) BETWEEN @startdate AND @endDate) OR 
(CAST(b.UpdatedDate AS DATE) BETWEEN @startDate AND @endDate)
OR (m.number IN (SELECT TOP 1 sh.AccountID FROM StatusHistory sh WITH (NOLOCK) WHERE m.number = sh.AccountID AND CAST(sh.DateChanged AS DATE) BETWEEN @startDate AND @endDate AND sh.NEWStatus IN ('EFD', 'PBK', 'VRD') ORDER BY sh.DateChanged)) 
OR (m.number IN (SELECT TOP 1 sh.AccountID FROM StatusHistory sh WITH (NOLOCK) WHERE m.number = sh.AccountID AND CAST(sh.DateChanged AS DATE) BETWEEN @startDate AND @endDate AND sh.OldStatus IN ('VRD') AND sh.NewStatus = 'ALV' ORDER BY sh.DateChanged)) 
)
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kia Evans
-- Create date: 06/01/2024
-- Description:	Export Transaction File for M&T
-- =============================================
CREATE PROCEDURE [dbo].[Custom_MT_CACS_TransAction_File_Outgoing] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--exec Custom_USBank_TransAction_File_Outgoing '20190420', '20190430'
--SET @startDate = '20190411'
--SET @endDate = '20190411'

SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

--Record 425 New accounts
--#region Record 425s
SELECT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	'3M' AS AgyActCode, CONVERT(VARCHAR(8), received, 112) AS AgyActDate, '000000' AS AgyActTime, 'SIM    ' AS AgcyId,
	'SYSTEM  ' AS AgyCollID, 'New Account' AS AgyHistoryTxt, '' AS PhoneNumber, '' AS PhoneExtension, '' AS PhoneFormat, '' AS ContactResult,
	'' AS PlaceCalled, '' AS PartyContacted
FROM master m WITH (NOLOCK)
WHERE received BETWEEN @startDate AND @endDate
AND customer IN ('0003107','0003109')

UNION ALL

--Record 425 Address Update
SELECT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	'3R' AS AgyActCode, CONVERT(VARCHAR(8), ah.DateChanged, 112) AS AgyActDate, '000000' AS AgyActTime, 'SIM    ' AS AgcyId,
	'SYSTEM  ' AS AgyCollID, d.SpouseJobName + ', ' + d.Street1 + ', ' + d.Street2 + ', ' + d.City + ', ' + d.State + ', ' + d.Zipcode AS AgyHistoryTxt,
	'' AS PhoneNumber, '' AS PhoneExtension, '01' AS PhoneFormat, '' AS ContactResult,'' AS PlaceCalled, '' AS PartyContacted
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
LEFT OUTER JOIN AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID
WHERE (ah.DateChanged BETWEEN @startDate AND @endDate)
AND customer IN ('0003107','0003109')

UNION ALL

--Record 425 Validation of Debt
SELECT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	'3R' AS AgyActCode, CONVERT(VARCHAR(8), received, 112) AS AgyActDate, '000000' AS AgyActTime, 'SIM    ' AS AgcyId,
	'SYSTEM  ' AS AgyCollID, CONVERT(VARCHAR(10), sh.DateChanged, 101) + ', ' + d.name + ', All Available Dates'  AS AgyHistoryTxt,
	'' AS PhoneNumber, '' AS PhoneExtension, '' AS PhoneFormat, '' AS ContactResult,'' AS PlaceCalled, '' AS PartyContacted
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.status IN ('VAL') AND sh.DateChanged BETWEEN @startDate AND @endDate
AND customer IN ('0003107','0003109')

UNION ALL

--Record 425 Scrubs
SELECT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '3R'
		 WHEN action = 'DECD' AND result = 'IF' THEN '3R'
		 WHEN action = 'BNKO' AND result = 'IF' THEN '3R' 
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' THEN '3R'  
		 WHEN user0 = 'Fusion' AND action = 'REC' AND result = 'REC' THEN '3R' 
		 WHEN user0 = 'DecdSvc' AND action = 'DECD' AND result = 'IF' THEN '3R'
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '3R'  
		 WHEN user0 = 'TLO' AND action = 'SEND' AND result = 'SEND' AND comment LIKE '%bankruptcy%' THEN '3R'
		 WHEN user0 = 'SCRA' AND action = 'RTN' THEN '3R'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIM    ' AS AgcyId,
'SYSTEM  ' AS AgyCollID, CONVERT(VARCHAR(300), n.comment)  AS AgyHistoryTxt,
'' AS PhoneNumber, '' AS PhoneExtension, '' AS PhoneFormat, '' AS ContactResult, '' AS PlaceCalled, '' AS PartyContacted
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN ('0003107','0003109')
AND user0 IN ('SIMM', 'TLO', 'FUSION', 'DECDSVC', 'WEBRECON', 'TLO', 'SCRA')

UNION ALL

--Record 425 Letter Sent
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	'3S' AS AgyActCode, 
CONVERT(VARCHAR(8), lr.DateProcessed, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), lr.DateProcessed, 8), ':', '') AS AgyActTime, 
'SIM    ' AS ThirdPartyID,
'SYSTEM  ' AS AgyCollID, lr.LetterCode + ', ' + l.Description + ' Sent to: ' + d.name  AS AgyHistoryTxt,
'' AS PhoneNumber, '' AS PhoneExtension, '' AS PhoneFormat, '' AS ContactResult, '' AS PlaceCalled, '' AS PartyContacted
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN LetterRequest lr WITH (NOLOCK) on m.number = lr.AccountID AND d.DebtorID = lr.RecipientDebtorID
INNER JOIN Letter l WITH (NOLOCK) ON lr.LetterCode = l.code
WHERE lr.DateProcessed BETWEEN @startDate AND @endDate 
AND customer IN ('0003107','0003109')
--#endregion

--#region Unused CDS Records and Financials 216/217/400/300/700
/* 
--Record 216 Paid Client
SELECT id2 AS LocationCode, m.account AS Acctnumber, '216' AS TransCode, CONVERT(VARCHAR(8), p.datepaid, 112) AS TransDate,
REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, REPLACE(CONVERT(VARCHAR(18), p.CollectorFee), '.', '') + '0000' AS CommissionAmt, 'SIM    ' AS AgcyId, '646' AS InputSRCcode
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PC' AND invoiced IS NOT NULL
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN ('0003107','0003109')

--Record 300-2 Paid Us
SELECT id2 AS LocationCode, m.account AS Acctnumber, '300' AS TransCode, CONVERT(VARCHAR(8), p.datepaid, 112) AS TransDate,
REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, '' AS NewDebits, '2' AS CatCode, 'SIM    ' AS AgcyId, REPLACE(CONVERT(VARCHAR(18), p.CollectorFee), '.', '') + '0000' AS CommissionAmt,
'' AS BatchInfo, 'C' AS Affect, CASE WHEN p.CollectorFee <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PU' AND invoiced IS NOT NULL
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN ('0003107','0003109')

--Record 217 Paid Client Reversal
SELECT id2 AS LocationCode, m.account AS Acctnumber, '217' AS TransCode, CONVERT(VARCHAR(8), p.datepaid, 112) AS TransDate,
REPLACE(CONVERT(VARCHAR(14), p.totalpaid), '.', '') + '0000' AS AmountPaid, REPLACE(CONVERT(VARCHAR(18), p.CollectorFee), '.', '') + '0000' AS CommissionAmt, 'SIM    ' AS AgcyId, '646' AS InputSRCcode
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PCR' AND invoiced IS NOT NULL
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN ('0003107','0003109')

--Record 300-1 Paid Us Reversal (Non-NSF) aka correction.
SELECT id2 AS LocationCode, m.account AS Acctnumber, '300' AS TransCode, (SELECT CONVERT(VARCHAR(8), datepaid, 112) FROM payhistory WITH (NOLOCK) WHERE UID = p.ReverseOfUID) AS TransDate,
REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, '1' AS NewDebits, '1' AS CatCode, 'SIM    ' AS AgcyId, REPLACE(CONVERT(VARCHAR(18), p.CollectorFee), '.', '') + '0000' AS CommissionAmt,
'' AS BatchInfo, 'C' AS Affect, CASE WHEN p.CollectorFee <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PUR' AND invoiced IS NOT NULL AND IsCorrection = 1
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN ('0003107','0003109')

--Record 700 Paid Us Reversal (NSF)
SELECT id2 AS LocationCode, m.account AS Acctnumber, '700' AS TransCode, (SELECT CONVERT(VARCHAR(8), datepaid, 112) FROM payhistory WITH (NOLOCK) WHERE UID = p.ReverseOfUID) AS TransDate,
REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, 'SIM    ' AS AgcyId, REPLACE(CONVERT(VARCHAR(18), p.CollectorFee), '.', '') + '0000' AS CommissionAmt,
'' AS BatchInfo, '' AS OrigTrans, CASE WHEN p.CollectorFee <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PUR' AND invoiced IS NOT NULL AND IsCorrection = 0
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN ('0003107','0003109')

--Record 400 Status Changes - ATTORNEY
SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), da.DateCreated, 112) AS TransDate,
'ATTORNEY' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), GETDATE(), 112) + ' Attorney ' + da.Name + ', of ' + da.Firm + 
' Phone: ' + da.Phone + ' or Fax ' + da.fax + CASE WHEN da.email <> '' THEN ' or Email: ' + da.Email ELSE ''  END + ' or Mail: ' + da.Addr1 + ' ' + da.Addr2 + ' ' + da.city + ', ' + da.State + 
' ' + da.Zipcode AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON m.number = da.AccountID 
WHERE m.customer IN ('0003107','0003109')
AND da.DateCreated BETWEEN @startDate AND @endDate

UNION ALL

--Record 400 Status Changes - Bankruptcy
SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), b.CreatedDate, 112) AS TransDate,
CASE WHEN m.STATUS = 'UBK' THEN 'UNCNFBK' When b.Chapter = '11' THEN 'BKCHP11' When b.Chapter =  '12' THEN 'BKCHP12' When b.Chapter = '13' THEN 'BKCHP13' When b.Chapter = '7' THEN 'BKCHP7'  END AS StatusCode, 
'Unconfirmed - Chapter ' + CONVERT(VARCHAR(3), b.Chapter) + ', ' + b.CaseNumber + ', ' + d.Name + ', ' + d.ssn + ', ' + CONVERT(VARCHAR(10), b.DateFiled, 101) + ', ' + b.CourtState + ', ' + CONVERT(VARCHAR(10), b.DateTime341, 101) + ', ' + b.CourtDistrict + ', ' + b.CourtDivision  AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID INNER JOIN debtors d WITH (NOLOCK) ON b.DebtorID = d.DebtorID
WHERE m.customer IN ('0003107','0003109')
AND b.CreatedDate BETWEEN @startDate AND @endDate AND m.status IN ('BKY', 'B07', 'B11', 'B12', 'B13', 'UBK')

UNION ALL

--Record 400 Status Changes - Cease and Desist
SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
'CEASE' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + m.name + ', ' + m.ssn + CASE WHEN m.status IN ('CAD', 'CND') THEN 'Written' ELSE 'Verbal' END  + ', Requested Cease and Desist'  AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer IN ('0003107','0003109')
AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('CND', 'CAD', 'VCD', 'HCD')

UNION ALL

--Record 400 Status Changes - Debt Management Co.
SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
'DEBT' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + c.CompanyName AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
	INNER JOIN CCCS c WITH (NOLOCK) ON d.DebtorID = c.DebtorID
WHERE m.customer IN ('0003107','0003109')
AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('DMC')

UNION ALL

--Record 400 Status Changes - Dispute account DSP Open
SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
'DISPUTE' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + CASE WHEN m.status = 'DSP' THEN 'Debtor is disputing the balance of the account' END AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer IN ('0003107','0003109')
AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('DSP')

UNION ALL

--Record 400 Status Changes - Request Recall Extension
--SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
--'EXTREQ1' AS StatusCode, 'As of ' + CONVERT(VARCHAR(8), GETDATE(), 112) + ', ' + 'Account is in a paying status or has a payment arrangement setup' AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 106) AND closed IS null
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND (status IN ('PDC', 'PCC', 'HOT', 'PPA', 'BKN', 'NPC', 'NSF', 'DCC', 'DBD') OR lastpaid > DATEADD(dd, -90, GETDATE()))

--UNION ALL

--Record 400 Status Changes - Request Recall Extension after recall 910 received and reopened.
SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), n.created, 112) AS TransDate,
'EXTREQ1' AS StatusCode, 'As of ' + CONVERT(VARCHAR(8), GETDATE(), 112) + ', ' + 'Request to continue working account' AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0003107','0003109')
AND n.created BETWEEN @startDate AND @endDate AND user0 = 'MT' AND action = 'RCL' AND result = 'RSN'
AND m.closed IS NULL

UNION ALL


--Record 400 Status Changes - Fruad
SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
'FRAUD' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + CASE WHEN m.status = 'FRD' THEN 'Debtor is stating fraudulent charges made on account or account opened without their knowledge' END AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer IN ('0003107','0003109')
AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('FRD')

UNION ALL

--Record 400 Status Changes - Verbal Bankuptcy
SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
'UNCNFBK' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + CASE WHEN m.status = 'VRB' THEN 'Debtor stated during conversation they were filing for bankruptcy' END AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer IN ('0003107','0003109')
AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('VRB')

UNION ALL

--Record 400 Status Changes - Validation of Debt
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
'VOD' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + CASE WHEN m.status = 'VAL' THEN 'Debtor requesting validation of debt for duration of account life' END AS StatusText
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer IN ('0003107','0003109')
AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('VAL')

--Custom Data Segment - DC1
SELECT id2 AS LocationCode, m.account AS Acctnumber, 'DC1' AS CDSID, CONVERT(VARCHAR(8), COALESCE(d2.TransmittedDate, GETDATE()), 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, d.FirstName AS DecFirstName, d.middleName AS DecMiddleName, d.LastName AS DecLastName, CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID,
CONVERT(VARCHAR(8), d2.DOD, 112) AS DOD, '' AS NotifySrc, '' AS ConfSrc, 'A' AS ContRelation, CASE WHEN d3.seq = 1 THEN 'Y' ELSE 'N' END AS SurvCustomers,
'' AS EstateExists, '' AS GeoState, '' AS POCDate, '+' AS DelqSign, '0' AS POCAmt, '' AS Notes1, '' AS Notes2, '' AS Notes3, '' AS ConfirmDate, '' AS NotifyDate, '' AS Filler
from master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
LEFT OUTER JOIN Debtors d3 WITH (NOLOCK) ON m.number = d.Number AND d.seq = 1
INNER JOIN Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID
WHERE m.customer IN ('0003107','0003109')
AND status = 'DEC' AND closed BETWEEN @startDate AND @endDate

UNION ALL

--Custom Data Segment - DC2
SELECT id2 AS LocationCode, m.account AS Acctnumber, 'DC2' AS CDSID, CONVERT(VARCHAR(8), COALESCE(d2.TransmittedDate, GETDATE()), 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, d.FirstName AS DecFirstName, d.middleName AS DecMiddleName, d.LastName AS DecLastName, CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID,
CONVERT(VARCHAR(8), d2.DOD, 112) AS DOD, '' AS NotifySrc, '' AS ConfSrc, 'B' AS ContRelation, CASE WHEN d3.seq = 0 THEN 'Y' ELSE 'N' END AS SurvCustomers,
'' AS EstateExists, '' AS GeoState, '' AS POCDate, '+' AS DelqSign, '0' AS POCAmt, '' AS Notes1, '' AS Notes2, '' AS Notes3, '' AS ConfirmDate, '' AS NotifyDate, '' AS Filler
from master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 1
LEFT OUTER JOIN Debtors d3 WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID
WHERE m.customer IN ('0003107','0003109')
AND status = 'DEC' AND closed BETWEEN @startDate AND @endDate

--Custom Data Segment - AGS
SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGS' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, 'SIM      ' AS AgencyId, REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') + '0000' AS BalAtSettle, (select REPLACE(CONVERT(VARCHAR(14), SUM(amount)), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)) AS SettlementOffered, 
CASE WHEN ((SELECT BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100) < (select SUM(amount) / m.original FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)) THEN 'Y' ELSE 'N' END AS SettlementInLimit, 
CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) ORDER BY deposit ASC), (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) ORDER BY deposit DESC)) > 18 THEN 'Y ' + (SELECT ISNULL(u.UserName, 'Not Available') FROM desk d WITH (NOLOCK) INNER JOIN Teams t WITH (NOLOCK) ON d.TeamID = t.ID INNER JOIN Users u WITH (NOLOCK) ON t.SupervisorID = u.ID
 WHERE d.code = p.desk) ELSE 'N' END AS AgencyMGRExcpApprove, 

CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) ORDER BY deposit ASC), (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) ORDER BY deposit DESC)) > 18 THEN 'Y ' + 'MT Manager' ELSE 'N' END AS StlmtNeedsSTBApprov, 
(select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) ORDER BY deposit ASC) AS SettlementStartDate, 
(select CONVERT(VARCHAR(13), COUNT(*)) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)) AS NumofPayments, 
(select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) ORDER BY deposit DESC) AS ProjEndDate, 
CONVERT(VARCHAR(8), datecreated, 112) AS DateSettlementTaken,
REPLACE(CONVERT(VARCHAR(14), (select ROUND(SUM(CAST(amount AS DECIMAL (9,3))) / CAST(m.original AS DECIMAL (9,3)), 4) * 100 FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate))), '.', '') AS SettlementPercOfBalance, 
REPLACE(CONVERT(VARCHAR(14), (SELECT m.original - SUM(amount) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate))), '.', '') + '0000' AS AmountForgiven, 
CASE WHEN CONVERT(VARCHAR(8), dateupdated, 112) = CONVERT(VARCHAR(8), datecreated, 112) THEN 'SETTLNEW' WHEN CONVERT(VARCHAR(8), dateupdated, 112) <> CONVERT(VARCHAR(8), datecreated, 112) AND active = 1 THEN 'SETTLPRO' WHEN m.number IN (SELECT AccountID FROM StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND OldStatus = 'SIF' AND CONVERT(VARCHAR(8), DateChanged, 112) < @startDate) THEN 'SETTLUPD' END AS SettlementUpdate, 
CASE WHEN m.ssn <> '' THEN 'Y' ELSE 'N' END AS SSNVerified, 
CASE WHEN (SELECT MR FROM debtors  WITH (NOLOCK) WHERE Number = m.number AND seq = 0) = 'Y' THEN 'N' ELSE 'Y' END AS AddressVerified, 'Settlement Offered' AS SettlementNotes,
'+' AS DelqSign,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) ORDER BY deposit ASC), '') AS Installment1Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) ORDER BY deposit ASC), 0) AS Installment1Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 1 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment2Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 1 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment2Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 2 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment3Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 2 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment3Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 3 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment4Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 3 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment4Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 4 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment5Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 4 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment5Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 5 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment6Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 5 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment6Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 6 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment7Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 6 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment7Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 7 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment8Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 7 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment8Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 8 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment9Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 8 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment9Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 9 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment10Date,
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 9 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment10Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 10 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment11Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 10 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment11Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 11 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment12Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 11 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment12Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 12 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment13Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 12 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment13Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 13 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment14Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 13 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment14Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 14 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment15Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 14 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment15Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 15 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment16Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 15 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment16Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 16 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment17Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 16 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment17Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 17 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment18Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 17 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment18Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 18 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment19Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 18 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment19Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 19 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment20Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 19 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment20Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 20 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment21Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 20 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment21Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 21 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment22Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 21 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment22Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 22 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment23Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 22 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment23Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 23 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment24Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 23 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment24Amt,
'' AS Filler
from master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer IN ('0003107','0003109')
AND ((p.DateCreated BETWEEN @startDate AND @endDate AND p.dateupdated IS NULL) OR (p.DateUpdated BETWEEN @startDate AND @endDate AND p.dateupdated IS NOT NULL))
AND p.PromiseMode IN (6,7) AND p.onhold IS NULL

--Custom Data Segment - AGT
SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGT' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, CASE WHEN CONVERT(VARCHAR(8), dateupdated, 112) = CONVERT(VARCHAR(8), datecreated, 112) THEN 'SETTLNEW' WHEN CONVERT(VARCHAR(8), dateupdated, 112) <> CONVERT(VARCHAR(8), datecreated, 112) AND active = 1 THEN 'SETTLPRO' WHEN m.number IN (SELECT AccountID FROM StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND OldStatus = 'SIF' AND CONVERT(VARCHAR(8), DateChanged, 112) < @startDate) THEN 'SETTLUPD' END AS SettlementUpdate, 
'+' AS DelqSign,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 24 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment25Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 24 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment25Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 25 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment26Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 25 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment26Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 26 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment27Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 26 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment27Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 27 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment28Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 27 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment28Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 28 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment29Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 28 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment29Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 29 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment30Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 29 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment30Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 30 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment31Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 30 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment31Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 31 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment32Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 31 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment32Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 32 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment33Date,
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 32 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment33Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 33 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment34Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 33 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment34Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 34 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment35Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 34 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment35Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 35 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment36Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 35 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment36Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 36 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment37Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 36 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment37Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 37 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment38Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 37 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment38Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 38 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment39Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 38 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment39Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 39 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment40Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 39 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment40Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 40 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment41Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 40 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment41Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 41 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment42Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 41 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment42Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 42 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment43Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 42 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment43Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 43 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment44Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 43 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment44Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 44 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment45Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 44 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment45Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 45 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment46Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 45 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment46Amt, 
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 46 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment47Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 46 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment47Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 47 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment48Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 47 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment48Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 48 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment49Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 48 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment49Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 49 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment50Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 49 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment50Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 50 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment51Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 50 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment51Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 51 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment52Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 51 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment52Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 52 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment53Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 52 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment53Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 53 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment54Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 53 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment54Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 54 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment55Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 54 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment55Amt,
ISNULL((select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 55 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '') AS Installment56Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate) AND uid NOT IN (SELECT TOP 55 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)  ORDER BY deposit ASC)), '0') AS Installment56Amt,
'' AS Filler
from master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer IN ('0003107','0003109')
AND ((p.DateCreated BETWEEN @startDate AND @endDate AND p.dateupdated IS NULL) OR p.DateUpdated BETWEEN @startDate AND @endDate)
AND (SELECT COUNT(*) FROM pdc WITH (NOLOCK) WHERE number = m.number AND ((p.DateCreated BETWEEN @startDate AND @endDate AND p.dateupdated IS NULL) OR p.DateUpdated BETWEEN @startDate AND @endDate)) >= 25
AND p.PromiseMode IN (6,7) AND p.onhold IS NULL

--Custom Data Segment - BCN
SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'BCN' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, b.CaseNumber AS CaseNumber, b.Chapter AS Chapter, CONVERT(VARCHAR(8), b.DateFiled, 112) AS FilingDate, d.Name AS FilerName1, '' AS FilerName2,
'U' AS ProSe, 'U' AS MaritalStatus, CASE WHEN m.status = 'UBK' THEN 'N' ELSE 'U' END AS BKConfirmed, '' AS Filler
FROM master m WITH (NOLOCK) INNER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID INNER JOIN debtors d WITH (NOLOCK) ON b.DebtorID = d.DebtorID
WHERE m.customer IN ('0003107','0003109')
AND b.CreatedDate BETWEEN @startDate AND @endDate

--Custom Data Segment - CEA
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, 'CEA' AS CDSID, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, CASE WHEN m.id2 IN ('040101', '040102') THEN 'A10' ELSE 'B10' END AS SystemOfRecord, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS CandDReceived, 
CASE WHEN status IN ('CAD', 'CND') THEN 'D10' ELSE 'C10' END AS TypeIndicator, '' AS AnyAll, CASE WHEN m.status = 'HCD' THEN 'SECCH' ELSE 'PRIMCH' END AS ContactRequesting,
'' AS RescindDate, '' AS P3Name, '' AS CDRecallDate, '' AS Filler
FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq =0
LEFT OUTER JOIN Debtors d2 WITH (NOLOCK) ON m.number = d2.number AND d.seq = 1
WHERE m.customer IN ('0003107','0003109')
AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('CND', 'CAD', 'VCD', 'HCD')

--Custom Data Segment - CDE
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, 'CDE' AS CDSID, CONVERT(VARCHAR(8), n.created, 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, m.account AS Acctnumber1, 
CASE n.result WHEN 'D1' THEN d.firstName + ' ' + d.lastname WHEN 'D2' THEN d2.firstName + ' ' + d2.lastname WHEN 'D3' THEN d3.firstName + ' ' + d3.lastname END AS CustomerName, 
''  AS PhoneNumber, '' AS BestCallBack, 'See complaint log' AS DetailOfComplaint,
'See complaint log' AS DesiredResolution, CONVERT(VARCHAR(8), n.created, 112) AS DateCompRecvd, '' AS DateCompResolve, '' AS ComplaintStatus,
'' AS ErroneousDisclosure, '' AS Filler
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq =0
LEFT OUTER JOIN Debtors d2 WITH (NOLOCK) ON m.number = d2.number AND d2.seq = 1
LEFT OUTER JOIN Debtors d3 WITH (NOLOCK) ON m.number = d3.number AND d3.seq = 2
WHERE m.customer IN ('0003107','0003109')
AND n.created BETWEEN @startDate AND @endDate AND n.action = 'CP'

--Custom Data Segment - AGV
SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGV' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, 'SIM      ' AS AgencyID, 'CONS'  AS RequestParty, d.firstName AS FirstName, d.lastname AS LastName, d.street1 AS Address1, d.street2 AS Address2,
d.city AS City, d.state AS State, d.zipcode AS ZipCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS DateVODRequested, '' AS DateVODFiled, '' AS StatementRequestRange,
'' AS Notes2, '' AS Notes3, '' AS Filler
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer IN ('0003107','0003109')
AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('VAL')
*/
--#endregion


--Record 215 - Confirm Account Recalled
--DEC no Case Number = Pending Deceased
--#region 215 Codes
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '215' AS TransCode, CONVERT(VARCHAR(8), COALESCE(returned, closed), 112) AS TransDate, 'SIM    ' AS AgcyId,
CASE WHEN m.status = 'RCL' THEN 'T' 
WHEN m.STATUS IN ('BKY', 'B07', 'B11', 'B13', 'B12', 'UBK') THEN 'B'
--WHEN status = 'DEC' AND (de.CaseNumber IS NULL OR de.CaseNumber = '') THEN 'J' 
WHEN m.STATUS IN ('CAD', 'CND') THEN 'M'
--WHEN status = 'CCS' THEN 'C' 
WHEN status IN ('LCP', 'ATY') THEN 'E' 
WHEN status IN ('RSK') THEN 'L' 
WHEN status = 'SIF' THEN 'S'
WHEN status = 'PIF' THEN 'P'
WHEN status = 'DPV' THEN 'D'
WHEN status = 'FRD' THEN 'F'
WHEN status = 'OOS' THEN 'H'
WHEN status = 'SSA' THEN 'G'
WHEN status = 'DEC' THEN 'Z'
ELSE 'N' END AS Reason, 
'Y' AS RouteConfirm
from master m WITH (NOLOCK) LEFT OUTER JOIN deceased de ON m.number = de.AccountID
WHERE m.customer IN ('0003107','0003109')
AND (m.closed BETWEEN @startDate AND @endDate OR m.returned BETWEEN @startDate AND @endDate)
--AND status NOT IN ('PIF')

UNION ALL

--Record 215 - Account reopened for Recall extension Requested
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '215' AS TransCode, CONVERT(VARCHAR(8), n.created, 112) AS TransDate, 'SIM    ' AS AgcyId,
SUBSTRING(RIGHT(CONVERT(VARCHAR(100), comment), 2), 1, 1) AS Reason, 
'Y' AS RouteConfirm
from master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0003107','0003109')
AND n.created BETWEEN @startDate AND @endDate AND user0 = 'MT' AND action = 'RCL' AND result = 'RSN'
AND m.closed IS NULL

UNION ALL

-- 215 for PIF Accounts
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '215' AS TransCode, CONVERT(VARCHAR(8), COALESCE(returned, closed), 112) AS TransDate, 'SIM    ' AS AgcyId,
'P' AS Reason, 
'Y' AS RouteConfirm
from master m WITH (NOLOCK) LEFT OUTER JOIN deceased de ON m.number = de.AccountID
WHERE m.customer IN ('0003107','0003109')
AND (m.closed BETWEEN @startDate AND @endDate OR m.returned BETWEEN @startDate AND @endDate)
AND status = 'PIF' AND CONVERT(VARCHAR(8), DATEADD(dd, 20, m.lastpaid), 112) BETWEEN @startDate AND @endDate

--#endregion



END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 12/16/2021
-- Description:	Exports KPI detail information
-- Changes:		02/21/2022 BGM  Updated Header changed Source from 0001647 to 001647
--								Removed extra space after Created Time stamp.
--								Changed ServiceID from 0001647 to 001647 on all records
--				02/22/2022 BGM Updated date formatting for several sections
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Resurgent_Export_Daily_KPI_File]
	-- Add the parameters for the stored procedure here
		@productionDate DATE

		--exec custom_resurgent_export_daily_kpi_file_test '20220221'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'FHD' AS RecType, '01' AS HeaderV, '01' AS FileV, 'KPI' AS BusProcType, '001647' AS ServiceID, '000075' AS Dest, 
	FORMAT(@productionDate, 'MM/dd/yyyy HH.mm.ss') AS created, ROUND(RAND() * 10000000000, 0) AS fileid

SELECT 'RHD' AS RecType, '01' AS HeadV, 'KPL' AS HeadRecType, '01' AS RecV, '' AS NumOfRec


SELECT DISTINCT 'KPL' AS RecType, id1 AS AcctID, m.account AS AcctNumber, m.id2 AS PlaceBatchID, '001647' AS ServiceID, FORMAT(lr.DateProcessed, 'MM/dd/yyyy') AS SendDate,
	D.Street1 AS Addr1, D.Street2 AS Addr2, D.City AS City, D.State AS [State], D.Zipcode AS Zip, CASE WHEN lr.LetterCode IN ('RCSP1', 'RCS01') THEN '1' ELSE '0' END AS ValidNotice,
	CASE WHEN lr.lettercode IN ('RCSP1', 'RCS01') AND (SELECT TOP 1 line1 FROM extradata WHERE extracode = 'L3' AND number = m.number) = 'Y' THEN '1' ELSE '0' END AS CBRNegNote,
	CASE WHEN lr.lettercode IN ('RCSP1', 'RCS01') AND (SELECT TOP 1 line3 FROM extradata WHERE extracode = 'L3' AND number = m.number) = 'Y' THEN '1' ELSE '0' END AS OOSNotice,
	CASE WHEN lr.lettercode IN ('RCSP1', 'RCS01') THEN '1' ELSE '0' END AS GLB, (SELECT description FROM letter WITH (NOLOCK) WHERE code = lr.lettercode) AS TemplateName
FROM LetterRequest lr WITH (NOLOCK) INNER JOIN master M WITH (NOLOCK) ON lr.AccountID = m.number
	INNER JOIN Debtors d WITH (NOLOCK) ON lr.SubjDebtorID = d.DebtorID
WHERE lr.CustomerCode IN (Select customerid from fact where customgroupid = 24)
AND CAST(lr.DateProcessed AS DATE) = @productionDate

--Get fake count for kpe
SELECT DISTINCT 'KPE'
FROM master M WITH (NOLOCK)
WHERE number = 1011111111

--Get fake count for kpt
SELECT DISTINCT 'KPT'
FROM master M WITH (NOLOCK)
WHERE number = 1011111111



--Get phone calls that did not make it to an Agent ie busy disconnected dropped
SELECT DISTINCT 'KPP' AS RecType, M.ID1 AS AcctID, m.account AS AcctNumber, m.id2 AS PlaceBatchID, '001647' AS ServiceID, FORMAT(pda.CALL_DATE_TIME, 'MM/dd/yyyy HH.mm.ss') AS CallDateTime, 
	REPLACE(REPLACE(REPLACE(REPLACE(PDA.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS PhoneNumber, CASE WHEN pt.PhoneTypeMapping = 1 THEN '1' ELSE '0' END AS POE,
	CASE WHEN pt.PhoneTypeMapping = 2 THEN '1' ELSE '0' END AS CellPhone, case when c.inbound = 1 then '1' else '0' end AS INBOUND, 
	CASE WHEN (SELECT TOP 1 d.Connect FROM DCLatitude..Disposition d WITH (NOLOCK) WHERE pda.RESULT_CODE = code AND d.Group_ID = 1) = 1 THEN '1' ELSE '0' END AS [Connect],
	CASE WHEN (SELECT TOP 1 d.Contact FROM DCLatitude..Disposition d WITH (NOLOCK) WHERE pda.RESULT_CODE = code AND d.Group_ID = 1) = 1 THEN '1' ELSE '0' END AS RPC,
	CASE WHEN pda.RESULT_CODE = 'PP' THEN '1' ELSE '0' END AS Promise, CASE WHEN pda.RESULT_CODE = 'PAY' THEN '1' ELSE '0' END AS PaymentTaken,
	'0' AS Dialer, '1' AS DialerHCI, '0' AS RinglessVM, '0' AS LimitContMessage, CASE WHEN pda.RESULT_CODE IN ('LM', 'LV', 'IVLM', 'IVLV') THEN '1' ELSE '0' END AS RepVoiceMail
	FROM DCLatitude..PD_Activity_Log PDA WITH(NOLOCK) JOIN 	DCLatitude..Campaign C WITH(NOLOCK) ON PDA.CAMPAIGN_ID = C.CAMPAIGN_ID
	JOIN master m WITH (NOLOCK) ON RTRIM(pda.RECORD_KEY) = m.number
		AND m.customer IN (Select customerid from fact where customgroupid = 24)
	OUTER APPLY (
		SELECT  TOP 1 *
		FROM    Phones_Master as PM 
		WHERE   RTRIM(pda.RECORD_KEY) = pm.number
		AND PDA.PHONE_NUMBER = PM.PhoneNumber
		) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE PDA.CLIENT_ID = 3 
	AND CAST(PDA.CALL_DATE_TIME AS DATE) = @productionDate
	AND PDA.CallType <> 3
	AND PDA.RESULT_CODE <> 'T'	

UNION ALL

--Get phone calls that made it to an Agent
SELECT DISTINCT 'KPP' AS RecType, M.ID1 AS AcctID, m.account AS AcctNumber, m.id2 AS PlaceBatchID, '001647' AS ServiceID, FORMAT(pch.RESULT_TIME, 'MM/dd/yyyy HH.mm.ss') AS CallDateTime, 
	REPLACE(REPLACE(REPLACE(REPLACE(PCH.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS PhoneNumber, CASE WHEN pt.PhoneTypeMapping = 1 THEN '1' ELSE '0' END AS POE,
	CASE WHEN pt.PhoneTypeMapping = 2 THEN '1' ELSE '0' END AS CellPhone, '0' AS INBOUND, 
	CASE WHEN (SELECT TOP 1 d.Connect FROM DCLatitude..Disposition d WITH (NOLOCK) WHERE PCH.RESULT_CODE = code AND d.Group_ID = 1) = 1 THEN '1' ELSE '0' END AS [Connect],
	CASE WHEN (SELECT TOP 1 d.Contact FROM DCLatitude..Disposition d WITH (NOLOCK) WHERE pch.RESULT_CODE = code AND D.Group_ID = 1) = 1 THEN '1' ELSE '0' END AS RPC,
	CASE WHEN PCH.RESULT_CODE = 'PP' THEN '1' ELSE '0' END AS Promise, CASE WHEN PCH.RESULT_CODE = 'PAY' THEN '1' ELSE '0' END AS PaymentTaken,
	'0' AS Dialer, '1' AS DialerHCI, '0' AS RinglessVM, '0' AS LimitContMessage, CASE WHEN PCH.RESULT_CODE IN ('LM', 'LV', 'IVLM', 'IVLV') THEN '1' ELSE '0' END AS RepVoiceMail
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	JOIN master m WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = m.number
		AND m.customer IN (Select customerid from fact where customgroupid = 24)
	OUTER APPLY (
				SELECT  TOP 1 *
				FROM    Phones_Master as PM 
				WHERE   RTRIM(pch.RECORD_KEY) = pm.number
				AND pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	CAST(PCH.RESULT_DATE AS DATE) = @productionDate
	AND PCH.CLIENT_ID = 3
	AND PV.TelephonyCallType IN (1) 
	AND pch.RESULT_CODE <> 'TFO'

UNION ALL

--Get phone calls that made it to an Agent
SELECT DISTINCT 'KPP' AS RecType, M.ID1 AS AcctID, m.account AS AcctNumber, m.id2 AS PlaceBatchID, '001647' AS ServiceID, FORMAT(pch.RESULT_TIME, 'MM/dd/yyyy HH.mm.ss') AS CallDateTime, 
	REPLACE(REPLACE(REPLACE(REPLACE(PCH.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS PhoneNumber, CASE WHEN pt.PhoneTypeMapping = 1 THEN '1' ELSE '0' END AS POE,
	CASE WHEN pt.PhoneTypeMapping = 2 THEN '1' ELSE '0' END AS CellPhone, '0' AS INBOUND, 
	CASE WHEN (SELECT TOP 1 d.Connect FROM DCLatitude..Disposition d WITH (NOLOCK) WHERE PCH.RESULT_CODE = code AND d.Group_ID = 1) = 1 THEN '1' ELSE '0' END AS [Connect],
	CASE WHEN (SELECT TOP 1 d.Contact FROM DCLatitude..Disposition d WITH (NOLOCK) WHERE pch.RESULT_CODE = code AND D.Group_ID = 1) = 1 THEN '1' ELSE '0' END AS RPC,
	CASE WHEN PCH.RESULT_CODE = 'PP' THEN '1' ELSE '0' END AS Promise, CASE WHEN PCH.RESULT_CODE = 'PAY' THEN '1' ELSE '0' END AS PaymentTaken,
	'0' AS Dialer, '1' AS DialerHCI, '0' AS RinglessVM, '0' AS LimitContMessage, CASE WHEN PCH.RESULT_CODE IN ('LM', 'LV', 'IVLM', 'IVLV') THEN '1' ELSE '0' END AS RepVoiceMail
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	JOIN master m WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = m.number 
		AND m.customer IN (Select customerid from fact where customgroupid = 24)
	OUTER APPLY (
				SELECT  TOP 1 *
				FROM    Phones_Master as PM 
				WHERE   RTRIM(pch.RECORD_KEY) = pm.number
				AND pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
	JOIN DCLatitude..Campaign C WITH(NOLOCK) ON PCH.CAMPAIGN_ID = C.CAMPAIGN_ID

WHERE
	CAST(PCH.RESULT_DATE AS DATE) = @productionDate
	AND PCH.CLIENT_ID = 3
	AND (C.INBOUND = 1 OR PCH.InboundCallLogId IS NOT NULL)
	AND ISNULL(PCH.RECORD_KEY, '') NOT IN ('0')
	AND PV.TelephonyCallType IN (1) 
	AND ISNULL(pch.RESULT_CODE,'') <> 'TFO'
	  
--Get Mail Returns
SELECT DISTINCT 'KLR' AS RecType, M.ID1 AS AcctID, m.account AS AcctNumber, m.id2 AS PlaceBatchID, '001647' AS ServiceID
FROM notes n WITH (NOLOCK) INNER JOIN master M WITH (NOLOCK) ON n.number = m.number
WHERE M.customer IN (Select customerid from fact where customgroupid = 24) AND
n.user0 = 'EXG' AND n.action = '+++++' AND n.result = '+++++' AND n.comment LIKE 'Mail returned%'
AND CAST(n.created AS DATE) = @productionDate

--Get fake count for KER
SELECT DISTINCT 'KER'
FROM master M WITH (NOLOCK)
WHERE number = 1011111111

--Get fake count for KTS
SELECT DISTINCT 'KTS'
FROM master M WITH (NOLOCK)
WHERE number = 1011111111


--Get PDC SIFs Entered
SELECT DISTINCT 'KSO' AS RecType, M.ID1 AS AcctID, m.account AS AcctNumber, m.id2 AS PlaceBatchID, '001647' AS ServiceID, FORMAT(p.Entered, 'MM/dd/yyyy HH.mm.ss')   AS OfferDate,
ROUND((CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid)	
 ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND CAST(datepaid AS DATE) = @productionDate), 0)
 FROM pdc WITH (NOLOCK) WHERE m.number = number AND CAST(DateCreated AS DATE) = @productionDate AND active = 1 AND printed = 0) END) 
 /
(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + ABS(m.paid) 	
WHEN m.STATUS <> 'SIF' AND CAST(m.lastpaid AS DATE) = @productionDate THEN m.current0 + 
	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND CAST(datepaid AS DATE) = @productionDate) 
	ELSE m.current0 END), 2) AS SIFOfferPercent,
(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM pdc WITH (NOLOCK) WHERE number = p.number AND CAST(DateCreated AS DATE) = @productionDate AND PromiseMode IN (6,7) 
AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))) AS NumofPayments, '2' AS Channel
from master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 24)
AND CAST(p.entered AS DATE) = @productionDate
AND p.PromiseMode IN (6,7) 
AND p.onhold IS NULL
AND (p.Active = 1 OR (p.Active = 0 AND m.status = 'sif'))

UNION ALL

--Get PCC SIFs Entered
SELECT DISTINCT 'KSO' AS RecType, M.ID1 AS AcctID, m.account AS AcctNumber, m.id2 AS PlaceBatchID, '001647' AS ServiceID, FORMAT(p.DateCreated, 'MM/dd/yyyy HH.mm.ss')   AS OfferDate,
ROUND((CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid)	
 ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND CAST(datepaid AS DATE) = @productionDate), 0)
 FROM DebtorCreditCards WITH (NOLOCK) WHERE m.number = Number AND CAST(DateCreated AS DATE) = @productionDate AND IsActive = 1 AND Printed IN ('0', 'N')) END) 
 / 
(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + ABS(m.paid)
	WHEN m.STATUS <> 'SIF' AND CAST(m.lastpaid AS DATE) = @productionDate THEN m.current0 + 
	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND CAST(datepaid AS DATE) = @productionDate) 
	ELSE m.current0 END), 2) AS SIFOfferPercent, 
(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND CAST(DateCreated AS DATE) = @productionDate AND PromiseMode IN (6,7) 
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) ) AS NumofPayments, '2' AS Channel
from master m WITH (NOLOCK) INNER JOIN DebtorCreditCards p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 24)
AND CAST(p.DateEntered AS DATE) = @productionDate
AND p.PromiseMode IN (6,7) AND p.OnHoldDate IS NULL
AND (p.IsActive = 1 OR (p.IsActive = 0 AND m.status = 'sif'))

UNION ALL

--Get Promise SIFs Entered
SELECT DISTINCT 'KSO' AS RecType, M.ID1 AS AcctID, m.account AS AcctNumber, m.id2 AS PlaceBatchID, '001647' AS ServiceID, FORMAT(p.DateCreated, 'MM/dd/yyyy HH.mm.ss')  AS OfferDate,
ROUND((CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid) ELSE (select top 1 
SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND CAST(datepaid AS DATE) = @productionDate), 0)
 FROM Promises WITH (NOLOCK) WHERE m.number = AcctID AND CAST(DateCreated AS DATE) = @productionDate AND active = 1) END) 
 / 
(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + ABS(m.paid) WHEN m.STATUS <> 'SIF' AND CAST(m.lastpaid AS DATE) = @productionDate THEN m.current0 + 
	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND CAST(datepaid AS DATE) = @productionDate) 
	ELSE m.current0 END), 2) AS SIFOfferPercent, 

(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND CAST(Entered AS DATE) = @productionDate AND PromiseMode IN (6,7) 
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))) AS NumofPayments, '2' AS Channel
from master m WITH (NOLOCK) INNER JOIN Promises p WITH (NOLOCK) ON m.number = p.acctid
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 24)
AND CAST(p.Entered AS DATE) = @productionDate
AND p.PromiseMode IN (6,7) 
AND (p.Suspended = 0 OR p.Suspended IS NULL)
AND (p.Active = 1 OR (p.Active = 0 AND m.status = 'sif'))


END
GO

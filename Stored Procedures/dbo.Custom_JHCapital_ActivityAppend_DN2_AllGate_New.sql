SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 07/02/2013
-- Description:	Export code for activity append report
-- Changes:
-- 9/11/2017 BGM Update to new DN2 system.
-- 09/20/2021 BGM Updated phone call types and letter types to bring them all up to date with new manual.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_ActivityAppend_DN2_AllGate_New]
	-- Add the parameters for the stored procedure here
	
	@startDate datetime,
	@endDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--exec Custom_JHCapital_ActivityAppend_DN2_AllGate_New '20210901', '20210921'


--Acknowledge received accounts
SELECT m.id1 AS data_id,
		'' AS activity_id, --Not Required
		'' AS activity_source_acctno, --Not Required
		'100000' AS activitytype_id,
		'' AS activity_type,
		'' AS activity_item,  -- not required
		'Acknowledged' AS activity_item_desc,
		CONVERT(VARCHAR(10), m.received, 101) AS activity_date,
	'' AS activity_amount, --not required
	'' AS activity_product, --not required
	'' AS activity_status, --not required
	'' AS activity_due, --not required
	'' AS activity_outstanding, --not required
	'' AS activity_source, --not required
	'' AS activity_location, --not required
	'' AS activity_method, --not required
	'' AS activity_code, --not required
	'' AS activity_credit_type, --not required
	'' AS activity_sequence, --not required
	'' AS activity_dial_type, --not required
	'' AS activity_phone, --not required
	'' AS activity_phone_type, --not required
	'' AS activity_time,--not required 
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code --not required
FROM master m WITH (NOLOCK)
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND CAST(m.received AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
and id2 in ('AllGate')

UNION ALL

--Comments and Skips only
SELECT DISTINCT m.id1 AS data_id,
	'' AS activity_id, --Not Required
	'' AS activity_source_acctno, --Not Required
	CASE WHEN action = 'co' THEN '100077'
	WHEN action = 'sk' AND result = 'sk' THEN '100049'
	end AS activitytype_id,
	CASE WHEN action = 'co' THEN 'Memo'
	WHEN action = 'sk' AND result = 'sk' THEN 'Skip Trace'		
	end AS activity_type,
	'' AS activity_item,  -- not required
	CASE WHEN action = 'co' THEN 'COMMENT ONLY'
   	WHEN action = 'sk' AND result = 'sk' THEN 'Skip Trace'
	END AS activity_item_desc,
	CONVERT(VARCHAR(10), n.created, 101) + ' ' + CONVERT(VARCHAR(8), n.created, 108) AS activity_date,
	'' AS activity_amount, --not required
	'' AS activity_product, --not required
	'' AS activity_status, --not required
	'' AS activity_due, --not required
	'' AS activity_outstanding, --not required
	'' AS activity_source, --not required
	'' AS activity_location, --not required
	'' AS activity_method, --not required
	'' AS activity_code, --not required
	'' AS activity_credit_type, --not required
	'' AS activity_sequence, --not required
	'' AS activity_dial_type, --not required
	'' AS activity_phone, --not required
	'' AS activity_phone_type, --not required
	convert(VARCHAR(5), n.created, 108) AS activity_time,--not required 
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code --not required
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND CAST(n.created AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND n.action IN ('co', 'sk')
AND n.result IN ('co', 'sk')
AND user0 IN (SELECT u.LoginName FROM Users u WITH (NOLOCK) WHERE u.LoginName NOT IN ('SYSTEM', 'TEST'))
and id2 in ('AllGate')

UNION ALL

--Outbound Calls no contact
SELECT DISTINCT  m.id1 AS data_id,
		'' AS activity_id, --Not Required
		'' AS activity_source_acctno, --Not Required
		CASE WHEN pal.RESULT_CODE in ('F', 'N') THEN '100057'
		WHEN pal.RESULT_CODE = 'M' THEN '100057'
		WHEN pal.RESULT_CODE = 'B' THEN '100045'
		WHEN pal.RESULT_CODE IN ('D', 'L', 'O', 'R', 'X', 'A') THEN '100047'
		WHEN pal.RESULT_CODE = 'K' THEN '100036'
		ELSE '100057'
		end AS activitytype_id,
		CASE WHEN pal.RESULT_CODE in ('F', 'N') THEN 'Phone'
		WHEN pal.RESULT_CODE = 'M' THEN 'Phone'
		WHEN pal.RESULT_CODE = 'B' THEN 'Phone'
		WHEN pal.RESULT_CODE IN ('D', 'L', 'O', 'R', 'X', 'A') THEN 'Phone'
		WHEN pal.RESULT_CODE = 'K' THEN 'Phone'
		ELSE 'Phone'
		end AS activity_type,
		'' AS activity_item,  -- not required
		CASE WHEN pal.RESULT_CODE in ('F', 'N') THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney- NO ANSWER'
		WHEN pal.RESULT_CODE = 'M' THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney- Answering Machine - No Message'
		WHEN pal.RESULT_CODE = 'B' THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney- LINE BUSY'
		WHEN pal.RESULT_CODE IN ('D', 'L', 'O', 'R', 'X', 'A') THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney- DISCONNECTED'
		WHEN pal.RESULT_CODE = 'K' THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney- Hung up on'
		ELSE 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney- NO ANSWER'
		END AS activity_item_desc,
		CONVERT(VARCHAR(10), pal.ADD_DATE, 101) + ' ' + CONVERT(VARCHAR(8), pal.ADD_DATE, 108) AS activity_date,
		'' AS activity_amount, --not required
		'' AS activity_product, --not required
		'' AS activity_status, --not required
		'' AS activity_due, --not required
		'' AS activity_outstanding, --not required
		'' AS activity_source, --not required
		'' AS activity_location, --not required
		'' AS activity_method, --not required
		'' AS activity_code, --not required
		'' AS activity_credit_type, --not required
		'' AS activity_sequence, --not required
		'Manual' AS activity_dial_type, --not required
		pal.PHONE_NUMBER AS activity_phone, --not required
		pt.PhoneTypeDescription AS activity_phone_type, --not required
		convert(VARCHAR(5), pal.ADD_DATE, 108) AS activity_time,--not required 
		CONVERT(VARCHAR(9), m.number) AS activity_collector_code --not required		
FROM master m WITH (NOLOCK)
INNER JOIN DCLatitude..PD_Activity_Log pal WITH (NOLOCK) ON RTRIM(pal.RECORD_KEY) = CAST(m.number AS VARCHAR(10))
INNER JOIN DCLatitude..PD_ResultCodes prc WITH (NOLOCK) ON pal.RESULT_CODE = prc.CODE
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pal.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number 
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND CAST(pal.ADD_DATE AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND pal.RESULT_CODE <> 'T'
and id2 in ('AllGate')

UNION ALL

--Outbound Calls Transfered
SELECT DISTINCT  m.id1 AS data_id,
		'' AS activity_id, --Not Required
		'' AS activity_source_acctno, --Not Required
		CASE WHEN pch.RESULT_ID in (21, 94) THEN '100018'
		WHEN pch.RESULT_ID IN (35) THEN '100023'
		WHEN pch.RESULT_ID IN (9, 25) THEN '100024'
		WHEN pch.RESULT_ID IN (99, 100) THEN '100027'
		WHEN pch.RESULT_ID IN (14, 38, 164, 198, 199) THEN '100035'
		WHEN pch.RESULT_ID IN (8, 97) THEN '100036'
		WHEN pch.RESULT_ID IN (15, 28) THEN '100037'
		WHEN pch.RESULT_ID IN (20) THEN '100038'
		WHEN pch.RESULT_ID IN (24, 32, 42, 96) THEN '100044'
		WHEN pch.RESULT_ID IN (163) THEN '100045'
		WHEN pch.RESULT_ID IN (34) THEN '100047'
		WHEN pch.RESULT_ID IN (19, 26) THEN '100048'
		WHEN pch.RESULT_ID IN (41, 160) THEN '100051'
		WHEN pch.RESULT_ID IN (22) THEN '100057'
		WHEN pch.RESULT_ID IN (18, 93) THEN '100110'
		ELSE '100057'
		end AS activitytype_id,
		CASE WHEN pch.RESULT_ID in (21, 94) THEN 'Phone'
		WHEN pch.RESULT_ID IN (35) THEN 'Phone'
		WHEN pch.RESULT_ID IN (9, 25) THEN 'Phone'
		WHEN pch.RESULT_ID IN (99, 100) THEN 'Phone'
		WHEN pch.RESULT_ID IN (14, 38, 164, 198, 199) THEN 'Phone'
		WHEN pch.RESULT_ID IN (8, 97) THEN 'Phone'
		WHEN pch.RESULT_ID IN (15, 28) THEN 'Phone'
		WHEN pch.RESULT_ID IN (20) THEN 'Phone'
		WHEN pch.RESULT_ID IN (24, 32, 42, 96) THEN 'Phone'
		WHEN pch.RESULT_ID IN (163) THEN 'Phone'
		WHEN pch.RESULT_ID IN (34) THEN 'Phone'
		WHEN pch.RESULT_ID IN (19, 26) THEN 'Phone'
		WHEN pch.RESULT_ID IN (41, 160) THEN 'Phone'
		WHEN pch.RESULT_ID IN (22) THEN 'Phone'
		WHEN pch.RESULT_ID IN (18, 93) THEN 'Phone'
		ELSE 'Phone'
		end AS activity_type,
		'' AS activity_item,  -- not required
		CASE WHEN pch.RESULT_ID in (21, 94) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - LEFT VOICEMAIL'
		WHEN pch.RESULT_ID IN (35) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - CALL BACK REQUESTED'
		WHEN pch.RESULT_ID IN (9, 25) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - WRONG NUMBER'
		WHEN pch.RESULT_ID IN (99, 100) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - PROMISED TO PAY'
		WHEN pch.RESULT_ID IN (14, 38, 164, 198, 199) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney- GAVE REPRESENTATION INFO'
		WHEN pch.RESULT_ID IN (8, 97) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - HUNG UP'
		WHEN pch.RESULT_ID IN (15, 28) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - REFUSED TO PAY'
		WHEN pch.RESULT_ID IN (20) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - RIGHT PARTY CONTACT - HUNG UP'
		WHEN pch.RESULT_ID IN (24, 32, 42, 96) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - NO MESSAGE LEFT'
		WHEN pch.RESULT_ID IN (163) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - BUSY'
		WHEN pch.RESULT_ID IN (34) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - DISCONNECTED'
		WHEN pch.RESULT_ID IN (19, 26) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - INVALID PHONE NUMBER'
		WHEN pch.RESULT_ID IN (41, 160) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - CANT PAY'
		WHEN pch.RESULT_ID IN (22) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - NO ANSWER'
		WHEN pch.RESULT_ID IN (18, 93) THEN 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney - LEFT MESSAGE'
		ELSE 'TELEPHONED RESIDENCE/TELEPHONED EMPLOYER/Telephoned Other/TELEPHONED CLIENT/Telephoned Attorney- NO ANSWER'
		END AS activity_item_desc,
		CONVERT(VARCHAR(10), PCH.ADD_DATE, 101) + ' ' + CONVERT(VARCHAR(8), PCH.ADD_DATE, 108) AS activity_date,
		'' AS activity_amount, --not required
		'' AS activity_product, --not required
		'' AS activity_status, --not required
		'' AS activity_due, --not required
		'' AS activity_outstanding, --not required
		'' AS activity_source, --not required
		'' AS activity_location, --not required
		'' AS activity_method, --not required
		'' AS activity_code, --not required
		'' AS activity_credit_type, --not required
		'' AS activity_sequence, --not required
		'Manual' AS activity_dial_type, --not required
		pch.PHONE_NUMBER AS activity_phone, --not required
		pt.PhoneTypeDescription AS activity_phone_type, --not required
		convert(VARCHAR(5), PCH.CHANGE_DATE, 108) AS activity_time,--not required 
		CONVERT(VARCHAR(9), m.number) AS activity_collector_code --not required	
FROM master m WITH (NOLOCK)
INNER JOIN DCLatitude..Prospect_CallHist pch WITH (NOLOCK) ON CAST(m.number AS VARCHAR(10)) = RTRIM(pch.RECORD_KEY)
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pch.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number 
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND CAST(pch.ADD_DATE AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND pch.MODE <> 1
and id2 in ('AllGate')

UNION ALL

----Inbound Calls
SELECT DISTINCT	 m.id1 AS data_id,
		'' AS activity_id, --Not Required
		'' AS activity_source_acctno, --Not Required
		CASE WHEN pch.RESULT_ID in (9, 19, 25, 26) THEN '100118'
		WHEN pch.RESULT_ID in (14, 24, 29, 35) THEN '100119'
		WHEN pch.RESULT_ID in (15, 28, 198) THEN '100124'
		WHEN pch.RESULT_ID IN (18) THEN '100122'
		WHEN pch.RESULT_ID IN (20) THEN '100166'
		WHEN pch.RESULT_ID IN (21, 94) THEN '100123'
		WHEN pch.RESULT_ID IN (22, 97) THEN '100117'
		WHEN pch.RESULT_ID IN (32, 38, 93, 164, 199) THEN '100121'
		WHEN pch.RESULT_ID IN (41, 160) THEN '100113'
		WHEN pch.RESULT_ID IN (99, 100) THEN '100120'
		ELSE '100119'
		end AS activitytype_id,
		CASE WHEN pch.RESULT_ID in (9, 19, 25, 26) THEN 'Phone'
		WHEN pch.RESULT_ID in (14, 24, 29, 35) THEN 'Phone'
		WHEN pch.RESULT_ID in (15, 28, 198) THEN 'Phone'
		WHEN pch.RESULT_ID IN (18) THEN 'Phone'
		WHEN pch.RESULT_ID IN (20) THEN 'Phone'
		WHEN pch.RESULT_ID IN (21, 94) THEN 'Phone'
		WHEN pch.RESULT_ID IN (22, 97) THEN 'Phone'
		WHEN pch.RESULT_ID IN (32, 38, 93, 164, 199) THEN 'Phone'
		WHEN pch.RESULT_ID IN (41, 160) THEN 'Phone'
		WHEN pch.RESULT_ID IN (99, 100) THEN 'Phone'
		ELSE 'Phone'
		end AS activity_type,
		'' AS activity_item,  -- not required
		CASE WHEN pch.RESULT_ID in (9, 19, 25, 26) THEN 'INBOUND - WRONG NUMBER'
		WHEN pch.RESULT_ID in (14, 24, 29, 35) THEN 'INBOUND - CALL BACK REQUESTED'
		WHEN pch.RESULT_ID in (15, 28, 198) THEN 'INBOUND - REFUSED TO PAY'
		WHEN pch.RESULT_ID IN (18) THEN 'INBOUND - LEFT MESSAGE'
		WHEN pch.RESULT_ID IN (20) THEN 'INBOUND - RIGHT PARTY CONTACT - HUNG UP'
		WHEN pch.RESULT_ID IN (21, 94) THEN 'INBOUND - LEFT VOICEMAIL'
		WHEN pch.RESULT_ID IN (22, 97) THEN 'INBOUND - LEFT VOICEMAIL'
		WHEN pch.RESULT_ID IN (32, 38, 93, 164, 199) THEN 'INBOUND - GAVE REPRESENTATION INFO'
		WHEN pch.RESULT_ID IN (41, 160) THEN 'INBOUND - CANT PAY'
		WHEN pch.RESULT_ID IN (99, 100) THEN 'INBOUND - PROMISED TO PAY'
		ELSE 'INBOUND - CALL BACK REQUESTED'
		END AS activity_item_desc,
		CONVERT(VARCHAR(10), pch.ADD_DATE, 101) + ' ' + CONVERT(VARCHAR(8), pch.ADD_DATE, 108) AS activity_date,
		'' AS activity_amount, --not required
		'' AS activity_product, --not required
		'' AS activity_status, --not required
		'' AS activity_due, --not required
		'' AS activity_outstanding, --not required
		'' AS activity_source, --not required
		'' AS activity_location, --not required
		'' AS activity_method, --not required
		'' AS activity_code, --not required
		'' AS activity_credit_type, --not required
		'' AS activity_sequence, --not required
		'Manual' AS activity_dial_type, --not required
		pch.PHONE_NUMBER AS activity_phone, --not required
		pt.PhoneTypeDescription AS activity_phone_type, --not required
		convert(VARCHAR(5), pch.CHANGE_DATE, 108) AS activity_time,--not required 
		CONVERT(VARCHAR(9), m.number) AS activity_collector_code --not required		
FROM master m WITH (NOLOCK)
INNER JOIN DCLatitude..Prospect_CallHist pch WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = CAST(m.number AS VARCHAR(10))
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pch.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number 
--INNER JOIN DCLatitude..PD_ResultCodes prc WITH (NOLOCK) ON pal.RESULT_CODE = prc.CODE
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND CAST(pch.ADD_DATE AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND pch.MODE = 1
and id2 in ('AllGate')

UNION ALL

--Letters Sent
SELECT m.id1 AS data_id, 
	'' AS activity_id, --Not Required
	'' AS activity_source_acctno, --Not Required
CASE 	WHEN lr.LetterCode = '09' THEN '100001'
		 WHEN lr.lettercode IN ('13', '13CC') THEN '100004'
		 WHEN lr.lettercode like 'BUY%' OR lr.lettercode IN ('10', '11', '11-ny', 'BYVS1', 'VSLDB') THEN '100007'
		 WHEN lr.LetterCode = 'DISP1' THEN '100015'
		 WHEN lr.lettercode IN ('101', 'OPTDB', 'TAX', 'TAXDB') THEN '100021'
		 WHEN lr.lettercode IN ('22', 'CA-DB', 'CLMCK', 'ENDOC', 'P1', 'P1TST', 'P2', 'P3', 'PREPF', 'PR-IH', 'PRPPF', 'PRROC', 'PRWOC') THEN '100084'
		 WHEN lr.lettercode IN ('PRVAL', 'VALID', 'VALNY') THEN '100085'
		 WHEN lr.lettercode IN ('AS', 'AS-IH', 'PS-IH') THEN '100129'
		 WHEN lr.lettercode IN ('AP', 'AP-IH', 'PP-IH') THEN '100130'
		 WHEN lr.LetterCode = 'PPAYO' THEN '100133'
		 WHEN lr.LetterCode = '90' THEN '100134'
		 WHEN lr.lettercode like '00%' OR lr.lettercode LIKE 'PS%' OR lr.lettercode IN ('NY-DB') THEN '100135'
		 WHEN lr.LetterCode = 'NY01' THEN '100136'
		 WHEN lr.lettercode = 'EML-2' THEN '100139'
		 WHEN lr.lettercode = 'EMAIL' THEN '100142'
		end AS activitytype_id,
	CASE WHEN lr.LetterCode = '09' THEN 'Letter'
		 WHEN lr.lettercode IN ('13', '13CC') THEN 'Letter'
		 WHEN lr.lettercode like 'BUY%' OR lr.lettercode IN ('10', '11', '11-ny', 'BYVS1', 'VSLDB') THEN 'Letter'
		 WHEN lr.LetterCode = 'DISP1' THEN 'Letter'
		 WHEN lr.lettercode IN ('101', 'OPTDB', 'TAX', 'TAXDB') THEN 'Letter'
		 WHEN lr.lettercode IN ('22', 'CA-DB', 'CLMCK', 'ENDOC', 'P1', 'P1TST', 'P2', 'P3', 'PREPF', 'PR-IH', 'PRPPF', 'PRROC', 'PRWOC') THEN 'Letter'
		 WHEN lr.lettercode IN ('PRVAL', 'VALID', 'VALNY') THEN 'Letter'
		 WHEN lr.lettercode IN ('AS', 'AS-IH', 'PS-IH') THEN 'Letter'
		 WHEN lr.lettercode IN ('AP', 'AP-IH', 'PP-IH') THEN 'Letter'
		 WHEN lr.LetterCode = 'PPAYO' THEN 'Letter'
		 WHEN lr.LetterCode = '90' THEN 'Letter'
		 WHEN lr.lettercode like '00%' OR lr.lettercode LIKE 'PS%' OR lr.lettercode IN ('NY-DB') THEN 'Letter'
		 WHEN lr.LetterCode = 'NY01' THEN 'Letter'
		 WHEN lr.lettercode = 'EML-2' THEN 'Email'
		 WHEN lr.lettercode = 'EMAIL' THEN 'Email'
		end AS activity_type,
	'' AS activity_item,  -- not required
	CASE WHEN lr.LetterCode = '09' THEN 'LETTER - PAYMENT DEMAND MAILED'
		 WHEN lr.lettercode IN ('13', '13CC') THEN 'LETTER - POST DATED CHECK / ELECTRONIC FUND TRANSFER NOTICE'
		 WHEN lr.lettercode like 'BUY%' OR lr.lettercode IN ('10', '11', '11-ny', 'BYVS1', 'VSLDB') THEN 'LETTER - VALIDATION NOTICE DEMAND MAILED - GLB'
		 WHEN lr.lettercode = 'DISP1' THEN 'LETTER - WRITTEN DISPUTE / COMPLAINT - RESPONSE GIVEN'
		 WHEN lr.lettercode IN ('101', 'OPTDB', 'TAX', 'TAXDB') THEN 'LETTER - SETTLEMENT LETTER'
		 WHEN lr.lettercode IN ('22', 'CA-DB', 'CLMCK', 'ENDOC', 'P1', 'P1TST', 'P2', 'P3', 'PREPF', 'PR-IH', 'PRPPF', 'PRROC', 'PRWOC') THEN 'LETTER - OTHER LETTER MAILED'
		 WHEN lr.lettercode IN ('PRVAL', 'VALID', 'VALNY') THEN 'LETTER - VERIFICATION OF DEBT MAILED'
		 WHEN lr.lettercode IN ('AS', 'AS-IH', 'PS-IH') THEN 'LETTER - SIF SATISFACTION'
		 WHEN lr.lettercode IN ('AP', 'AP-IH', 'PP-IH') THEN 'LETTER - PIF SATISFACTION'
		 WHEN lr.lettercode = 'PPAYO' THEN 'LETTER - ALREADY PAID CLAIM RESPONSE'
		 WHEN lr.lettercode = '90' THEN 'LETTER - PAYMENT RECEIPT'
		 WHEN lr.lettercode like '00%' OR lr.lettercode LIKE 'PS%' OR lr.lettercode IN ('NY-DB') THEN 'LETTER - PAYMENT PLAN ARRANGEMENT'
		 WHEN lr.lettercode = 'NY01' THEN 'LETTER - NY QUARTERLY STATEMENT'
		 WHEN lr.lettercode = 'EML-2' THEN 'EMAIL - PAYMENT DEMAND'
		 WHEN lr.lettercode = 'EMAIL' THEN 'EMAIL - SETTLEMENT OFFER'
		end AS activity_item_desc, 
	CONVERT(VARCHAR(10), lr.DateProcessed, 101) + ' ' + CONVERT(VARCHAR(8), lr.DateProcessed, 108) AS activity_date,
	'' AS activity_amount, --not required
	'' AS activity_product, --not required
	'' AS activity_status, --not required
	'' AS activity_due, --not required
	'' AS activity_outstanding, --not required
	'' AS activity_source, --not required
	'' AS activity_location, --not required
	'' AS activity_method, --not required
	'' AS activity_code, --not required
	'' AS activity_credit_type, --not required
	'' AS activity_sequence, --not required
	'' AS activity_dial_type, --not required
	'' AS activity_phone, --not required
	'' AS activity_phone_type, --not required
	'' AS activity_time, --not required
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code --not required
FROM LetterRequest lr WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON lr.AccountID = m.number
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND CAST(lr.DateProcessed AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND (lr.ErrorDescription = '' OR lr.ErrorDescription IS NULL) 
AND (lr.lettercode like 'BUY%' or lr.lettercode LIKE '%VAL%' OR lr.lettercode LIKE '%SIF%' OR lr.lettercode like '00%' OR lr.lettercode LIKE 'PS%' OR 
	lr.lettercode IN ('09', '10', '11', '11-ny', '13', '13CC', '22', '90', '101', 'BYVS1', 'CA-DB', 'CLMCK', 'DISP1', 'ENDOC', 'NY-DB', 'NY01',
	'OPTDB', 'P1', 'P1TST', 'P2', 'P3', 'PPAYO', 'PREPF', 'PR-IH', 'PRPPF', 'PRROC', 'PRWOC', 'TAX', 'TAXDB', 'VSLDB', 'AS', 'AS-IH', 'PS-IH', 'AP', 'AP-IH', 'PP-IH', 'EML-2', 'EMAIL' ))
and id2 in ('AllGate')

END
GO

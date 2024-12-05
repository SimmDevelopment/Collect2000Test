SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kia Evans
-- Create date: 11/6/2023
-- Description:	Export Account Activity Changes
-- Changes:  
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Denali_Capital_ActivityAppend]
	-- Add the parameters for the stored procedure here
	
	@startDate datetime,
	@endDate datetime
AS
BEGIN


SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -3, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

--exec Custom_CitizensBank_DN_ActivityAppend '20220509', '20220509'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT DISTINCT m.id2 AS data_id,
	'' AS activity_id,
    '' AS activity_source_acctno,
	'100070' AS activitytype_id,
	'' AS activity_item,
	'Acknowledged' AS activity_item_desc,
	CONVERT(VARCHAR(10), m.received, 101) AS activity_date,
	'' AS activity_amount,
	'' AS activity_status,
	'' AS activity_due,
	'' AS activity_source
	FROM master m WITH (NOLOCK)
WHERE m.customer IN ('0003108')
AND dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION ALL
    
		SELECT DISTINCT m.id2 AS data_id,
		'' AS activity_id,
		'' AS activity_source_acctno,
		CASE 	WHEN USER0 = 'SCRA' AND result = 'SEND' THEN '100002'
		WHEN action IN ('dt','ic') THEN '100008'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'wng' THEN '100048'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'pp' THEN '100022'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'cd' THEN '100017'
		WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') AND result = 'tt' THEN '100022'
		end AS activitytype_id,
		'' AS activity_item,
	REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(2000),n.comment),CHAR(13) + CHAR(10),' '), CHAR(13), ' '), CHAR(10), ' ') AS activity_item_desc,
	CONVERT(VARCHAR(10), n.created, 101) + ' ' + CONVERT(VARCHAR(8), n.created, 108) AS activity_date,
	'' AS activity_amount,
	'' AS activity_status,
	CASE WHEN user0 = 'SCRA' AND result = 'ACT' THEN (SELECT TOP 1 CONVERT(VARCHAR(10), ActiveDutyEndDate, 101) FROM custom_scra_history WITH (NOLOCK) WHERE m.number = number ORDER BY DateSent DESC) ELSE '' END AS activity_due,
	'' AS activity_source
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer IN ('0003108')
AND dbo.date(n.created) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
AND action IN ('co', 'tr', 'te', 'to', 'tc', 'ta', 'dt', 'sk', 'RQST', 'RTN','ic') 
AND result IN ('na', 'am', 'wng', 'lb', 'td', 'amnm', 'dh', 'dhu', 'pp', 'rp', 'cd', 'hu', 'tt', 'sk', 'SEND', 'ACT', 'CO', 'lm')
--AND ((CASE WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') --AND result IN ('tt', 'lm', 'wn') 
--	THEN ISNULL((SELECT TOP 1 pm.phonenumber FROM Phones_master pm WITH (NOLOCK)
--	WHERE pm.number = m.number AND pm.PhoneNumber = SUBSTRING(CONVERT(VARCHAR(1000), comment), 2, 10) ORDER BY DateAdded DESC), '') ELSE '' END <> '') 
--	OR action IN ('co', 'dt', 'sk', 'RQST', 'RTN','ic'))

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
		'' AS activity_status, --not required
		'' AS activity_due, --not required
		'' AS activity_source --not required
FROM master m WITH (NOLOCK)
INNER JOIN DCLatitude..PD_Activity_Log pal WITH (NOLOCK) ON RTRIM(pal.RECORD_KEY) = CAST(m.number AS VARCHAR(10))
INNER JOIN DCLatitude..PD_ResultCodes prc WITH (NOLOCK) ON pal.RESULT_CODE = prc.CODE
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pal.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number 
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer IN ('0003108')
AND CAST(pal.ADD_DATE AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND pal.RESULT_CODE <> 'T'
--and id2 not in ('AllGate','ARS-JMET')

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
		'' AS activity_status, --not required
		'' AS activity_due, --not required
		'' AS activity_source
FROM master m WITH (NOLOCK)
INNER JOIN DCLatitude..Prospect_CallHist pch WITH (NOLOCK) ON CAST(m.number AS VARCHAR(10)) = RTRIM(pch.RECORD_KEY)
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pch.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number 
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer IN ('0003108')
AND CAST(pch.ADD_DATE AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND pch.MODE <> 1


UNION ALL

-----Inbound Calls
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
		'' AS activity_status, --not required
		'' AS activity_due, --not required
		'' AS activity_source --not required	
FROM master m WITH (NOLOCK)
INNER JOIN DCLatitude..Prospect_CallHist pch WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = CAST(m.number AS VARCHAR(10))
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pch.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number 
--INNER JOIN DCLatitude..PD_ResultCodes prc WITH (NOLOCK) ON pal.RESULT_CODE = prc.CODE
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer IN ('0003108')
AND CAST(pch.ADD_DATE AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND pch.MODE = 1


UNION ALL

---Letters Sent
SELECT m.id1 AS data_id, 
	'' AS activity_id, --Not Required
	'' AS activity_source_acctno, --Not Required
CASE 	WHEN lr.LetterCode = '09' THEN '100001'
		 WHEN lr.lettercode IN ('13', '13CC') THEN '100004'
		 WHEN lr.lettercode IN ('1BUYR','1BUYP','BUY00','BUY01','BUY02','BUY03','BUY04','BUY05','BUY06','BUY07','BUY08','BUY09','BUY10','BUY11','BUY12','BUY13','BUY14','BUY15','BUY16','BUY17','BUY18','BUY19','BUY20','BUY21',
			'10', '11', '11-ny', 'BYVS1', 'VSLDB') THEN '100007'
		--WHEN lr.lettercode like 'BUY%' OR lr.lettercode IN ('10', '11', '11-ny', 'BYVS1', 'VSLDB') THEN '100007'
		 WHEN lr.LetterCode = 'DISP1' THEN '100015'
		 WHEN lr.lettercode IN ('101', 'TAX', 'TAXDB') THEN '100021'--removed OPTDB temporarily per JEFF
		 WHEN lr.lettercode IN ('OPTDB') THEN '100137'--changed OPTDB to get 100137 Per Jim & Jeff
		 WHEN lr.lettercode IN ('22', 'CA-DB', 'CLMCK', 'ENDOC', 'P1', 'P1TST', 'P2', 'P3', 'PREPF', 'PR-IH', 'PRPPF', 'PRROC', 'PRWOC') THEN '100084'
		 WHEN lr.lettercode IN ('PRVAL', 'VALID', 'VALNY') THEN '100085'
		 WHEN lr.lettercode IN ('AS', 'AS-IH', 'PS-IH') THEN '100129'
		 WHEN lr.lettercode IN ('AP', 'AP-IH', 'PP-IH') THEN '100130'
		 WHEN lr.LetterCode = 'PPAYO' THEN '100133'
		 WHEN lr.LetterCode = '90' THEN '100134'
		 WHEN lr.lettercode like '00%' OR lr.lettercode LIKE 'PS%' OR lr.lettercode IN ('NY-DB') THEN '100135'
		 WHEN lr.LetterCode = 'NY01' THEN '100136'
		 WHEN lr.lettercode = 'EML-2' THEN '100153'--temporarily changed from 100139 per Jeff
		 WHEN lr.lettercode = 'EMAIL' THEN '100142'
		 end AS activitytype_id,
	     '' AS activity_item,  -- not required
	     CASE WHEN lr.LetterCode = '09' THEN 'LETTER - PAYMENT DEMAND MAILED'
		 WHEN lr.lettercode IN ('13', '13CC') THEN 'LETTER - POST DATED CHECK / ELECTRONIC FUND TRANSFER NOTICE'
		 WHEN lr.lettercode IN ('1BUYR','1BUYP','BUY00','BUY01','BUY02','BUY03','BUY04','BUY05','BUY06','BUY07','BUY08','BUY09','BUY10','BUY11','BUY12','BUY13','BUY14','BUY15','BUY16','BUY17','BUY18','BUY19','BUY20','BUY21',
								'10', '11', '11-ny', 'BYVS1', 'VSLDB') THEN 'LETTER - VALIDATION NOTICE DEMAND MAILED - GLB'
		 --WHEN lr.lettercode like 'BUY%' OR lr.lettercode IN ('10', '11', '11-ny', 'BYVS1', 'VSLDB') THEN 'LETTER - VALIDATION NOTICE DEMAND MAILED - GLB'
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
	'' AS activity_status, --not required
	'' AS activity_due, --not required
	'' AS activity_source
FROM LetterRequest lr WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON lr.AccountID = m.number
WHERE m.customer IN ('0003108')
AND CAST(lr.DateProcessed AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND (lr.ErrorDescription = '' OR lr.ErrorDescription IS NULL) 
AND (lr.lettercode LIKE '%VAL%' OR lr.lettercode LIKE '%SIF%' OR lr.lettercode like '00%' OR lr.lettercode LIKE 'PS%' OR 
	lr.lettercode IN ('09', '1BUYR','1BUYP','BUY00','BUY01','BUY02','BUY03','BUY04','BUY05','BUY06','BUY07','BUY08','BUY09','BUY10','BUY11','BUY12','BUY13','BUY14','BUY15','BUY16','BUY17','BUY18','BUY19','BUY20','BUY21','10', '11', '11-ny', '13', '13CC', '22', '90', '101', 'BYVS1', 'CA-DB', 'CLMCK', 'DISP1', 'ENDOC', 'NY-DB', 'NY01',
	'OPTDB', 'P1', 'P1TST', 'P2', 'P3', 'PPAYO', 'PREPF', 'PR-IH', 'PRPPF', 'PRROC', 'PRWOC', 'TAX', 'TAXDB', 'VSLDB', 'AS', 'AS-IH', 'PS-IH', 'AP', 'AP-IH', 'PP-IH', 'EML-2', 'EMAIL' ))
--AND (lr.lettercode like 'BUY%' or lr.lettercode LIKE '%VAL%' OR lr.lettercode LIKE '%SIF%' OR lr.lettercode like '00%' OR lr.lettercode LIKE 'PS%' OR 
--	lr.lettercode IN ('09', '10', '11', '11-ny', '13', '13CC', '22', '90', '101', 'BYVS1', 'CA-DB', 'CLMCK', 'DISP1', 'ENDOC', 'NY-DB', 'NY01',
--	'OPTDB', 'P1', 'P1TST', 'P2', 'P3', 'PPAYO', 'PREPF', 'PR-IH', 'PRPPF', 'PRROC', 'PRWOC', 'TAX', 'TAXDB', 'VSLDB', 'AS', 'AS-IH', 'PS-IH', 'AP', 'AP-IH', 'PP-IH', 'EML-2', 'EMAIL' ))
--and id2 not in ('AllGate','ARS-JMET')


END
GO

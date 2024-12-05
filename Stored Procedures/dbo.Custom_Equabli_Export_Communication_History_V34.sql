SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 08/16/2023
-- Description:	Export Communication History Information
-- Changes:
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Communication_History_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME	
	
/*
exec Custom_Equabli_Export_Communication_History_V34 '20230719', '20230719'
*/


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
--Outbound calls made by Mobile Comply
SELECT
 'communication' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 thedata	 FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'acc.0.client_id') AS equabliClientId
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'con.0.client_consumer_number') AS clientConsumerNumber
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) 
	 WHERE number = m.number AND title = 'con.0.consumer_id') AS equabliConsumerId
, PDL.sequence AS communicationId
, 'VC' AS communicationChannel
, 'P' AS communicationReason
, 'OP' AS communicationSubreason
, FORMAT(PDL.call_date_time, 'yyyy-MM-dd') AS communicationDate
, FORMAT(DATEADD(HOUR, datediff(hour,getdate(),getutcdate()), PDL.call_date_time), 'HH:mm:ss') AS communicationTime
, CASE pdl.result_code WHEN 'B' THEN 'BS' WHEN 'D' THEN 'DD' WHEN 'F' THEN 'OT' WHEN 'I' THEN 'OT' WHEN 'L' THEN 'SI' WHEN 'M' THEN 'VN' WHEN 'N' THEN 'NR'
	WHEN 'O' THEN 'SI' WHEN 'R' THEN 'DC' WHEN 'T' THEN 'OT' WHEN 'X' THEN 'OT' WHEN 'A' THEN 'DC' WHEN 'C' THEN 'OT' ELSE pdl.result_code END AS communicationOutcome
, 'Outbound' AS communicationDirection
, '' AS communicationDisposition
, '1-' + STUFF(STUFF(RTRIM(LTRIM(PDL.phone_number)), 7, 0, '-'), 4, 0, '-') AS communicationDetails
, '' AS discountPercentage
, 'N' AS rpcReceivedFlag
, FORMAT(PDL.call_date_time, 'yyyy-MM-dd') AS rpcReceivedDate
, '' AS complianceType
, '' AS complianceSubType
, '' AS complianceDate
, '' AS complianceId
, '' AS dateCommunicationUpdate
, '' AS communicationUpdateTime
, '' AS regulatoryBody
, '' AS commentRemark
FROM dclatitude..PD_Activity_Log PDL WITH (NOLOCK) INNER JOIN master m	WITH (NOLOCK) ON pdl.record_key = m.number
	INNER JOIN dclatitude..pd_resultcodes prc WITH (NOLOCK) ON PDL.result_code = prc.code
    WHERE PDL.CLIENT_ID IN (10)
	--AND CAST(PDL.CALL_DATE_TIME AS DATE) = CAST(DATEADD(dd, -1, GETDATE()) AS DATE)	 
	AND CAST(PDL.CALL_DATE_TIME AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
	AND AGENT_ID IS NULL 
	   AND ISNUMERIC(PDL.record_key) = 1
            AND PDL.record_key < 2147483647

    AND m.customer IN (Select customerid from fact where customgroupid = 381)
 
 UNION ALL

--Outbound MC and Manual Phone Calls Transferred to Agent
SELECT
 'communication' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 thedata	 FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'acc.0.client_id') AS equabliClientId
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'con.0.client_consumer_number') AS clientConsumerNumber
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) 
	 WHERE number = m.number AND title = 'con.0.consumer_id') AS equabliConsumerId
, PCH.sequence AS communicationId
, 'VC' AS communicationChannel
, 'P' AS communicationReason
, 'OP' AS communicationSubreason
, FORMAT(PV.date, 'yyyy-MM-dd') AS communicationDate
, FORMAT(DATEADD(HOUR, datediff(hour,getdate(),getutcdate()), PV.date), 'HH:mm:ss') AS communicationTime
, CASE WHEN D.code IN ('3PHU', 'DHU', 'HU') THEN 'HU' 
		WHEN d.code IN ('WNG', 'DK', 'NL') THEN 'BN' 
		WHEN d.code IN ('DC', 'CA', 'CY', 'SK', 'CORT1', 'CORT2', 'CORT3', 'CORT4') THEN 'OT' 
		WHEN d.code IN ('RP', 'DS', 'TO', 'TT', 'BK', 'NV', 'RFSD') THEN 'AR' 
		WHEN d.code IN ('LM', 'LV', 'IVLV') THEN 'VM' 
		WHEN d.code IN ('LN', 'NI', 'NB', 'TW', 'ATTY') THEN 'AT' 
		WHEN d.code IN ('NA') THEN 'NR' 
		WHEN D.code IN ('TD') THEN 'DC' 
		WHEN D.code IN ('AMNM') THEN 'VN'
		WHEN D.code IN ('IVLM', 'AMNG') THEN 'AW'
		WHEN D.code IN ('FSBZ') THEN 'BS'
		WHEN d.code IN ('PP', 'PAY') THEN 'VA'
		ELSE d.code END AS communicationOutcome 
, CASE WHEN PV.TelephonyCallType IN (5) THEN 'Inbound' ELSE 'Outbound' END AS communicationDirection
, '' AS communicationDisposition
, '1-' + STUFF(STUFF(RTRIM(LTRIM(PCH.phone_number)), 7, 0, '-'), 4, 0, '-') AS communicationDetails
, '' AS discountPercentage
, CASE WHEN D.contact = 1 THEN 'Y' ELSE 'N' END AS rpcReceivedFlag
, FORMAT(PV.date, 'yyyy-MM-dd') AS rpcReceivedDate
, '' AS complianceType
, '' AS complianceSubType
, '' AS complianceDate
, '' AS complianceId
, '' AS dateCommunicationUpdate
, '' AS communicationUpdateTime
, '' AS regulatoryBody
, RTRIM(REPLACE(REPLACE(PCH.result_note, CHAR(10), ''), CHAR(13), ' ')) AS commentRemark
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID AND d.group_id = 1
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	INNER JOIN master m WITH (NOLOCK) ON pv.record_key = m.number
		AND m.customer IN (SELECT customerid FROM fact WHERE customgroupid = 381)	
WHERE PV.CLIENT_ID IN (10)
	--AND CAST(PV.Date AS DATE) = CAST(DATEADD(dd, -1, GETDATE()) AS DATE)
	AND CAST(pv.date AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
	   AND ISNUMERIC(PV.record_key) = 1
            AND PV.record_key < 2147483647

	AND PV.TelephonyCallType IN (1,3)

UNION ALL

--Inbound Calls
SELECT
 'communication' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 thedata	 FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'acc.0.client_id') AS equabliClientId
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'con.0.client_consumer_number') AS clientConsumerNumber
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) 
	 WHERE number = m.number AND title = 'con.0.consumer_id') AS equabliConsumerId
, PCH.sequence AS communicationId
, 'VC' AS communicationChannel
, 'P' AS communicationReason
, 'OP' AS communicationSubreason
, FORMAT(PV.date, 'yyyy-MM-dd') AS communicationDate
, FORMAT(DATEADD(HOUR, datediff(hour,getdate(),getutcdate()), PV.date), 'HH:mm:ss') AS communicationTime
, CASE WHEN D.code IN ('3PHU', 'DHU', 'HU') THEN 'HU' 
		WHEN d.code IN ('WNG', 'DK', 'NL') THEN 'BN' 
		WHEN d.code IN ('DC', 'CA', 'CY', 'SK', 'CORT1', 'CORT2', 'CORT3', 'CORT4') THEN 'OT' 
		WHEN d.code IN ('RP', 'DS', 'TO', 'TT', 'BK', 'NV', 'RFSD') THEN 'AR' 
		WHEN d.code IN ('LM', 'LV', 'IVLV') THEN 'VM' 
		WHEN d.code IN ('LN', 'NI', 'NB', 'TW', 'ATTY') THEN 'AT' 
		WHEN d.code IN ('NA') THEN 'NR' 
		WHEN D.code IN ('TD') THEN 'DC' 
		WHEN D.code IN ('AMNM') THEN 'VN'
		WHEN D.code IN ('IVLM', 'AMNG') THEN 'AW'
		WHEN D.code IN ('FSBZ') THEN 'BS'
		WHEN d.code IN ('PP', 'PAY') THEN 'VA'
		ELSE d.code  END AS communicationOutcome 
, CASE WHEN PV.TelephonyCallType IN (5) THEN 'Inbound' ELSE 'Outbound' END AS communicationDirection
, '' AS communicationDisposition
, '1-' + STUFF(STUFF(RTRIM(LTRIM(PCH.phone_number)), 7, 0, '-'), 4, 0, '-') AS communicationDetails
, '' AS discountPercentage
, CASE WHEN D.contact = 1 THEN 'Y' ELSE 'N' END AS rpcReceivedFlag
, FORMAT(PV.date, 'yyyy-MM-dd') AS rpcReceivedDate
, '' AS complianceType
, '' AS complianceSubType
, '' AS complianceDate
, '' AS complianceId
, '' AS dateCommunicationUpdate
, '' AS communicationUpdateTime
, '' AS regulatoryBody
, RTRIM(REPLACE(REPLACE(PCH.result_note, CHAR(10), ''), CHAR(13), ' ')) AS commentRemark
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID AND d.group_id = 1
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	INNER JOIN master m WITH (NOLOCK) ON pv.record_key = m.number
		AND m.customer IN (SELECT customerid FROM fact WHERE customgroupid = 381)	
WHERE PV.CLIENT_ID IN (10)
	--AND CAST(PV.Date AS DATE) = CAST(DATEADD(dd, -1, GETDATE()) AS DATE)
	AND CAST(pv.date AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
	AND PV.TelephonyCallType IN (5)
	AND D.code NOT IN ('trans')
	AND ISNUMERIC(PV.record_key) = 1
    AND PV.record_key < 2147483647
	AND pch.inboundcalllogid IS NOT NULL
	
UNION ALL

--Get letters sent
SELECT
 'communication' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 thedata	 FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'acc.0.client_id') AS equabliClientId
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'con.0.client_consumer_number') AS clientConsumerNumber
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) 
	 WHERE number = m.number AND title = 'con.0.consumer_id') AS equabliConsumerId
, lr.letterrequestid AS communicationId
, 'LT' AS communicationChannel
, CASE WHEN lettercode IN ('DISP4') THEN 'C'
		WHEN lr.lettercode IN ('22', 'AP', 'AP-IH', 'AS', 'AS-IH', 'MOSTA', 'NY01', 'PP-IH', 'PR-IH', 'PS-IH', '0041', '0042', '0043', '0044', '0045', '0046', 
			'0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', 'CA-DB', 'ME-D', 'OPTDB', '90', '08', '09',
			'1', '12', '12CC', '13', '13CC') THEN 'P'
		WHEN lr.lettercode IN ('1BUYR', 'VALDB', 'VALNY') THEN 'V' ELSE 'P' END AS communicationReason
, CASE WHEN lr.lettercode IN ('DISP4') THEN 'DR' 
		WHEN lr.lettercode IN ('22', 'AP', 'AP-IH', 'AS', 'AS-IH', 'MOSTA', 'NY01', 'PP-IH', 'PR-IH', 'PS-IH') THEN 'OP'
		WHEN lr.lettercode IN ('0041', '0042', '0043', '0044', '0045', '0046', 
			'0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', 'CA-DB', 'ME-D') THEN 'PE'
		WHEN lr.lettercode IN ('OPTDB') THEN 'PL'
		WHEN lr.lettercode IN ('90') THEN 'PR'
		WHEN lr.lettercode IN ('08', '09', '1', '12', '12CC', '13', '13CC') THEN 'RM'
		WHEN lr.lettercode IN ('1BUYR', 'VALDB', 'VALNY') THEN 'VL'
	ELSE 'OP' END AS communicationSubreason
, FORMAT(lr.dateprocessed, 'yyyy-MM-dd') AS communicationDate
, FORMAT(DATEADD(HOUR, datediff(hour,getdate(),getutcdate()), LR.dateprocessed), 'HH:mm:ss') AS communicationTime
, CASE WHEN lr.errordescription <> '' THEN 'OT' ELSE 'AD' END AS communicationOutcome 
, 'Outbound' AS communicationDirection
, '' AS communicationDisposition
, '' AS communicationDetails
, '' AS discountPercentage
, '' AS rpcReceivedFlag
, '' AS rpcReceivedDate
, '' AS complianceType
, '' AS complianceSubType
, '' AS complianceDate
, '' AS complianceId
, '' AS dateCommunicationUpdate
, '' AS communicationUpdateTime
, '' AS regulatoryBody
, '' AS commentRemark
FROM master m WITH (NOLOCK) INNER JOIN letterrequest lr WITH (NOLOCK) ON m.number = lr.accountid
WHERE lr.customercode IN (Select customerid from fact where customgroupid = 381)
--AND CAST(lr.dateprocessed AS DATE) = CAST(DATEADD(dd, -1, GETDATE()) AS DATE)
AND CAST(lr.dateprocessed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND lr.lettercode NOT IN ('EMAIL', 'EML-2', 'EMVSL')

UNION ALL

--Emails --EMVSL = IDL, EMAIL = SIFOffer, EML-2 = 2nd EMAIL SENT
SELECT
 'communication' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 thedata	 FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'acc.0.client_id') AS equabliClientId
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'con.0.client_consumer_number') AS clientConsumerNumber
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) 
	 WHERE number = m.number AND title = 'con.0.consumer_id') AS equabliConsumerId
, lr.letterrequestid AS communicationId
, 'EM' AS communicationChannel
, CASE lr.lettercode WHEN 'EMVSL' THEN 'V' WHEN 'EMAIL' THEN 'P' ELSE 'P' END AS communicationReason
, CASE lr.lettercode WHEN 'EMVSL' THEN 'VL' WHEN 'EMAIL' THEN 'PL' ELSE 'OP' END AS communicationSubreason
, FORMAT(lr.dateprocessed, 'yyyy-MM-dd') AS communicationDate
, FORMAT(DATEADD(HOUR, datediff(hour,getdate(),getutcdate()), LR.dateprocessed), 'HH:mm:ss') AS communicationTime
, 'AD' AS communicationOutcome 
, 'Outbound' AS communicationDirection
, '' AS communicationDisposition
, d.email AS communicationDetails
, CAST(CASE WHEN lr.lettercode = 'EMAIL' THEN CAST((100 - CAST(esd.plancode AS DECIMAL(9,2))) / 100 AS DECIMAL(9,4))  ELSE 0 END AS VARCHAR(8)) AS discountPercentage
, '' AS rpcReceivedFlag
, '' AS rpcReceivedDate
, '' AS complianceType
, '' AS complianceSubType
, '' AS complianceDate
, '' AS complianceId
, '' AS dateCommunicationUpdate
, '' AS communicationUpdateTime
, '' AS regulatoryBody
, '' AS commentRemark
FROM master m WITH (NOLOCK) INNER JOIN letterrequest lr WITH (NOLOCK) ON m.number = lr.accountid
	LEFT OUTER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	LEFT OUTER JOIN earlystagedata esd WITH (NOLOCK) ON	m.number = esd.accountid
WHERE lr.customercode IN (Select customerid from fact where customgroupid = 381) 
--AND CAST(lr.dateprocessed AS DATE) = CAST(DATEADD(dd, -1, GETDATE()) AS DATE)
AND CAST(lr.dateprocessed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND lr.lettercode IN ('EMAIL', 'EML-2', 'EMVSL')

UNION ALL

--Get SMS Text sent
SELECT
 'communication' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 thedata	 FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'acc.0.client_id') AS equabliClientId
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK)
	 WHERE number = m.number AND title = 'con.0.client_consumer_number') AS clientConsumerNumber
, (SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) 
	 WHERE number = m.number AND title = 'con.0.consumer_id') AS equabliConsumerId
, n.uid AS communicationId
, 'SM' AS communicationChannel
, 'P' AS communicationReason
, 'OP' AS communicationSubreason
, FORMAT(n.created, 'yyyy-MM-dd') AS communicationDate
, FORMAT(DATEADD(HOUR, datediff(hour,getdate(),getutcdate()), n.created), 'HH:mm:ss') AS communicationTime
, CASE WHEN result = 'T-OK' THEN 'AD' WHEN n.result = 'NOTXT' THEN 'US' ELSE 'OT' END AS communicationOutcome 
, CASE WHEN action = 'TXT1' THEN 'Outbound' WHEN action = 'TXT2' THEN 'Inbound' END AS communicationDirection
, '' AS communicationDisposition
, (SELECT TOP 1 '1-' + STUFF(STUFF(RTRIM(LTRIM(phonenumber)), 7, 0, '-'), 4, 0, '-') FROM phones_master WITH (NOLOCK) WHERE m.number = number AND phonetypeid IN (SELECT pt.phonetypeid FROM phones_types pt WITH (NOLOCK) WHERE pt.phonetypemapping= 2 )) AS communicationDetails
, '' AS discountPercentage
, '' AS rpcReceivedFlag
, '' AS rpcReceivedDate
, '' AS complianceType
, '' AS complianceSubType
, '' AS complianceDate
, '' AS complianceId
, '' AS dateCommunicationUpdate
, '' AS communicationUpdateTime
, '' AS regulatoryBody
, '' AS commentRemark
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN (Select customerid from fact where customgroupid = 381)
--AND CAST(n.created AS DATE) = CAST(DATEADD(dd, -1, GETDATE()) AS DATE)
AND CAST(n.created AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND n.user0 IN ('SBT') AND action IN ('txt1', 'txt2')

END
GO

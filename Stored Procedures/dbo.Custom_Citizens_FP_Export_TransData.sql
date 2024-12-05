SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan Ft. SQL Steve (Dial Connection)
-- Create date: 8/19/2019
-- Description:	Stored procedure to generate TransData File
-- File due between 12 a.m. and 1 a.m.
-- 11/21/2019 BGM Updated the code for the query that accesses the prospect call history table to look at not only the 
--					campaignID but also if there is an entry in the Inbound Call Log
-- 11/25/2019 BGM  Added account 123456 to be excluded from the file.
-- 11/26/2019 BGM Moved account 123456 filter to join rather than where clause.
-- 12/10/2019 BGM Updated Prospect_Call_history TRN_TIME field to be calulcated instead of using Change_Date field
-- 01/07/2020 BGM Updated to Trim record key on DC and cast latitude number to varchar to be compatable
-- 02/18/2020 BGM Added exclusion of result TFO to prospect call hist table query per dialconnection to elimiate duplicates.
-- 02/19/2020 BGM above change on hold per client
-- 04/21/2020 BGM Added customer number to only send accounts in customer 2226
-- 01/13/2021 BGM Minor adjustments made to match up with input efficiency report
-- 11/22/2021 BGM Added Function to pull CompCodes for System dispositions that do not get to an agent(no Agent provided from DCLatitude)
--				  added case statements to use either System codes or Agent codes(TRN_CompCode/TRN_AGCompCode) based on TRN_AgentName field populated.
-- 12/14/2021 BGM Updated code to match what Dialconnection is using to create their numbers for input efficiency report
-- 01/26/2022 BGM Changed Production date to be current run date so file is ready to be uploaded between 12 and 1 a.m.
-- 04/11/2022 BGM Changed Production date to be dynamic based on time of date it runs.
-- 08/17/2022 BGM Changed how inbound/Manual Outbound calls are pulled mainly from input efficency report code
-- 08/17/2022 BGM Removed Inbound Calls Offered Query, unsure if needed, but modified the code to match input efficiency report.
-- 08/18/2022 BGM Changed how Mobile Comply Outbound calls are pulled mainly from input efficency report code
-- =============================================

CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_TransData]
	-- Add the parameters for the stored procedure here
	
	--EXEC Custom_Citizens_FP_Export_TransData
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ProductionDate DATE
	DECLARE @ClientID AS INT

--Set to client id 20 for CTZ FP
SET @ClientID = 20

--------Use current date if the process runs prior to midnight of current production date, else use previous date for the production date-----
SET @ProductionDate = CASE WHEN DATEPART(hh, GETDATE()) BETWEEN 22 AND 23 THEN CAST(GETDATE() AS DATE) ELSE CAST(DATEADD(dd, -1, GETDATE()) AS DATE) END

/***************************************************************************
Note:
A TRN_COMPCODE MUST BE USED WHEN A CALL IS DISPOSITIONED BY THE SYSTEM AND NOT AN AGENT.
A TRN_AGCOMPCODE MUST BE USED WHEN A CALL IS DISPOSITION BY AN AGENT AND NOT THE SYSTEM.
THERE CAN NOT BE A SITUATION WHERE A TRN_COMPCODE AND A TRN_AGCOMPCODE CAN BE ON THE SAME CALL RECORD.
***************************************************************************/

--Outbound Calls 
--Get Outbound calls made by Mobile Comply - Input Efficiency Fields - Outbound Predictive Calls Placed\Abandons
SELECT 'SIMM - CARD' AS TRN_JOBNUM
	, CONVERT(VARCHAR(10), PDA.CALL_DATE_TIME, 101) AS TRN_DATE
	, CONVERT(VARCHAR(8), PDA.CALL_DATE_TIME, 108) AS TRN_TIME
	, '0' AS TRN_WAITTIME
	, ISNULL(m.account, '555') AS TRN_USERFIELD
	, CASE WHEN pda.AGENT_ID = '' OR pda.AGENT_ID IS NULL THEN dbo.Get_Citizens_COMP(pda.RESULT_CODE) ELSE '' END AS TRN_COMPCODE
	, ROW_NUMBER() OVER(ORDER BY m.account DESC) AS TRN_RECNUM --Counter is handled in the export in exchange now
	, REPLACE(REPLACE(REPLACE(REPLACE(PDA.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS TRN_PHONENUM
	, ISNULL(CASE WHEN pda.AGENT_ID <> '' THEN 'CTZ_' + pda.AGENT_ID ELSE '' END, '') AS TRN_AGENTNAME
	, '0' AS TRN_RECALLCNT
	, PDA.Duration AS TRN_TALKTIME
	, '0' AS TRN_WORKTIME
	, '0' AS TRN_V_TO_HANG
	, '0' AS TRN_OFF_TO_HNG
	, '0' AS TRN_CONNECT
	, '0' AS TRN_UPDATETIME
	, '0' AS TRN_PREVTIME
	, ''  AS TRN_AGCOMPCODE
	, case when c.inbound = 1 then 'INBOUND' else 'MANUAL' end AS TRN_LOGTYPE 
	, ISNULL(pm.PhoneTypeID, 60) AS PHN_ID
	, ISNULL(pt.PhoneTypeMapping, 2) AS PHN_TYPE
	, ISNULL(CASE WHEN PM.PhoneStatusID IN (1,3) THEN 'N' ELSE 'Y' END, 'Y') AS ALLOW
	, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(M.homephone, '-', ''), '(', ''), ')', ''), ' ', ''), '') AS HOME_PH
	, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(m.workphone, ''), '-', ''), '(', ''), ')', ''), ' ', ''), '') AS WORK_PH
FROM DCLatitude..PD_Activity_Log PDA WITH(NOLOCK) JOIN 	DCLatitude..Campaign C WITH(NOLOCK) ON PDA.CAMPAIGN_ID = C.CAMPAIGN_ID
	OUTER APPLY (
		SELECT  TOP 1 *
		FROM    Phones_Master as PM 
		WHERE   RTRIM(pda.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
		AND PDA.PHONE_NUMBER = PM.PhoneNumber
		) AS pm
		LEFT OUTER JOIN master m WITH (NOLOCK) ON pm.Number = m.number AND m.account NOT IN ('123456') --Exclude Account used to make calls to Citizens Cust Serv.
		AND m.customer = '0002226'	
		LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	PDA.CLIENT_ID = @ClientID
	AND CAST(PDA.CALL_DATE_TIME AS DATE) = @ProductionDate	 
	AND PDA.CallType <> 3
    AND PDA.RESULT_CODE NOT IN ('T')

UNION ALL

--Get Outbound calls made by Mobile Comply - Input Efficiency Fields - Outbound Connects/RPC/PTP/Messages Left
SELECT 'SIMM - CARD' AS TRN_JOBNUM
	, CONVERT(VARCHAR(10), pch.RESULT_TIME, 101) AS TRN_DATE
	, CONVERT(VARCHAR(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS TRN_TIME
	, '0' AS TRN_WAITTIME
	, ISNULL(m.account, '555') AS TRN_USERFIELD
	, CASE WHEN pch.ADD_USER = '' OR pch.ADD_USER IS NULL THEN dbo.Get_Citizens_COMP(pch.RESULT_CODE) ELSE '' END AS TRN_COMPCODE
	, ROW_NUMBER() OVER(ORDER BY m.account DESC) AS TRN_RECNUM --Counter is handled in the export in exchange now
	, REPLACE(REPLACE(REPLACE(REPLACE(pch.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS TRN_PHONENUM
	, ISNULL(CASE WHEN pch.ADD_USER <> '' THEN 'CTZ_' + pch.ADD_USER ELSE '' END, '') AS TRN_AGENTNAME
	, '0' AS TRN_RECALLCNT
	, pch.DURATION AS TRN_TALKTIME
	, '0' AS TRN_WORKTIME
	, '0' AS TRN_V_TO_HANG
	, '0' AS TRN_OFF_TO_HNG
	, '0' AS TRN_CONNECT
	, '0' AS TRN_UPDATETIME
	, '0' AS TRN_PREVTIME
	, CASE WHEN pch.ADD_USER <> '' THEN dbo.Get_Citizens_AGCOMP(pch.RESULT_CODE) ELSE '' END  AS TRN_AGCOMPCODE	
	, 'MANUAL' AS TRN_LOGTYPE
	, ISNULL(pm.PhoneTypeID, 60) AS PHN_ID
	, ISNULL(pt.PhoneTypeMapping, 2) AS PHN_TYPE
	, ISNULL(CASE WHEN PM.PhoneStatusID IN (1,3) THEN 'N' ELSE 'Y' END, 'Y') AS ALLOW
	, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(M.homephone, '-', ''), '(', ''), ')', ''), ' ', ''), '') AS HOME_PH
	, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(m.workphone, ''), '-', ''), '(', ''), ')', ''), ' ', ''), '') AS WORK_PH
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	OUTER APPLY (
				SELECT  TOP 1 PM.Number, PM.PhoneTypeID, PM.PhoneStatusID, PM.PhoneNumber
				FROM    Phones_Master as PM 
				WHERE   pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT OUTER JOIN master m WITH (NOLOCK) ON pm.Number = m.number AND m.account NOT IN ('123456')--Exclude Account used to make calls to Citizens Cust Serv.
		AND m.customer = '0002226'	
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	PCH.Client_ID IN (@ClientID)
	AND CAST(PV.Date AS DATE) = @ProductionDate
	AND PV.TelephonyCallType IN (3)

UNION ALL

--Get Outbound calls made by Manually - Input Efficiency Field - MCallsPlace
SELECT 'SIMM - CARD' AS TRN_JOBNUM
	, CONVERT(VARCHAR(10), pch.RESULT_TIME, 101) AS TRN_DATE
	, CONVERT(VARCHAR(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS TRN_TIME
	, '0' AS TRN_WAITTIME
	, ISNULL(m.account, '555') AS TRN_USERFIELD
	, CASE WHEN pch.ADD_USER = '' OR pch.ADD_USER IS NULL THEN dbo.Get_Citizens_COMP(pch.RESULT_CODE) ELSE '' END AS TRN_COMPCODE
	, ROW_NUMBER() OVER(ORDER BY pch.RESULT_DATE DESC) AS TRN_RECNUM --Counter is handled in the export in exchange now
	, REPLACE(REPLACE(REPLACE(REPLACE(pch.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS TRN_PHONENUM
	, ISNULL(CASE WHEN pch.ADD_USER <> '' THEN 'CTZ_' + pch.ADD_USER ELSE '' END, '') AS TRN_AGENTNAME
	, '0' AS TRN_RECALLCNT
	, pch.DURATION AS TRN_TALKTIME
	, '0' AS TRN_WORKTIME
	, '0' AS TRN_V_TO_HANG
	, '0' AS TRN_OFF_TO_HNG
	, '0' AS TRN_CONNECT
	, '0' AS TRN_UPDATETIME
	, '0' AS TRN_PREVTIME
	, CASE WHEN pch.ADD_USER <> '' THEN dbo.Get_Citizens_AGCOMP(pch.RESULT_CODE) ELSE '' END  AS TRN_AGCOMPCODE	
	, 'MANUAL' AS TRN_LOGTYPE
	, ISNULL(pm.PhoneTypeID, 60) AS PHN_ID
	, ISNULL(pt.PhoneTypeMapping, 2) AS PHN_TYPE
	, ISNULL(CASE WHEN PM.PhoneStatusID IN (1,3) THEN 'N' ELSE 'Y' END, 'Y') AS ALLOW
	, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(M.homephone, '-', ''), '(', ''), ')', ''), ' ', ''), '') AS HOME_PH
	, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(m.workphone, ''), '-', ''), '(', ''), ')', ''), ' ', ''), '') AS WORK_PH
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	OUTER APPLY (
				SELECT  TOP 1 PM.Number, PM.PhoneTypeID, PM.PhoneStatusID, PM.PhoneNumber
				FROM    Phones_Master as PM 
				WHERE   pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT OUTER JOIN master m WITH (NOLOCK) ON pm.Number = m.number AND m.account NOT IN ('123456')--Exclude Account used to make calls to Citizens Cust Serv.
		AND m.customer = '0002226'	
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	PCH.Client_ID IN (@ClientID)
	AND CAST(PV.Date AS DATE) = @ProductionDate
	AND PV.TelephonyCallType IN (1)
	
UNION ALL

--Inbound Calls
/* Call offered currently not send in the TransData file, this was a recent change after  and may need to be reinstated.

--Get Inbound calls IBCallsOffered from Inbound Call Log
SELECT 'SIMM - CARD' AS TRN_JOBNUM
	, CONVERT(VARCHAR(10), icl.CallStartDT, 101) AS TRN_DATE
	, CONVERT(VARCHAR(8), icl.CallStartDT, 108) AS TRN_TIME
	, '0' AS TRN_WAITTIME
	, ISNULL(m.account, '555') AS TRN_USERFIELD
	, CASE WHEN m.account IS NULL THEN '57' ELSE '' END AS TRN_COMPCODE
	, ROW_NUMBER() OVER(ORDER BY icl.CallStartDT DESC) AS TRN_RECNUM
	, REPLACE(REPLACE(REPLACE(REPLACE(icl.ANI, '-', ''), '(', ''), ')', ''), ' ', '') AS TRN_PHONENUM
	, '' AS TRN_AGENTNAME
	, '0' AS TRN_RECALLCNT
	, icl.TalkDuration AS TRN_TALKTIME
	, '0' AS TRN_WORKTIME
	, '0' AS TRN_V_TO_HANG
	, '0' AS TRN_OFF_TO_HNG
	, '0' AS TRN_CONNECT
	, '0' AS TRN_UPDATETIME
	, '0' AS TRN_PREVTIME
	, CASE WHEN m.account IS NOT NULL THEN dbo.Get_Citizens_AGCOMP(icl.Result) ELSE '' END AS TRN_AGCOMPCODE
	, 'INBOUND' AS TRN_LOGTYPE
	, ISNULL(pm.PhoneTypeID, '') AS PHN_ID
	, ISNULL(pt.PhoneTypeMapping, '') AS PHN_TYPE
	, ISNULL(CASE WHEN PM.PhoneStatusID IN (1,3) THEN 'N' ELSE 'Y' END, 'Y') AS ALLOW
	, REPLACE(REPLACE(REPLACE(REPLACE(M.homephone, '-', ''), '(', ''), ')', ''), ' ', '') AS HOME_PH
	, REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(m.workphone, ''), '-', ''), '(', ''), ')', ''), ' ', '') AS WORK_PH	
FROM DCLatitude..Inbound_Call_Log ICL WITH(NOLOCK) JOIN DCLatitude..Campaign C WITH(NOLOCK) ON ICL.CampaignID = C.CAMPAIGN_ID
	LEFT JOIN master m WITH (NOLOCK) ON RTRIM(icl.RECORDKEY) = CAST(m.number AS VARCHAR(10)) AND m.account NOT IN ('123456') --Exclude Acct 123456 its used to contact Citizens Customer Server and causes false positives.
		AND m.customer = '0002226'
		OUTER APPLY (
    SELECT  TOP 1 *
    FROM    Phones_Master as PM 
    WHERE   RTRIM(icl.RECORDKEY) = CAST(pm.number AS VARCHAR(10))
    AND icl.ani = PM.PhoneNumber
    ) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID 
WHERE
	ICL.CLIENTID IN (@ClientID)
	AND CAST(ICL.CallEndDT AS DATE) = @ProductionDate
	AND ICL.Result <> 3

UNION ALL

--Get Inbound calls IBCallsOffered Prospect Call History
SELECT 'SIMM - CARD' AS TRN_JOBNUM
	, CONVERT(VARCHAR(10), pch.RESULT_TIME, 101) AS TRN_DATE
	, CONVERT(VARCHAR(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS TRN_TIME
	, '0' AS TRN_WAITTIME
	, ISNULL(m.account, '555') AS TRN_USERFIELD
	, CASE WHEN m.account IS NULL THEN '57' ELSE '' END AS TRN_COMPCODE
	, ROW_NUMBER() OVER(ORDER BY pch.RESULT_DATE DESC) AS TRN_RECNUM
	, REPLACE(REPLACE(REPLACE(REPLACE(pch.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS TRN_PHONENUM
	, '' AS TRN_AGENTNAME
	, '0' AS TRN_RECALLCNT
	, PCH.Duration AS TRN_TALKTIME
	, '0' AS TRN_WORKTIME
	, '0' AS TRN_V_TO_HANG
	, '0' AS TRN_OFF_TO_HNG
	, '0' AS TRN_CONNECT
	, '0' AS TRN_UPDATETIME
	, '0' AS TRN_PREVTIME
	, CASE WHEN pch.ADD_USER <> '' THEN dbo.Get_Citizens_AGCOMP(pch.RESULT_CODE) ELSE '' END  AS TRN_AGCOMPCODE	
	, 'INBOUND' AS TRN_LOGTYPE
	, ISNULL(pm.PhoneTypeID, '') AS PHN_ID
	, ISNULL(pt.PhoneTypeMapping, '') AS PHN_TYPE
	, ISNULL(CASE WHEN PM.PhoneStatusID IN (1,3) THEN 'N' ELSE 'Y' END, 'Y') AS ALLOW
	, REPLACE(REPLACE(REPLACE(REPLACE(M.homephone, '-', ''), '(', ''), ')', ''), ' ', '') AS HOME_PH
	, REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(m.workphone, ''), '-', ''), '(', ''), ')', ''), ' ', '') AS WORK_PH	
FROM 
		dclatitude..Prospect_CallHist PCH WITH(NOLOCK) JOIN dclatitude..Campaign C WITH(NOLOCK)	ON PCH.CAMPAIGN_ID = C.CAMPAIGN_ID
		OUTER APPLY (
				SELECT  TOP 1 PM.Number, PM.PhoneTypeID, PM.PhoneStatusID, PM.PhoneNumber
				FROM    Phones_Master as PM 
				WHERE   pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT OUTER JOIN master m WITH (NOLOCK) ON pm.Number = m.number AND m.account NOT IN ('123456') --Exclude Acct 123456 its used to contact Citizens Customer Server and causes false positives.
		AND m.customer = '0002226'	
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
	WHERE 
		PCH.CLIENT_ID = @ClientID 
		AND CAST(PCH.RESULT_DATE AS DATE) = @ProductionDate
		AND (C.INBOUND = 1 OR PCH.InboundCallLogId IS NOT NULL)

UNION All
*/

--Inbound Calls Accepted
SELECT 'SIMM - CARD' AS TRN_JOBNUM
	, CONVERT(VARCHAR(10), pch.RESULT_TIME, 101) AS TRN_DATE
	, CONVERT(VARCHAR(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS TRN_TIME
	, '0' AS TRN_WAITTIME
	, ISNULL(m.account, '555') AS TRN_USERFIELD
	, CASE WHEN pch.ADD_USER = '' OR pch.ADD_USER IS NULL THEN dbo.Get_Citizens_COMP(pch.RESULT_CODE) ELSE '' END AS TRN_COMPCODE
	, ROW_NUMBER() OVER(ORDER BY pch.RESULT_DATE DESC) AS TRN_RECNUM --Counter is handled in the export in exchange now
	, REPLACE(REPLACE(REPLACE(REPLACE(pch.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS TRN_PHONENUM
	, ISNULL(CASE WHEN pch.ADD_USER <> '' THEN 'CTZ_' + pch.ADD_USER ELSE '' END, '') AS TRN_AGENTNAME
	, '0' AS TRN_RECALLCNT
	, pch.DURATION AS TRN_TALKTIME
	, '0' AS TRN_WORKTIME
	, '0' AS TRN_V_TO_HANG
	, '0' AS TRN_OFF_TO_HNG
	, '0' AS TRN_CONNECT
	, '0' AS TRN_UPDATETIME
	, '0' AS TRN_PREVTIME
	, CASE WHEN pch.ADD_USER <> '' THEN dbo.Get_Citizens_AGCOMP(pch.RESULT_CODE) ELSE '' END  AS TRN_AGCOMPCODE	
	, 'INBOUND' AS TRN_LOGTYPE
	, ISNULL(pm.PhoneTypeID, 60) AS PHN_ID
	, ISNULL(pt.PhoneTypeMapping, 2) AS PHN_TYPE
	, ISNULL(CASE WHEN PM.PhoneStatusID IN (1,3) THEN 'N' ELSE 'Y' END, 'Y') AS ALLOW
	, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(M.homephone, '-', ''), '(', ''), ')', ''), ' ', ''), '') AS HOME_PH
	, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(m.workphone, ''), '-', ''), '(', ''), ')', ''), ' ', ''), '') AS WORK_PH
	FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	OUTER APPLY (
				SELECT  TOP 1 PM.Number, PM.PhoneTypeID, PM.PhoneStatusID, PM.PhoneNumber
				FROM    Phones_Master as PM 
				WHERE   pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT OUTER JOIN master m WITH (NOLOCK) ON pm.Number = m.number AND m.account NOT IN ('123456')--Exclude Account used to make calls to Citizens Cust Serv.
		AND m.customer = '0002226'	
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	PCH.Client_ID IN (@ClientID)
	AND CAST(PV.Date AS DATE) = @ProductionDate
	AND PV.TelephonyCallType IN (5)
	

END
GO

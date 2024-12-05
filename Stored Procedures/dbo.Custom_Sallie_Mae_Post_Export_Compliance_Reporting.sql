SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan Ft. SQL Steve (Dial Connection)
-- Create date: 8/19/2019
-- Description:	Stored procedure to generate Daily Calls File
-- Changes:
--		04/22/2022 BGM Added Phone Status to be returned.
--		04/25/2022 BGM Updated PDA Call ID to the Sequence field instead of Unique Call ID
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Post_Export_Compliance_Reporting]
	-- Add the parameters for the stored procedure here
	--@startDate AS DATETIME,
	--@endDate AS DATETIME
	@productionDate AS DATETIME
	
	--EXEC Custom_Sallie_Mae_Post_Export_Compliance_Reporting '20220408'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--DECLARE @startDate DATETIME
	--DECLARE @endDate DATETIME
	--DECLARE @ProductionDate DATE

    -- Insert statements for procedure here  @startdate default is -1
	--SET @startDate = dbo.F_START_OF_DAY(DATEADD(dd, 0, GETDATE()))
	--SET @startDate = dbo.F_START_OF_DAY('20210601')
	--SET @endDate = DATEADD(ss, -3, dbo.F_START_OF_DAY(GETDATE()))

--------Change the 0 in the Cast statement to -1 to pull data from the previous day if the file fails to run on the current date-----
--------Remember to change back to 0 after the file has been created--------
--SET @ProductionDate = CASE WHEN DATEPART(hh, GETDATE()) BETWEEN 22 AND 23 THEN CAST(GETDATE() AS DATE) ELSE CAST(DATEADD(dd, -1, GETDATE()) AS DATE) END

SET @productionDate = CAST(@productionDate AS DATE)


--Outbound Calls *******Need to update TRN_CompCodes per spreadsheet
--Get Outbound calls made by Mobile Comply - Input Efficiency Field - OBMobileComplyCallsPlaced
SELECT 'D' AS [Record Type]
	,'SIMMS' AS Stream
	, CONVERT(VARCHAR(10), PDA.CALL_DATE_TIME, 101) AS [CAll Date]
	, CONVERT(VARCHAR(8), PDA.CALL_DATE_TIME, 108) AS [Call Time]
	, ISNULL(m.account, '') AS [SMB-Account Number]
	, ISNULL(m.ssn, '') AS SSN
	, REPLACE(REPLACE(REPLACE(REPLACE(PDA.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS [Phone Dialed]
	, (SELECT TOP 1 tn.TIMEZONE_ABBR FROM AreaCode_Sec ac WITH (NOLOCK) INNER JOIN Timezone_Names tn WITH (NOLOCK)  ON ac.TIMEZONE = tn.TIMEZONE WHERE SUBSTRING(PDA.PHONE_NUMBER, 1, 3) = AREACODE AND SUBSTRING(PDA.PHONE_NUMBER, 4, 3) = ac.PREFIX) AS [Phone Time Zone]
	, ISNULL(CASE WHEN pda.AGENT_ID <> '' THEN pda.AGENT_ID ELSE '' END, '') AS [Agent Transferred To]
	, PDA.Duration AS [Duration (Secs)]
	, pda.RESULT_CODE AS [Call Result Code]
	, case when c.inbound = 1 then 'INBOUND' else 'MANUAL' end AS [Call Type] 
	, ISNULL(pt.PhoneTypeDescription, 'Unknown') AS [Phone Type]
	, CASE pt.PhoneTypeMapping WHEN 0 THEN 'Home' WHEN 1 THEN 'Work' WHEN 2 THEN 'Cell' ELSE 'Other' END AS [Phone Classification]
	, CASE pm.PhoneStatusID WHEN 1 THEN 'N' ELSE 'Y' END AS [Phone Status]
	, CASE WHEN pda.RESULT_CODE IN (SELECT code FROM DCLatitude..Disposition d WHERE d.Contact = 1) THEN 'Y' ELSE 'N' END AS [RPC (Y/N)]
	, ISNULL(m.Street1 + ' ' + m.City + ', ' + m.State + ' ' + m.Zipcode, '') AS [Address]
	, ISNULL((SELECT TOP 1 tn.TIMEZONE_ABBR FROM zipcodes z WITH (NOLOCK) INNER JOIN Timezone_Names tn WITH (NOLOCK)  ON z.t_z = tn.TIMEZONE WHERE m.zipcode = z.zip_code), '') AS [Address Time Zone]
	, ISNULL(m.State, '') AS STATE
	, ISNULL(m.name, '') AS [Customer Name]
	, CONVERT(VARCHAR(50), pda.SEQUENCE) AS [Call Sequence ID]
	, ISNULL(m.status, '') AS [Account Status]
FROM DCLatitude..PD_Activity_Log PDA WITH(NOLOCK) JOIN 	DCLatitude..Campaign C WITH(NOLOCK) ON PDA.CAMPAIGN_ID = C.CAMPAIGN_ID AND pda.CAMPAIGN_ID IN (406, 407)
	JOIN master m WITH (NOLOCK) ON RTRIM(pda.RECORD_KEY) = CAST(m.number AS VARCHAR(10)) AND m.account NOT IN ('123456') 
		AND m.customer = '0002877'
	OUTER APPLY (
		SELECT  TOP 1 *
		FROM    Phones_Master as PM 
		WHERE   RTRIM(pda.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
		AND PDA.PHONE_NUMBER = PM.PhoneNumber
		) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	PDA.CAMPAIGN_ID IN (406, 407)
	AND CAST(PDA.CALL_DATE_TIME AS DATE) = @productionDate --BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
	AND PDA.CallType <> 3
	AND PDA.RESULT_CODE <> 'T'	

UNION ALL

--Get Outbound calls made by Manually - Input Efficiency Field - MCallsPlace
SELECT 'D' AS Record_Type
	,'SIMMS' AS Stream
	, CONVERT(VARCHAR(10), pch.RESULT_TIME, 101) AS [CAll Date]
	, CONVERT(VARCHAR(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS [Call Time]
	, ISNULL(m.account, '') AS Account
	, ISNULL(m.ssn, '') AS SSN
	, REPLACE(REPLACE(REPLACE(REPLACE(pch.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS [Phone Dialed]
	, (SELECT TOP 1 tn.TIMEZONE_ABBR FROM AreaCode_Sec ac WITH (NOLOCK) INNER JOIN Timezone_Names tn WITH (NOLOCK)  ON ac.TIMEZONE = tn.TIMEZONE WHERE SUBSTRING(PCH.PHONE_NUMBER, 1, 3) = AREACODE AND SUBSTRING(PCH.PHONE_NUMBER, 4, 3) = ac.PREFIX) AS [Phone Time Zone]
	, ISNULL(CASE WHEN pch.ADD_USER <> '' THEN pch.ADD_USER ELSE '' END, '') AS [Agent Transferred To]
	, pch.DURATION AS [Duration (Secs)]
	, pch.RESULT_CODE  AS [Call Result Code]
	, 'MANUAL' AS [Call Type]
	, ISNULL(pt.PhoneTypeDescription, 'Unknown') AS [Phone Type]
	, CASE pt.PhoneTypeMapping WHEN 0 THEN 'Home' WHEN 1 THEN 'Work' WHEN 2 THEN 'Cell' ELSE 'Other' END AS [Phone Classification]
	, CASE pm.PhoneStatusID WHEN 1 THEN 'N' ELSE 'Y' END AS [Phone Status]
	, CASE WHEN pch.RESULT_CODE IN (SELECT code FROM DCLatitude..Disposition d WHERE d.Contact = 1) THEN 'Y' ELSE 'N' END AS [RPC (Y/N)]
	, ISNULL(m.Street1 + ' ' + m.City + ', ' + m.State + ' ' + m.Zipcode, '') AS [Address]
	, ISNULL((SELECT TOP 1 tn.TIMEZONE_ABBR FROM zipcodes z WITH (NOLOCK) INNER JOIN Timezone_Names tn WITH (NOLOCK)  ON z.t_z = tn.TIMEZONE WHERE m.zipcode = z.zip_code), '') AS [Address Time Zone]
	, ISNULL(m.State, '') AS STATE
	, ISNULL(m.name, '') AS [Customer Name]
	, CONVERT(VARCHAR(50), PCH.UniqueCallId) AS [Call Sequence ID]
	, ISNULL(m.status, '') AS [Account Status]
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	JOIN master m WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = CAST(m.number AS VARCHAR(10)) AND m.account NOT IN ('123456')
		AND m.customer = '0002877'
	OUTER APPLY (
				SELECT  TOP 1 *
				FROM    Phones_Master as PM 
				WHERE   RTRIM(pch.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
				AND pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	CAST(PCH.RESULT_DATE AS DATE) = @productionDate -- BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
	AND PCH.CAMPAIGN_ID IN (406, 407)
	AND PV.TelephonyCallType IN (1) 
	AND pch.RESULT_CODE <> 'TFO'
	
UNION ALL

--Get Inbound calls IBCallsOffered
SELECT 'D' AS [Record Type]
	,'SIMMS' AS Stream
	, CONVERT(VARCHAR(10), icl.CallStartDT, 101) AS [CAll Date]
	, CONVERT(VARCHAR(8), icl.CallStartDT, 108) AS [Call Time]
	, ISNULL(m.account, '') AS Account
	, ISNULL(m.ssn, '') AS SSN
	, REPLACE(REPLACE(REPLACE(REPLACE(icl.ANI, '-', ''), '(', ''), ')', ''), ' ', '') AS [Phone Dialed]
	, (SELECT TOP 1 tn.TIMEZONE_ABBR FROM AreaCode_Sec ac WITH (NOLOCK) INNER JOIN Timezone_Names tn WITH (NOLOCK)  ON ac.TIMEZONE = tn.TIMEZONE WHERE SUBSTRING(icl.ani, 1, 3) = AREACODE AND SUBSTRING(icl.ani, 4, 3) = ac.PREFIX) AS [Phone Time Zone]
	, '' AS [Agent Transferred To]
	, icl.TalkDuration AS [Duration (Secs)]
	, CONVERT(VARCHAR(10), icl.Result) AS [Call Result Code]
	, 'INBOUND' AS [Call Type]
	, ISNULL(pt.PhoneTypeDescription, 'Unknown') AS [Phone Type]
	, CASE pt.PhoneTypeMapping WHEN 0 THEN 'Home' WHEN 1 THEN 'Work' WHEN 2 THEN 'Cell' ELSE 'Other' END AS [Phone Classification]
	, CASE pm.PhoneStatusID WHEN 1 THEN 'N' ELSE 'Y' END AS [Phone Status]
	, CASE WHEN CONVERT(VARCHAR(10), icl.Result) IN (SELECT code FROM DCLatitude..Disposition d WHERE d.Contact = 1) THEN 'Y' ELSE 'N' END AS [RPC (Y/N)]
	, ISNULL(m.Street1 + ' ' + m.City + ', ' + m.State + ' ' + m.Zipcode, '') AS [Address]
	, ISNULL((SELECT TOP 1 tn.TIMEZONE_ABBR FROM zipcodes z WITH (NOLOCK) INNER JOIN Timezone_Names tn WITH (NOLOCK)  ON z.t_z = tn.TIMEZONE WHERE m.zipcode = z.zip_code), '') AS [Address Time Zone]
	, ISNULL(m.State, '') AS STATE
	, ISNULL(m.name, '') AS [Customer Name]
	, CONVERT(VARCHAR(50), icl.CallID) AS [Call Sequence ID]
	, ISNULL(m.status, '') AS [Account Status]
FROM DCLatitude..Inbound_Call_Log ICL WITH(NOLOCK) JOIN DCLatitude..Campaign C WITH(NOLOCK) ON ICL.CampaignID = C.CAMPAIGN_ID AND icl.CampaignID = 87
	LEFT JOIN master m WITH (NOLOCK) ON RTRIM(icl.RECORDKEY) = CAST(m.number AS VARCHAR(10)) AND m.account NOT IN ('123456')
		AND m.customer = '0002877'
		OUTER APPLY (
    SELECT  TOP 1 *
    FROM    Phones_Master as PM 
    WHERE   RTRIM(icl.RECORDKEY) = CAST(pm.number AS VARCHAR(10))
    AND icl.ani = PM.PhoneNumber
    ) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID 
WHERE
	ICL.CampaignID = 87
	AND CAST(ICL.CallEndDT AS DATE) = @productionDate -- BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
	AND ICL.Result <> 3

UNION ALL

--Get Inbound Calls that make it to an agent
SELECT 'D' AS [Record Type]
	,'SIMMS' AS Stream
	, CONVERT(VARCHAR(10), pch.RESULT_TIME, 101) AS [CAll Date]
	, CONVERT(VARCHAR(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS [Call Time]
	, ISNULL(m.account, '') AS Account
	, ISNULL(m.ssn, '') AS SSN
	, REPLACE(REPLACE(REPLACE(REPLACE(pch.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS [Phone Dialed]
	, (SELECT TOP 1 tn.TIMEZONE_ABBR FROM AreaCode_Sec ac WITH (NOLOCK) INNER JOIN Timezone_Names tn WITH (NOLOCK)  ON ac.TIMEZONE = tn.TIMEZONE WHERE SUBSTRING(PCH.PHONE_NUMBER, 1, 3) = AREACODE AND SUBSTRING(PCH.PHONE_NUMBER, 4, 3) = ac.PREFIX) AS [Phone Time Zone]
	, ISNULL(CASE WHEN pch.ADD_USER <> '' THEN pch.ADD_USER ELSE '' END, '') AS [Agent Transferred To]
	, pch.DURATION AS [Duration (Secs)]
	, pch.RESULT_CODE AS [Call Result Code]
	, 'INBOUND' AS [Call Type]
	, ISNULL(pt.PhoneTypeDescription, 'Unknown') AS [Phone Type]
	, CASE pt.PhoneTypeMapping WHEN 0 THEN 'Home' WHEN 1 THEN 'Work' WHEN 2 THEN 'Cell' ELSE 'Other' END AS [Phone Classification]
	, CASE pm.PhoneStatusID WHEN 1 THEN 'N' ELSE 'Y' END AS [Phone Status]
	, CASE WHEN pch.RESULT_CODE IN (SELECT code FROM DCLatitude..Disposition d WHERE d.Contact = 1) THEN 'Y' ELSE 'N' END AS [RPC (Y/N)]
	, ISNULL(m.Street1 + ' ' + m.City + ', ' + m.State + ' ' + m.Zipcode, '') AS [Address]
	, ISNULL((SELECT TOP 1 tn.TIMEZONE_ABBR FROM zipcodes z WITH (NOLOCK) INNER JOIN Timezone_Names tn WITH (NOLOCK)  ON z.t_z = tn.TIMEZONE WHERE m.zipcode = z.zip_code), '') AS [Address Time Zone]
	, ISNULL(m.State, '') AS STATE
	, ISNULL(m.name, '') AS [Customer Name]
	, CONVERT(VARCHAR(50), PCH.UniqueCallId) AS [Call Sequence ID]
	, ISNULL(m.status, '') AS [Account Status]
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	JOIN DCLatitude..Campaign C WITH(NOLOCK) ON PCH.CAMPAIGN_ID = C.CAMPAIGN_ID AND pch.CAMPAIGN_ID = 87	
	JOIN master m WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = CAST(m.number AS VARCHAR(10)) AND m.account NOT IN ('123456')
		AND m.customer = '0002877'
	OUTER APPLY (
				SELECT  TOP 1 *
				FROM    Phones_Master as PM 
				WHERE   RTRIM(pch.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
				AND pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	PCH.CAMPAIGN_ID = 87
    AND CAST(PCH.RESULT_DATE AS DATE) = @productionDate -- BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
    AND (C.INBOUND = 1 OR PCH.InboundCallLogId IS NOT NULL)
    AND RTRIM(PCH.RECORD_KEY) IN (SELECT number FROM master m WITH (NOLOCK) 
		WHERE m.Customer = '0002877')
    AND RTRIM(PCH.RECORD_KEY) NOT IN (SELECT m.number FROM master  m WITH (NOLOCK)   
       WHERE m.account  IN ('123456'))
	AND ISNULL(PCH.RECORD_KEY, '') NOT IN ('0')
	AND ISNULL(pch.RESULT_CODE,'') <> 'TFO'
	

END

--inbound = 87
--outbound = 406, 407
GO

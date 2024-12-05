SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:           Brian Meehan Ft. SQL Steve (Dial Connection)
-- Create date: 8/19/2019
-- Description:      Stored procedure to generate TransData File
-- File due between 12 a.m. and 1 a.m.
-- 11/21/2019 BGM Updated the code for the query that accesses the prospect call history table to look at not only the 
--                                campaignID but also if there is an entry in the Inbound Call Log
-- 11/25/2019 BGM  Added account 123456 to be excluded from the file.
-- 11/26/2019 BGM Moved account 123456 filter to join rather than where clause.
-- 12/10/2019 BGM Updated Prospect_Call_history TRN_TIME field to be calulcated instead of using Change_Date field
-- 01/07/2020 BGM Updated to Trim record key on DC and cast latitude number to varchar to be compatable
-- 02/18/2020 BGM Added exclusion of result TFO to prospect call hist table query per dialconnection to elimiate duplicates.
-- 02/19/2020 BGM above change on hold per client
-- 04/21/2020 BGM Added customer number to only send accounts in customer 2226
-- 01/13/2021 BGM Minor adjustments made to match up with input efficiency report
-- 11/22/2021 BGM Added Function to pull CompCodes for System dispositions that do not get to an agent(no Agent provided from DCLatitude)
--                           added case statements to use either System codes or Agent codes(TRN_CompCode/TRN_AGCompCode) based on TRN_AgentName field populated.
-- 12/14/2021 BGM Updated code to match what Dialconnection is using to create their numbers for input efficiency report
-- 01/26/2022 BGM Changed Production date to be current run date so file is ready to be uploaded between 12 and 1 a.m.
-- 04/11/2022 BGM Changed Production date to be dynamic based on time of date it runs.
-- 08/17/2022 BGM Changed how inbound/Manual Outbound calls are pulled mainly from input efficency report code
-- 08/17/2022 BGM Removed Inbound Calls Offered Query, unsure if needed, but modified the code to match input efficiency report.
-- 08/18/2022 BGM Changed how Mobile Comply Outbound calls are pulled mainly from input efficency report code
-- 12/14/2022 DMA Per Jeff 12/13/2022 12:16 email, removed commas from customer names, trimmed zipcode to 5 digits, changed call_time to MM/DD/YY hh:mm:ss, and removed commas from call_result field.
-- =============================================

CREATE PROCEDURE [dbo].[Custom_TF_Holdings_ECHO_Outbound_Phones_Report_New]
       -- Add the parameters for the stored procedure here
    @startDate datetime,
	@endDate datetime
       --EXEC Custom_TF_Holdings_Outbound_Phones_Report_New
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;

       DECLARE @ProductionDate DATE
       DECLARE @ClientID AS INT

--Set to client id 20 for CTZ FP
SET @ClientID = 28

--------Use current date if the process runs prior to midnight of current production date, else use previous date for the production date-----
--SET @ProductionDate = CASE WHEN DATEPART(hh, GETDATE()) BETWEEN 22 AND 23 THEN CAST(GETDATE() AS DATE) ELSE CAST(DATEADD(dd, -1, GETDATE()) AS DATE) END

/***************************************************************************
Note:
A TRN_COMPCODE MUST BE USED WHEN A CALL IS DISPOSITIONED BY THE SYSTEM AND NOT AN AGENT.
A TRN_AGCOMPCODE MUST BE USED WHEN A CALL IS DISPOSITION BY AN AGENT AND NOT THE SYSTEM.
THERE CAN NOT BE A SITUATION WHERE A TRN_COMPCODE AND A TRN_AGCOMPCODE CAN BE ON THE SAME CALL RECORD.
***************************************************************************/

--Outbound Calls 
--Get Outbound calls made by Mobile Comply - Input Efficiency Fields - Outbound Predictive Calls Placed\Abandons
SELECT m.account AS Loan_Series_Number
       , replace(m.Name,',','') AS Customer_Name
       , left(m.zipcode,5) AS ZipCode
       , CONVERT(VARCHAR(10), PDA.CALL_DATE_TIME, 101) AS Call_Date
       , REPLACE(REPLACE(REPLACE(REPLACE(PDA.PHONE_NUMBER, '-', ''),'(',''),')', ''), ' ', '') AS Phone_Number
       , CASE WHEN pt.PhoneTypeMapping = 2 THEN 'Mobile' WHEN pt.PhoneTypeMapping = 1 THEN 'Work' ELSE 'Home' END AS Phone_Type
--       , CONVERT(VARCHAR(8), PDA.CALL_DATE_TIME, 108) AS Call_Time
       , CONVERT(VARCHAR(10), PDA.CALL_DATE_TIME, 101) + ' ' + convert(varchar(8), PDA.CALL_DATE_TIME, 108) AS Call_Time
       , replace(prc.DESCRIPTION,',','')  AS Call_Result 
FROM DCLatitude..PD_Activity_Log PDA WITH(NOLOCK) JOIN        DCLatitude..Campaign C WITH(NOLOCK) ON PDA.CAMPAIGN_ID = C.CAMPAIGN_ID
       OUTER APPLY (
              SELECT  TOP 1 *
              FROM    Phones_Master as PM 
              WHERE   RTRIM(pda.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
              AND PDA.PHONE_NUMBER = PM.PhoneNumber
              ) AS pm
              INNER JOIN master m WITH (NOLOCK) ON pm.Number = m.number AND m.account NOT IN ('123456') --Exclude Account used to make calls to Citizens Cust Serv.
              AND m.customer in ('0003017')      
              LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
              INNER JOIN DCLatitude..PD_ResultCodes prc ON pda.RESULT_CODE = prc.CODE
WHERE
       PDA.CLIENT_ID = @ClientID
       AND CAST(PDA.CALL_DATE_TIME AS DATE) BETWEEN CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
       AND PDA.CallType <> 3
    AND PDA.RESULT_CODE NOT IN ('T')

UNION ALL

--Get Outbound calls made by Mobile Comply - Input Efficiency Fields - Outbound Connects/RPC/PTP/Messages Left
SELECT m.account AS Loan_Series_Number
       ,replace(m.Name, ',','') AS Customer_Name
       ,left(m.zipcode,5) AS ZipCode
       , CONVERT(VARCHAR(10), pch.RESULT_TIME, 101) AS Call_Date
       , REPLACE(REPLACE(REPLACE(REPLACE(pch.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS Phone_Number
       ,CASE WHEN pt.PhoneTypeMapping = 2 THEN 'Mobile' WHEN pt.PhoneTypeMapping = 1 THEN 'Work' ELSE 'Home' END AS Phone_Type
--       , CONVERT(VARCHAR(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS Call_Time
       , CONVERT(VARCHAR(10), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 101) + ' ' +  convert(varchar(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS Call_Time
       ,replace(D.description,',','') AS Call_Result
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
       JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
       JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
       OUTER APPLY (
                           SELECT  TOP 1 PM.Number, PM.PhoneTypeID, PM.PhoneStatusID, PM.PhoneNumber
                           FROM    Phones_Master as PM 
                           WHERE   pch.PHONE_NUMBER = PM.PhoneNumber
                           ) AS pm
       INNER JOIN master m WITH (NOLOCK) ON pm.Number = m.number AND m.account NOT IN ('123456')--Exclude Account used to make calls to Citizens Cust Serv.
              AND m.customer in ('0003017')      
       LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
       PCH.Client_ID IN (@ClientID)
       AND CAST(PV.Date AS DATE) BETWEEN CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
       AND PV.TelephonyCallType IN (3)

UNION ALL

--Get Outbound calls made by Manually - Input Efficiency Field - MCallsPlace
SELECT m.account AS Loan_Series_Number
       ,replace(m.Name,',','') AS Customer_Name
       ,left(m.zipcode,5) AS ZipCode
       , CONVERT(VARCHAR(10), pch.RESULT_TIME, 101) AS Call_Date
       , REPLACE(REPLACE(REPLACE(REPLACE(pch.PHONE_NUMBER, '-', ''), '(', ''), ')', ''), ' ', '') AS Phone_Number
       ,CASE WHEN pt.PhoneTypeMapping = 2 THEN 'Mobile' WHEN pt.PhoneTypeMapping = 1 THEN 'Work' ELSE 'Home' END AS Phone_Type
--       , CONVERT(VARCHAR(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108) AS Call_Time
       , CONVERT(VARCHAR(10), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 101) + ' ' +  convert(varchar(8), DATEADD(ss, -(pch.duration), pch.RESULT_TIME), 108 ) AS Call_Time
       ,replace(D.description,',','') AS Call_Result
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
       JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
       JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
       OUTER APPLY (
                           SELECT  TOP 1 PM.Number, PM.PhoneTypeID, PM.PhoneStatusID, PM.PhoneNumber
                           FROM    Phones_Master as PM 
                           WHERE   pch.PHONE_NUMBER = PM.PhoneNumber
                           ) AS pm
       Inner JOIN master m WITH (NOLOCK) ON pm.Number = m.number AND m.account NOT IN ('123456')--Exclude Account used to make calls to Citizens Cust Serv.
              AND m.customer in ('0003017')      
       LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
       PCH.Client_ID IN (@ClientID)
       AND CAST(PV.Date AS DATE) BETWEEN CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
       AND PV.TelephonyCallType IN (1)
       
       END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:           Brian Meehan Ft. SQL Steve (Dial Connection)
-- Create date: 08/08/2023
-- Description:      Stored procedure to generate Phones Report for QCC
-- Changes:	
--			08/16/2023 BGM switched to client id 30
-- =============================================

CREATE PROCEDURE [dbo].[Custom_TF_Holdings_QCC_Outbound_Phones_Report_New]
       -- Add the parameters for the stored procedure here
    @startDate datetime,
	@endDate datetime
       --EXEC Custom_TF_Holdings_QCC_Outbound_Phones_Report_New '20230807', '20230807'
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;

       DECLARE @ProductionDate DATE
       DECLARE @ClientID AS INT

SET @ClientID = 30

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
              INNER JOIN master m WITH (NOLOCK) ON pm.Number = m.number
              AND m.customer in ('0003157')      
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
       INNER JOIN master m WITH (NOLOCK) ON pm.Number = m.number
              AND m.customer in ('0003157')      
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
       Inner JOIN master m WITH (NOLOCK) ON pm.Number = m.number
              AND m.customer in ('0003157')      
       LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
       PCH.Client_ID IN (@ClientID)
       AND CAST(PV.Date AS DATE) BETWEEN CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
       AND PV.TelephonyCallType IN (1)
       
       END


	   SELECT * 
       FROM dclatitude..campaign c WITH (NOLOCK)
GO

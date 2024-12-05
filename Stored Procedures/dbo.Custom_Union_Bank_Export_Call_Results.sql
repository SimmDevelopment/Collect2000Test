SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 10/31/2019
-- Description:	Exports call results from date selected
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Union_Bank_Export_Call_Results] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SET @startDate = dbo.F_START_OF_DAY(@startDate)
	SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))
	

    -- Insert statements for procedure here
	SELECT 
	 CAST(PDA.CALL_DATE_TIME AS DATE) AS 'Date'
	,CAST(PDA.CALL_DATE_TIME AS TIME) AS 'Time'
	,'Outbound' AS 'Direction'
	,PDA.CAMPAIGN_ID AS 'Campaign ID'
	,C.DESCRIPTION AS 'Campaign Name'
	,PDA.STAGE_ID AS 'Stage ID'
	,S.DESCRIPTION AS 'Stage Name'
	,PDA.AGENT_ID AS 'Agent'
	,PDA.RECORD_KEY AS 'Record Key'
	,'' AS 'Disposition'
	,PDA.RESULT_CODE AS 'Result Code'
	,PDA.RESULT_NOTE AS 'Result Note'
	,PDA.PHONE_NUMBER AS 'Phone Number'
	,'' AS 'DNIS'
	,0 AS 'Agent Duration'
	,PDA.Duration AS 'Call Duration'
	,IsNull(pt.PhoneTypeDescription,0) AS 'Phone Type'
	,CASE WHEN PDA.CallType <> 0 THEN 'Manual' ELSE 'MobileComply' END AS 'Call Type'
	,(SELECT COUNT(*) FROM promises WITH (NOLOCK) WHERE AcctID = pda.record_key AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE) ) AS 'Num of Promises'
	,ISNULL((SELECT SUM(Amount) FROM promises WITH (NOLOCK) WHERE AcctID = pda.record_key AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)), 0) AS 'Amount of Promises'
	,(SELECT COUNT(*) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = pda.record_key AND IsActive =1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)) AS 'Num of PCC'
	,ISNULL((SELECT SUM(amount) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = pda.record_key AND IsActive =1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)), 0) AS 'Amount of PCC'
	,(SELECT COUNT(*) FROM pdc WITH (NOLOCK) WHERE number = pda.record_key AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE) ) AS 'Num of PDC'
	,ISNULL((SELECT SUM(amount) FROM pdc WITH (NOLOCK) WHERE number = pda.record_key AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE) ), 0) AS 'Amount of PDC'
	,ISNULL((SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = pda.record_key AND batchtype LIKE 'pu' AND CAST(datepaid AS DATE) = CAST(GETDATE()-1 AS DATE) ), 0) AS 'Payments Made'
	, m.account AS [Account Number]
FROM
	DCLatitude..PD_Activity_Log PDA WITH(NOLOCK)
LEFT JOIN master m WITH (NOLOCK)
ON
	pda.RECORD_KEY = m.number
JOIN
	DCLatitude..Campaign C WITH(NOLOCK)
ON
	PDA.CAMPAIGN_ID = C.CAMPAIGN_ID
JOIN
	DCLatitude..Stage S WITH(NOLOCK)
ON
	PDA.CAMPAIGN_ID = S.CAMPAIGN_ID
	AND PDA.STAGE_ID = S.STAGE_ID
LEFT JOIN
	Phones_Master PM WITH(NOLOCK)
ON
	PDA.RECORD_KEY = PM.Number
	AND PDA.PHONE_NUMBER = PM.PhoneNumber
LEFT JOIN 
	Phones_Types pt WITH (NOLOCK)
ON
	pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	PDA.CALL_DATE_TIME BETWEEN @startDate AND @endDate
	AND PDA.RESULT_CODE <> 'T'
	AND PDA.CLIENT_ID = 6
	AND PDA.CAMPAIGN_ID IN (72,73,192,206)


UNION ALL


SELECT
	 CAST(PCH.RESULT_DATE AS DATE) AS 'Date'
	,CAST(PCH.RESULT_DATE AS TIME) AS 'Time'
	,CASE WHEN PCH.MODE = 1 THEN 'Inbound' ELSE 'Outbound' END AS 'Direction'
	,PCH.CAMPAIGN_ID AS 'Campaign ID'
	,C.DESCRIPTION AS 'Campaign Name'
	,IsNull(PCH.STAGE_ID,1) AS 'Stage ID'
	,IsNull(S.DESCRIPTION,'') AS 'Stage Name'
	,PCH.ADD_USER AS 'Agent'
	,PCH.RECORD_KEY AS 'Record Key'
	,D.Description AS 'Disposition'
	,PCH.RESULT_CODE AS 'Result Code'
	,PCH.RESULT_NOTE AS 'Result Note'
	,PCH.PHONE_NUMBER AS 'Phone Number'
	,'' AS 'DNIS'
	,PCH.DURATION
	,IsNull(PV.Duration,0) AS 'Call Duration'
	,IsNull(pt.PhoneTypeDescription,0) AS 'Phone Type'
	,
	CASE 
		WHEN PCH.MODE=1 THEN 'Inbound'
		WHEN PCH.MODE=2 THEN 'Outbound'
		WHEN PCH.MODE=3 THEN 'Blended'
		WHEN PCH.MODE=4 THEN 'Power'
		WHEN PCH.MODE=5	THEN 'Data'
		WHEN PCH.MODE=6	THEN 'MobileComply Initiated'
		WHEN PCH.MODE=7	THEN 'MobileComply Manual'
	END
	AS 'Call Type'
	,(SELECT COUNT(*) FROM promises WITH (NOLOCK) WHERE AcctID = pch.record_key AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)) AS 'Num of Promises'
	,ISNULL((SELECT SUM(Amount) FROM promises WITH (NOLOCK) WHERE AcctID = pch.record_key AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)), 0) AS 'Amount of Promises'
	,(SELECT COUNT(*) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = pch.record_key AND IsActive =1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)) AS 'Num of PCC'
	,ISNULL((SELECT SUM(amount) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = pch.record_key AND IsActive =1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)), 0) AS 'Amount of PCC'
	,(SELECT COUNT(*) FROM pdc WITH (NOLOCK) WHERE number = pch.record_key AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE) ) AS 'Num of PDC'
	,ISNULL((SELECT SUM(amount) FROM pdc WITH (NOLOCK) WHERE number = pch.record_key AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE) ), 0) AS 'Amount of PDC'
	,ISNULL((SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = pch.record_key AND batchtype LIKE 'pu' AND CAST(datepaid AS DATE) = CAST(GETDATE()-1 AS DATE) ), 0) AS 'Payments Made'
	, m.account AS [Account Number]

FROM
	DCLatitude..Prospect_CallHist PCH WITH(NOLOCK)
LEFT JOIN master m WITH (NOLOCK)
ON
	pch.RECORD_KEY = m.number
JOIN
	DCLatitude..Campaign C WITH(NOLOCK)
ON
	PCH.CAMPAIGN_ID = C.CAMPAIGN_ID
LEFT JOIN
	DCLatitude..Stage S WITH(NOLOCK)
ON
	PCH.CAMPAIGN_ID = S.CAMPAIGN_ID
	AND PCH.STAGE_ID = S.STAGE_ID
JOIN
	DCLatitude..Disposition D WITH(NOLOCK)
ON
	PCH.RESULT_ID = D.Result_ID
LEFT JOIN
	Phones_Master PM WITH(NOLOCK)
ON
	PCH.RECORD_KEY = PM.Number
	AND PCH.PHONE_NUMBER = PM.PhoneNumber
LEFT JOIN 
	Phones_Types pt WITH (NOLOCK)
ON
	pm.PhoneTypeID = pt.PhoneTypeID
LEFT JOIN
	DCLatitude..Prospect_Voice PV WITH(NOLOCK)
ON
	PCH.SEQUENCE = PV.ProspectCallHistId
WHERE
	PCH.RESULT_DATE BETWEEN @startDate AND @endDate
	AND PCH.CLIENT_ID = 6
	AND PCH.CAMPAIGN_ID IN (72,73,192,206)


UNION ALL


SELECT
	 CAST(ICL.CallStartDT AS DATE) AS 'Date'
	,CAST(ICL.CallStartDT AS TIME) AS 'Time'
	,'Inbound' AS 'Direction'
	,ICL.CampaignID AS 'Campaign ID'
	,C.DESCRIPTION AS 'Campaign Name'
	,1 AS 'Stage ID'
	,'' AS 'Stage Name'
	,'' AS 'Agent'
	,ICL.RecordKey AS 'Record Key'
	,
	CASE
		WHEN ICL.Result = -3 THEN 'Error during Routing'
		WHEN ICL.Result = -2 THEN 'Inbound_Call Record Was Not Removed'
		WHEN ICL.Result = -1 THEN 'IVR Failed'
		WHEN ICL.Result = 0	THEN 'None'
		WHEN ICL.Result = 1	THEN 'Abandoned'
		WHEN ICL.Result = 2	THEN 'Route Timed Out'
		WHEN ICL.Result = 3	THEN 'Routed To Agent'
		WHEN ICL.Result = 4	THEN 'Routed To 3rd Party'
		WHEN ICL.Result = 5	THEN 'Routed To Voice Mail'
		WHEN ICL.Result = 6	THEN 'IVR Completed'
		WHEN ICL.Result = 7	THEN 'IVR Abandoned'
	END
	AS 'Disposition'
	,CAST(ICL.Result AS VARCHAR(10)) AS 'Result Code'
	,'' AS 'Result Note'
	,ICL.ANI AS 'Phone Number'
	,ICL.DNIS AS 'DNIS'
	,0 AS 'Agent Duration'
	,0 AS 'Call Duration'
	,IsNull(pt.PhoneTypeDescription,0) AS 'Phone Type'
	,'Inbound' AS 'Call Type'
	,(SELECT COUNT(*) FROM promises WITH (NOLOCK) WHERE AcctID = icl.recordkey AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)) AS 'Num of Promises'
	,ISNULL((SELECT SUM(Amount) FROM promises WITH (NOLOCK) WHERE AcctID = icl.recordkey AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)), 0) AS 'Amount of Promises'
	,(SELECT COUNT(*) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = icl.recordkey AND IsActive =1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)) AS 'Num of PCC'
	,ISNULL((SELECT SUM(amount) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = icl.recordkey AND IsActive =1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE)), 0) AS 'Amount of PCC'
	,(SELECT COUNT(*) FROM pdc WITH (NOLOCK) WHERE number = icl.recordkey AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE) ) AS 'Num of PDC'
	,ISNULL((SELECT SUM(amount) FROM pdc WITH (NOLOCK) WHERE number = icl.recordkey AND Active = 1 AND CAST(DateCreated AS DATE) = CAST(GETDATE()-1 AS DATE) ), 0) AS 'Amount of PDC'
	,ISNULL((SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = icl.recordkey AND batchtype LIKE 'pu' AND CAST(datepaid AS DATE) = CAST(GETDATE()-1 AS DATE) ), 0) AS 'Payments Made'
	, m.account AS [Account Number]
FROM
	DCLatitude..Inbound_Call_Log ICL WITH(NOLOCK)
	LEFT JOIN master m WITH (NOLOCK)
ON
	icl.RECORDKEY = m.number
JOIN
	DCLatitude..Campaign C WITH(NOLOCK)
ON
	ICL.CampaignID = C.CAMPAIGN_ID
LEFT JOIN
	Phones_Master PM WITH(NOLOCK)
ON
	ICL.RecordKey = PM.Number
	AND ICL.ANI = PM.PhoneNumber
LEFT JOIN 
	Phones_Types pt WITH (NOLOCK)
ON
	pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	ICL.CallEndDT BETWEEN @startDate AND @endDate
	AND ICL.Result <> 3 /* Not routed to agent */
	AND ICL.CLIENTID = 6
	AND ICL.CAMPAIGNID IN (72,73,192,206)




END
GO

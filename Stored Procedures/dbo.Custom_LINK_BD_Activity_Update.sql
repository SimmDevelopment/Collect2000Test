SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_LINK_BD_Activity_Update] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	---Get Calls
	SELECT 
	'SAI' AS [VendorID], 
	m.account AS [AccountID], 
	m.number AS [ClientAccountID],
	(select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Acc.0.PlacementID') AS [PlacementID], 
	pm.MasterPhoneID AS [ContactID], 
	'PHONE' AS [ContactType], 
	u.UserName AS [EmployeeName],
	CASE WHEN pc.MODE = 1 OR InboundCallLogId IS NOT NULL THEN 'I' ELSE 'O' END AS [Outbound/Inbound],
	CASE WHEN result_code IN ('LM', 'LV' ) THEN 'T' ELSE 'F' END AS [VoicemailPlaced/Received],
	CASE WHEN pt.phonetypemapping = 2 THEN 'MANUAL' else 'AUTOMATIC' END AS [Dialing Method],
	pt.PhoneTypeDescription AS [PhoneType], 
	pc.PHONE_NUMBER AS [PhoneNumber], 
	convert(VARCHAR(5), pc.CHANGE_DATE, 108) AS [TimeContactBegan],
	CONVERT(VARCHAR(10),pc.change_date, 101) AS [DateofContact],
	RIGHT(CONVERT(VARCHAR(8), DATEADD(s, pc.DURATION, 0), 108), 5) AS [CallDuration],
	'' AS [TimeContactEnded], 
	'' AS [Off-Shore], 
	pc.RESULT_NOTE AS [CallNotes],
	pc.CALL_STATUS AS [ContactSucces], 
	'' AS [StreetAddress/EmailAddress]

FROM DCLatitude.dbo.Prospect_CallHist as pc WITH (NOLOCK) INNER JOIN Master m WITH (NOLOCK) ON pc.RECORD_KEY = m.number AND LEN(pc.RECORD_KEY) <= 8
INNER JOIN users u WITH (NOLOCK) ON pc.RESULT_USER = u.LoginName INNER JOIN AreaCode ac WITH (NOLOCK) ON SUBSTRING(pc.PHONE_NUMBER, 1, 3) = ac.AREACODE AND SUBSTRING(pc.PHONE_NUMBER, 4, 3) = ac.PREFIX
--INNER JOIN Timezone_Names tn WITH (NOLOCK ) ON ac.TIMEZONE = tn.TIMEZONE
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pc.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
INNER JOIN debtors d WITH (NOLOCK) ON pm.DebtorID = d.DebtorID
WHERE m.customer IN ('0003115')
AND ADD_DATE BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION ALL 

SELECT 
'SAI' AS [VendorID], m.account AS [AccountID], m.number AS [ClientAccountID],
	(select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Acc.0.PlacementID') AS [PlacementID], 
	pm.MasterPhoneID AS [ContactID], 
	'PHONE' AS [ContactType], 
	u.UserName AS [EmployeeName],
	CASE WHEN pc.MODE = 1 OR InboundCallLogId IS NOT NULL THEN 'I' ELSE 'O' END AS [Outbound/Inbound],
	CASE WHEN result_code IN ('LM', 'LV' ) THEN 'T' ELSE 'F' END AS [VoicemailPlaced/Received],
	CASE WHEN pt.phonetypemapping = 2 THEN 'MANUAL' else 'AUTOMATIC' END AS [Dialing Method],
	pt.PhoneTypeDescription AS [PhoneType], 
	pc.PHONE_NUMBER AS [PhoneNumber], 
	convert(VARCHAR(5), pc.CHANGE_DATE, 108) AS [TimeContactBegan],
	CONVERT(VARCHAR(10),pc.change_date, 101) AS [DateofContact],
	RIGHT(CONVERT(VARCHAR(8), DATEADD(s, pc.DURATION, 0), 108), 5) AS [CallDuration],
	'' AS [TimeContactEnded], 
	'' AS [Off-Shore], 
	pc.RESULT_NOTE AS [CallNotes],
	pc.CALL_STATUS AS [ContactSucces], '' AS [StreetAddress/EmailAddress]
FROM DCLatitude.dbo.Prospect_CallHist as pc WITH (NOLOCK) INNER JOIN Master m WITH (NOLOCK) ON pc.RECORD_KEY = m.number AND LEN(pc.RECORD_KEY) <= 8
INNER JOIN users u WITH (NOLOCK) ON pc.RESULT_USER = u.LoginName INNER JOIN AreaCode ac WITH (NOLOCK) ON SUBSTRING(pc.PHONE_NUMBER, 1, 3) = ac.AREACODE AND SUBSTRING(pc.PHONE_NUMBER, 4, 3) = ac.PREFIX
--INNER JOIN Timezone_Names tn WITH (NOLOCK ) ON ac.TIMEZONE = tn.TIMEZONE
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pc.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
INNER JOIN debtors d WITH (NOLOCK) ON pm.DebtorID = d.DebtorID
WHERE m.customer IN ('0003115')
AND ADD_DATE BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION ALL

--Get Letters
SELECT DISTINCT
'SAI' AS [VendorID], 
m.account AS [AccountID], 
m.number AS [ClientAccountID],
	(select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Acc.0.PlacementID') AS [PlacementID], 
	lr.LetterRequestID AS [ContactID], 
	'LETTER' AS [ContactType], 
	lr.UserName AS [EmployeeName],
	'' AS [Outbound/Inbound],
	'' AS [VoicemailPlaced/Received],
	'' AS [Dialing Method],
	'' AS [Phone Type],
	'' AS [PhoneNumber], 
	lr.DateCreated AS [TimeContactBegan],
	lr.DateProcessed AS [DateofContact],
	'' AS [CallDuration],
	'' AS [TimeContactEnded], 
	'' AS [Off-Shore], 
	'' AS [CallNotes],
	'' AS [ContactSucces], 
	m.Street1 + m.Street2  + m.City  + m.State  + m.Zipcode AS [StreetAddress/EmailAddress]
FROM LetterRequest lr WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON lr.AccountID = m.number
WHERE m.customer IN ('0003115')
AND CAST(lr.DateProcessed AS DATE) BETWEEN CAST(@startdate AS DATE) AND CAST(@endDate AS DATE)
AND (lr.ErrorDescription = '' OR lr.ErrorDescription IS NULL) 
AND (lr.lettercode LIKE '%VAL%' OR lr.lettercode LIKE '%SIF%' OR lr.lettercode like '00%' OR lr.lettercode LIKE 'PS%' OR 
	lr.lettercode IN ('09', '1BUYR','1BUYP','BUY00','BUY01','BUY02','BUY03','BUY04','BUY05','BUY06','BUY07','BUY08','BUY09','BUY10','BUY11','BUY12','BUY13','BUY14','BUY15','BUY16','BUY17','BUY18','BUY19','BUY20','BUY21','10', '11', '11-ny', '13', '13CC', '22', '90', '101', 'BYVS1', 'CA-DB', 'CLMCK', 'DISP1', 'ENDOC', 'NY-DB', 'NY01',
	'OPTDB', 'P1', 'P1TST', 'P2', 'P3', 'PPAYO', 'PREPF', 'PR-IH', 'PRPPF', 'PRROC', 'PRWOC', 'TAX', 'TAXDB', 'VSLDB', 'AS', 'AS-IH', 'PS-IH', 'AP', 'AP-IH', 'PP-IH', 'EML-2', 'EMAIL' ))



	UNION ALL

--Get Emails
	SELECT
	'SAI' AS [VendorID],
   m.account AS [AccountID], 
   m.number AS [ClientAccountID],
   (select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Acc.0.PlacementID') AS [PlacementID], 
   '' AS [ContactID], 
   CASE WHEN n.action = 'EMVSL' THEN 'EMAIL' END AS [ContactType], 
   n.user0 AS [EmployeeName],
	'' AS [Outbound/Inbound],
	'' AS [VoicemailPlaced/Received],
	'' AS [Dialing Method],
	'' AS [Phone Type],
	'' AS [PhoneNumber], 
	'' AS [TimeContactBegan],
	n.created AS [DateofContact],
	'' AS [CallDuration],
	'' AS [TimeContactEnded], 
	'' AS [Off-Shore], 
	'' AS [CallNotes],
	'' AS [ContactSucces], 
	D.Email AS [StreetAddress/EmailAddress]		
	FROM notes n WITH(NOLOCK)INNER JOIN master m WITH (NOLOCK) ON m.number = n.number
	INNER JOIN Debtors d WITH(NOLOCK) ON m.number = d.Number
	LEFT OUTER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
	--INNER JOIN notes n WITH(NOLOCK) ON m.number = n.number
	--INNER JOIN LetterRequest lr WITH(NOLOCK) ON m.number = lr.AccountID
	WHERE m.customer IN ('0003115') --AND status IN ('hot', 'pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'bkn', 'clm')
	AND dbo.date(n.created) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
	--AND dbo.date(n.created) BETWEEN dbo.date('20231101') AND dbo.date('20231205')
	----AND dbo.date(lr.DateProcessed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


END

GO

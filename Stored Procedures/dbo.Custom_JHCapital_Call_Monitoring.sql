SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:		03/01/2021 BGM Added code to filter out the prev creditor on the first query so it won't duplicate.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_Call_Monitoring]
	-- Add the parameters for the stored procedure here
	@startDate as DATETIME,
	@endDate AS DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CONVERT(VARCHAR(10), pc.change_date, 101) AS [Date], 
convert(VARCHAR(5), pc.CHANGE_DATE, 108) AS [Time], 
u.UserName AS [Name],  
RIGHT(CONVERT(VARCHAR(8), DATEADD(s, pc.DURATION, 0), 108), 5) AS [Duration], 
m.id1 AS [JH_Data_ID], 
pc.PHONE_NUMBER AS [Number], 
pt.PhoneTypeDescription AS [Phone_Type],
CASE WHEN pt.phonetypemapping = 2 THEN 'Manual' else 'Dialer' END AS [Call_Method], 
d.firstName + ' ' + d.lastName AS [Customer_Name], 
d.STATE AS [Customer_State], 
CASE WHEN result_code IN ('LM', 'LV' ) THEN 'Yes' ELSE 'No' END AS [Message_Left],
CASE WHEN result_code IN ('TT', 'PP', 'RP') THEN 'Yes' ELSE 'No' END AS [Right_Party_Contact],
CASE WHEN result_code IN ('3PHU', 'DHU') THEN 'Yes' ELSE 'No' END AS [Customer_Hung_Up],
CASE WHEN result_code IN ('WN') THEN 'Yes' ELSE 'No' END AS [Wrong_Number],
CASE tn.TIMEZONE_ABBR WHEN 'pt' THEN 'PTZ' WHEN 'mt' THEN 'MTZ' WHEN 'ct' THEN 'CTZ'
	WHEN 'est' THEN 'ETZ' WHEN 'ak' THEN 'AKST' WHEN 'hi' THEN 'HST' ELSE '' END AS [Time_Zone],
CASE WHEN pc.MODE = 1 OR InboundCallLogId IS NOT NULL THEN 'Inbound' ELSE 'Outbound' END AS direction      	

FROM DCLatitude.dbo.Prospect_CallHist as pc WITH (NOLOCK) INNER JOIN Master m WITH (NOLOCK) ON pc.RECORD_KEY = m.number AND LEN(pc.RECORD_KEY) <= 8
INNER JOIN users u WITH (NOLOCK) ON pc.RESULT_USER = u.LoginName INNER JOIN AreaCode ac WITH (NOLOCK) ON SUBSTRING(pc.PHONE_NUMBER, 1, 3) = ac.AREACODE AND SUBSTRING(pc.PHONE_NUMBER, 4, 3) = ac.PREFIX
INNER JOIN Timezone_Names tn WITH (NOLOCK ) ON ac.TIMEZONE = tn.TIMEZONE
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pc.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
INNER JOIN debtors d WITH (NOLOCK) ON pm.DebtorID = d.DebtorID

WHERE m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND ADD_DATE BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)and id2 not in ('AllGate','ARS-JMET')
--AND pc.RESULT_CODE IN ('tt', 'pp', 'lm', 'lv', 'RP', '3PHU', 'DHU')
and PreviousCreditor <> 'JHPDE SPV II, LLC'

UNION ALL 

	SELECT CONVERT(VARCHAR(10), pc.change_date, 101) AS [Date], 
convert(VARCHAR(5), pc.CHANGE_DATE, 108) AS [Time], 
u.UserName AS [Name],  
RIGHT(CONVERT(VARCHAR(8), DATEADD(s, pc.DURATION, 0), 108), 5) AS [Duration], 
m.id1 AS [JH_Data_ID], 
pc.PHONE_NUMBER AS [Number], 
pt.PhoneTypeDescription AS [Phone_Type],
CASE WHEN pt.phonetypemapping = 2 THEN 'Manual' else 'Dialer' END AS [Call_Method], 
d.firstName + ' ' + d.lastName AS [Customer_Name], 
d.STATE AS [Customer_State], 
CASE WHEN result_code IN ('LM', 'LV' ) THEN 'Yes' ELSE 'No' END AS [Message_Left],
CASE WHEN result_code IN ('TT', 'PP', 'RP') THEN 'Yes' ELSE 'No' END AS [Right_Party_Contact],
CASE WHEN result_code IN ('3PHU', 'DHU') THEN 'Yes' ELSE 'No' END AS [Customer_Hung_Up],
CASE WHEN result_code IN ('WN') THEN 'Yes' ELSE 'No' END AS [Wrong_Number],
CASE tn.TIMEZONE_ABBR WHEN 'pt' THEN 'PTZ' WHEN 'mt' THEN 'MTZ' WHEN 'ct' THEN 'CTZ'
	WHEN 'est' THEN 'ETZ' WHEN 'ak' THEN 'AKST' WHEN 'hi' THEN 'HST' ELSE '' END AS [Time_Zone],
CASE WHEN pc.MODE = 1 OR InboundCallLogId IS NOT NULL THEN 'Inbound' ELSE 'Outbound' END AS direction      	

FROM DCLatitude.dbo.Prospect_CallHist as pc WITH (NOLOCK) INNER JOIN Master m WITH (NOLOCK) ON pc.RECORD_KEY = m.number AND LEN(pc.RECORD_KEY) <= 8
INNER JOIN users u WITH (NOLOCK) ON pc.RESULT_USER = u.LoginName INNER JOIN AreaCode ac WITH (NOLOCK) ON SUBSTRING(pc.PHONE_NUMBER, 1, 3) = ac.AREACODE AND SUBSTRING(pc.PHONE_NUMBER, 4, 3) = ac.PREFIX
INNER JOIN Timezone_Names tn WITH (NOLOCK ) ON ac.TIMEZONE = tn.TIMEZONE
INNER JOIN dbo.Phones_Master pm WITH (NOLOCK) ON pc.PHONE_NUMBER = pm.PhoneNumber AND m.number = pm.Number
INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
INNER JOIN debtors d WITH (NOLOCK) ON pm.DebtorID = d.DebtorID

WHERE m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND ADD_DATE BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
and id2 not in ('AllGate','ARS-JMET')
and PreviousCreditor = 'JHPDE SPV II, LLC'

END
GO

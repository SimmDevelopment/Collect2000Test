SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Weekly_Call_Log_List]
	-- Add the parameters for the stored procedure here
	@date DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DECLARE @startOfWeek DATETIME
DECLARE @endOfWeek	DATETIME
SET @startOfWeek = dbo.F_START_OF_WEEK(@date, 2)
SET @endOfWeek = dbo.F_END_OF_WEEK(@date, 2)


SELECT DISTINCT CONVERT(VARCHAR(50), pch.RecordingCallId) + CONVERT(VARCHAR(10), pt.phonetypeid) AS [RecordingID], m.account AS [URSAcctid], pv.Record_Key AS [Client AcctID], CONVERT(VARCHAR(10), [date], 101) AS [RecordingDate], 
CONVERT(VARCHAR(10), CallStartTime, 101) AS [CallDate],  CONVERT(VARCHAR(10), CallStartTime, 108) AS [CallTime], pv.duration AS [CallLength], telephone AS [PhoneNumber], 
pt.PhoneTypeDescription AS [CallType], CASE WHEN pv.campaign_id IN (93, 94) THEN 'Inbound' ELSE 'Outbound' END AS [CallDirection], LoginID AS [UserID], pv.LoginName AS [UserName],
d2.lastName AS [Last Name], d2.firstName AS [First Name], d2.SSN AS [SSN], d2.City AS [CITY], d2.State AS [State]
FROM DCLatitude.dbo.Prospect_Voice pv WITH (NOLOCK) INNER JOIN DCLatitude.dbo.Disposition d WITH (NOLOCK) ON pv.ResultId = d.Result_ID
INNER JOIN DCLatitude.dbo.Prospect_CallHist pch WITH (NOLOCK) ON pv.ProspectCallHistId = pch.SEQUENCE
INNER JOIN master m	WITH (NOLOCK) ON pv.Record_Key = m.number 
INNER JOIN Phones_Master pm WITH (NOLOCK) ON pv.Telephone = pm.PhoneNumber AND pv.Record_Key = pm.Number
INNER JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
INNER JOIN debtors d2 WITH (NOLOCK) ON pm.DebtorID = d2.DebtorID
WHERE pv.Campaign_ID IN (SELECT CAMPAIGN_ID FROM DCLatitude..Campaign c WITH (NOLOCK) WHERE CLIENT_ID IN (11, 7))
AND [date] BETWEEN @startOfWeek AND @endOfWeek AND m.customer IN (SELECT CustomerID FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 113)

END
GO

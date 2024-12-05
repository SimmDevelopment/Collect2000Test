SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LatitudeLegal_ReconciliationReport]
@startdate datetime,
@enddate datetime,
@sentdate datetime
AS

BEGIN


--SELECT WHAT WE SENT IN AN 18 AND DID NOT RECEIVE BACK
SELECT 
'Sent And Not Received' as [Status],
a.Name,
llrSent.AccountID as [Number],
llrSent.FORW_FILE as [Account],
llrSent.DPLACED as [Placed],
llrSent.DEBT_NAME as [Name],
llrSent.CRED_NAME as [Original Creditor],
llrSent.D1_BAL as [Current Balance]
FROM LatitudeLegal_Reconciliation llrSent WITH (NOLOCK)
JOIN Attorney a WITH (NOLOCK) ON llrSent.FIRM_ID = a.YouGotClaimsID
LEFT OUTER JOIN LatitudeLegal_Reconciliation llrReceived WITH (NOLOCK) ON llrSent.AccountID = llrReceived.AccountID 
	AND llrSent.SentFlag = 1 AND llrReceived.SentFlag = 0 AND llrReceived.ReceivedDate between @startdate and @enddate
	AND llrSent.FIRM_ID = llrReceived.FIRM_ID
	AND month(llrSent.SentDate) = month(@sentdate) 
	AND year(llrSent.SentDate) = year(@sentdate)
	AND day(llrSent.SentDate) = day(@sentdate)
WHERE llrReceived.AccountID is null


--SELECT WHAT WE RECEIVED AND DID NOT SEND
SELECT 
'Received And Not Sent' as [Status],
a.Name,
llrReceived.AccountID as [Number],
llrReceived.FORW_FILE as [Account],
llrReceived.DPLACED as [Placed],
llrReceived.DEBT_NAME as [Name],
llrReceived.CRED_NAME as [Original Creditor],
llrReceived.D1_BAL as [Current Balance]
FROM LatitudeLegal_Reconciliation llrReceived WITH (NOLOCK)
JOIN Attorney a WITH (NOLOCK) ON llrReceived.FIRM_ID = a.YouGotClaimsID
LEFT OUTER JOIN LatitudeLegal_Reconciliation llrSent WITH (NOLOCK) ON llrSent.AccountID = llrReceived.AccountID 
	AND llrSent.SentFlag = 1 AND llrReceived.SentFlag = 0 AND llrReceived.ReceivedDate between @startdate and @enddate
	AND llrSent.FIRM_ID = llrReceived.FIRM_ID
	AND month(llrSent.SentDate) = month(@sentdate) 
	AND year(llrSent.SentDate) = year(@sentdate)
	AND day(llrSent.SentDate) = day(@sentdate)
WHERE llrSent.AccountID is null


END
GO

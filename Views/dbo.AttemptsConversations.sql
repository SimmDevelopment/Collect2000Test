SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[AttemptsConversations]
AS
	SELECT 
	(SELECT COUNT(1) FROM Phonecall_Attempts pa WHERE CONVERT(DATE,pa.AttemptDate) > DATEADD(DAY, -8, GETDATE()) AND pa.DebtorID = d.DebtorID) AS AttemptsInLast7Days,
	(SELECT COUNT(1) FROM Phonecall_Attempts pa WHERE CONVERT(DATE,pa.AttemptDate) > DATEADD(DAY, -31, GETDATE()) AND pa.DebtorID = d.DebtorID) AS AttemptsInLast30Days,
	DebtorID AS Debtor,
	(SELECT TOP 1 CONVERT(DATE,ContactDate) FROM Phonecall_Contacts pc WHERE pc.DebtorID = d.DebtorID ORDER BY pc.ContactDate DESC) AS LastConversationDate,
	NextAllowableCallAttemptDate NextCallableDate,
	CASE WHEN NextAllowableCallReason = 'EXPLICIT_PERMISSION' THEN 'Y' ELSE 'N' END AS ConsentToCall,
	CASE WHEN NextAllowableCallReason = 'EXPLICIT_PERMISSION' THEN NextAllowableCallAttemptDate ELSE NULL END AS ConsentToCallDate
	FROM Debtors d
GO

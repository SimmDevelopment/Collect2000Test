SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetDebtorCallAttempts] 
	@DebtorID INT
AS
BEGIN
	;WITH CTE_PhoneCallAttempt AS
	(
	SELECT TOP 1 DebtorID, Number, AttemptDate, totSeven.TotalAttemptsSeven, totThirty.TotalAttemptsThirty FROM Phonecall_Attempts
	CROSS JOIN
		(SELECT COUNT(*) AS TotalAttemptsSeven FROM Phonecall_Attempts WHERE DebtorID = @DebtorID AND AttemptDate >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))) totSeven
	CROSS JOIN
		(SELECT COUNT(*) AS TotalAttemptsThirty FROM Phonecall_Attempts WHERE DebtorID = @DebtorID AND AttemptDate >= DATEADD(DAY, -29, CAST(GETDATE() AS DATE)))  totThirty
	WHERE DebtorID = @DebtorID
	ORDER BY PhonecallAttemptsID DESC
	),
	CTE_PhoneCallContact AS
	(
	SELECT TOP 1 DebtorID, Number, ContactDate, ExpressConsentDate, totSeven.TotalContactsSeven, totThirty.TotalContactsThirty FROM Phonecall_Contacts 
	CROSS JOIN
		(SELECT COUNT(*) AS TotalContactsSeven FROM Phonecall_Contacts WHERE DebtorID = @DebtorID AND ContactDate >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))) totSeven
	CROSS JOIN
		(SELECT COUNT(*) AS TotalContactsThirty FROM Phonecall_Contacts WHERE DebtorID = @DebtorID AND ContactDate >= DATEADD(DAY, -29, CAST(GETDATE() AS DATE)))  totThirty
	WHERE DebtorID = @DebtorID
	ORDER BY PhonecallContactsID DESC
	)

	SELECT 
		d.NextAllowableCallAttemptDate AS NextCallableDate,
		d.NextAllowableCallReason AS NextCallableReason,
		ca.AttemptDate AS LastAttemptDate,
		cc.ContactDate AS LastContactDate,
		cc.ExpressConsentDate AS LastContactExpressConsentDate, 
		CASE d.NextAllowableCallReason WHEN 'EXPLICIT_PERMISSION' THEN 1 ELSE 0 END AS ConsentToCallAgain,
		ISNULL(ca.TotalAttemptsSeven, 0) AS TotalAttemptsSeven,
		ISNULL(ca.TotalAttemptsThirty, 0) AS TotalAttemptsThirty,
		ISNULL(cc.TotalContactsSeven, 0) AS TotalContactsSeven,
		ISNULL(cc.TotalContactsThirty, 0) AS TotalContactsThirty
	FROM Debtors d
	LEFT JOIN CTE_PhoneCallAttempt ca ON ca.DebtorID = d.DebtorID
	LEFT JOIN CTE_PhoneCallContact cc ON cc.DebtorID = d.DebtorID
	WHERE d.DebtorID = @DebtorID

END
GO

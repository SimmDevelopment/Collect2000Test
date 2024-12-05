SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Attunely_Staging_ScheduledPayments]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE @Updated BIT = 0

	INSERT INTO [dbo].[Attunely_ScheduledPayments]
           ([AccountKey]
           ,[ScheduledPaymentKey]
           ,[Type_Id]
           ,[AmountCents]
           ,[PromiseMadeTime]
           ,[PaymentDeadlineTime]
           ,[PaymentMethod_Id]
           ,[RecordTime])
	SELECT AcctId, 
		ID, 
		'ScheduledPaymentType|promise_to_pay', 
		ABS(Amount) * 100, 
		Entered, 
		DueDate, 
		'PaymentMethod|other', 
		GETUTCDATE() 
	FROM Attunely_AccountStubs a
		INNER JOIN Promises p
			ON a.AccountKey = p.AcctID
		LEFT OUTER JOIN Attunely_ScheduledPayments sp
			ON p.ID = sp.ScheduledPaymentKey
	WHERE sp.ScheduledPaymentKey IS NULL
		AND (p.Active = 1 OR p.Kept = 1)

	IF @@ROWCOUNT > 0 SET @Updated = 1
	
	INSERT INTO [dbo].[Attunely_ScheduledPayments]
           ([AccountKey]
           ,[ScheduledPaymentKey]
           ,[Type_Id]
           ,[AmountCents]
           ,[PromiseMadeTime]
           ,[PaymentDeadlineTime]
           ,[PaymentMethod_Id]
           ,[RecordTime])
	SELECT number,
		UID,
		'ScheduledPaymentType|post_dated_transaction', 
		ABS(amount) * 100,
		entered,
		deposit,
		'PaymentMethod|check_draft', 
		GETUTCDATE()
	FROM Attunely_AccountStubs a
		INNER JOIN PDC p
			ON a.AccountKey = p.number
		LEFT OUTER JOIN Attunely_ScheduledPayments sp
			ON p.UID = sp.ScheduledPaymentKey
	WHERE sp.ScheduledPaymentKey IS NULL
		AND (p.Active = 1 OR p.Printed = 1)

	IF @@ROWCOUNT > 0 SET @Updated = 1
	
	INSERT INTO [dbo].[Attunely_ScheduledPayments]
           ([AccountKey]
           ,[ScheduledPaymentKey]
           ,[Type_Id]
           ,[AmountCents]
           ,[PromiseMadeTime]
           ,[PaymentDeadlineTime]
           ,[PaymentMethod_Id]
           ,[RecordTime])
	SELECT number,
		ID,
		'ScheduledPaymentType|post_dated_transaction', 
		ABS(amount) * 100,
		DateEntered,
		DepositDate,
		CASE ApprovedBy WHEN 'PayWeb' THEN 'PaymentMethod|cc_web' ELSE 'PaymentMethod|cc_phone' END, 
		GETUTCDATE()
	FROM Attunely_AccountStubs a
		INNER JOIN DebtorCreditCards p
			ON a.AccountKey = p.number
		LEFT OUTER JOIN Attunely_ScheduledPayments sp
			ON p.ID = sp.ScheduledPaymentKey
	WHERE sp.ScheduledPaymentKey IS NULL
		AND (p.IsActive = 1 OR p.BatchNumber IS NOT NULL)

	IF @@ROWCOUNT > 0 SET @Updated = 1

	SELECT @Updated
END
GO

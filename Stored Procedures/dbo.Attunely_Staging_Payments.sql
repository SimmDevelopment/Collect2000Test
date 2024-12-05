SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Attunely_Staging_Payments]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE @Updated BIT = 0

	INSERT INTO [dbo].[Attunely_Payments]
           ([AccountKey]
           ,[TransactionKey]
           ,[PrincipalCents]
           ,[SurchargeCents]
           ,[Type_Id]
           ,[PaymentMethod_Id]
           ,[TransactionTime]
           ,[RecordTime])
	SELECT pays.Number,
			pays.uid,
			CASE WHEN pays.batchtype IN ('PUR','PCR','PAR') THEN ABS(pays.Cents) * -1 ELSE ABS(pays.Cents) END,
			CASE WHEN pays.batchtype IN ('PUR','PCR','PAR') THEN ABS(pays.Surcharge) * -1 ELSE ABS(pays.Surcharge) END,
			CASE WHEN pays.batchtype IN ('PUR','PCR','PAR') THEN 'PaymentType|reversal' ELSE 'PaymentType|payment' END,
			CASE COALESCE(vm.ValidMethod, 'PaymentMethod|other') 
			WHEN 'PaymentMethod|cc_mail' THEN 
				CASE WHEN pays.PhonePay > 0 THEN 'PaymentMethod|cc_phone'
				WHEN pays.WebPay > 2 THEN 'PaymentMethod|cc_web'
				END
			ELSE COALESCE(vm.ValidMethod, 'PaymentMethod|other') END,
			pays.Date,
			GETUTCDATE()
	FROM Attunely_AccountStubs a
		INNER JOIN (SELECT 
				p.number [Number], 
				p.uid [UID], 
				MAX(p.totalpaid - p.paid10) * 100 [Cents], 
				MAX(p.paid10) * 100 [Surcharge], 
				MAX(p.datepaid) [Date], 
				SUM(CASE n.result WHEN 'PP' THEN 1 WHEN 'TT' THEN 1 ELSE 0 END) [PhonePay],
				SUM(CASE n.user0 WHEN 'PayWeb' THEN 1 ELSE 0 END) [WebPay],
				p.batchtype,
				p.paymethod
			FROM payhistory p
				INNER JOIN notes n on p.number = n.number
			WHERE p.batchtype IN ('PU', 'PUR', 'PC', 'PCR', 'PA', 'PAR')
			GROUP BY p.number, p.UID, p.batchtype, p.paymethod) pays
			ON a.AccountKey = pays.[Number]
		LEFT OUTER JOIN Attunely_Payments existing ON pays.UID = existing.TransactionKey
		LEFT OUTER JOIN Attunely_Helper_PayMethodToValidValue vm
			ON pays.paymethod = vm.PayMethod
		WHERE existing.TransactionKey IS NULL
		
	IF @@ROWCOUNT > 0 SET @Updated = 1
	SELECT @Updated

END
GO

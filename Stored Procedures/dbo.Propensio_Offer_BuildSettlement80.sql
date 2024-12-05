SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Changes:
--	06/08/2021 BGM Added state check for RI and MA to not allow multi pays, single pays only.

CREATE procedure [dbo].[Propensio_Offer_BuildSettlement80]
	@AccountId NVARCHAR(max),
	@Balance MONEY
AS

	DECLARE @SettlementId UNIQUEIDENTIFIER
	SET @SettlementId = NEWID()
	DECLARE @Tier INT --Zero based. Each tier is presented to the consumer in order
	SET @Tier = 0
	
	--Create one pay settlement
	DECLARE @Payment1Amount MONEY
	DECLARE @MaxDate1 DATETIME
	DECLARE @Percent INT

	SET @Payment1Amount = ROUND(@Balance*.8, 2, 0)
	SET @MaxDate1 = DATEADD(d,7,GETDATE())
	SET @SettlementId = NEWID()

	INSERT INTO [dbo].[SettlementOffers]
           ([Id]
           ,[AccountId]
           ,[PolicyId]
           ,[ExpirationDate]
           ,[Priority]
           ,[Description]
           ,[TotalAmount]
           ,[IsSettlement]
           ,[Tier]
           ,[Code]
           ,[UtcCreated]
           ,[UtcUpdated])
     VALUES
           (@SettlementId,
			@AccountId,
			'',
			DATEADD(d, 1, GETDATE()),
			1, --Priority within each tier determines the order on the screen. (Order by Tier, Priority)
			'A payment of 80% of your current balance in ONE PAYMENT of $' + CONVERT(varchar, @Payment1Amount) + ' that must be received in this office on or before ' + CONVERT(varchar, @MaxDate1, 101),
			@Payment1Amount,
			0,
			@Tier,
           'STLMNT80', -- This is arbitrary. Can be used for reporting/metrics
           GETDATE(),
		   GETDATE())
		   
	--Create FuturePayments (2 part)
	DECLARE @MinDate DATETIME
	DECLARE @MaxDate2 DATETIME

	SET @MinDate = GETDATE()


	INSERT INTO [dbo].[FuturePayments]
           ([Id]
           ,[SettlementOfferId]
           ,[SuggestedPaymentDate]
           ,[MinDate]
           ,[MaxDate]
           ,[SuggestedPaymentAmount]
           ,[MinPaymentAmount]
           ,[MaxPaymentAmount])
     VALUES
           (NEWID(),
			@SettlementId,
			GETDATE(),
			@MinDate,
			DATEADD(d,-1,@MaxDate1),
			@Payment1Amount,
			@Payment1Amount,
			@Payment1Amount)
	--Create two pay settlement

	SET @SettlementId = NEWID()
	SET @MaxDate1 = DATEADD(d,14,GETDATE())
	SET @MaxDate2 = DATEADD(d, 35, GETDATE())
	SET @Payment1Amount = ROUND((@Balance*.82)/2, 2, 0)

	INSERT INTO [dbo].[SettlementOffers]
           ([Id]
           ,[AccountId]
           ,[PolicyId]
           ,[ExpirationDate]
           ,[Priority]
           ,[Description]
           ,[TotalAmount]
           ,[IsSettlement]
           ,[Tier]
           ,[Code]
           ,[UtcCreated]
           ,[UtcUpdated])
     VALUES
           (@SettlementId,
			@AccountId,
			'',
			DATEADD(d, 1, GETDATE()),
			2, --Priority within each tier determines the order on the screen. (Order by Tier, Priority)
			'A payment of 82% of your current balance in TWO PAYMENTS of $' + CONVERT(varchar, @Payment1Amount) + ' that must be received in this office. The first payment on or before ' + CONVERT(varchar,@MaxDate1, 101) + ' with the second and final payment due by ' + CONVERT(varchar, @MaxDate2,101) ,
			 @Payment1Amount * 2,
			0,
			@Tier,
           'STLMNT82', -- This is arbitrary. Can be used for reporting/metrics
           GETDATE(),
		   GETDATE())

	INSERT INTO [dbo].[FuturePayments]
           ([Id]
           ,[SettlementOfferId]
           ,[SuggestedPaymentDate]
           ,[MinDate]
           ,[MaxDate]
           ,[SuggestedPaymentAmount]
           ,[MinPaymentAmount]
           ,[MaxPaymentAmount])
     VALUES
           (NEWID(),
			@SettlementId,
			DATEADD(d,7,@MinDate),
			GETDATE(),
			DATEADD(d,-1,@MaxDate1),
			@Payment1Amount,
			@Payment1Amount,
			@Payment1Amount)

	INSERT INTO [dbo].[FuturePayments]
           ([Id]
           ,[SettlementOfferId]
           ,[SuggestedPaymentDate]
           ,[MinDate]
           ,[MaxDate]
           ,[SuggestedPaymentAmount]
           ,[MinPaymentAmount]
           ,[MaxPaymentAmount])
     VALUES
           (NEWID(),
			@SettlementId,
			DATEADD(d,-7,@MaxDate2),
			@MinDate,
			@MaxDate2,
			@Payment1Amount,
			@Payment1Amount,
			@Payment1Amount)
GO

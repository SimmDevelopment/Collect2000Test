SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Changes:
--	06/08/2021 BGM Added state check for RI and MA to not allow multi pays, single pays only.

CREATE procedure [dbo].[Propensio_Offer_Build]
	@AccountId NVARCHAR(max),
	@Balance MONEY
AS
	
--RI MA State check
	declare @state as varchar(3)
	select @state = m.state
	from master m WITH (NOLOCK)
	where m.number = @AccountId

-- if state is RI or MA then exit SP to prevent Multi pays to be presented on website.
	if (@state like 'RI' or @state like 'MA')
		begin
			return 0
		end

	DECLARE @SettlementId UNIQUEIDENTIFIER
	SET @SettlementId = NEWID()
	DECLARE @Tier INT --Zero based. Each tier is presented to the consumer in order
	SET @Tier = 0

	--TODO: Set Has Offer

	--50% SIF
	IF EXISTS(SELECT number FROM master 
	WHERE number = @AccountId AND customer IN ('0002213', '0002610','0001788','0003215') AND status IN ('ACT','BKN', 'BRP', 'COV', 'DBD', 'DCC', 'DIS', 'HLD', 'ILA', 'MHD', 'NEW', 'NHD', 'REV', 'SKP', 'VAL', 'VRD') 
		AND received <= DATEADD(d, -180, GETDATE()))
	BEGIN
		EXEC dbo.Propensio_Offer_BuildSettlement @AccountId, @Balance
		SET @Tier = 1
	END

	--80% SIF
	IF EXISTS(SELECT number FROM master 
	WHERE number = @AccountId AND customer IN ('0003299') AND status IN ('ACT','BKN', 'BRP', 'COV', 'DBD', 'DCC', 'DIS', 'HLD', 'ILA', 'MHD', 'NEW', 'NHD', 'REV', 'SKP', 'VAL', 'VRD') 
		AND received <= DATEADD(d, -90, GETDATE()))
	BEGIN
		EXEC dbo.Propensio_Offer_BuildSettlement90 @AccountId, @Balance
		SET @Tier = 1
	END

	--90% SIF
	IF EXISTS(SELECT number FROM master 
	WHERE number = @AccountId AND customer IN ('0003298') AND status IN ('ACT','BKN', 'BRP', 'COV', 'DBD', 'DCC', 'DIS', 'HLD', 'ILA', 'MHD', 'NEW', 'NHD', 'REV', 'SKP', 'VAL', 'VRD') 
		AND received <= DATEADD(d, -90, GETDATE()))
	BEGIN
		EXEC dbo.Propensio_Offer_BuildSettlement80 @AccountId, @Balance
		SET @Tier = 1
	END
	--Create 2 pay offer at 90 max

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
			'2 Future Payments',
			@Balance,
			0,
			@Tier,
           '2PAY', -- This is arbitrary. Can be used for reporting/metrics
           GETDATE(),
		   GETDATE())

	--Create FuturePayments (2 part)
	DECLARE @Payment1Amount MONEY
	DECLARE @Payment2Amount MONEY
	DECLARE @MinDate DATETIME
	DECLARE @MaxDate1 DATETIME
	DECLARE @MaxDate2 DATETIME

	SET @MinDate = GETDATE()
	SET @MaxDate1 = DATEADD(M, 1, GETDATE())
	SET @MaxDate2 = DATEADD(M, 2, GETDATE())
	SET @Payment1Amount = ROUND(@Balance/2, 2, 1)
	SET @Payment2Amount = @Balance - @Payment1Amount

	--TODO: Insert logic here if you need to avoid a particular day of the month being available for selection
	-- Any date between min date and max date will be available for the user to select

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
			@MaxDate1,
			@Payment1Amount,
			CASE WHEN @Payment1Amount < 25 THEN @Payment1Amount ELSE 25 END,
			@Balance)

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
			DATEADD(M,1,GETDATE()),
			@MinDate,
			@MaxDate2,
			@Payment2Amount,
			CASE WHEN @Payment2Amount < 25 THEN @Payment2Amount ELSE 25 END,
			@Balance)

	--Create 3 pay offer at 90 max


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
			2, --Priority within each tier determines the order on the screen. (Order by Tier, Priority)
			'3 Future Payments',
			@Balance,
			0,
			@Tier,
           '3PAY', -- This is arbitrary. Can be used for reporting/metrics
           GETDATE(),
		   GETDATE())

	--Create FuturePayments (3 part)
	DECLARE @Payment3Amount MONEY
	DECLARE @MaxDate3 DATETIME

	SET @MinDate = GETDATE()
	SET @MaxDate1 = DATEADD(M, 1, GETDATE())
	SET @MaxDate2 = DATEADD(M, 2, GETDATE())
	SET @MaxDate3 = DATEADD(M, 3, GETDATE())
	SET @Payment1Amount = ROUND(@Balance/3, 2, 1)
	SET @Payment2Amount = @Payment1Amount
	SET @Payment3Amount = @Balance - @Payment1Amount - @Payment2Amount

	--TODO: Insert logic here if you need to avoid a particular day of the month being available for selection
	-- Any date between min date and max date will be available for the user to select

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
			@MaxDate1,
			@Payment1Amount,
			CASE WHEN @Payment1Amount < 25 THEN @Payment1Amount ELSE 25 END,
			@Balance)

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
			DATEADD(M,1,GETDATE()),
			@MinDate,
			@MaxDate2,
			@Payment2Amount,
			CASE WHEN @Payment2Amount < 25 THEN @Payment2Amount ELSE 25 END,
			@Balance)

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
			DATEADD(M,2,GETDATE()),
			@MinDate,
			@MaxDate3,
			@Payment3Amount,
			CASE WHEN @Payment3Amount < 25 THEN @Payment3Amount ELSE 25 END,
			@Balance)


			
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
			3, --Priority within each tier determines the order on the screen. (Order by Tier, Priority)
			'6 Future Payments',
			@Balance,
			0,
			@Tier,
           '6PAY', -- This is arbitrary. Can be used for reporting/metrics
           GETDATE(),
		   GETDATE())

	--Create FuturePayments (6 part)
	DECLARE @Payment4Amount MONEY
	DECLARE @MaxDate4 DATETIME
	DECLARE @Payment5Amount MONEY
	DECLARE @MaxDate5 DATETIME
	DECLARE @Payment6Amount MONEY
	DECLARE @MaxDate6 DATETIME

	SET @MinDate = GETDATE()
	SET @MaxDate1 = DATEADD(M, 1, GETDATE())
	SET @MaxDate2 = DATEADD(M, 2, GETDATE())
	SET @MaxDate3 = DATEADD(M, 3, GETDATE())
	SET @MaxDate4 = DATEADD(M, 4, GETDATE())
	SET @MaxDate5 = DATEADD(M, 5, GETDATE())
	SET @MaxDate6 = DATEADD(M, 6, GETDATE())
	SET @Payment1Amount = ROUND(@Balance/6, 2, 1)
	SET @Payment2Amount = @Payment1Amount
	SET @Payment3Amount = @Payment1Amount
	SET @Payment4Amount = @Payment1Amount
	SET @Payment5Amount = @Payment1Amount
	SET @Payment6Amount = @Balance - @Payment1Amount - @Payment2Amount - @Payment3Amount - @Payment4Amount - @Payment5Amount 

	--TODO: Insert logic here if you need to avoid a particular day of the month being available for selection
	-- Any date between min date and max date will be available for the user to select

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
			@MaxDate1,
			@Payment1Amount,
			CASE WHEN @Payment1Amount < 25 THEN @Payment1Amount ELSE 25 END,
			@Balance)

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
			DATEADD(M,1,GETDATE()),
			@MinDate,
			@MaxDate2,
			@Payment2Amount,
			CASE WHEN @Payment2Amount < 25 THEN @Payment2Amount ELSE 25 END,
			@Balance)
			
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
			DATEADD(M,2,GETDATE()),
			@MinDate,
			@MaxDate3,
			@Payment3Amount,
			CASE WHEN @Payment3Amount < 25 THEN @Payment3Amount ELSE 25 END,
			@Balance)

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
			DATEADD(M,3,GETDATE()),
			@MinDate,
			@MaxDate4,
			@Payment4Amount,
			CASE WHEN @Payment4Amount < 25 THEN @Payment4Amount ELSE 25 END,
			@Balance)

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
			DATEADD(M,4,GETDATE()),
			@MinDate,
			@MaxDate5,
			@Payment5Amount,
			CASE WHEN @Payment5Amount < 25 THEN @Payment5Amount ELSE 25 END,
			@Balance)

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
			DATEADD(M,5,GETDATE()),
			@MinDate,
			@MaxDate6,
			@Payment6Amount,
			CASE WHEN @Payment6Amount < 25 THEN @Payment6Amount ELSE 25 END,
			@Balance)


GO

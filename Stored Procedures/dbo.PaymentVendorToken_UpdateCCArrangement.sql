SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/09/03
-- Description:	Set the PaymentVendorTokenId for all scheduled credit card payments in an arrangement
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 16:53:31-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Added procedures from 9 
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2009-10-13   Time: 09:41:57-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  removed CCImageId as OUTPUT parm and return a result set of the CCImageId's 
--  instead. There can be more than one for same CC device. 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2009-09-24   Time: 10:32:11-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  obfuscate data that was previously not 
--  
--  ****************** Version 1 ****************** 
--  User: jbryant   Date: 2009-09-22   Time: 15:53:15-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  New Procedures added for 9.0.0 
-- =============================================
CREATE PROCEDURE [dbo].[PaymentVendorToken_UpdateCCArrangement] 
	-- Add the parameters for the stored procedure here
	@CCId int, 
	@PaymentVendorTokenId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Err int
	DECLARE @Rows int
	DECLARE @ArrangementId int
	DECLARE @Number int
	DECLARE @CardNumber varchar(30)
	DECLARE @SecurityCode varchar(10)
	DECLARE @CardHolderName varchar(30)
	DECLARE @ExpMonth varchar(2)
	DECLARE @ExpYear varchar(2)
	DECLARE @ZipCode varchar(10)
	DECLARE @CCImageId uniqueidentifier

	DECLARE @ScheduledCCPayments table (
		paymentid int not null,
		number int not null, 
		CardNumber varchar(30),
		SecurityCode varchar(10),
		CardHolderName varchar(30),
		ExpMonth varchar(2),
		ExpYear varchar(2),
		CCImageId uniqueidentifier,
		ZipCode varchar(10),
		PaymentVendorTokenId int,
		ArrangementId int,
		primary key(paymentid))	

	-- Get any scheduled payments for this account that having matching payment device information...
	-- First, lets make sure that the CC for the passed in CCId is included. This should result in at least one row.
	INSERT INTO @ScheduledCCPayments 
	SELECT id, number, CardNumber, Code, Name, ExpMonth, ExpYear, CCImageId, ZipCode, PaymentVendorTokenId, ArrangementId
	FROM DebtorCreditCards 
	WHERE id =  @CCId
	
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	-- if we had an error then return the error
	IF @Err <> 0 RETURN @Err

	-- Get the ccimageid, arrangementid, and the CardNumber, SecurityCode, CardHolderName, and zipcode from the one record...
	SELECT 
		@Number = number, 
		@CardNumber = CardNumber,
		@SecurityCode = SecurityCode,
		@CardHolderName = CardHolderName,
		@ExpMonth = ExpMonth,
		@ExpYear = ExpYear,
		@ZipCode = ZipCode,
		@ArrangementId = ArrangementId, 
		@CCImageId = CCImageId
	FROM @ScheduledCCPayments 
	WHERE paymentid = @CCId
	
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	-- if we had an error then return the error
	IF @Err <> 0 RETURN @Err

	-- Now, lets attempt to find records for the same payment device...
	IF @CCImageId IS NOT NULL
	BEGIN
		-- with same CCImageId. Assumes that existing CC records for single card have same CCImageId.
		INSERT INTO @ScheduledCCPayments 
		SELECT id, number, CardNumber, Code, Name, ExpMonth, ExpYear, CCImageId, ZipCode, PaymentVendorTokenId, ArrangementId
		FROM DebtorCreditCards 
		WHERE CCImageId is not null 
			AND CCImageId = @CCImageId
			AND id NOT IN (SELECT paymentid FROM @ScheduledCCPayments)

		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
		-- if we had an error then return the error
		IF @Err <> 0 RETURN @Err
	END
	ELSE
	BEGIN
		SET @Rows = 0
	END
	
	-- If the record did not have a CCImageId or there were no matching records for the CCImageId, then we attempt to match information...
	IF @Rows = 0
	BEGIN
		-- for the same account with same CC data. This should only be for CC's that have not yet been encrypted (CCImageId == null)
		INSERT INTO @ScheduledCCPayments 
		SELECT id, number, CardNumber, Code, Name, ExpMonth, ExpYear, CCImageId, ZipCode, PaymentVendorTokenId, ArrangementId
		FROM DebtorCreditCards 
		WHERE number = @Number
			AND cardnumber = @CardNumber
			AND code = @SecurityCode 
			AND name = @CardHolderName 
			AND expmonth = @ExpMonth 
			AND expyear = @ExpYear 
			AND zipcode = @ZipCode
			AND id NOT IN (SELECT paymentid FROM @ScheduledCCPayments)
			
		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
		-- if we had an error then return the error
		IF @Err <> 0 RETURN @Err
	END

	-- with same arrangementid. Assumes that all CC records in the arrangement have same ArrangementId.
	IF @ArrangementId is not null
	BEGIN
		INSERT INTO @ScheduledCCPayments 
		SELECT id, number, CardNumber, Code, Name, ExpMonth, ExpYear, CCImageId, ZipCode, PaymentVendorTokenId, ArrangementId
		FROM DebtorCreditCards 
		WHERE arrangementid IS NOT null 
			AND arrangementid = @ArrangementId
			AND number = @Number
			AND cardnumber = @CardNumber
			AND code = @SecurityCode 
			AND name = @CardHolderName 
			AND expmonth = @ExpMonth 
			AND expyear = @ExpYear 
			AND zipcode = @ZipCode
			AND id NOT IN (SELECT paymentid FROM @ScheduledCCPayments)

		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
		-- if we had an error then return the error
		IF @Err <> 0 RETURN @Err
	END

	UPDATE debtorcreditcards
	SET	PaymentVendorTokenId = @PaymentVendorTokenId, CCImageID = null
	WHERE id IN (SELECT paymentid FROM @ScheduledCCPayments)

	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	-- if we had an error then return the error
	IF @Err <> 0 RETURN @Err
		
	-- update any cc records that have not already been obfuscated...
	IF LEN(@CardNumber) > 4 
		SET @CardNumber = '************' + SUBSTRING(@CardNumber, LEN(@CardNumber) - 3, 4)
	ELSE
		SET @CardNumber = '****************'

	IF EXISTS(SELECT TOP 1 Id FROM [dbo].[Wallet] WHERE [Wallet].[PaymentVendorTokenId] = @PaymentVendorTokenId)
	BEGIN
		UPDATE [dbo].[Wallet] 
		SET [AccountNumber] = @CardNumber
		WHERE [wallet].[PaymentVendorTokenId] IN (SELECT PaymentVendorTokenId FROM @ScheduledCCPayments)
		AND SUBSTRING(AccountNumber, 2, 8) != '********';
	END
	ELSE 
		BEGIN
			INSERT INTO [dbo].[Wallet](
				[ModeStatus],
				[LastOperation],
				[Type], 
				[PaymentVendorTokenId], 
				[DebtorId], 
				[SearchKey], 
				[AccountNumber], 
				[InstitutionCode], 
				[AccountType], 
				[PayorName] , 
				[CCExpiration], 
				[CreatedWhen] , 
				[CreatedBy] , 
				[UpdatedWhen], 
				[UpdatedBy])
				SELECT TOP 1
				'Searchable',
				'New',
				'CreditCard', --CREDIT CARD , ACH DEBIT, PAPER DRAFT
				[DebtorCreditCards].[PaymentVendorTokenId],
				CASE WHEN ([Debtors].[DebtorId] IS NULL) THEN (SELECT TOP 1 DebtorID FROM Debtors as db WHERE [db].[Number] = [DebtorCreditCards].[Number] AND [db].[Seq] = 0) ELSE [DebtorCreditCards].[DebtorId] END,
				CASE WHEN (LEN(ISNULL([DebtorCreditCards].[CardNumber], '')) > 4) THEN RIGHT([DebtorCreditCards].[CardNumber],4)
				ELSE LTRIM(RTRIM(RIGHT(SPACE(4) + [DebtorCreditCards].[CardNumber], 4))) END,
				@CardNumber,
				[DebtorCreditCards].[CreditCard],
				'CREDIT',
				[DebtorCreditCards].[Name],
				CASE WHEN [DebtorCreditCards].[EXPMonth] <> '00' AND [DebtorCreditCards].[EXPYear] <> '00' 
				THEN CASE WHEN [DebtorCreditCards].[EXPYear] < 100 
				THEN CAST(CAST(2000+[DebtorCreditCards].[EXPYear] AS VARCHAR) + '-' + CAST([DebtorCreditCards].[EXPMonth] AS VARCHAR) + '-15' AS DATE)
				ELSE CAST(CAST([DebtorCreditCards].[EXPYear] AS VARCHAR) + '-' + CAST([DebtorCreditCards].[EXPMonth] AS VARCHAR) + '-15' AS DATE)
				END
				ELSE NULL END,--Expiration
				GETDATE(),
				'ADMIN',
				GETDATE(),
				'ADMIN'
				FROM [dbo].[DebtorCreditCards] 
				LEFT OUTER JOIN [dbo].[Debtors] [Debtors]
				ON [DebtorCreditCards].[DebtorID] =[Debtors].[DebtorID]
				where [DebtorCreditCards].[PaymentVendorTokenId] = @PaymentVendorTokenId


			INSERT INTO [dbo].[WalletContact](
				[WalletId], 
				[AccountAddress1], 
				[AccountAddress2] ,
				[AccountCity] ,
				[AccountState] ,
				[AccountZipcode]
				)
			SELECT TOP 1
				[Wallet].[Id],
				[DebtorCreditCards].[Street1],
				[DebtorCreditCards].[Street2],
				[DebtorCreditCards].[City] ,
				[DebtorCreditCards].[State] ,
				[DebtorCreditCards].[Zipcode]
				FROM [dbo].[DebtorCreditCards] [DebtorCreditCards]
				INNER JOIN [dbo].[Wallet] [Wallet]
				ON [Wallet].[PaymentVendorTokenId] = [DebtorCreditCards].[PaymentVendorTokenId]
				WHERE [DebtorCreditCards].[PaymentVendorTokenId] = @PaymentVendorTokenId;		
		END
	UPDATE debtorcreditcards
	SET	PaymentVendorTokenId = @PaymentVendorTokenId, 
		CCImageID = null, 
		name = null,
		code = null,
		expmonth = null, 
		expyear = null, 
		cardnumber = null,
		CreditCard = null
	WHERE id IN (SELECT paymentid FROM @ScheduledCCPayments)
		AND SUBSTRING(cardnumber, 2, 8) != '********'

	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	-- if we had an error then return the error
	IF @Err <> 0 RETURN @Err
	
	-- Generate the result set for use by calling application so it can delete the encrypted data...
	SELECT CCImageId FROM @ScheduledCCPayments
	
	RETURN @@ERROR
END
GO

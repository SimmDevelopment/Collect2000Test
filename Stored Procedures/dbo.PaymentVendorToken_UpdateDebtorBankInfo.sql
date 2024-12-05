SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/11/09
-- Description:	Set the PaymentVendorTokenId for the debtorbankinfo record corresponding to the given id.
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 16:53:31-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Added procedures from 9 
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2009-11-09   Time: 16:55:31-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  added paymentvendortoken_updatedebtorbankinfo 
-- =============================================
CREATE PROCEDURE [dbo].[PaymentVendorToken_UpdateDebtorBankInfo] 
	@BankId int,
	@PaymentVendorTokenId int
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRANSACTION;
	BEGIN TRY
	IF EXISTS(SELECT TOP 1 Id FROM [dbo].[Wallet] WHERE [Wallet].[PaymentVendorTokenId] = @PaymentVendorTokenId)
		BEGIN
			UPDATE [dbo].[pdc] SET DebtorBankID=NULL WHERE [PaymentVendorTokenId] = @PaymentVendorTokenId;
			UPDATE [dbo].[Wallet] SET [AccountNumber] = CASE WHEN (LEN(ISNULL(AccountNumber, '')) > 4) 
									THEN '************' + SUBSTRING(AccountNumber, LEN(AccountNumber) - 3, 4)
									ELSE '****************'
									END
			WHERE [Wallet].[PaymentVendorTokenId] = @PaymentVendorTokenId;
		END
	ELSE 
		BEGIN
			INSERT INTO [dbo].[Wallet](
				[ModeStatus], --Searchable
				[LastOperation], --New
				[Type], --ACH, PaperDraft
				[PaymentVendorTokenId], --pdc/dcc PaymentVendorTokenID
				[DebtorId], --Debtors.DebtorID
				[SearchKey], --*************1111
				[AccountNumber], --*************1111
				[InstitutionCode], --ABA/CreditCardCode
				[AccountType], --CREDIT/CHECKING/SAVINGS
				[PayorName] , --Name of payer
				[CreatedWhen] , --GETDATE()
				[CreatedBy] , --CONV
				[UpdatedWhen], --GETDATE()
				[UpdatedBy] --CONV
				)
			SELECT TOP 1
				'Searchable',
				'New',
				CASE [pd].[PDC_Type] WHEN 6 THEN 'PaperDraft' WHEN 7 THEN 'ACH' END,
				@PaymentVendorTokenId,
				[Debtors].[DebtorId],
				CASE WHEN (LEN(ISNULL([DebtorBankInfo].[AccountNumber], [PaymentVendorToken].[MaskedValue])) > 4) THEN RIGHT(ISNULL([DebtorBankInfo].[AccountNumber], [PaymentVendorToken].[MaskedValue]),4)
				ELSE LTRIM(RTRIM(RIGHT(SPACE(4) + ISNULL([DebtorBankInfo].[AccountNumber], [PaymentVendorToken].[MaskedValue]), 4))) END,
				CASE WHEN (LEN(ISNULL(AccountNumber, '')) > 4) 
							THEN '************' + SUBSTRING(AccountNumber, LEN(AccountNumber) - 3, 4)
							ELSE '****************'
							END,
				[DebtorBankInfo].[ABANumber],
				CASE [DebtorBankInfo].[AccountType] WHEN 'C' THEN 'CHECKING' WHEN 'S' THEN 'SAVINGS' END,
				[DebtorBankInfo].[AccountName],
				GETDATE(),
				'ADMIN',
				GETDATE(),
				'ADMIN'
				FROM [dbo].[DebtorBankInfo] 
				INNER JOIN [dbo].[pdc] [pd] 
				ON [pd].[DebtorBankID] = [DebtorBankInfo].[BankID]
				INNER JOIN [dbo].[Debtors] [Debtors]
				ON [DebtorBankInfo].[AcctID] =[Debtors].[Number] AND [DebtorBankInfo].[DebtorID] = [Debtors].[Seq]
				INNER JOIN [dbo].[PaymentVendorToken] 
				ON [pd].[PaymentVendorTokenId] = [PaymentVendorToken].[Id]
				where [pd].[PaymentVendorTokenId] = @PaymentVendorTokenId AND [DebtorBankInfo].[BankID] IS NOT NULL

				INSERT INTO [dbo].[WalletContact](
					[WalletId], 
					[AccountAddress1], 
					[AccountAddress2] ,
					[AccountCity] ,
					[AccountState] ,
					[AccountZipcode],
					[BankAddress] ,
					[BankCity] ,
					[BankState] ,
					[BankZipcode],
					[BankName] ,
					[BankPhone] 
					)
				SELECT TOP 1
					[Wallet].[Id],
					[DebtorBankInfo].[AccountAddress1],
					[DebtorBankInfo].[AccountAddress2],
					[DebtorBankInfo].[AccountCity] ,
					[DebtorBankInfo].[AccountState] ,
					[DebtorBankInfo].[AccountZipcode],
					[DebtorBankInfo].[BankAddress],
					[DebtorBankInfo].[BankCity],
					[DebtorBankInfo].[BankState],
					[DebtorBankInfo].[BankZipcode],
					[DebtorBankInfo].[BankName],
					[DebtorBankInfo].[BankPhone]
					FROM [dbo].[DebtorBankInfo] 
					INNER JOIN [dbo].[pdc] on [pdc].[DebtorBankID] = [DebtorBankInfo].[BankID]
					INNER JOIN [dbo].[Wallet] on [Wallet].[PaymentVendorTokenId] = [pdc].[PaymentVendorTokenId]
					where [pdc].[PaymentVendorTokenId] = @PaymentVendorTokenId;

			UPDATE [dbo].[pdc] SET DebtorBankID=NULL WHERE [PaymentVendorTokenId] = @PaymentVendorTokenId;
			UPDATE [dbo].[Wallet] SET [AccountNumber] = CASE WHEN (LEN(ISNULL(AccountNumber, '')) > 4) 
									THEN '************' + SUBSTRING(AccountNumber, LEN(AccountNumber) - 3, 4)
									ELSE '****************'
									END
			WHERE [Wallet].[PaymentVendorTokenId] = @PaymentVendorTokenId;
		END
	-- update the debtorbankinfo record for the given id
	UPDATE debtorbankinfo
	SET	[PaymentVendorTokenId] = @PaymentVendorTokenId, 
		[AccountNumber] = CASE WHEN (LEN(ISNULL(AccountNumber, '')) > 4) 
							THEN '************' + SUBSTRING(AccountNumber, LEN(AccountNumber) - 3, 4)
							ELSE '****************'
							END
		-- [AccountName] = NULL, [AccountAddress1] = NULL, [AccountAddress2] = NULL, [AccountCity] = NULL
	WHERE BankId = @BankId;
	
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
    ROLLBACK TRANSACTION;
		RETURN @@ERROR
	END CATCH;
END
GO

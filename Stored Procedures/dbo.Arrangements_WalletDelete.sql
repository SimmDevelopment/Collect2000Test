SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_WalletDelete] @WalletId INTEGER, @WalletInArrangement BIT OUTPUT
AS

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--CHECK IF ANY PAYMENTS ARE USING IT
	SET @WalletInArrangement =  
	CASE WHEN EXISTS(SELECT TOP 1 wallet.Id FROM [dbo].[Wallet] INNER JOIN [dbo].[pdc] on [wallet].[PaymentVendorTokenId] = [pdc].[PaymentVendorTokenId] 
	WHERE [Wallet].[Id] = @WalletId AND [pdc].[Active] = 1) 
	THEN 1
	WHEN EXISTS(SELECT TOP 1 wallet.Id FROM [dbo].[Wallet] INNER JOIN [dbo].[DebtorCreditCards] on [wallet].[PaymentVendorTokenId] = [DebtorCreditCards].[PaymentVendorTokenId] 
	WHERE [Wallet].[Id] = @WalletId AND [DebtorCreditCards].[IsActive] = 1) 
	THEN 1
	ELSE 0 END;

	IF (@WalletInArrangement = 0)
		BEGIN
			SET @WalletInArrangement = 0;
			UPDATE [dbo].[Wallet]
			   SET [ModeStatus] = 'Deleted'
			 WHERE [Id] = @WalletId
		END

RETURN 0;SET ANSI_NULLS ON
GO

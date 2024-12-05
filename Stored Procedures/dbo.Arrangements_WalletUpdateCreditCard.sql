SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_WalletUpdateCreditCard]
	@ID INTEGER,
	@PaymentVendorTokenId INTEGER,
	@NSFCount INTEGER
AS
SET NOCOUNT ON;

UPDATE [dbo].[DebtorCreditCards]
SET [CreditCard] = (SELECT PayMethodSubTypeCode FROM PaymentVendorToken WHERE Id = @paymentVendorTokenId), 
	[PaymentVendorTokenId] = ISNULL(@PaymentVendorTokenId, [PaymentVendorTokenId]), 
	[CardNumber] = (SELECT MaskedValue FROM PaymentVendorToken WHERE Id = @paymentVendorTokenId),
	[NSFCount] = ISNULL(@NSFCount, [NSFCount])
WHERE [ID] = @ID;

RETURN 0;SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_WalletUpdateCheck]
	@ID INTEGER,
	@PaymentVendorTokenId INTEGER,
	@PDC_Type TINYINT,
	@NSFCount INTEGER,
	@CheckNumber CHAR(10)
AS
SET NOCOUNT ON;

UPDATE [dbo].[pdc]
SET [PaymentVendorTokenId] = ISNULL(@PaymentVendorTokenId, [PaymentVendorTokenId]), 
	--[DebtorBankID] = (SELECT BankID FROM dbo.DebtorBankInfo WHERE PaymentVendorTokenId = @paymentVendorTokenId),
	[PDC_Type] = ISNULL(@PDC_Type, [PDC_Type]),
	[NSFCount] = ISNULL(@NSFCount, [NSFCount]),
	[checknbr] = ISNULL(@CheckNumber, [checknbr])
WHERE [UID] = @ID;

RETURN 0;
SET ANSI_NULLS ON
GO

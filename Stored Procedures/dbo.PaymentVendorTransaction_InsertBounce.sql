SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description:	Insert a Bounce record .
CREATE PROCEDURE [dbo].[PaymentVendorTransaction_InsertBounce] 
	@PaymentVendorTransactionID int, 
	@TransactionResultCode [varchar](50),
	@TransactionResultDescription [varchar](255)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Err int

UPDATE [dbo].[PaymentVendorTransaction]
           SET [BounceErrCode] = @TransactionResultCode,
               [BounceErrDesc] = @TransactionResultDescription
WHERE Id = @PaymentVendorTransactionID

	SET @Err = @@ERROR
	IF @Err <> 0 RETURN @Err

	RETURN @@ERROR

END
GO

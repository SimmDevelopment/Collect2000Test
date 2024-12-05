SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/09/09
-- Description:	Add authorization information to a debtorcreditcards record
-- History: tag removed
--  
--  ****************** Version 5 ****************** 
--  User: mdevlin   Date: 2010-09-03   Time: 17:15:53-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  only set the active to 0 if the transaction was declined, and it will not 
--  get batched. Otherwise let the batch process set the active flag... 
--  
--  ****************** Version 4 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 10:41:00-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  syntax error 
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2010-02-04   Time: 14:48:05-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  added paymentLinkUID 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2009-11-03   Time: 16:18:23-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Integrated nsf functionality from payment reversals into payment vendor 
--  decline process (payment not entered because cc or pdc declined). 
--  
--  ****************** Version 1 ****************** 
--  User: jbryant   Date: 2009-09-22   Time: 15:53:15-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  New Procedures added for 9.0.0 
-- =============================================
CREATE PROCEDURE [dbo].[DebtorCreditCards_UpdateAuthorizationInfo] 
	@UID int
	,@AuthorizationCode varchar(255)
	,@TransactionResult int = 0
	,@TransactionResultDescription varchar(255) = 'Success'
	,@VendorCode varchar(16)
	,@VendorBatchNumber int
	,@VendorReferenceNumber varchar(50)
	,@AuthDate datetime = GETDATE
	,@PaymentLinkUID int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Err int
	DECLARE @FileNumber int
	DECLARE @POSTDATE_CATEGORY varchar(3)
	DECLARE @ErrorBlock varchar(30)
	DECLARE @IsExternallyManaged bit

	UPDATE [dbo].[DebtorCreditCards]
	SET [IsActive] = CASE WHEN @TransactionResult <> 0 THEN 0
		ELSE [IsActive]
		END
      ,[AuthDate] = @AuthDate
      ,[AuthCode] = @AuthorizationCode
      ,[AuthErrCode] = @TransactionResult
      ,[AuthErrDesc] = @TransactionResultDescription
      ,[AuthSource] = @VendorCode
      ,[BatchNumber] = @VendorBatchNumber
      ,[DateUpdated] = GETDATE()
      ,[AuthReferenceNumber] = @VendorReferenceNumber
      ,[Printed] = '1'
      ,[PaymentLinkUID] = @PaymentLinkUID
	WHERE id = @UID

	SELECT @Err=@@ERROR
	IF @Err <> 0 
	BEGIN  
		SET @ErrorBlock = 'Update dcc table.'
		PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') ' + @ErrorBlock
		RETURN @Err  
	END  
	
	IF @TransactionResult <> 0
	BEGIN
		SELECT @FileNumber = number, @POSTDATE_CATEGORY = 'PCC', @IsExternallyManaged = ISNULL(IsExternallyManaged,0) FROM DebtorCreditCards WHERE id = @UID
		SELECT @Err=@@ERROR 
		IF @Err <> 0 
		BEGIN  
			SET @ErrorBlock = 'Selecting filenumber.'
			PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') ' + @ErrorBlock
			RETURN @Err  
		END  

		IF @IsExternallyManaged = 0
		BEGIN
			EXEC @Err = Account_NSFHandling @FileNumber, @UID, @POSTDATE_CATEGORY, @ErrorBlock = @ErrorBlock OUTPUT
			SELECT @Err=@@ERROR 
			IF @Err <> 0 
			BEGIN  
				PRINT 'ERROR (' + CAST(@Err AS varchar(10)) + ') executing Account_NSFHandling: ' + @ErrorBlock
				RETURN @Err  
			END  
		END
	END

	RETURN @Err
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.AddPaymentSurchargeOverride    Script Date: 3/20/2006 2:56:03 PM ******/
/* AddPaymentSurchargeOverride Procedure */
CREATE PROCEDURE [dbo].[AddPaymentSurchargeOverride]
	@SurchargeTypeId	int,
	@PaymentId		int,
	@PaymentTableId		int,
	@LatitudeUser varchar(50)
AS

 /*
**Name		:AddPaymentSurchargeOverride	
**Function	:Adds/Updates a record in the PaymentSurchargeOverride Table
**Creation	:03/13/2006
**CreatedBy	:Mike Devlin
**Used by 	:Promises		
**Parameters	:@SurchargeTypeId	the FK to SurchargeType table
		:@PaymentId	FK to payment table (either PDC or DebtorCreditCards)
		:@PaymentTableId	See C2KPromise.Application.PromiseTypeEnum for values

**Change History:
*/

IF @LatitudeUser is null 
	SELECT @LatitudeUser = suser_sname() 
ELSE
	SELECT @LatitudeUser = @LatitudeUser

IF @SurchargeTypeId = 0
BEGIN
	-- Just remove any existing record...
	DELETE PaymentSurchargeOverride WHERE PaymentId = @PaymentId and PaymentTableId = @PaymentTableId
END
ELSE	
BEGIN
	SELECT SurchargeTypeId FROM PaymentSurchargeOverride WHERE PaymentId = @PaymentId and PaymentTableId = @PaymentTableId
	
	IF @@Rowcount = 0 
		INSERT INTO PaymentSurchargeOverride(SurchargeTypeId,PaymentId,PaymentTableId, LastUpdatedBy)VALUES(@SurchargeTypeId,@PaymentId,@PaymentTableId,@LatitudeUser)
	ELSE
		UPDATE PaymentSurchargeOverride SET SurchargeTypeId = @SurchargeTypeId, LastUpdated = getdate(), LastUpdatedBy = @LatitudeUser WHERE  PaymentId = @PaymentId and PaymentTableId = @PaymentTableId
END

Return @@Error

GO

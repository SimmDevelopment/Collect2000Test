SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_PMethod_Update*/
CREATE    PROCEDURE [dbo].[sp_PMethod_Update]
(
	@PayMethod varchar(20),
	@Surcharge money,
	@SurchargePercent real,
	@IsPostDateType bit,
	@InvoiceHoldDays tinyint,
	@NITDLetterCode varchar(5),
	@CalculateSurchargeFromGross BIT = 0,
	@Id int
)
AS

/*
** Name:		sp_PMethod_Update
** Function:		This procedure will update an Payment Method item in PMethod table
** 			using input parameters.
** Creation:		7/2/2002 jc
**			Used by class CPaymentMethodFactory. 
** Change History:	9/17/2002 jc revised to support additional fields
*/

    BEGIN TRAN
	
	UPDATE PMethod
		SET PayMethod = @PayMethod,
		Surcharge = @Surcharge,
		SurchargePercent = @SurchargePercent,
		IsPostDateType = @IsPostDateType,
		InvoiceHoldDays = @InvoiceHoldDays,
		NITDLetterCode = @NITDLetterCode,
		CalcSurchargeFromGross = @CalculateSurchargeFromGross
	WHERE Id = @Id

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_PMethod_Update: Cannot update PMethod table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

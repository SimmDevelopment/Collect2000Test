SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_PMethod_Insert*/
CREATE    PROCEDURE [dbo].[sp_PMethod_Insert]
(
	@PayMethod varchar(20),
	@Surcharge money,
	@SurchargePercent real,
	@IsPostDateType bit,
	@InvoiceHoldDays tinyint,
	@NITDLetterCode varchar(5),
	@CalculateSurchargeFromGross BIT = 0
)
AS

/*
** Name:		sp_PMethod_Insert
** Function:		This procedure will insert a new Payment Method in PMethod table
** 			using input parameters.
** Creation:		7/2/2002 jc
**			Used by class CPaymentMethodFactory. 
** Change History:	9/17/2002 jc revised to support additional fields
*/

    BEGIN TRAN
	
	INSERT INTO PMethod
		(PayMethod,
		Surcharge,
		SurchargePercent,
		IsPostDateType,
		InvoiceHoldDays,
		NITDLetterCode,
		CalcSurchargeFromGross)
	VALUES(
		@PayMethod,
		@Surcharge,
		@SurchargePercent,
		@IsPostDateType,
		@InvoiceHoldDays,
		@NITDLetterCode,
		@CalculateSurchargeFromGross)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_PMethod_Insert: Cannot insert into PMethod table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

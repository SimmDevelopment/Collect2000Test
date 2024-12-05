SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_CreditCardTypes_Insert*/
CREATE   PROCEDURE [dbo].[sp_CreditCardTypes_Insert]
(
	@Code varchar(4),
	@Description varchar(30),
	@ValidationPattern VARCHAR(100) = NULL,
	@Cvv2Location BIT = NULL,
	@ChecksumAlgorithm TINYINT = NULL
)
AS

/*
** Name:		sp_CreditCardTypes_Insert
** Function:		This procedure will insert a new CreditCardType in CreditCardTypes table
** 			using input parameters.
** Creation:		6/27/2002 jc
**			Used by class CCreditCardTypeFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO CreditCardTypes
		(code,
		Description,
		ValidationPattern,
		Cvv2Location,
		ChecksumAlgorithm)
	VALUES(
		@Code,
		@Description,
		@ValidationPattern,
		@Cvv2Location,
		@ChecksumAlgorithm)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_CreditCardTypes_Insert: Cannot insert into CreditCardTypes table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

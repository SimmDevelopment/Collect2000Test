SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_CreditCardTypes_Update*/
CREATE   PROCEDURE [dbo].[sp_CreditCardTypes_Update]
(
	@Code varchar(4),
	@Description varchar(30),
	@ValidationPattern VARCHAR(100) = NULL,
	@Cvv2Location BIT = NULL,
	@ChecksumAlgorithm TINYINT = NULL
)
AS

/*
** Name:		sp_CreditCardTypes_Update
** Function:		This procedure will update a CreditCardTypes item in CreditCardTypes table
** 			using input parameters.
** Creation:		6/27/2002 jc
**			Used by class CCreditCardTypeFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE CreditCardTypes
		SET Description = @Description,
			ValidationPattern = @ValidationPattern,
			Cvv2Location = @Cvv2Location,
			ChecksumAlgorithm = @ChecksumAlgorithm
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_CreditCardTypes_Update: Cannot update CreditCardTypes table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

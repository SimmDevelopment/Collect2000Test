SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_ClassOfBusiness_Update*/
CREATE   PROCEDURE [dbo].[sp_ClassOfBusiness_Update]
(
	@Code varchar(5),
	@Description varchar(30)
)
AS

/*
** Name:		sp_ClassOfBusiness_Update
** Function:		This procedure will update a ClassOfBusiness item in cob table
** 			using input parameters.
** Creation:		6/27/2002 jc
**			Used by class CClassOfBusinessFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE cob
		SET Description = @Description
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_ClassOfBusiness_Update: Cannot update cob table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

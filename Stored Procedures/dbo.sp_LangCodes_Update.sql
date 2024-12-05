SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_LangCodes_Update*/
CREATE   PROCEDURE [dbo].[sp_LangCodes_Update]
(
	@Code varchar(5),
	@Description varchar(30)
)
AS

/*
** Name:		sp_LangCodes_Update
** Function:		This procedure will update a Language Code item in LangCodes table
** 			using input parameters.
** Creation:		7/2/2002 jc
**			Used by class CLanguageCodeFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE LangCodes
		SET Description = @Description
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_LangCodes_Update: Cannot update LangCodes table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

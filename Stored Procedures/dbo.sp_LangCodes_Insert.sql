SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_LangCodes_Insert*/
CREATE   PROCEDURE [dbo].[sp_LangCodes_Insert]
(
	@Code varchar(4),
	@Description varchar(30)
)
AS

/*
** Name:		sp_LangCodes_Insert
** Function:		This procedure will insert a new Language Code in LangCodes table
** 			using input parameters.
** Creation:		7/2/2002 jc
**			Used by class CLanguageCodeFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO LangCodes
		(code,
		Description)
	VALUES(
		@Code,
		@Description)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_LangCodes_Insert: Cannot insert into LangCodes table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

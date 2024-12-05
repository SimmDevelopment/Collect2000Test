SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_RespParty_Update*/
CREATE   PROCEDURE [dbo].[sp_RespParty_Update]
(
	@Code int,
	@Description varchar(30)
)
AS

/*
** Name:		sp_RespParty_Update
** Function:		This procedure will update a Responsible Party item in RespParty table
** 			using input parameters.
** Creation:		7/3/2002 jc
**			Used by class CResponsiblePartyFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE RespParty
		SET Description = @Description
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_RespParty_Update: Cannot update RespParty table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

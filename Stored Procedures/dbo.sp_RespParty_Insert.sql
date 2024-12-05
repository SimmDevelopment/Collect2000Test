SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_RespParty_Insert*/
CREATE   PROCEDURE [dbo].[sp_RespParty_Insert]
(
	@Code int,
	@Description varchar(30)
)
AS

/*
** Name:		sp_RespParty_Insert
** Function:		This procedure will insert a new Responsible Party in RespParty table
** 			using input parameters.
** Creation:		7/3/2002 jc
**			Used by class CResponsiblePartyFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO RespParty
		(code,
		Description)
	VALUES(
		@Code,
		@Description)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_RespParty_Insert: Cannot insert into RespParty table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

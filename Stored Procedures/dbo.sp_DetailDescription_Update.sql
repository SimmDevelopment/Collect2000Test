SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_DetailDescription_Update*/
CREATE   PROCEDURE [dbo].[sp_DetailDescription_Update]
(
	@Code varchar(4),
	@Description varchar(30)
)
AS

/*
** Name:		sp_DetailDescription_Update
** Function:		This procedure will update an Detail Charge item in DetailDescription table
** 			using input parameters.
** Creation:		7/2/2002 jc
**			Used by class CDetailChargeFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE DetailDescription
		SET DetailDescription = @Description
	WHERE DetailCode = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_DetailDescription_Update: Cannot update DetailDescription table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

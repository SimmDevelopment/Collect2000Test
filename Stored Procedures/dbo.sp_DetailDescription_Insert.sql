SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_DetailDescription_Insert*/
CREATE   PROCEDURE [dbo].[sp_DetailDescription_Insert]
(
	@Code varchar(4),
	@Description varchar(30)
)
AS

/*
** Name:		sp_DetailDescription_Insert
** Function:		This procedure will insert a new Detail Charge in DetailDescription table
** 			using input parameters.
** Creation:		7/2/2002 jc
**			Used by class CDetailChargeFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO DetailDescription
		(DetailCode,
		DetailDescription)
	VALUES(
		@Code,
		@Description)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_DetailDescription_Insert: Cannot insert into DetailDescription table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

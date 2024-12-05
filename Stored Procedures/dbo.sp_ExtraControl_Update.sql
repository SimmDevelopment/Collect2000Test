SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_ExtraControl_Update*/
CREATE    PROCEDURE [dbo].[sp_ExtraControl_Update]
(
	@Code varchar(2),
	@Description varchar(30),
	@Title1 varchar(8),
	@Title2 varchar(8),
	@Title3 varchar(8),
	@Title4 varchar(8),
	@Title5 varchar(8),
	@Desc1 varchar(30),
	@Desc2 varchar(30),
	@Desc3 varchar(30),
	@Desc4 varchar(30),
	@Desc5 varchar(30)
)
AS

/*
** Name:		sp_ExtraControl_Update
** Function:		This procedure will update an Extra Data item in ExtraControl table
** 			using input parameters.
** Creation:		7/2/2002 jc
**			Used by class CExtraDataFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE ExtraControl
		SET Title = @Description,
		Title1 = @Title1,
		Title2 = @Title2,
		Title3 = @Title3,
		Title4 = @Title4,
		Title5 = @Title5,
		Description1 = @Desc1,
		Description2 = @Desc2,
		Description3 = @Desc3,
		Description4 = @Desc4,
		Description5 = @Desc5
	WHERE ExtraCode = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_ExtraControl_Update: Cannot update ExtraControl table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

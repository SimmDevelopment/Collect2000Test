SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_ExtraControl_Insert*/
CREATE    PROCEDURE [dbo].[sp_ExtraControl_Insert]
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
** Name:		sp_ExtraControl_Insert
** Function:		This procedure will insert a new Extra Data item in ExtraControl table
** 			using input parameters.
** Creation:		7/2/2002 jc
**			Used by class CExtraDataFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO ExtraControl
		(ExtraCode, Title, 
		Title1, Title2, Title3, Title4, Title5,
		Description1, Description2, Description3, Description4, Description5)
	VALUES(
		@Code, @Description,
		@Title1, @Title2, @Title3, @Title4, @Title5,
		@Desc1, @Desc2, @Desc3, @Desc4, @Desc5)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_ExtraControl_Insert: Cannot insert into ExtraControl table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

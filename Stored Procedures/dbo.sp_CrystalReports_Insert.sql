SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_CrystalReports_Insert*/
CREATE   PROCEDURE [dbo].[sp_CrystalReports_Insert]
(
	@FileName varchar(25),
	@Description varchar(30),
	@Image image,
	@FileDate datetime
)
AS

/*
** Name:		sp_CrystalReports_Insert
** Function:		This procedure will insert a new Crystal Report in CrystalReports table
** 			using input parameters.
** Creation:		6/28/2002 jc
**			Used by class CCrystalReportFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO CrystalReports
		(filename,
		Description,
		CrystalReportImage,
		FileDate)
	VALUES(
		@FileName,
		@Description,
		@Image,
		@FileDate)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_CrystalReports_Insert: Cannot insert into CrystalReports table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

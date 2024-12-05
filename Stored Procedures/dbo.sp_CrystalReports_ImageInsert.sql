SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE   PROCEDURE sp_CrystalReports_ImageInsert*/
CREATE   PROCEDURE [dbo].[sp_CrystalReports_ImageInsert]
(
	@FileName varchar(25),
	@Image image,
	@FileDate datetime
)
AS

/*
** Name:		sp_CrystalReports_ImageInsert
** Function:		This procedure will insert a new Crystal Report image in CrystalReports table
** 			using input parameters.
** Creation:		7/1/2002 jc
**			Used by class CCrystalReportFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO CrystalReports
		(filename,
		CrystalReportImage,
		FileDate)
	VALUES(
		@FileName,
		@Image,
		@FileDate)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_CrystalReports_ImageInsert: Cannot insert into CrystalReports table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

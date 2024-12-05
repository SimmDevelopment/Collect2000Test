SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_CrystalReports_ImageUpdate*/
CREATE    PROCEDURE [dbo].[sp_CrystalReports_ImageUpdate]
(
	@FileName varchar(25),
	@Image image,
	@FileDate datetime

)
AS

/*
** Name:		sp_CrystalReports_ImageUpdate
** Function:		This procedure will update an image of a Crystal Report item in CrystalReports table
** 			using input parameters.
** Creation:		6/28/2002 jc
**			Used by class CCrystalReportFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE CrystalReports
		SET CrystalReportImage = @Image,
		FileDate = @FileDate
	WHERE filename = @FileName

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_CrystalReports_ImageUpdate: Cannot update CrystalReports table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Qlevel_Update*/
CREATE     PROCEDURE [dbo].[sp_Qlevel_Update]
(
	@Code varchar(3),
	@Description varchar(30),
	@ShouldQueue bit
)
AS
-- Name:		sp_Qlevel_Update
-- Function:		This procedure will update a Queue Level item in Qlevel table
-- 			using input parameters.
-- Creation:		7/2/2002 jc
--			Used by class CQueueLevelFactory. 
-- Change History:
--			7/2/2002 jc currently not supporting CustomLevel field
--			7/27/2004 jc added support for new bit column ShouldQueue
    BEGIN TRAN
	
	UPDATE Qlevel
		SET QName = @Description,
		ShouldQueue = @ShouldQueue
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Qlevel_Update: Cannot update Qlevel table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Qlevel_Insert*/
CREATE    PROCEDURE [dbo].[sp_Qlevel_Insert]
(
	@Code varchar(3),
	@Description varchar(30),
	@ShouldQueue bit
)
AS
-- Name:		sp_Qlevel_Insert
-- Function:		This procedure will insert a new action in Qlevel table
-- 			using input parameters.
-- Creation:		7/2/2002 jc
--			Used by class CQueueLevelFactory. 
-- Change History:
--			7/2/2002 jc currently not supporting CustomLevel field
--			7/27/2004 jc added support for new bit column ShouldQueue
    BEGIN TRAN
	
	INSERT INTO Qlevel
		(code, QName, ShouldQueue)
	VALUES(
		@Code, @Description, @ShouldQueue)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Qlevel_Insert: Cannot insert into Qlevel table ') 
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

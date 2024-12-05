SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_DeskDistribution_Delete*/
CREATE    PROCEDURE [dbo].[sp_DeskDistribution_Delete]
(
	@Id int
)
AS
    BEGIN TRAN
	DELETE DeskDistributionDetail 
	WHERE DeskDistributionId = @Id
	
	DELETE DeskDistribution
	WHERE Id = @Id

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_DeskDistribution_Delete: Cannot delete from DeskDistribution table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO

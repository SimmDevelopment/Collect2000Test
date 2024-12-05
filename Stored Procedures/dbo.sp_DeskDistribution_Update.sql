SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_DeskDistribution_Update*/
CREATE    PROCEDURE [dbo].[sp_DeskDistribution_Update]
(
	@Customer varchar(7),
	@State varchar(3),
	@Id int 
)
AS
    BEGIN TRAN
	UPDATE DeskDistribution
		SET Customer = @Customer,
		State = @State
	WHERE Id = @Id

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_DeskDistribution_Update: Cannot update DeskDistribution table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE    PROCEDURE sp_DeskDistributionDetail_Insert*/
CREATE    PROCEDURE [dbo].[sp_DeskDistributionDetail_Insert]
(
	@DeskDistributionId int,
	@Desk varchar(10),
	@LowLimit money,
	@HighLimit money
)
AS
    BEGIN TRAN
	INSERT INTO DeskDistributionDetail
		(DeskDistributionId, Desk, LowLimit, HighLimit)
	VALUES(
		@DeskDistributionId, @Desk, 
		@LowLimit, @HighLimit)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_DeskDistributionDetail_Insert: Cannot insert into DeskDistributionDetail table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*ALTER     PROCEDURE sp_DeskDistribution_Insert*/
CREATE    PROCEDURE [dbo].[sp_DeskDistribution_Insert]
(
	@Customer varchar(7),
	@State varchar(3),
	@Id int output
)
AS
    BEGIN TRAN
	INSERT INTO DeskDistribution
		(Customer,
		State)
	VALUES(
		@Customer,
		@State)

	SELECT @Id = SCOPE_IDENTITY()

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_DeskDistribution_Insert: Cannot insert into DeskDistribution table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO

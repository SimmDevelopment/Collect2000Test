SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_AddArrangement]
	@CreatedBy VARCHAR(20),
	@SpreadAlgorithm TEXT = NULL,
	@FlatSurcharge MONEY = NULL,
	@PercentageSurcharge MONEY = NULL,
	@AddedFlatSurcharge MONEY = NULL,
	@AddedPercentageSurcharge MONEY = NULL,
	@ManualSurcharge BIT = 0,
	@ArrangementFee MONEY = NULL,
	@ExistingArrangementId INTEGER = NULL,
	@ID INTEGER OUTPUT
AS
SET NOCOUNT ON;

IF (@ExistingArrangementId IS NOT NULL)
BEGIN
	UPDATE [dbo].[Arrangements] 
	SET [CreatedBy] = @CreatedBy, 
	[SpreadAlgorithm] = @SpreadAlgorithm, 
	[FlatSurcharge] = @FlatSurcharge,
	[PercentageSurcharge] = @PercentageSurcharge, 
	[AddedFlatSurcharge] = @AddedFlatSurcharge, 
	[AddedPercentageSurcharge] = @AddedPercentageSurcharge, 
	[ManualSurcharge] = @ManualSurcharge,  
	[ArrangementFee] = @ArrangementFee
	WHERE [Id] = @ExistingArrangementId;

	SET @ID = @ExistingArrangementId;
END
ELSE
BEGIN
	INSERT INTO [dbo].[Arrangements] ([CreatedBy], [SpreadAlgorithm], [FlatSurcharge],
	[PercentageSurcharge], [AddedFlatSurcharge], [AddedPercentageSurcharge], [ManualSurcharge], [ArrangementFee])
	VALUES (@CreatedBy, @SpreadAlgorithm, @FlatSurcharge,
		@PercentageSurcharge, @AddedFlatSurcharge, @AddedPercentageSurcharge, @ManualSurcharge, @ArrangementFee);

	SET @ID = SCOPE_IDENTITY();
END

RETURN 0;
GO

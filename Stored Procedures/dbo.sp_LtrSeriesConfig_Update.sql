SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesConfig_Update*/
CREATE Procedure [dbo].[sp_LtrSeriesConfig_Update]
(
	@LtrSeriesConfigID int,
	@LtrSeriesID int,
	@LetterID int,
	@DaysToWait int,
	@ToPrimaryDebtor bit,
	@ToCoDebtors bit
)
AS
-- Name:		sp_LtrSeriesConfig_Update
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	UPDATE LtrSeriesConfig
	SET
	LtrSeriesID = @LtrSeriesID,
	LetterID = @LetterID,
	DaysToWait = @DaysToWait,
	ToPrimaryDebtor = @ToPrimaryDebtor,
	ToCoDebtors = @ToCoDebtors,
	DateUpdated = getdate()
	WHERE LtrSeriesConfigID = @LtrSeriesConfigID
GO

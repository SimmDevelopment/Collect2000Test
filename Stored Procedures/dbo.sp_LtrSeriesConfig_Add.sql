SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_LtrSeriesConfig_Add*/
CREATE  PROCEDURE [dbo].[sp_LtrSeriesConfig_Add]
(
	@LtrSeriesConfigID int OUTPUT,
	@LtrSeriesID int,
	@LetterID int,
	@DaysToWait int,
	@ToPrimaryDebtor bit,
	@ToCoDebtors bit
)
AS
-- Name:		sp_LtrSeriesConfig_Add
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	INSERT INTO LtrSeriesConfig
	(
	LtrSeriesID,
	LetterID,
	DaysToWait,
	ToPrimaryDebtor,
	ToCoDebtors,
	DateCreated,
	DateUpdated
	)
	VALUES
	(
	@LtrSeriesID,
	@LetterID,
	@DaysToWait,
	@ToPrimaryDebtor,
	@ToCoDebtors,
	getdate(),
	getdate()
	)
	
	SET @LtrSeriesConfigID = SCOPE_IDENTITY()


GO

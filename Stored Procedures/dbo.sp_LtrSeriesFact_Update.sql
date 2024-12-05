SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesFact_Update*/
CREATE Procedure [dbo].[sp_LtrSeriesFact_Update]
(
	@LtrSeriesFactID int,
	@LtrSeriesID int,
	@CustomerID int,
	@MinBalance money,
	@MaxBalance money
)
AS
-- Name:		sp_LtrSeriesFact_Update
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	UPDATE LtrSeriesFact
	SET
	LtrSeriesID = @LtrSeriesID,
	CustomerID = @CustomerID,
	MinBalance = @MinBalance,
	MaxBalance = @MaxBalance,
	DateUpdated = getdate()
	WHERE LtrSeriesFactID = @LtrSeriesFactID
GO

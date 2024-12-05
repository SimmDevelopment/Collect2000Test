SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_LtrSeriesFact_Add*/
CREATE  PROCEDURE [dbo].[sp_LtrSeriesFact_Add]
(
	@LtrSeriesFactID int OUTPUT,
	@LtrSeriesID int,
	@CustomerID int,
	@MinBalance money,
	@MaxBalance money
)
AS
-- Name:		sp_LtrSeriesFact_Add
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	INSERT INTO LtrSeriesFact
	(
	LtrSeriesID,
	CustomerID,
	MinBalance,
	MaxBalance,
	DateCreated,
	DateUpdated
	)
	VALUES
	(
	@LtrSeriesID,
	@CustomerID,
	@MinBalance,
	@MaxBalance,
	getdate(),
	getdate()
	)
	
	SET @LtrSeriesFactID = SCOPE_IDENTITY()


GO

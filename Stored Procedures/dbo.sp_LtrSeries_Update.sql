SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_LtrSeries_Update*/
CREATE  Procedure [dbo].[sp_LtrSeries_Update]
(
	@LtrSeriesID int,
	@Description varchar(50),
	@Active bit,
	@IsNewBusiness bit,
	@MinBalance money,
	@MaxBalance money
)
AS
-- Name:		sp_LtrSeries_Update
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	UPDATE LtrSeries
	SET
	Description = @Description,
	Active = @Active,
	IsNewBusiness = @IsNewBusiness,
	MinBalance = @MinBalance,
	MaxBalance = @MaxBalance,
	DateUpdated = getdate()
	WHERE LtrSeriesID = @LtrSeriesID

	UPDATE LtrSeriesFact
	SET
	MinBalance = CASE
			WHEN MinBalance < @MinBalance THEN @MinBalance
			ELSE MinBalance
		END,
	MaxBalance = CASE
			WHEN MaxBalance > @MaxBalance THEN @MaxBalance
			ELSE MaxBalance
		END,
	DateUpdated = getdate()
	WHERE LtrSeriesID = @LtrSeriesID;

	UPDATE CustomCustGroupLtrSeries
	SET
	MinBalance = CASE
			WHEN MinBalance < @MinBalance THEN @MinBalance
			ELSE MinBalance
		END,
	MaxBalance = CASE
			WHEN MaxBalance > @MaxBalance THEN @MaxBalance
			ELSE MaxBalance
		END,
	DateUpdated = getdate()
	WHERE LtrSeriesID = @LtrSeriesID;


GO

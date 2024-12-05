SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_LtrSeries_Add*/
CREATE  PROCEDURE [dbo].[sp_LtrSeries_Add]
(
	@LtrSeriesID int OUTPUT,
	@Description varchar(50),
	@Active bit,
	@IsNewBusiness bit,
	@MinBalance money,
	@MaxBalance money
)
AS
-- Name:		sp_LtrSeries_Add
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	INSERT INTO LtrSeries
	(
	Description,
	Active,
	IsNewBusiness,
	MinBalance,
	MaxBalance,
	DateCreated,
	DateUpdated
	)
	VALUES
	(
	@Description,
	@Active,
	@IsNewBusiness,
	@MinBalance,
	@MaxBalance,
	getdate(),
	getdate()
	)
	
	SET @LtrSeriesID = SCOPE_IDENTITY()


GO

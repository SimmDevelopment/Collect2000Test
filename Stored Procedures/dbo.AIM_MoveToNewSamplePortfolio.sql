SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_MoveToNewSamplePortfolio    */



create    procedure [dbo].[AIM_MoveToNewSamplePortfolio]
(
	@number int
	,@newPortfolioId int
)

AS

	update 
		master
	set 
		soldportfolio = @newPortfolioId
	where
		number = @number






GO

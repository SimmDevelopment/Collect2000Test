SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create               procedure [dbo].[AIM_SelectPortfolioInvestor]  
	@portfolioId int
	,@investorId int
AS


	select
		commissionableamount
		,noncommissionableamount
	from
		aim_portfolioinvestor
	where
		portfolioid = @portfolioId
		and investorid = @investorId


GO

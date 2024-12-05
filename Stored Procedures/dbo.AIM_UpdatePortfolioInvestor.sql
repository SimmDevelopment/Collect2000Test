SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create               procedure [dbo].[AIM_UpdatePortfolioInvestor]  
	@portfolioId int
	,@investorId int
	,@commissionableAmount money
	,@nonCommissionableAmount money
AS


	declare @portfolioInvestorId int
	select
		@portfolioInvestorId = portfolioinvestorid
	from
		aim_portfolioinvestor
	where
		portfolioid = @portfolioId
		and investorid = @investorId

	if(@portfolioInvestorId is null)
	begin
		insert into
			aim_portfolioinvestor
			(
				portfolioid
				,investorid
				,commissionableamount
				,noncommissionableamount
			)
			values
			(
				@portfolioId
				,@investorId
				,@commissionableAmount
				,@noncommissionableAmount
			)
	end
	else
	begin
		update
			aim_portfolioInvestor
		set
			commissionableamount = @commissionableAmount
			,noncommissionableamount = @nonCommissionableAmount
		where
			portfolioInvestorId = @portfolioInvestorId
	end


GO

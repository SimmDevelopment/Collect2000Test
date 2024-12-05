SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*   User Defined Function dbo.AIM_CalculatePortfolioValue    */



CREATE       FUNCTION [dbo].[AIM_CalculatePortfolioValue]
	(
		@portfolioId int		
	)
returns money
as
	begin
		declare @value money
		select
			@value = isnull(sum(credit),0) - isnull(sum(debit),0)
		from
			aim_ledger 			
		where
			portfolioid = @portfolioid

		return @value
			

	end


GO

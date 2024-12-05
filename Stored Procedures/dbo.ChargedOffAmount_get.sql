SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ChargedOffAmount_get]
	@number int
AS

-- Get a single record from ChargedOffBalanceDetailTotal. Used by ChargedOffBalances panel

SELECT ChargedOffAmount, Interest, Fees, Payments, TotalInterest, TotalFees, TotalPayments
FROM ChargedOffBalanceDetailTotal nolock
WHERE AccountId = @number
SET ANSI_NULLS ON
GO

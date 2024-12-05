SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   FUNCTION [dbo].[AIM_GetCurrentlyPlacedBalance]
	(
		@referenceNumber int
	)
returns money
as
	begin
		declare @currentlyPlacedBalance money
		select
			top 1
			@currentlyPlacedBalance = atr.balance
		from
			AIM_accountreference ar with (nolock)
			join AIM_accounttransaction atr with (nolock) on atr.accountreferenceid = ar.accountreferenceid
		where
			atr.transactiontypeid = 1
			and atr.transactionstatustypeid = 3
			and ar.referencenumber = @referencenumber
		order by
			atr.completeddatetime

		return @currentlyPlacedBalance
			

	end


GO

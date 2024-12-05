SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE                procedure [dbo].[AIM_Account_SelectDetailsFromDebtorId]
(
      @debtor_number   int
)
as
begin

	select
		ar.*
		,a.name as agencyname
		,dbo.AIM_GetCurrentlyPlacedBalance(mv.number) as currentlyplacedbalance
		,mv.current0 as currentlatitudebalance
	from
		AIM_accountreference ar
		left outer join AIM_agency a on a.agencyid = ar.currentlyplacedagencyid
		join master mv with (nolock) on mv.number = ar.referencenumber
		join debtors dv with (nolock) on dv.number = mv.number
		
	where
		dv.debtorid = @debtor_number


end



GO

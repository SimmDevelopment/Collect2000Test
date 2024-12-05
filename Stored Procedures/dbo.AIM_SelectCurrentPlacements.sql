SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AIM_SelectCurrentPlacements]
AS

SELECT 
	cast(a.AgencyTier as varchar) + ' Agencies' as [Tier],
	a.Name,
	convert(varchar(10),r.LastPlacementDate,101) as [Placement Date],
	count(*) as [Number Placed],
	sum(cast(agencyacknowledgement as int)) as [Number Acknowledged],
	sum(cast(acknowledgementerror as int)) as [Acknowledgment Errors],
	cast(sum(current0) as decimal(12,2)) as [Current Dollars Placed]

FROM
	 	aim_accountreference r with (nolock)
	join aim_agency a with (nolock) on r.currentlyplacedagencyid = a.agencyid
	join master m with (nolock) on m.number = r.referencenumber
GROUP BY a.AgencyTier,a.Name,convert(varchar(10),r.LastPlacementDate,101)

GO

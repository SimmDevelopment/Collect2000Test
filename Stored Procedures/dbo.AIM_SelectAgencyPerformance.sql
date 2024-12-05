SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create               procedure [dbo].[AIM_SelectAgencyPerformance]
(@agencyId int)
AS

select 	DatePlaced,TotalNumberPlaced as Count,TotalDollarsPlaced as [Dollars Placed]
	,TotalCollected as Collected,TotalFees as Fees
	,(TotalCollected-TotalFees)/(TotalDollarsPlaced - Adjustments)*100 as [NetBack(%)]
from 	aim_stairstep
where 	agencyId = @agencyId
order by DatePlaced desc

select 	DatePlaced
	,month1/(TotalDollarsPlaced - Adjustments)*100 as [Month1(%)]
	,month2/(TotalDollarsPlaced - Adjustments)*100 as [Month2(%)]
	,month3/(TotalDollarsPlaced - Adjustments)*100 as [Month3(%)]
	,month4/(TotalDollarsPlaced - Adjustments)*100 as [Month4(%)]
	,month5/(TotalDollarsPlaced - Adjustments)*100 as [Month5(%)]
	,month6/(TotalDollarsPlaced - Adjustments)*100 as [Month6(%)]
	,month7/(TotalDollarsPlaced - Adjustments)*100 as [Month7(%)]
	,month8/(TotalDollarsPlaced - Adjustments)*100 as [Month8(%)]
	,month9/(TotalDollarsPlaced - Adjustments)*100 as [Month9(%)]
	,month10/(TotalDollarsPlaced - Adjustments)*100 as [Month10(%)]
	,month11/(TotalDollarsPlaced - Adjustments)*100 as [Month11(%)]
	,month12/(TotalDollarsPlaced - Adjustments)*100 as [Month12(%)]
from aim_stairstep
where agencyId = @agencyId

GO

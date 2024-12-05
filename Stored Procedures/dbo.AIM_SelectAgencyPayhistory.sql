SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[AIM_SelectAgencyPayhistory]
(
	@startdate datetime
	,@enddate datetime
)
as

select 	a.name as Agency
	,m.Name
	,m.Account
	,p.Batchtype as [Batch Type]
	,CASE WHEN p.Batchtype IN ('PU','PC','PA') THEN p.totalpaid ELSE -1*p.totalpaid END as [Amount]
	,p.datepaid as [Date Paid]
	,p.aimagencyfee as [Agency Fee]
	,p.aimdueagency as [Due Agency]
from	payhistory p with (nolock)
	join master m with (nolock) on m.number = p.number
	join aim_agency a on a.agencyid = p.aimagencyid
where 	p.datepaid between @startdate and @enddate
	and p.batchtype in ('PA','PAR','PU','PUR','PCR','PC')

GO

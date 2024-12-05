SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  View dbo.AIM_AccountView    */

CREATE                VIEW [dbo].[AIM_AccountView] AS


SELECT 
	m.number
	,m.desk
	,m.name
	,m.state
	,m.zipcode
	,m.mr
	,m.account
	,m.userdate1
	,m.userdate2
	,m.userdate3
	,m.status
	,m.customer
	,m.ssn
	,m.current0 as balance
	--,m.queue
	,m.qlevel
	,m.clidlc
	,m.clidlp
	,m.soldportfolio
	,m.purchasedportfolio
	,m.originalcreditor
	,isplaced = case ar.isplaced
		when 1 then 'True'
		when 0 then 'False'
		when null then 'False'
		else 'False'
	end
	,tier1agencycode = 	case 
					when t1.tier1agencycode is null then 0
					else t1.tier1agencycode
				end
	,tier2agencycode = 	case 
					when t2.tier2agencycode is null then 0
					else t2.tier2agencycode
				end
	,tier3agencycode = 	case 
					when t3.tier3agencycode is null then 0
					else t3.tier3agencycode
				end
	,lastrecalldate
	,getdate() - cast(cast(a.value as varchar(10)) as int) as tiergraceperiod
from
	[dbo].[master] m
	join [dbo].[desk] d on m.desk = d.code
	left outer join AIM_AccountReference ar on m.number = ar.referencenumber
	left outer join (
		select 	accountreferenceid, agencyid as tier1agencycode 
		from 	AIM_accounttransaction
		where 	transactiontypeid = 1 
			and tier = 1) t1 on t1.accountreferenceid = ar.accountreferenceid
	left outer join (
		select 	accountreferenceid, agencyid as tier2agencycode 
		from 	AIM_accounttransaction
		where 	transactiontypeid = 1 
			and tier = 2) t2 on t2.accountreferenceid = ar.accountreferenceid
	left outer join (
		select 	accountreferenceid, agencyid as tier3agencycode 
		from 	AIM_accounttransaction
		where 	transactiontypeid = 1 
			and tier = 3) t3 on t3.accountreferenceid = ar.accountreferenceid
	join AIM_appsetting a on a.[key] = 'AIM.Default.Tier.GracePeriod'
where
	d.desktype = 'AIM'
	and ((m.qlevel between '000' and '399') or m.qlevel = '599')










GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create                  procedure [dbo].[AIM_SelectAccountsAtAgency] 
 @agencyId   int
as
begin

select m.number,m.desk,m.name,m.state,m.zipcode ,m.mr ,m.account,m.userdate1 ,m.userdate2,
m.userdate3 ,m.status,m.customer,m.ssn ,m.current1 as balance	,m.qlevel ,m.clidlc,m.clidlp 
,m.soldportfolio,m.purchasedportfolio,m.originalcreditor, isnull(max(bh.batchid) ,0) as batchid
,ar.currentcommissionpercentage as commissionrate 
from master m with (nolock) 
join AIM_AccountReference ar on m.number = ar.referencenumber 
left outer join aim_accounttransaction atr on atr.accountreferenceid = ar.accountreferenceid and atr.transactionstatustypeid = 3 and atr.transactiontypeid = 1
left outer join AIM_batchfilehistory bh on bh.batchfilehistoryid = atr.batchfilehistoryid 
where ar.currentlyplacedagencyid = @agencyId
group by m.number,m.desk,m.name,m.state,m.zipcode ,m.mr ,m.account,m.userdate1 ,m.userdate2,
m.userdate3 ,m.status,m.customer,m.ssn ,m.current1,m.qlevel ,m.clidlc,m.clidlp 
,m.soldportfolio,m.purchasedportfolio,m.originalcreditor,ar.currentcommissionpercentage

end

GO

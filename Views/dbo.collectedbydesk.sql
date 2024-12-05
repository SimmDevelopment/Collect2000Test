SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[collectedbydesk]
as
select desk.code,desk.[name],branchcodes.code as branchcode,branchcodes.[name] as branchname,

sq.systemyear,sq.systemmonth,isnull(sq.collected,0) as collected ,isnull(sq.fees,0) as fees,isnull(pdc.pdcamount,0) as pdcamount ,isnull(pdc.pdcfee,0) as pdcfee ,isnull(cc.ccamount,0) as ccamount

, isnull(cc.ccfee,0) as ccfee

from

(select isnull(p.desk,'Unknown') as Desk,p.systemyear,p.systemmonth,

 sum(case when p.batchtype like '%r' then -(dbo.determineinvoicedamount(p.invoiceflags,p.paid1,p.paid2,p.paid3,p.paid4,

p.paid5,p.paid6,p.paid7,p.paid8,p.paid9,p.paid10)) else

dbo.determineinvoicedamount(p.invoiceflags,p.paid1,p.paid2,p.paid3,p.paid4,

p.paid5,p.paid6,p.paid7,p.paid8,p.paid9,p.paid10) end) as Collected,

 sum(case when p.batchtype like '%r' then -(dbo.determineinvoicedamount(p.invoiceflags,p.fee1,p.fee2,p.fee3,p.fee4,

p.fee5,p.fee6,p.fee7,p.fee8,p.fee9,p.fee10)) else

dbo.determineinvoicedamount(p.invoiceflags,p.fee1,p.fee2,p.fee3,p.fee4,

p.fee5,p.fee6,p.fee7,p.fee8,p.fee9,p.fee10) end) as Fees

 from payhistory p with (nolock)

where batchtype in ('pu','pur','pc','pcr','pa','par')

group by p.systemyear,p.systemmonth,p.desk) as sq

inner join desk with (nolock) on sq.desk = desk.code

inner join branchcodes with (nolock) on desk.branch = branchcodes.code

left outer join (select cast((select datepart(year,eomdate) from controlfile) as int) as sysyear, 

cast((select datepart(month,eomdate) from controlfile) as int) as sysmonth,

p.desk,sum(p.amount) as pdcamount,sum(p.projectedfee) as pdcfee 

from pdcview p where p.deposit <= (select eomdate from controlfile with (nolock)) and active = '1' 

and approvedby is not null and onhold is null group by p.desk) as pdc

on sq.desk = pdc.desk and sq.systemyear = pdc.sysyear and sq.systemmonth = pdc.sysmonth

left outer join (select cast((select datepart(year,eomdate) from controlfile with (nolock) ) as int) as sysyear, 

cast((select datepart(month,eomdate) from controlfile with (nolock) ) as int) as sysmonth,

m.desk,sum(d.amount) as ccamount,sum(d.projectedfee) as ccfee

from debtorcreditcards d with (nolock) inner join master m on d.number = m.number 

where d.depositdate <= (select eomdate from controlfile with (nolock) ) and d.isactive = '1' 

and d.approvedby is not null and d.onholddate is null group by 

m.desk) as cc

on sq.desk = cc.desk and sq.systemyear = cc.sysyear and sq.systemmonth = cc.sysmonth


GO

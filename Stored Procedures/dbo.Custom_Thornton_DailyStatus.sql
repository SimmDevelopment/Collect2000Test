SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Thornton_DailyStatus]

@Date datetime

AS



declare @thornton table (acctid varchar(10), numcalls int, numrpc int, numprom int, promamt money, promdate varchar(10), balance money, status varchar(5), settleamtapp money, settleamtpend money, paymtd money, payytd money, worked varchar(10))

insert into @thornton(acctid, balance, status, worked)
select m.id2, m.current1, m.status, isnull(convert(varchar, dbo.date(worked), 101), '')
from master m with (nolock)
where m.customer = '0000974'

update @thornton
set numcalls = rc.numcount
from
(select m.id2 as id2, count(user0) as numcount
from notes n with (nolock) inner join master m with (nolock) on n.number = m.number
where m.customer = '0000974' and action in ('tr', 'te') and dbo.date(n.created) = @date
group by m.id2, m.current1, m.status, convert(varchar, dbo.date(worked), 101)) rc
where rc.id2 = acctid

update @thornton
set numcalls = 0
where numcalls is null


update @thornton
set numrpc = rc.numcount
from
(select m.id2 as id2, count(user0) as numcount
from notes n with (nolock) inner join master m with (nolock) on n.number = m.number
where m.customer = '0000974' and action in ('tr', 'te') and dbo.date(n.created) = @date and result = 'tt'
group by m.id2) rc
where rc.id2 = acctid

update @thornton
set numrpc = 0
where numrpc is null

update @thornton
set numprom = prom.numprom, promamt = prom.promamt
from
(select m.id2, count(m.id2) as numprom, sum(isnull(pdc.amount, 0)) + sum(isnull(p.amount, 0)) + sum(isnull(dc.amount, 0)) as promamt
from master m with (nolock) left join pdc pdc with (nolock) on m.number = pdc.number left join debtorcreditcards dc with (nolock) on m.number = dc.number left join promises p with (nolock) on m.number = p.acctid
where m.customer = '0000974' and (dbo.date(p.entered) = @date or dbo.date(pdc.entered) = @date or dbo.date(dc.dateentered) = @date)
group by m.id2) prom
where prom.id2 = acctid

update @thornton
set promdate = prom.depositdate
from
(select top 1 m.number, m.id2 as id2, convert(varchar, dbo.date(depositdate), 101) as depositdate
from debtorcreditcards dc with (nolock) inner join  master m with (nolock) on dc.number = m.number
where m.customer = '0000974' and dbo.date(dc.dateentered) = @date
order by depositdate) prom
where prom.id2 = acctid

update @thornton
set promdate = prom.depositdate
from
(select top 1 m.number, m.id2 as id2, convert(varchar, dbo.date(deposit), 101) as depositdate
from pdc pdc with (nolock) inner join  master m with (nolock) on pdc.number = m.number
where m.customer = '0000974' and dbo.date(pdc.entered) = @date
order by deposit) prom
where prom.id2 = acctid

update @thornton
set promdate = prom.depositdate
from
(select top 1 m.number, m.id2 as id2, convert(varchar, dbo.date(duedate), 101) as depositdate
from promises pdc with (nolock) inner join  master m with (nolock) on pdc.acctid = m.number
where m.customer = '0000974' and dbo.date(pdc.entered) = @date
order by duedate) prom
where prom.id2 = acctid

update @thornton
set numprom = 0
where numprom is null

update @thornton
set promamt = 0
where promamt is null

update @thornton
set promdate = ''
where promdate is null

update @thornton
set settleamtapp = setl.original1 + setl.paid1
from (select number, id2, original1, paid1
from master m with (nolock)
where customer = '0000974' and status = 'sif') setl
where setl.id2 = acctid

update @thornton
set settleamtapp = 0
where settleamtapp is null

update @thornton
set settleamtpend = 0
where settleamtpend is null

update @thornton
set paymtd = pay.paid
from (select m.id2, 'paid' = sum(case when p.batchtype = 'pu' then p.paid1 when batchtype = 'pur' then -p.paid1 end)
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
where p.customer = '0000974' and p.systemmonth = datepart(mm, @date) and p.systemyear = datepart(yyyy, @date)
group by m.id2) pay
where pay.id2 = acctid

update @thornton
set paymtd = 0
where paymtd is null

update @thornton
set payytd = pay.paid
from (select m.id2, 'paid' = sum(case when p.batchtype = 'pu' then p.paid1 when batchtype = 'pur' then -p.paid1 end)
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
where p.customer = '0000974' and p.systemyear = datepart(yyyy, @date)
group by m.id2) pay
where pay.id2 = acctid

update @thornton
set payytd = 0
where payytd is null


select *
from @thornton
order by acctid
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Discover_Inbound]

@startDate datetime,
@endDate datetime

 AS



declare @discoverinb table([acctnbr] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[dod] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[addr] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[homeph] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[bkfile] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[bkchap] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[bkcase] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[primename] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[secname] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[poephone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[poename] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[poeaddr] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[caddate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[dispdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[cccsinfo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[consnameph] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ssnchgdate] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[akaname] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[addrphchgdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[attynameph] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lastlttrdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[dodver] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[bkydismisdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[bkydischdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
)

insert into @discoverinb(acctnbr, addr, addrphchgdate, lastlttrdate)
select distinct m.account, substring(m.street1 + ', ' + m.city + ', ' + m.state + ', ' + m.zipcode, 1, 40), convert(varchar, n.created, 112), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from notes n with (nolock) inner join master m with (nolock) on m.number = n.number
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and action = 'addr' and result = 'chng' and user0 not in ('system', 'discover') and dbo.date(created) between dbo.date(@startDate) and dbo.date(@endDate)

insert into @discoverinb(acctnbr, homeph, addrphchgdate, lastlttrdate)
select distinct m.account, substring(replace(replace(replace(m.homephone, '-', ''), '(', ''), ')', ''), 1, 10), convert(varchar, n.created, 112), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from notes n with (nolock) inner join master m with (nolock) on m.number = n.number
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and action = 'phone' and result = 'chng' and user0 not in ('system', 'discover') and dbo.date(created) between dbo.date(@startDate) and dbo.date(@endDate) and comment like '%home%'

insert into @discoverinb(acctnbr, poephone, addrphchgdate, lastlttrdate)
select distinct m.account, substring(replace(replace(replace(m.workphone, '-', ''), '(', ''), ')', ''), 1, 10), convert(varchar, n.created, 112), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from notes n with (nolock) inner join master m with (nolock) on m.number = n.number
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and action = 'phone' and result = 'chng' and user0 not in ('system', 'discover') and dbo.date(created) between dbo.date(@startDate) and dbo.date(@endDate) and comment like '%work%'

insert into @discoverinb(acctnbr, dod, dodver, lastlttrdate)
select distinct m.account, convert(varchar, d.dod, 112), convert(varchar, d.dod, 112), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from deceased d with (nolock) inner join master m with (nolock) on d.accountid = m.number
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and dbo.date(transmitteddate) between dbo.date(@startDate) and dbo.date(@endDate)

insert into @discoverinb(acctnbr, bkfile, bkchap, bkcase, bkydismisdate, bkydischdate, lastlttrdate)
select distinct m.account, convert(varchar, b.datefiled, 112), b.chapter, b.casenumber, convert(varchar, b.dismissaldate, 112), convert(varchar, b.dischargedate, 112), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from bankruptcy b with (nolock) inner join master m with (nolock) on b.accountid = m.number
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and dbo.date(transmitteddate) between dbo.date(@startDate) and dbo.date(@endDate)

insert into @discoverinb(acctnbr, cccsinfo, consnameph, lastlttrdate)
select distinct m.account, substring(c.companyname, 1, 20), substring(c.phone, 1, 20), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from cccs c with (nolock) inner join debtors d with (nolock) on c.debtorid = d.debtorid inner join master m with (nolock) on d.number = m.number
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and d.seq = 0

insert into @discoverinb(acctnbr, primename, addrphchgdate, lastlttrdate)
select distinct m.account, substring(m.name, 1, 26), convert(varchar, n.created, 112), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from notes n with (nolock) inner join master m with (nolock) on n.number = m.number
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and action = 'name' and result = 'chng' and user0 not in ('system', 'discover') and dbo.date(created) between dbo.date(@startDate) and dbo.date(@endDate)

insert into @discoverinb(acctnbr, caddate, lastlttrdate)
select distinct m.account, convert(varchar, m.closed, 112), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from master m with (nolock)
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and m.status = 'cad' and dbo.date(closed) between dbo.date(@startDate) and dbo.date(@endDate)

insert into @discoverinb(acctnbr, dispdate, lastlttrdate)
select distinct m.account, (SELECT TOP 1 convert(varchar, [StatusHistory].[datechanged], 112) FROM [StatusHistory] WITH (NOLOCK) WHERE [StatusHistory].[AccountID] = m.[number] ORDER BY [StatusHistory].[DateChanged] DESC), (select top 1 convert(varchar, dateprocessed, 112) from letterrequest l with (nolock) where m.number = l.accountid order by dateprocessed desc) as lastletter
from master m with (nolock)
where m.customer in (select customerid from fact with (nolock) where customgroupid = 58) and m.status = 'dsp' and dbo.date(closed) between dbo.date(@startDate) and dbo.date(@endDate)



select acctnbr, isnull(dod, '') dod, isnull(addr, '') addr, isnull(homeph, '') homeph, isnull(bkfile, '') bkfile, isnull(bkchap, '') bkchap, isnull(bkcase, '') bkcase, isnull(primename, '') primename, isnull(secname, '') secname, isnull(poephone, '') poephone, isnull(poename, '') poename, isnull(poeaddr, '') poeaddr, isnull(caddate, '') caddate, isnull(dispdate, '') dispdate, isnull(cccsinfo, '') cccsinfo, isnull(consnameph, '') consnameph, isnull(ssnchgdate, '') ssnchgdate, isnull(akaname, '') akaname, isnull(addrphchgdate, '') addrphchgdate, isnull(attynameph, '') attynameph, isnull(lastlttrdate, '') lastlttrdate, isnull(dodver, '') dodver, isnull(bkydismisdate, '') bkydismisdate, isnull(bkydischdate, '') bkydischdate
from @discoverinb
GO

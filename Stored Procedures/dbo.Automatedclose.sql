SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Automatedclose] AS
if exists (select * from dbo.sysobjects 
where id = object_id(N'[dbo].[tempclose1]') 
and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tempclose1]


CREATE TABLE [dbo].[tempclose1] (
	[number] [int]  NULL ,
	[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[qdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[oldbranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[newbranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[oldstatus] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[newstatus] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[user0] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[comment] [varchar] (800) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[olddesk] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


-- acb chargeoff
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (nolock) inner join supportqueueitems s with (nolock)
on master.number = s.accountid
where queuecode > '699'
 and master.customer in ('0000571','0000480','0000583','0000880','0000881','0000882')
and dateadd(day,90,received) < getdate()
and qlevel < '998'
and current0 <= 499.00

--cms
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (nolock) inner join supportqueueitems s with (Nolock) 
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000511','0000591','0000644','0000633','0000677')
and dateadd(day,90,received) < getdate()
and qlevel < '998'
and current0 < 1000.00

--- cms
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (nolock) inner join supportqueueitems s with (nolock) 
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000676')
and qlevel < '998'

-- discover
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock)
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000926')
and dateadd(day,90,received) < getdate()
and qlevel < '998'


-- gecc 

insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock) 
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000828')
and qlevel < '998'

-- Pinnacle
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock)
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000831','0000835')
and dateadd(day,90,received) < getdate()
and qlevel < '998'
and current0 <= 1000.00

--Jeff Cap
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock)
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000833')
and dateadd(day,90,received) < getdate()
and qlevel < '998'

--TOyota
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock)
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000837','0000839','0000841')
and dateadd(day,90,received) < getdate()
and qlevel < '998'
and current0 <= 1250


-- Target
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock)
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000856')
and dateadd(day,150,received) < getdate()
and qlevel < '998'
and current0 <= 250


-- Midland

insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock) 
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000900')
and dateadd(day,90,received) < getdate()
and qlevel < '998'
and current0 <= 700


--Midland

insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock) 
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000916','0000917','0000918')
and dateadd(day,90,received) < getdate()
and qlevel < '998'
and current0 <= 400


-- FIrst PRemeir

insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock) 
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000905')
and dateadd(day,90,received) < getdate()
and qlevel < '998'
and current0 <= 300

-- Jeff Cap
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock) 
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000927')
and dateadd(day,90,received) < getdate()
and qlevel < '998'
and current0 <= 250


--Midland
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock) 
on master.number = s.accountid
where queuecode > '699'
and master.customer in ('0000930')
and dateadd(day,120,received) < getdate()
and qlevel < '998'
and current0 <= 500


-- medical
insert into tempclose1 (number,oldstatus,newstatus,user0,olddesk,desk)
select number,status,'REV','Close1',desk,'008' from master with (Nolock) inner join supportqueueitems s with (Nolock) 
on master.number = s.accountid
where queuecode > '699'
 and master.customer in (select customer from customer with (Nolock) where cob like 'MED%' or cob like 'LOC%')
and qlevel < '998'

/*
insert into deskchangehistory (number,Jobnumber,olddesk,newdesk,oldqdate,newqdate,
[user],dmdatestamp)
select number,'Sweep',olddesk,desk,qdate,qdate,'Sweep',getdate()
from tempclose1
*/

--select top 1 * from notes
insert into notes (number,created,user0,action,result,comment)
select number,getdate(),user0,'DESK','CHNG','Desk changed from '+olddesk+' to '+desk from tempclose1 with (Nolock)

update master set status = t.newstatus,master.desk = t.desk,branch = (select branch from desk with (Nolock) where code = t.desk) from tempclose1 t with (Nolock) where master.number = t.number

--select * from statushistory
insert into statushistory (accountid,datechanged,username,oldstatus,newstatus)
select number,getdate(),user0,oldstatus,newstatus from tempclose1 with (Nolock)

insert into notes (number,created,user0,action,result,comment)
select number,getdate(),user0,'+++++','+++++','Status Change from '+oldstatus+' to '+newstatus
from tempclose1 with (Nolock)

delete from supportqueueitems where accountid in (select number from tempclose1 with (Nolock))
update master set shouldqueue = 1 where number in (select number from tempclose1 with (Nolock))

--update master set status = t.newstatus,qlevel = '998',
--closed=convert(varchar,getdate(),112) from tempclose1 t
--where master.number = t.number
--and master.qlevel < '998'

--select * from notes where number = 1974218
--select desk,status,* from master where number = 1974218

--select * from tempclose1
GO

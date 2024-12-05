SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Targetfronttobacksweep] AS
--
-- THis is to move the front line accounts to back line.
--
--sp_help notes
/*
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tempdeskmove]') 
and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tempdeskmove]


CREATE TABLE [dbo].[tempdeskmove] (
	[number] [int]  NULL ,
	[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[qdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[oldbranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[newbranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[user0] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[comment] [varchar] (800) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[olddesk] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


---- all this stuff moves to tier 2

---  Select Tier 1 feeder that is over 60 days.
insert into tempdeskmove (number,desk,user0,olddesk)
select number,'082','TGSweep1',desk from master with (nolock) where desk in ('071','259','245','164','211','183','193','282','153') and 
dateadd(day,60,received) < getdate() and qlevel < '800'
and number not in (select number from pdc where active = 1)
and number not in (select number from debtorcreditcards where isactive = 1)
and number not in (select acctid from promises where active = 1)
and number not in (select number from tempdeskmove)

---  get tier 1 no phones where the phone was removed at least 3 days ago and account worked once.
insert into tempdeskmove (number,desk,user0,olddesk)
select master.number,'082','TGSweep2',desk from master with (nolock) 
--left outer join (select number,max(dmdatestamp) as [lastmove] from deskchangehistory with (nolock) group by number) as sq
--on master.number = sq.number
where desk in ('259','245','164','211','183','193','282','153') and 
(homephone is null or homephone = '0') and (workphone is null or workphone = '0')
and master.number in (select accountid from phonehistory with (nolock) group by accountid) 
--and getdate() - 3 > isnull(sq.lastmove,master.received)
and isnull(worked,getdate()) + 3 < getdate() 
and qlevel < '800'
and master.number not in (select number from pdc where active = 1)
and master.number not in (select number from debtorcreditcards where isactive = 1)
and master.number not in (select acctid from promises where active = 1)
and master.number not in (select number from tempdeskmove)


---  from tier1 with phones that are over 30 days old
insert into tempdeskmove (number,desk,user0,olddesk)
select number,'082','TGSweep3',desk from master with (nolock) where desk in ('259','245','164','211','183','193','282','153') and
((homephone is not null and homephone > '0') or (workphone is not null and workphone > '0'))
and dateadd(day,30,received) < getdate()
and qlevel < '800'
and worked is not null
and number not in (select number from pdc where active = 1)
and number not in (select number from debtorcreditcards where isactive = 1)
and number not in (select acctid from promises where active = 1)
and number not in (select number from tempdeskmove)



Insert into tempdeskmove (number,desk,user0,olddesk)
select number,'029','TGSweep4',desk from master with (nolock) where desk in ('082','188','160','184','167','255','306','132')
and qlevel < '800' 
and current0 <= 150.00
and number not in (select number from pdc where active = 1)
and number not in (select number from debtorcreditcards where isactive = 1)
and number not in (select acctid from promises where active = 1)
and number not in (select number from tempdeskmove)







--SELECT * FROM tempdeskmove

insert into deskchangehistory (number,Jobnumber,olddesk,newdesk,oldqlevel,newqlevel,oldqdate,newqdate,
oldbranch,newbranch,[user],dmdatestamp)
select number,user0,olddesk,desk,'...','...',' ',' ',' ',' ',user0,getdate()
from tempdeskmove

--select top 1 * from notes
insert into notes (number,created,user0,action,result,comment)
select number,getdate(),user0,'DESK','CHNG','Desk changed from '+olddesk+' to '+desk from tempdeskmove

update master set master.desk = t.desk  from tempdeskmove t where master.number = t.number

*/
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_FMC_Export_OCA_Snapshot] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select convert(varchar(8), getdate(), 112) as asofdate, m.number as account, d1.ssn, right(account, 3) as loanseqnum, 
		(select top 1 thedata from miscextra with (nolock) where number = m.number and title = 'servicer') as loanservicer, 
		d1.firstname as borfirstname, d1.lastname as borlastname, d1.street1 as boraddress, d1.city as borcity, 
		d1.state as borstate, replace(d1.zipcode, '-', '') as borzip, d1.country as borcountry, d1.homephone as borhomephone, 
		d1.workphone as borworkphone, d1.pager as borcellphone, d1.email as boremail, 'N' as borskipind, 
		'' as borskipmethod, 'N' as borcndind, convert(varchar(8), m.contacted, 112) as borlastcontact, d2.firstname as cofirstname, 
		d2.lastname as colastname, d2.street1 as coaddress, d2.city as cocity, d2.state as costate, replace(d2.zipcode, '-', '') as cozip,
		d2.country as cocountry, d2.homephone as cohomephone, d2.workphone as coworkphone, d2.pager as cocellphone, 
		d2.email as coemail, 'N' as coskipind, '' as coskipmethod, 'N' as cocndind, '' as colastcontact,
		m.status as statuscode, m.current1 as acctbalance, case when m.status in ('ppa') then 'Y' else 'N' end as ptpind,
		convert(varchar(8), Case when m.status = 'ppa' then (select top 1 duedate from promises with (nolock) where acctid = m.number and active = 1 order by duedate desc) else null end, 112) as ptpdate,
		Case when m.status = 'ppa' then (select top 1 amount from promises with (nolock) where acctid = m.number and active = 1 order by duedate desc) else '' end as ptpamount,
		Case when m.status = 'ppa' and (select top 1 p.debtorid from promises p with (nolock) where acctid = m.number and active = 1 order by duedate desc) = '0' then 'B'
		when m.status = 'ppa' and (select top 1 p.debtorid from promises p with (nolock) where acctid = m.number and active = 1 order by duedate desc) = '1' then 'C'  else '' end as ptpmadeby,
		'SIMM' as recoverercode, '' as filler
from master m with (Nolock) left outer join debtors d1 with (nolock) on m.number = d1.number and d1.seq = 0 left outer join debtors d2 with (nolock) on m.number = d2.number and d2.seq = 1
where m.customer in (select customerid from fact with (Nolock) where customgroupid = 134) and m.closed is null


END
GO

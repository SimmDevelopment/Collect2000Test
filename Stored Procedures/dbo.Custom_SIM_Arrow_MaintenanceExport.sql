SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
[dbo].[spCustom_NCC_Arrow_MaintenanceExport]
'1/1/2005','1/1/2008'

MG 20080326 Updated maintenance export to accomodate the media request records

*/

CREATE  procedure [dbo].[Custom_SIM_Arrow_MaintenanceExport]
--@customer varchar(8000)
@BeginDate datetime,
@EndDate datetime
as

begin
set @EndDate = dateadd(d, 1, @EndDate) 
set @EndDate = dateadd(s, -1, @EndDate)

--Get the accounts with Close codes
CREATE TABLE #Returns(number int, status varchar(5), id int IDENTITY(1,1)) 
INSERT INTO #Returns(number, status) 

Select m.number as [number], m.status as [status]
FROM master m WITH(NOLOCK)
INNER JOIN status s WITH(NOLOCK) ON s.code=m.status
Where m.qlevel < '999'
and m.closed between @BeginDate and @EndDate
and (m.status in ('SIF', 'PIF') or s.isbankruptcy = 1)
and m.customer in (select customerid from fact (nolock) where customgroupid = 97)

Union All

Select m.number as [number], 
case m.status
	when 'BKY' then 'BKP'
	when 'CCR' then 'RCC'
	when 'AEX' then 'UNC'
	when 'RFP' then 'LAR'
	when 'PIE' then 'ERR'
	else m.status end as [status]
FROM master m WITH(NOLOCK)
INNER JOIN status s WITH(NOLOCK) ON s.code=m.status 
where m.qlevel < '999'
and m.status not in ('SIF', 'PIF') 
and s.isbankruptcy != 1
and  m.closed between @BeginDate and @EndDate
and m.status in ('BKY','CAD','CCR','DEC','RFP', 'AEX', 'DSP','FRD','PIE')
AND m.customer in (select customerid from fact (nolock) where customgroupid = 97)


--CREATE TEMP BANKRUPTCY AND DECEASED TABLES
--DECLARE TEMP TABLE

DECLARE  @tempBankruptcy TABLE(
	[BankruptcyID] [int] NOT NULL 
) 


--INSERT DATA INTO TEMP TABLE

INSERT INTO @tempBankruptcy (BankruptcyId)

SELECT  BankruptcyID
FROM 
	bankruptcy b 
	join master m on m.number = b.accountid
	join fact f on f.customerid = m.customer
	join customcustgroups c on c.id = f.customgroupid
	
WHERE 
	b.transmitteddate is null and  customgroupid = 97


--Get the status code changes



-- --UPDATE TRANSMITTED DATE IN BANKRUPTCY TABLE
-- 	UPDATE Bankruptcy
-- 	SET
-- 		TransmittedDate = getdate()
-- 	FROM 
-- 		Bankruptcy b join @tempBankruptcy t
-- 		on b.BankruptcyId = t.BankruptcyId
--DECLARE TEMP TABLE

	DECLARE  @tempDeceased TABLE(
		[ID] [int] NOT NULL 
	) 
	INSERT INTO @tempDeceased (ID)
	SELECT
		d.ID
	FROM
		deceased d 
		join master m on m.number = d.accountid
	join fact f on f.customerid = m.customer
	join customcustgroups c on c.id = f.customgroupid
		
	WHERE
		d.transmitteddate is null  and  customgroupid = 97
		
 --UPDATE DECEASED TABLE
-- 	UPDATE Deceased
-- 	SET transmitteddate = getdate()
-- 	FROM deceased d join @tempDeceased t
-- 	on t.id = d.id



--GET DEMOGRAPHIC ADDRESS CHANGES
SELECT
m.account as account,
substring(m.name,charindex(',',m.name,0)+2,len(m.name)-charindex(',',m.name,0)) as debtor_first_name,
substring(m.name,0,charindex(',',m.name,0)) as debtor_last_name,
m.ssn as debtor_ssn,
m.street1 as street1,
Replace(m.street2,'&',' ') as street2,
m.city as city,
m.state as state,
replace(m.zipcode,'-','') as zipcode,
m.homephone as home_phone,
Replace(d.jobname,'&',' ') as work_name,
m.workphone as work_phone,
d.jobaddr1 as work_street,
d.jobcsz as work_city,
d.jobcsz as work_state,
replace(d.jobcsz,'-','') as work_zipcode,
b.casenumber as bankruptcy_case_number,
b.chapter as bankruptcy_chapter,
b.datefiled as bankruptcy_date_filed,
'' as bankruptcy_discharged_or_dismissed,
null as date_of_death,
d1.name as comaker_first_name,
d1.name as comaker_last_name,
d1.homephone as comaker_home_phone,
d1.street1 as comaker_street,
d1.city as comaker_city,
d1.state as comaker_state,
replace(d1.zipcode,'-','') as comaker_zipcode,
d1.jobname as comaker_work_name,
d1.jobaddr1 as comaker_work_street,
d1.jobcsz as comaker_work_city,
d1.jobcsz as comaker_work_state,
replace(d1.jobcsz,'-','') as comaker_work_zipcode,
d.spouse as spouse_first_name,
d.spouse as spouse_last_name,
d.spousehomephone as spouse_home_phone,
m.street1 as spouse_street,
m.city as spouse_city,
m.state as spouse_state,
replace(m.zipcode,'-','') as spouse_zipcode,
d.spousejobname as spouse_work_name,
d.spousejobaddr1 as spouse_work_street,
d.spousejobcsz as spouse_work_city,
d.spousejobcsz as spouse_work_state,
d.spousejobcsz as spouse_work_zipcode,
--csr.externalstatus as status,
 'DAV' status,
		 
null as bankruptcy_discharged_or_dismissed_date,
m.id2 as arrow_account_number,
m.contacted as last_contact_date,
a.datechanged as address_change_date,
null as dispute_date,

--the fields in the spec in this location are to be replaced with spaces - the xslt handles this

da.name as [attorneyLastName],--load the name field into attorney name per Mike Gwinnell
da.firm as [firmName],
da.phone as [attorneyPhone],
da.addr1 as [attorneyAddress],
da.city as [attorneyCity],
da.state as[attorneyState],
da.zipcode as [attorneyZip],

cccs.companyname as [cccsAgencyName],
cccs.phone as [cccsAgencyPhoneNumber],
'SIM' as [agencyId]

FROM
	addresshistory a with( nolock) join master m with( nolock) on m.number = a.accountid
	join debtors d with( nolock) on d.debtorid = a.debtorid and d.seq = 0
	left outer join bankruptcy b with( nolock) on b.debtorid = a.debtorid
	left outer join debtors d1 with( nolock) on d1.number = a.accountid and d1.seq = 1
	left outer join debtorattorneys  da (nolock) on d.debtorid = da.debtorid
	left outer join CCCS cccs (nolock) on  d.debtorid = cccs.debtorid

WHERE
	a.datechanged between @BeginDate and @EndDate  --Changed to date range per Mike Gwinnell
	and m.customer in (select customerid from fact (nolock) where customgroupid = 97)

UNION ALL

--Get the phone changes
SELECT
m.account as account,
substring(m.name,charindex(',',m.name,0)+2,len(m.name)-charindex(',',m.name,0)) as debtor_first_name,
substring(m.name,0,charindex(',',m.name,0)) as debtor_last_name,
m.ssn as debtor_ssn,
m.street1 as street1,
Replace(m.street2,'&',' ') as street2,
m.city as city,
m.state as state,
replace(m.zipcode,'-','') as zipcode,
m.homephone as home_phone,
Replace(d.jobname,'&',' ') as work_name,
m.workphone as work_phone,
d.jobaddr1 as work_street,
d.jobcsz as work_city,
d.jobcsz as work_state,
replace(d.jobcsz,'-','') as work_zipcode,
b.casenumber as bankruptcy_case_number,
b.chapter as bankruptcy_chapter,
b.datefiled as bankruptcy_date_filed,
'' as bankruptcy_discharged_or_dismissed,
null as date_of_death,
d1.name as comaker_first_name,
d1.name as comaker_last_name,
d1.homephone as comaker_home_phone,
d1.street1 as comaker_street,
d1.city as comaker_city,
d1.state as comaker_state,
replace(d1.zipcode,'-','') as comaker_zipcode,
d1.jobname as comaker_work_name,
d1.jobaddr1 as comaker_work_street,
d1.jobcsz as comaker_work_city,
d1.jobcsz as comaker_work_state,
replace(d1.jobcsz,'-','') as comaker_work_zipcode,
d.spouse as spouse_first_name,
d.spouse as spouse_last_name,
d.spousehomephone as spouse_home_phone,
m.street1 as spouse_street,
m.city as spouse_city,
m.state as spouse_state,
replace(m.zipcode,'-','') as spouse_zipcode,
d.spousejobname as spouse_work_name,
d.spousejobaddr1 as spouse_work_street,
d.spousejobcsz as spouse_work_city,
d.spousejobcsz as spouse_work_state,
replace(d.spousejobcsz,'-','') as spouse_work_zipcode,
--csr.externalstatus as status,
'HPV' as status,
null as bankruptcy_discharged_or_dismissed_date,
m.id2 as arrow_account_number,
m.contacted as last_contact_date,
p.datechanged as address_change_date,
null as dispute_date,

--the fields in the spec in this location are to be replaced with spaces - the xslt handles this

da.name as [attorneyLastName],--load the name field into attorney name per Mike Gwinnell
da.firm as [firmName],
da.phone as [attorneyPhone],
da.addr1 as [attorneyAddress],
da.city as [attorneyCity],
da.state as[attorneyState],
da.zipcode as [attorneyZip],

cccs.companyname as [cccsAgencyName],
cccs.phone as [cccsAgencyPhoneNumber],
'SIM' as [agencyId]


FROM
	phonehistory p with (nolock) join master m with (nolock) on m.number = p.accountid
	join debtors d with (nolock) on d.debtorid = p.debtorid and d.seq = 0
	left outer join bankruptcy b with (nolock) on b.debtorid = p.debtorid
	left outer join debtors d1 with (nolock) on d1.number = p.accountid and d1.seq = 1
	left outer join debtorattorneys  da (nolock) on d.debtorid = da.debtorid
	left outer join CCCS cccs (nolock) on  d.debtorid = cccs.debtorid
WHERE
	p.datechanged between @BeginDate and @EndDate 
	and m.customer in (select customerid from fact (nolock) where customgroupid = 97)

UNION ALL

--Get the Deceased Records

SELECT
m.account as account,
substring(m.name,charindex(',',m.name,0)+2,len(m.name)-charindex(',',m.name,0)) as debtor_first_name,
substring(m.name,0,charindex(',',m.name,0)) as debtor_last_name,
m.ssn as debtor_ssn,
m.street1 as street1,
Replace(m.street2,'&',' ') as street2,
m.city as city,
m.state as state,
replace(m.zipcode,'-','') as zipcode,
m.homephone as home_phone,
Replace(d.jobname,'&',' ') as work_name,
m.workphone as work_phone,
d.jobaddr1 as work_street,
d.jobcsz as work_city,
d.jobcsz as work_state,
replace(d.jobcsz,'-','') as work_zipcode,
b.casenumber as bankruptcy_case_number,
b.chapter as bankruptcy_chapter,
b.datefiled as bankruptcy_date_filed,
'' as bankruptcy_discharged_or_dismissed,
dc.dod as date_of_death,
d1.name as comaker_first_name,
d1.name as comaker_last_name,
d1.homephone as comaker_home_phone,
d1.street1 as comaker_street,
d1.city as comaker_city,
d1.state as comaker_state,
replace(d1.zipcode,'-','') as comaker_zipcode,
d1.jobname as comaker_work_name,
d1.jobaddr1 as comaker_work_street,
d1.jobcsz as comaker_work_city,
d1.jobcsz as comaker_work_state,
replace(d1.jobcsz,'-','') as comaker_work_zipcode,
d.spouse as spouse_first_name,
d.spouse as spouse_last_name,
d.spousehomephone as spouse_home_phone,
m.street1 as spouse_street,
m.city as spouse_city,
m.state as spouse_state,
replace(m.zipcode,'-','') as spouse_zipcode,
d.spousejobname as spouse_work_name,
d.spousejobaddr1 as spouse_work_street,
d.spousejobcsz as spouse_work_city,
d.spousejobcsz as spouse_work_state,
replace(d.spousejobcsz,'-','') as spouse_work_zipcode,
'DEC' as status,
null as bankruptcy_discharged_or_dismissed_date,
m.id2 as arrow_account_number,
m.contacted as last_contact_date,
null as address_change_date,
null as dispute_date,

--the fields in the spec in this location are to be replaced with spaces - the xslt handles this

da.name as [attorneyLastName],--load the name field into attorney name per Mike Gwinnell
da.firm as [firmName],
da.phone as [attorneyPhone],
da.addr1 as [attorneyAddress],
da.city as [attorneyCity],
da.state as[attorneyState],
da.zipcode as [attorneyZip],

cccs.companyname as [cccsAgencyName],
cccs.phone as [cccsAgencyPhoneNumber],
'SIM' as [agencyId]

FROM
	deceased dc  with (nolock) join master m  with (nolock) on m.number = dc.accountid
	join debtors d  with (nolock) on d.debtorid = dc.debtorid and d.seq = 0
	left outer join bankruptcy b  with (nolock) on b.debtorid = dc.debtorid
	left outer join debtors d1 with (nolock)  on d1.number = dc.accountid and d1.seq = 1
	--join Custom_StatusReference csr  with (nolock) on csr.internalstatus = m.status
	join @tempDeceased t   on dc.id = t.id
	left outer join debtorattorneys  da (nolock) on d.debtorid = da.debtorid
	left outer join CCCS cccs (nolock) on  d.debtorid = cccs.debtorid
	join statushistory sh on sh.accountid = m.number
where m.customer in (select customerid from fact (nolock) where customgroupid = 97)
and sh.datechanged between @BeginDate and @EndDate

UNION ALL

SELECT
m.account as account,
substring(m.name,charindex(',',m.name,0)+2,len(m.name)-charindex(',',m.name,0)) as debtor_first_name,
substring(m.name,0,charindex(',',m.name,0)) as debtor_last_name,
m.ssn as debtor_ssn,
m.street1 as street1,
Replace(m.street2,'&',' ') as street2,
m.city as city,
m.state as state,
replace(m.zipcode,'-','') as zipcode,
m.homephone as home_phone,
Replace(d.jobname,'&',' ') as work_name,
m.workphone as work_phone,
d.jobaddr1 as work_street,
d.jobcsz as work_city,
d.jobcsz as work_state,
replace(d.jobcsz,'-','') as work_zipcode,
b.casenumber as bankruptcy_case_number,
b.chapter as bankruptcy_chapter,
b.datefiled as bankruptcy_date_filed,
'' as bankruptcy_discharged_or_dismissed,
null as date_of_death,
d1.name as comaker_first_name,
d1.name as comaker_last_name,
d1.homephone as comaker_home_phone,
d1.street1 as comaker_street,
d1.city as comaker_city,
d1.state as comaker_state,
replace(d1.zipcode,'-','') as comaker_zipcode,
d1.jobname as comaker_work_name,
d1.jobaddr1 as comaker_work_street,
d1.jobcsz as comaker_work_city,
d1.jobcsz as comaker_work_state,
replace(d1.jobcsz,'-','') as comaker_work_zipcode,
d.spouse as spouse_first_name,
d.spouse as spouse_last_name,
d.spousehomephone as spouse_home_phone,
m.street1 as spouse_street,
m.city as spouse_city,
m.state as spouse_state,
replace(m.zipcode,'-','') as spouse_zipcode,
d.spousejobname as spouse_work_name,
d.spousejobaddr1 as spouse_work_street,
d.spousejobcsz as spouse_work_city,
d.spousejobcsz as spouse_work_state,
replace(d.spousejobcsz,'-','') as spouse_work_zipcode,
--csr.externalstatus as status,
'BKP' as status,
null as bankruptcy_discharged_or_dismissed_date,
m.id2 as arrow_account_number,
m.contacted as last_contact_date,
null as address_change_date,
null as dispute_date,

--the fields in the spec in this location are to be replaced with spaces - the xslt handles this

da.name as [attorneyLastName],--load the name field into attorney name per Mike Gwinnell
da.firm as [firmName],
da.phone as [attorneyPhone],
da.addr1 as [attorneyAddress],
da.city as [attorneyCity],
da.state as[attorneyState],
da.zipcode as [attorneyZip],

cccs.companyname as [cccsAgencyName],
cccs.phone as [cccsAgencyPhoneNumber],
'SIM' as [agencyId]


FROM
	bankruptcy b  with (nolock) join master m  with (nolock) on b.accountid = m.number
	join debtors d  with (nolock) on d.debtorid = b.debtorid and d.seq = 0
	left outer join debtors d1  with (nolock) on d1.number = b.accountid and d1.seq = 1
	--join Custom_StatusReference csr  on csr.internalstatus = m.status
	join @tempbankruptcy t  on t.bankruptcyid = b.bankruptcyid
	left outer join debtorattorneys  da (nolock) on d.debtorid = da.debtorid
	left outer join CCCS cccs (nolock) on  d.debtorid = cccs.debtorid
	join statushistory sh on sh.accountid = m.number

Where m.customer in (select customerid from fact (nolock) where customgroupid = 97)
and sh.datechanged between @BeginDate and @EndDate --Changed to date range per Mike Gwinnell


UNION ALL
--Get status code changes

SELECT
m.account as account,
substring(m.name,charindex(',',m.name,0)+2,len(m.name)-charindex(',',m.name,0)) as debtor_first_name,
substring(m.name,0,charindex(',',m.name,0)) as debtor_last_name,
m.ssn as debtor_ssn,
m.street1 as street1,
Replace(m.street2,'&',' ') as street2,
m.city as city,
m.state as state,
replace(m.zipcode,'-','') as zipcode,
m.homephone as home_phone,
Replace(d.jobname,'&',' ') as work_name,
m.workphone as work_phone,
d.jobaddr1 as work_street,
d.jobcsz as work_city,
d.jobcsz as work_state,
replace(d.jobcsz,'-','') as work_zipcode,
null as bankruptcy_case_number,
null as bankruptcy_chapter,
null as bankruptcy_date_filed,
'' as bankruptcy_discharged_or_dismissed,
null as date_of_death,
d1.name as comaker_first_name,
d1.name as comaker_last_name,
d1.homephone as comaker_home_phone,
d1.street1 as comaker_street,
d1.city as comaker_city,
d1.state as comaker_state,
replace(d1.zipcode,'-','') as comaker_zipcode,
d1.jobname as comaker_work_name,
d1.jobaddr1 as comaker_work_street,
d1.jobcsz as comaker_work_city,
d1.jobcsz as comaker_work_state,
replace(d1.jobcsz,'-','') as comaker_work_zipcode,
d.spouse as spouse_first_name,
d.spouse as spouse_last_name,
d.spousehomephone as spouse_home_phone,
m.street1 as spouse_street,
m.city as spouse_city,
m.state as spouse_state,
replace(m.zipcode,'-','') as spouse_zipcode,
d.spousejobname as spouse_work_name,
d.spousejobaddr1 as spouse_work_street,
d.spousejobcsz as spouse_work_city,
d.spousejobcsz as spouse_work_state,
d.spousejobcsz as spouse_work_zipcode,
CASE sh.newstatus WHEN 'PDC' THEN 'PPA'
		WHEN 'PCC' THEN 'PPA'
		WHEN 'PPA' THEN 'PRO'
		WHEN 'ACT' THEN 'PAY'
		when 'BKN' then 'PPD'
		when 'STL' then 'VSO'
END as status,
--csr.externalstatus as status,
null as bankruptcy_discharged_or_dismissed_date,
m.id2 as arrow_account_number,
m.contacted as last_contact_date,
null as address_change_date,
null as dispute_date,

--the fields in the spec in this location are to be replaced with spaces - the xslt handles this

null as [attorneyLastName],--load the name field into attorney name per Mike Gwinnell
null as [firmName],
null as [attorneyPhone],
null as [attorneyAddress],
null as [attorneyCity],
null as[attorneyState],
null as [attorneyZip],

null as [cccsAgencyName],
null as [cccsAgencyPhoneNumber],
'SIM' as [agencyId]

from master m  with (nolock)inner join statushistory sh (nolock) on m.number = sh.accountid
	join debtors d  with (nolock) on m.number = d.number and d.seq = 0
	left outer join debtors d1  with (nolock) on d1.number = m.number and d1.seq = 1
	
where sh.datechanged between @BeginDate and @EndDate --Changed to date range per Mike Gwinnell
and m.customer in (select customerid from fact (nolock) where customgroupid = 97)
and (sh.newstatus IN ('PDC','PCC','PPA', 'BKN', 'STL')
OR (sh.newstatus IN('ACT') AND
m.number in (select ph.number from payhistory ph (nolock) where 
ph.number = m.number and datediff(d,ph.entered, getdate()) between 0 and 45)))

UNION ALL
--Generate the Media Request Records

SELECT
m.account as account,
substring(m.name,charindex(',',m.name,0)+2,len(m.name)-charindex(',',m.name,0)) as debtor_first_name,
substring(m.name,0,charindex(',',m.name,0)) as debtor_last_name,
m.ssn as debtor_ssn,
m.street1 as street1,
Replace(m.street2,'&',' ') as street2,
m.city as city,
m.state as state,
replace(m.zipcode,'-','') as zipcode,
m.homephone as home_phone,
Replace(d.jobname,'&',' ') as work_name,
m.workphone as work_phone,
d.jobaddr1 as work_street,
d.jobcsz as work_city,
d.jobcsz as work_state,
replace(d.jobcsz,'-','') as work_zipcode,
null as bankruptcy_case_number,
null as bankruptcy_chapter,
null as bankruptcy_date_filed,
'' as bankruptcy_discharged_or_dismissed,
null as date_of_death,
d1.name as comaker_first_name,
d1.name as comaker_last_name,
d1.homephone as comaker_home_phone,
d1.street1 as comaker_street,
d1.city as comaker_city,
d1.state as comaker_state,
replace(d1.zipcode,'-','') as comaker_zipcode,
d1.jobname as comaker_work_name,
d1.jobaddr1 as comaker_work_street,
d1.jobcsz as comaker_work_city,
d1.jobcsz as comaker_work_state,
replace(d1.jobcsz,'-','') as comaker_work_zipcode,
d.spouse as spouse_first_name,
d.spouse as spouse_last_name,
d.spousehomephone as spouse_home_phone,
m.street1 as spouse_street,
m.city as spouse_city,
m.state as spouse_state,
replace(m.zipcode,'-','') as spouse_zipcode,
d.spousejobname as spouse_work_name,
d.spousejobaddr1 as spouse_work_street,
d.spousejobcsz as spouse_work_city,
d.spousejobcsz as spouse_work_state,
d.spousejobcsz as spouse_work_zipcode,
case si.queuecode
when '690' then 'RCA'
when '691' then 'APP'
when '692' then 'AFS'
when '693' then 'CST' else 'LST' end as status,
-- 'ACK' as status,
--csr.externalstatus as status,
null as bankruptcy_discharged_or_dismissed_date,
m.id2 as arrow_account_number,
m.contacted as last_contact_date,
null as address_change_date,
null as dispute_date,

--the fields in the spec in this location are to be replaced with spaces - the xslt handles this

null as [attorneyLastName],--load the name field into attorney name per Mike Gwinnell
null as [firmName],
null as [attorneyPhone],
null as [attorneyAddress],
null as [attorneyCity],
null as[attorneyState],
null as [attorneyZip],

null as [cccsAgencyName],
null as [cccsAgencyPhoneNumber],
'SIM' as [agencyId]

from master m  with (nolock)

inner join supportqueueitems si (nolock) on m.number = si.accountid and si.queuecode between '690' and '699'
inner join debtors d  with (nolock) on m.number = d.number and d.seq = 0

left outer join debtors d1  with (nolock) on d1.number = m.number and d1.seq = 1

where si.dateadded between @BeginDate and @EndDate --Changed to date range per Mike Gwinnell

and m.customer in (select customerid from fact (nolock) where customgroupid = 97)




--Close the accounts 
Update master set returned = getdate(), qlevel = '999' where number in (Select number from #Returns) 

end
GO

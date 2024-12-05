SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 02/21/2022
-- Description:	YGC Export records for WRC
-- Codes The Firm Id for you is “SIMM” and FORW_ID is “WCF3”
/* Required Records
1.	Record 30 - Good
2.	Record 31 - Good
3.	Record 36 - Good
4.	Record 38 - Good
5.	Record 39 - Good
6.	Record 43 - Programming
*/

-- =============================================
CREATE PROCEDURE [dbo].[Custom_WRC_All_Records]
	-- Add the parameters for the stored procedure here
@startdate datetime,
@enddate DATETIME,
@invoice varchar(8000)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Record Code 30 - Financial Transactions
	select  '30' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,

	CASE WHEN m.status = 'SIF' THEN 3 ELSE CASE p.batchtype when 'pc' then 6 when 'pcr' then 6 when 'pu' then 1 when 'pur' then 1 END END as ret_code,
	p.datepaid as pay_date,
	case when batchtype like '%r' then -(p.paid1 + p.paid2) else (p.paid1 + p.paid2) end as gross_pay,
	case when batchtype like '%r' then -(p.paid1) else p.paid1 end as net_client,
	case when batchtype like '%r' then -((p.paid1 + p.paid2) - (p.collectorfee)) else ((p.paid1 + p.paid2) - (p.collectorfee)) end as check_amt,
	'' as cost_ret,
	case when batchtype like '%r' then -(p.collectorfee) else p.collectorfee end as fees,
	'' as agent_fees,
	'' as forw_cut,
	'' as cost_rec,
	'B' as bpj,
	p.uid as ta_no,
	p.batchnumber as rmit_no,
	'' as line1_3,
	p.balance as line1_5,
	case when batchtype like '%r' then -(p.paid1 + p.paid2) else (p.paid1 + p.paid2) end as line1_6,
	case when batchtype like '%r' then -(p.paid1) else p.paid1 end as line2_1,
	case when batchtype like '%r' then -(p.paid2) else p.paid2 end as line2_2,
	'' as line2_5,
	'' as line2_6,
	'' as line2_7,
	case when batchtype like '%r' then -(p.collectorfee) else p.collectorfee end as line2_8,
	'' as descr,
	p.datepaid as post_date,
	p.invoiced as remit_date,
	CASE WHEN m.status = 'SIF' AND p.batchtype = 'pu' THEN '*CC:A101'
		WHEN m.status = 'PIF' AND p.batchtype = 'pu' THEN '*CC:A100'
		WHEN batchtype like '%r' THEN '*CC:A030' 
		WHEN batchtype = 'pu' AND p.paymethod = 'CREDIT CARD' THEN '*CC:A029'
		WHEN batchtype = 'pu' AND p.paymethod = 'MONEY ORDER' THEN '*CC:A043'
		WHEN batchtype = 'pu' AND p.paymethod = 'BANK WIRE' THEN '*CC:A042'
		WHEN batchtype = 'pu' AND p.paymethod = 'WESTERN UNION' THEN '*CC:A040'
		 ELSE '*CC:A020' END as ta_code,
	'' as comment,
	CASE WHEN P.batchtype LIKE '%r' THEN P.ReverseOfUID ELSE '' END AS originaltanumber,
	CASE WHEN P.batchtype LIKE '%r' THEN (SELECT batchnumber FROM payhistory WITH (NOLOCK) WHERE P.ReverseOfUID = uid) ELSE '' END AS originalremitnumber,
	CASE WHEN P.batchtype LIKE '%r' THEN (SELECT CONVERT(VARCHAR(9), invoiced, 112) FROM payhistory WITH (NOLOCK) WHERE P.ReverseOfUID = uid) ELSE '' END AS originalremitdate,
	'' AS costspentrecoverfromdebtor,
	'' AS costspentnonrecoverfromdebtor,
	'' AS costspentrecoverfromclient,
	'' AS costspentnonrecoverfromclient,
	'1' AS debtornumber
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
where m.customer = '0002770' 
--and p.invoiced between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
and p.batchtype in ('pu', 'pur', 'pc', 'pcr')
AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))
--end Record code 30

--Begin Record code 31 - Primary Debtor Info Update
select  '31' as record_code,
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,	
	d.name as d1_name,
	'' as d1_salut,
	'' as d1_alias,
	d.street1 as d1_street,
	rtrim(d.city) + ', ' + rtrim(d.state) as d1_cs,
	d.zipcode as d1_zip,
	ISNULL((SELECT TOP 1 phonenumber FROM Phones_Master pm WITH (NOLOCK) WHERE pm.PhoneTypeID = 1 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID = 2) AND d.DebtorID = pm.DebtorID ORDER BY pm.LastUpdated DESC), d.HomePhone) as d1_phone,
	ISNULL(d.fax, '') as d1_fax,
	d.SSN as d1_ssn,
	'' as rfile,
	'' as d1_dob,
	'' as d1_dl,
	d.state as d1_state,
	d.mr as d1_mail,
	'' as service_d,
	'' as answer_due_d,
	'' as answer_file_d,
	'' as default_d,
	'' as trial_d,
	'' as hearing_d,
	'' as lien_d,
	'' as garn_d,
	'' as service_type,
	d.street2 as d1_strt2,
	d.city as d1_city,
	ISNULL((SELECT TOP 1 phonenumber FROM Phones_Master pm WITH (NOLOCK) WHERE pm.PhoneTypeID = 3 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID = 2) AND d.DebtorID = pm.DebtorID ORDER BY pm.LastUpdated DESC), '') as d1_cell,
	'' as score_fico,
	'' as score_collect,
	'' as score_other,
	'USA' as d1_cntry,
	d.street1 + ' ' + d.street2 as d1_street_long,
	'' as d1_street2_long,
	d.firstName AS firstname,
	d.lastName AS lastname,
	'' AS scoreinternal,
	'' AS stage
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
where m.customer = '0002770' and 
(CAST(dateupdated AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
OR (SELECT TOP 1 CAST(lastupdated AS DATE) FROM Phones_Master pm WITH (NOLOCK) WHERE pm.PhoneTypeID = 1 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID IN (0, 2)) AND d.DebtorID = pm.DebtorID ORDER BY pm.LastUpdated DESC) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
OR (SELECT TOP 1 CAST(lastupdated AS DATE) FROM Phones_Master pm WITH (NOLOCK) WHERE pm.PhoneTypeID = 3 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID IN (0, 2)) AND d.DebtorID = pm.DebtorID ORDER BY pm.LastUpdated DESC) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE))
--end Record code 31

----begin Record code 33 - Co-Debtor information update
--select  '33' as record_code, 
--	m.id1 as fileno, 
--	m.account as forw_file, 
--	m.number as masco_file, 
--	'SIMM' as firm_id, 
--	'WCF3' as forw_id,

--	d.name as d2_name,
--	d.street1 as d2_street,

--	case when d.city = '' and d.state = ''
--		then '' else rtrim(d.city) + ', ' + rtrim(d.state) + ' ' + d.zipcode end as d2_csz,
--	isnull(d.homephone, '') as d2_phone,
--	'' as d2_ssn,
--	'' as d3_name,
--	'' as d3_street,
--	'' as d3_csz,
--	'' as d3_phone,
--	'' as d3_ssn,
--	'' as d2_dob,
--	'' as d3_dob,
--	'' as d2_dl,
--	'' as d3_dl,
--	'USA' as d2_cntry,
--	'' as d3_cntry,
--	d.street1 + ' ' + d.street2 as d2_street_long,
--	'' as d2_street2_long,
--	'' as d3_street_long,
--	'' as d3_street2_long

--from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 1
--where m.customer = '0002770' and dateupdated between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
----end Record code 33

----begin Record code 34
--select  '34' as record_code, 
--	m.id1 as fileno, 
--	m.account as forw_file, 
--	m.number as masco_file, 
--	'SIMM' as firm_id, 
--	'WCF3' as forw_id,

--	d.jobname as emp_name,
--	d.jobaddr1 as emp_street,
--	'' as emp_po,
--	rtrim(substring(d.jobcsz, 0, patindex('%[0-9]%', d.jobcsz))) as emp_cs,
--	substring(d.jobcsz, patindex('%[0-9]%', d.jobcsz), 10) as emp_zo,
--	d.workphone as emp_phone,
--	'' as emp_fax,
--	'' as emp_attn,
--	'' as emp_payr,
--	'1' as emp_no,
--	d.name as employee_name,
--	'' as emp_income,
--	'' as emp_freq,
--	'' as emp_pos,
--	'' as emp_tenure,
--	'USA' as emp_cntry

--from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
--where m.customer = '0002770' and dateupdated between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
----end Record code 34

----begin Record code 35
--select  '35' as record_code, 
--	m.id1 as fileno, 
--	m.account as forw_file, 
--	m.number as masco_file, 
--	'SIMM' as firm_id, 
--	'WCF3' as forw_id,

--	'' as filler,
--	b.bankname as bank_name,
--	b.bankaddress as bank_street,
--	b.bankcity + ', ' + b.bankstate + ' ' + b.bankzipcode as bank_csz,
--	'' as bank_attn,
--	b.bankphone as bank_phone,
--	'' as bank_fax,
--	b.accountnumber as bank_acct,
--	'' as misc_asset1,
--	'' as misc_asset2,
--	'' as misc_asset3,
--	'' as misc_phone,
--	'1' as bank_no,
--	'USA' as bank_cntry
	

--from master m with (nolock) inner join debtorbankinfo b with (nolock) on m.number = b.acctid inner join pdc p with (nolock) on m.number = p.number
--where m.customer = '0002770' and m.number in (select number from pdc with (Nolock) where m.number = number group by number having count(*) = 1) and entered between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
----end Record code 35

--Begin Record code 36 - Primary Debtor Info Update
select  '36' as record_code,
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,	
	da.Name AS adva_name,
	SUBSTRING(da.Firm, 1, 30) AS adva_firm,
	CASE WHEN LEN(da.Firm) > 30 THEN SUBSTRING(da.Firm, 31, 30) ELSE '' END AS adva_firm2,
	da.Addr1 AS adva_street,
	da.city + ', ' + da.State + ' ' + da.Zipcode AS adva_csz,
	'' AS adva_salut,
	da.Phone AS adva_phone,
	da.Fax AS adva_fax,
	'' AS adva_fileno,
	'' AS misc_date1,
	'' AS misc_date2,
	'' AS misc_amt1,
	'' AS misc_amt2,
	'' AS misc_comm1,
	'' AS misc_comm2,
	'' AS misc_comm3,
	'' AS misc_comm4,
	'' AS adva_num,
	'USA' AS adva_cntry,
	'' AS adversemotionfileddate,
	'' AS adversemotionreceiveddate,
	'' AS adversemotiondescription
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0 INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
where m.customer = '0002770' and 
CAST(da.DateCreated AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)

--end Record code 36

--begin Record code 38 - Recon
select  '38' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,

	CONVERT(VARCHAR(8), m.received, 112) as dplaced, 
	m.name  as debt_name, 
	SUBSTRING(m.id2, 1, 30) as cred_name, 
	m.current1 as d1_bal, 
	ISNULL(CONVERT(VARCHAR(8), m.lastinterest, 112), '') as idate, 
	m.accrued2 as iamt,
	m.current2 as idue, 
	abs(m.paid1 + m.paid2 + m.paid3 + m.paid4) as paid, 
	'' as cost_bal, 
	rtrim(m.city) + ', ' + rtrim(m.state) as debt_cs, 
	REPLACE(m.zipcode, '-', '') as debt_zip, 
	CASE WHEN LEN(m.id2) > 30 THEN SUBSTRING(m.id2, 31, 55) ELSE '' END as cred_name2,
	(select fee1 from feescheduledetails fsd with (Nolock) inner join customer c with (nolock) on fsd.code = c.feeschedule where c.customer = m.customer)  as comm, 
	'' as sfee, 
	'' AS rfile,
	'USA' as debt_cntry,
	m.original AS originalplacedbalance,
	 CASE WHEN CONVERT(VARCHAR(8),closed, 112) IS NOT NULL THEN CONVERT(VARCHAR(8),closed, 112) ELSE '' END  AS closeddate,
	case when m.status in ('CCR', 'RCL') then '*CC:C102'
		when m.status = 'PIF' then '*CC:C109'
		when m.status = 'SIF' then '*CC:C118' 
		when m.status in ('CAD', 'CND') then '*CC:C135'
		when m.status in ('B07', 'B11', 'B13', 'BKY') then '*CC:C101'
		when m.status = 'DEC' then '*CC:C163'
		when m.status = 'RSK' then '*CC:C196'
		when m.status = 'MIL' then '*CC:C140'
		when m.status = 'AEX' then '*CC:C105'
		ELSE '' END AS closedcode
from master m with (nolock)
where customer = '0002770' AND qlevel <> '999' --and m.received between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
--end Record code 38

--begin Record code 39 - Message - Status Changes
--Acknowledgements
SELECT '39' AS record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(m.received AS DATE) AS pdate,
	'*CC:S101' AS pcode,
	'Acknowledgment' AS pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	'1' AS debtor_type
FROM master m WITH (NOLOCK) 
WHERE m.customer = '0002770' and CAST(m.received AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)

UNION ALL 

--Active Collections
SELECT '39' AS record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(m.received AS DATE) AS pdate,
	'*CC:A020' AS pcode,
	'Collection' AS pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	'1' AS debtor_type
FROM master m WITH (NOLOCK) 
WHERE m.customer = '0002770' AND (SELECT TOP 1 sh.OldStatus FROM StatusHistory sh WITH (NOLOCK) WHERE sh.AccountID = m.number AND CAST(sh.DateChanged AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) AND sh.OldStatus = 'NEW' ORDER BY sh.DateChanged DESC) = 'NEW'

UNION ALL 

--Closed Accounts
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(datechanged AS DATE) as pdate,
	case when newstatus in ('CCR', 'RCL') then '*CC:C102'
		when newstatus = 'PIF' then '*CC:C109'
		when newstatus = 'SIF' then '*CC:C118' 
		when newstatus in ('CAD', 'CND') then '*CC:C135'
		when newstatus in ('B07', 'B11', 'B13', 'BKY') then '*CC:C101'
		when newstatus = 'DEC' then '*CC:C163'
		when newstatus = 'RSK' then '*CC:C196'
		when newstatus = 'MIL' then '*CC:C140'
		when newstatus = 'AEX' then '*CC:C105'		
	end as pcode,
	case when newstatus in ('CCR', 'RCL') then 'Close - Client Request'
		when newstatus = 'PIF' then 'Close - Paid in Full'
		when newstatus = 'SIF' then 'Close - Settle in Full' 
		when newstatus in ('CAD', 'CND') then 'Close - Cease and Desist'
		when newstatus in ('B07', 'B11', 'B13', 'BKY') then 'Close - Bankrupt'
		when newstatus = 'DEC' then 'Close - Deceased - Confirmed'
		when newstatus = 'RSK' then 'Litigation Risk by Consumer'
		when newstatus = 'MIL' then 'Close - Soldiers & Sailors'
		when newstatus = 'AEX' then 'Close - Efforts exhausted'		
	end AS pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	'1' AS debtor_type
from master m with (nolock) inner join statushistory sh with (nolock) on m.number = sh.accountid
where m.customer = '0002770' and 
	newstatus in ('SIF', 'PIF', 'CCR', 'RCL', 'B07', 'B11', 'B13', 'BKY', 'DEC', 'RSK', 'MIL', 'AEX', 'CAD', 'CND') 	and datechanged between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
	
UNION ALL

--Letters Sent Primary
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(dateprocessed AS DATE) as pdate,
	case when lettercode = '1BNK' then '*CC:W100'
		WHEN l.LetterCode LIKE 'EML%' THEN '*CC:W190'
	end as pcode,
	case when lettercode = '1BNK' then '1st Demand Letter Sent'
		WHEN l.LetterCode LIKE 'EML%' THEN 'Send an Email'
	end as pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	CASE WHEN l.RecipientDebtorSeq = 0 THEN '1' ELSE '2' END AS debtor_type
from master m with (nolock) inner join letterrequest l with (nolock) on m.number = l.accountid
where m.customer = '0002770' AND (l.LetterCode = '1BNK' OR l.LetterCode LIKE 'EML%') and dateprocessed between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)

UNION ALL

--Bad Address Notification
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	(SELECT TOP 1 CAST(n.created AS DATE) FROM notes n WITH (NOLOCK) WHERE m.number = n.number AND CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	AND n.action = '+++++' AND n.result = '+++++' AND CONVERT(VARCHAR(50), n.comment) LIKE 'Mail Return%' ORDER BY n.created) as pdate,
	'*CC:I103' as pcode,
	'Debtor Address no Good' as pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction,
	CASE WHEN (SELECT TOP 1 CONVERT(VARCHAR(50), n.comment)  FROM notes n WITH (NOLOCK) WHERE m.number = n.number AND CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	AND n.action = '+++++' AND n.result = '+++++' AND CONVERT(VARCHAR(50), n.comment) LIKE 'Mail Return%' ORDER BY n.created) = 'Mail Return Set on Debtor(1)'
THEN '1' ELSE '2' END AS debtor_type
FROM master m WITH (NOLOCK) 
WHERE m.customer = '0002770' AND m.mr = 'y' 
AND (SELECT TOP 1 CONVERT(VARCHAR(50), n.comment)  FROM notes n WITH (NOLOCK) WHERE m.number = n.number AND CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
AND n.action = '+++++' AND n.result = '+++++' AND CONVERT(VARCHAR(50), n.comment) LIKE 'Mail Return%' ORDER BY n.created) like 'Mail Return Set on Debtor%'

UNION ALL

--Attorney representation
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(da.DateCreated AS DATE) as pdate,
	'*CC:L102' as pcode,
	'Attorney represented' as pcmt,
	FORMAT(da.DateCreated, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	CASE WHEN D.Seq = 0 THEN '1' ELSE '2' END AS debtor_type
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE m.customer = '0002770' AND CAST(da.DateCreated AS DATE) BETWEEN CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 

UNION ALL

--Non Closing Status Updates
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(@enddate AS DATE) as pdate,
		case when newstatus = 'DSP' then '*CC:S106'
		when newstatus = 'VDC' then '*CC:S109'
		when newstatus = 'VDS' then '*CC:S115' 
		when newstatus = 'FRD' then '*CC:S116'
		when newstatus = 'SKP' then '*CC:S124'
	end as pcode,
	case when newstatus = 'DSP' then 'Debtor Disputes Debt'
		when newstatus = 'VDC' then 'Debtor is Deceased'
		when newstatus = 'VDS' then 'Disputed' 
		when newstatus = 'FRD' then 'Dtr Claims Fraud on Acct'
		when newstatus = 'SKP' then 'Skip Trace'
	end AS pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	'1' AS debtor_type
FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer = '0002770' AND CAST(sh.DateChanged AS DATE) BETWEEN CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
AND m.status IN ('DSP', 'VDC', 'VDS', 'FRD', 'SKP') AND sh.NewStatus IN ('DSP', 'VDC', 'VDS', 'FRD', 'SKP')

UNION ALL

/*
--Outbound Calls Mobile Comply Made
SELECT  '39' as record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(PDA.CALL_DATE_TIME AS DATE) AS pdate,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN '*CC:W154'
		WHEN pt.PhoneTypeMapping = 0 THEN '*CC:W141'
		WHEN pt.PhoneTypeMapping = 2 THEN '*CC:W358'
	END AS pcode,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN 'Telephone Business'
		WHEN pt.PhoneTypeMapping = 0 THEN 'Telephone Residence'
		WHEN pt.PhoneTypeMapping = 2 THEN 'Telephoned Cell #'
	END AS pcmt,
	FORMAT(PDA.CALL_DATE_TIME, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	PDA.PHONE_NUMBER AS phone_number,
	'O' AS call_direction, 
	'1' AS debtor_type
	FROM DCLatitude..PD_Activity_Log PDA WITH(NOLOCK) JOIN 	DCLatitude..Campaign C WITH(NOLOCK) ON PDA.CAMPAIGN_ID = C.CAMPAIGN_ID
	JOIN master m WITH (NOLOCK) ON RTRIM(pda.RECORD_KEY) = CAST(m.number AS VARCHAR(10)) 
		AND m.customer = '0002770'
	OUTER APPLY (
		SELECT  TOP 1 *
		FROM    Phones_Master as PM 
		WHERE   RTRIM(pda.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
		AND PDA.PHONE_NUMBER = PM.PhoneNumber
		) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	--PDA.CLIENT_ID = 20 AND
	 CAST(PDA.CALL_DATE_TIME AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	AND PDA.CallType <> 3
	AND PDA.RESULT_CODE <> 'T'	

UNION ALL

--Manual Outbound Calls Made
SELECT  '39' as record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(PCH.RESULT_DATE AS DATE) AS pdate,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN '*CC:W154'
		WHEN pt.PhoneTypeMapping = 0 THEN '*CC:W141'
		WHEN pt.PhoneTypeMapping = 2 THEN '*CC:W358'
	END AS pcode,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN 'Telephone Business'
		WHEN pt.PhoneTypeMapping = 0 THEN 'Telephone Residence'
		WHEN pt.PhoneTypeMapping = 2 THEN 'Telephoned Cell #'
	END AS pcmt,
	FORMAT(PCH.RESULT_DATE, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	PCH.PHONE_NUMBER AS phone_number,
	'O' AS call_direction, 
	'1' AS debtor_type
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	JOIN master m WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = CAST(m.number AS VARCHAR(10))
		AND m.customer = '0002770'
	OUTER APPLY (
				SELECT  TOP 1 *
				FROM    Phones_Master as PM 
				WHERE   RTRIM(pch.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
				AND pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	CAST(PCH.RESULT_DATE AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	--AND PCH.CLIENT_ID = 20
	AND PV.TelephonyCallType IN (1) 
	AND pch.RESULT_CODE <> 'TFO'

UNION ALL

--Outbound Calls RPC
SELECT  '39' as record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(PCH.RESULT_DATE AS DATE) AS pdate,
	CASE 
		WHEN D.Contact = 1 THEN '*CC:W010'
	END AS pcode,
	CASE 
		WHEN D.Contact = 1 THEN 'Right Party Contact'
	END AS pcmt,
	FORMAT(PCH.RESULT_DATE, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	PCH.PHONE_NUMBER AS phone_number,
	'O' AS call_direction, 
	'1' AS debtor_type
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	JOIN master m WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = CAST(m.number AS VARCHAR(10))
		AND m.customer = '0002770'
	OUTER APPLY (
				SELECT  TOP 1 *
				FROM    Phones_Master as PM 
				WHERE   RTRIM(pch.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
				AND pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	CAST(PCH.RESULT_DATE AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	--AND PCH.CLIENT_ID = 20
	AND PV.TelephonyCallType IN (1) 
	AND pch.RESULT_CODE <> 'TFO'
	
UNION ALL
*/
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(e.ModifiedWhen AS DATE) as pdate,
	CASE WHEN e.Email <> '' THEN '*CC:I147'
	WHEN e.Email = '' THEN '*CC:I135' 
	END as pcode,
	CASE WHEN e.Email <> '' THEN 'Debtor Gave Email Address/Authorized Use'
	WHEN e.Email = '' THEN 'Remove Email address' 
	END as pcmt,
	FORMAT(e.ModifiedWhen, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	CASE WHEN D.Seq = 0 THEN '1' ELSE '2' END AS debtor_type
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number INNER JOIN Email e WITH (NOLOCK) ON d.DebtorID = e.DebtorId
WHERE m.customer = '00002770' AND e.CreatedWhen <> e.ModifiedWhen AND CAST(e.ModifiedWhen AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 

UNION ALL

--Text messages and results needs phones and debtors
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(n.created AS DATE) as pdate,
	CASE WHEN n.result = 'TSTOP' THEN '*CC:W951'
	WHEN n.action = 'TXT1' AND n.result = 'T-OK' THEN '*CC:W952' 
	WHEN n.action = 'TXT2' AND n.result = 'T-OK' THEN '*CC:W953' 
	END as pcode,
	CASE WHEN n.result = 'TSTOP' THEN 'Text Consent Revoked'
	WHEN n.action = 'TXT1' AND n.result = 'T-OK' THEN 'Text Sent to Customer' 
	WHEN n.action = 'TXT2' AND n.result = 'T-OK' THEN 'Text Clicked by Customer' 
	END as pcmt,
	FORMAT(n.created, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	CASE WHEN D.Seq = 0 THEN '1' ELSE '2' END AS debtor_type
	FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
WHERE m.customer = '0002770' AND USER0 = 'iconnect24' AND n.action in ('TXT1', 'TXT2') AND n.result IN ('T-OK', 'T-STOP')
AND CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
--end Record 39


----begin Record 42
--select  '42' as record_code, 
--	m.id1 as fileno, 
--	m.account as forw_file, 
--	m.number as masco_file, 
--	'SIMM' as firm_id, 
--	'WCF3' as forw_id,

--	m.interestrate as rates_pre,
--	0.00 as rates_post,
--	0 as per_diem,
--	0 as int_base,
--	m.accrued2 as iamount,
--	case when batchtype like '%r' then -(p.paid2) else p.paid2 end as ipaid,
--	m.lastinterest as idate,
--	current1 as prin_amt,
--	case when batchtype like '%r' then -(p.paid1) else p.paid1 end as prin_paid,
--	0 as cntrct_amt,
--	0 as cntrct_paid,
--	0 as stat_amt,
--	0 as stat_paid,
--	0 as cost_amt,
--	0 as cost_paid,
--	current1 as dbal,
--	current2 as ibal,
--	'' as stat_flag
--from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
--where m.customer = '0002770' and p.invoiced between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) and p.batchtype in ('pu', 'pur', 'pc', 'pcr')
----end Record 42


END
GO

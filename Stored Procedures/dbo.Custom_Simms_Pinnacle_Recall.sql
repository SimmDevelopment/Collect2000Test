SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*

DECLARE	@customer varchar(8000)
DECLARE @startdate DATETIME
DECLARE @enddate DATETIME
set @customer='0000831|0000895|'
SET @startdate = '20070201'
SET @enddate = '20070222'
EXECUTE [Custom_Simms_Pinnacle_Recall]    @customer, @startdate, @enddate

*/

CREATE        PROCEDURE [dbo].[Custom_Simms_Pinnacle_Recall]
	@customer varchar(8000),
	@startdate DATETIME,
	@enddate DATETIME

AS
BEGIN

	DECLARE @tmp_count TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[number] [int] NOT NULL)
	

	INSERT INTO @tmp_count (number)
	select n.number from notes n with(nolock)
	join master m with(nolock) on m.number = n.number
	WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	and DATEADD(day, 0, DATEDIFF(day, 0, n.created)) between @startdate and @enddate
	and n.user0 = 'EXCH' and n.action = 'RCL'
	group by n.number

	INSERT INTO @tmp_count (number)
	select m.number
	from master m with(nolock) 
	WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	and m.closed between @startdate and @enddate
	and m.returned is null and m.qlevel = '998'
	and m.number not in (select number from @tmp_count)
	group by number


	select
		m.account AS [data_id],
		CASE when isnull(mi.thedata,'1') <> '1' then '9' + RIGHT(mi.thedata, LEN(mi.thedata) - 1) 
			 when m.status in ('B07','B13','BKY') then '101050'
			 when m.status in ('DEC') then '101135'
			 when m.status in ('CAD') then '101110'
			 when m.status in ('FRD') then '101160'
			 when m.status in ('PCC','PDC') THEN '101210'
			 when m.status in ('SKP') THEN '101250'
		else '101000' end AS [status_code],
		m.id2 AS [pri_acctno],
		'' AS [sec_acctno],
		'' AS [type],
		m.originalcreditor AS [originator],
		'' AS [intrate],
		'' AS [term],
		'' AS [cycleid],
		m.received AS [acctopen],
		'' AS [lastactivity],
		'' AS [lastactivityamt],
		m.lastpaid AS [lastpayment],
		m.lastpaidamt AS [lastpaymentamt],
		'' AS [delinquency],
		m.closed AS [chargeoff],
		'' AS [chargeoffamt],
		m.current0 AS [bal_total],
		m.current1 AS [bal_principal],
		m.current2 AS [bal_interest],
		m.current8 AS [bal_fees_court],
		m.current5 AS [bal_fees_attorney],
		m.current6 AS [bal_fees_nsf],
		m.current3 AS [bal_fees_general],
		m.current4 AS [bal_fees_other],
		'' AS [lineofcredit],
		m.ssn AS [pri_ssn],
		'' as	[pri_taxid],
		m.dob AS [pri_dob],
		d.lastname as	[pri_last],
		d.middlename AS [pri_middle],
		d.firstname AS [pri_first],
		'' AS [pri_company],
		m.street1 AS [pri_add1],
		m.street2 AS [pri_add2],
		m.city AS [pri_city],
		m.state AS [pri_state],
		m.zipcode AS [pri_zip],
		'' AS [pri_country],
		m.homephone AS [pri_hphone],
		m.workphone AS [pri_wphone],
		'' AS [sec_ssn],
		'' AS [sec_taxid],
		'' AS [sec_dob],
		'' AS [sec_last],
		'' AS [sec_middle],
		'' AS [sec_first],
		'' AS [sec_company],
		'' AS [sec_add1],
		'' AS [sec_add2],
		'' AS [sec_city],
		'' AS [sec_state],
		'' AS [sec_zip],
		'' AS [sec_country],
		'' AS [sec_wphone],
		'' AS [sec_hphone],
		b.datefiled AS [bk_filing],
		b.chapter AS [bk_chapter],
		b.casenumber AS [bk_case],
		dec.dod AS [dec_date],
		'' AS [fraud_date],
		c.datefiled AS [judgment_filed],
		c.judgementdate AS [judgment_served],
		c.judgementdate AS [judgment_date],
		c.judgementamt AS [judgment_amount],
		c.judgementcostaward AS [judgment_bal_total],
		'' AS [judgment_bal_principal],
		'' AS [judgment_bal_interest],
		'' AS [judgment_bal_court],
		c.judgmentattorneycostaward AS [judgment_bal_attorney],
		'' AS [judgment_bal_nsf],
		'' AS [judgment_bal_fees],
		'' AS [judgment_bal_other],
		'' AS [judgment_suit_amount],
		'' AS [judgment_intrate]
	FROM @tmp_count t
	join master m with(nolock) on t.number = m.number 
	left outer join miscextra mi with(nolock) on mi.number = m.number 
	left outer join debtors d with(nolock) on d.number = m.number and d.seq = 0
	left outer join bankruptcy b with(nolock) on b.accountid = m.number
	left outer join deceased dec with(nolock) on dec.accountid = m.number
	left outer join courtcases c with(nolock) on c.accountid = m.number
	WHERE --m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) and 
--	n.created between @startdate and @enddate and 
	mi.title = 'Recall Reason'
--	and n.user0 = 'EXCH' and n.action = 'RCL'
--	and m.status = 'RCL' and m.qlevel = '998'


	--update master
	update m set returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103),qlevel = '999'
	from @tmp_count t
	join master m with(nolock) on t.number = m.number
	WHERE m.returned is null and m.qlevel = '998' and m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


end






GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/17/2022
-- Description: Export record 30 only
-- =============================================
CREATE PROCEDURE [dbo].[Custom_WRC_Record_30]
	-- Add the parameters for the stored procedure here
@invoice varchar(8000)

	-- exec Custom_YGC_WRC_Record_30 23385

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
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

END




GO

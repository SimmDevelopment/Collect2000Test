SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/23/2022
-- Description: Export record 38 only
-- =============================================
CREATE PROCEDURE [dbo].[Custom_WRC_Record_38]
	-- Add the parameters for the stored procedure here

	-- exec Custom_YGC_WRC_Record_38 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
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

END



GO

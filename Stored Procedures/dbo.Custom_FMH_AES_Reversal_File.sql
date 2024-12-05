SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_FMH_AES_Reversal_File]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Payment Header
select distinct substring(replace(replace(replace(replace(convert(varchar(50), GETDATE(), 126), '-', ''), 'T', ''), ':', ''), '.', ''), 1, 16) as serialnumber,
	'2' as batchtypecode,
	'10' as financialacttype,
	'10' as financialactsubtype,
	replace(convert(varchar(10), datepaid, 110), '-', '') as effectivedate,
	replace(convert(varchar(10), datepaid, 110), '-', '') as releasedate,
	'SIMM  ' as transmissionsource,
	'Y' as batchdepositind,
	case when batchtype like '%r' then '1' else ' ' end as reversalreason,
	'PA' as regionind

	
from payhistory with (Nolock)
where customer in (select customerid from fact with (nolock) where customgroupid = 134) and invoiced = dbo.date(getdate()) and batchtype = 'pur'



--payment detail records
select 
	row_number() over (order by datepaid) as sequencenumber,
	m.ssn as borrowerssn,
	'10' as financialacttype,
	'10' as financialactsubtype,
	replace(convert(varchar(10), (SELECT datepaid FROM payhistory WITH (NOLOCK) WHERE p.ReverseOfUID = uid), 110), '-', '') as effectivedate,  --must be original date paid.
	replace((p.paid1 + p.paid2), '.', '') as paymentamount,
	replace(convert(varchar(10), datepaid, 110), '-', '') as remitbatchdaterev,
	case when batchtype like '%R' then '01' else '' end as revreasonrejectcode,
	m.ssn as borroweraccountnum,
	'' as targetedamount, --?? what is this?
		(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE number = p.number AND title = 'servicerseq') AS loansequence,
	--(SELECT 	CASE WHEN checknbr IS NULL THEN '0001' WHEN checknbr = '' THEN '0001' ELSE p.checknbr END FROM payhistory WITH (NOLOCK) WHERE p.ReverseOfUID = uid) as loansequence,
	'PA' as regionind
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
where p.customer in (select customerid from fact with (nolock) where customgroupid = 134) and invoiced = dbo.date(getdate()) and batchtype = 'pur'


--payment trailer record 
select 'TRAILER' as recordtype,
	'0001' as batchnumber,
	substring(replace(replace(replace(replace(convert(varchar(50), GETDATE(), 126), '-', ''), 'T', ''), ':', ''), '.', ''), 1, 16) as serialnumber,
	count(*) as recordcount,
	replace(sum((p.paid1 + p.paid2)), '.', '') as totalpayments,
	'' as filler,
	'PA' as regionind
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
where p.customer in (select customerid from fact with (nolock) where customgroupid = 134) and invoiced = dbo.date(getdate()) and batchtype = 'pur'

END
GO

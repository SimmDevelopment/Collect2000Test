SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_GS2_Fortress_AES_Reversal_File]
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
	'SIMFRR' as transmissionsource,
	'Y' as batchdepositind,
	case when batchtype like '%r' then '1' else ' ' end as reversalreason,
	'PA' as regionind

	
from payhistory with (Nolock)
where customer in ('0001298', '0001360', '0001434', '0001435', '0001443', '0001524', '0001529', '0001674', '0001694','0001754','0001763','0001775','0001810','0001811','0001812','0001813','0001814','0001815','0001816','0001821','0002367') and invoiced = dbo.date(getdate()) and batchtype = 'pur'



--payment detail records
select 
	row_number() over (order by datepaid) as sequencenumber,
	m.ssn as borrowerssn,
	'10' as financialacttype,
	'10' as financialactsubtype,
	replace(convert(varchar(10), (SELECT datepaid FROM payhistory WITH (NOLOCK) WHERE p.ReverseOfUID = uid), 110), '-', '') as effectivedate,  --must be original date paid.
	replace((p.paid1 + p.paid2 + p.OverPaidAmt), '.', '') as paymentamount,
	replace(convert(varchar(10), datepaid, 110), '-', '') as remitbatchdaterev,
	case when batchtype like '%R' then '01' else '' end as revreasonrejectcode,
	m.ssn as borroweraccountnum,
	'' as targetedamount, --?? what is this?
	ISNULL((SELECT TOP 1 SUBSTRING(thedata, 1, 4) FROM miscextra WITH (NOLOCK) WHERE number = p.number AND title = 'rec.0.servicerseq'), (SELECT TOP 1 SUBSTRING(thedata, 1, 4) FROM miscextra WITH (NOLOCK) WHERE number = p.number AND title = 'pri.0.ServicerSubAccountNumber')) AS loansequence,
	--(SELECT 	CASE WHEN checknbr IS NULL THEN '0001' WHEN checknbr = '' THEN '0001' ELSE p.checknbr END FROM payhistory WITH (NOLOCK) WHERE p.ReverseOfUID = uid) as loansequence,
	'PA' as regionind
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
where p.customer in ('0001298', '0001360', '0001434', '0001435', '0001443', '0001524', '0001529', '0001674', '0001694','0001754','0001763','0001775','0001810','0001811','0001812','0001813','0001814','0001815','0001816','0001821','0002367') and invoiced = dbo.date(getdate()) and batchtype = 'pur'


--payment trailer record 
select 'TRAILER' as recordtype,
	'0001' as batchnumber,
	substring(replace(replace(replace(replace(convert(varchar(50), GETDATE(), 126), '-', ''), 'T', ''), ':', ''), '.', ''), 1, 16) as serialnumber,
	count(*) as recordcount,
	replace(sum((p.paid1 + p.paid2 + p.OverPaidAmt)), '.', '') as totalpayments,
	'' as filler,
	'PA' as regionind
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
where p.customer in ('0001298', '0001360', '0001434', '0001435', '0001443', '0001524', '0001529', '0001674', '0001694','0001754','0001763','0001775','0001810','0001811','0001812','0001813','0001814','0001815','0001816','0001821','0002367') and invoiced = dbo.date(getdate()) and batchtype = 'pur'

END
GO

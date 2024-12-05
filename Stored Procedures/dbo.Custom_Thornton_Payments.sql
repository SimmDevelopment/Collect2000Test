SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Thornton_Payments] 

@invoice varchar(8000)

AS

select id2 as thorAccount, id1 as Portfolio, name as DebtorName, account as Account, dbo.date(p.datepaid) as PayDate,
	case when batchtype = 'pur' then -p.paid1 else p.paid1 end  as AmtPaid, 
	case when batchtype = 'pur' then -p.fee1 else p.fee1 end as FeeAmt, 
	case when batchtype = 'pur' then -p.paid1 + p.fee1 else p.paid1 - p.fee1 end as dueclient, 
	case batchtype when 'pu' then 'PAYMENT' when 'pur' THEN 'NSF' end as paytype 
from (select string as invoices from dbo.CustomStringToSet(@invoice, '|')) i
			inner join payhistory p with (nolock) on p.invoice = i.invoices
			inner JOIN  master m with (nolock) ON m.Number=p.Number
where m.customer = '0000974' and batchtype in ('pu', 'pur') and p.invoice = i.invoices
GO

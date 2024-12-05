SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_TLJ_Payments]

@startDate datetime,
@endDate datetime

AS

select account, current1, name, case when batchtype = 'pu' then p.paid1 when p.batchtype = 'pur' then -p.paid1 end as payment, 
	case p.batchtype when 'pu' then 'payment' when 'pur' then 'payment reversal' end as paymenttype, p.datepaid
from master m with (nolock) join payhistory p with (nolock) on m.number = p.number
where m.customer = '0000979' and p.batchtype in ('pur', 'pu') and p.datepaid between @startDate AND @endDate
GO

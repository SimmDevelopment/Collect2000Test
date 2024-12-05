SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Thornton_DailyPayments]

@Date datetime

AS

select m.id2 as acctid, p.paid1 as payment, convert(varchar, dbo.date(p.datepaid), 101) as datepaid, 'trancode' = case when p.batchtype = 'pu' then '10' when p.batchtype = 'pur' then '20' when p.batchtype = 'dar' then '30' when p.batchtype = 'da' then '31' end
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
where p.customer = '0000974' and dbo.date(p.datepaid) = @Date
GO

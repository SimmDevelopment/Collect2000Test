SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Bureaus_SIF_LOG]

@date datetime

AS

select id2 as [TBI Account ID], name as [Name], received as [Date Placed], closed as [Date of Settlement], original as [Original Placement], (select sum(case when batchtype in ('pcr', 'pur') then -(paid1 + paid2) else (paid1 + paid2) end) from payhistory with (nolock) where m.number = number and batchtype in ('pc', 'pu', 'pcr', 'pur') and systemmonth = month(@date)) as [Paid Last Month], abs(m.paid1 + m.paid2) as [Total Paid], (abs(m.paid1+m.paid2)/original) * 100 as [SIF%], status as [Status]
from master m with (Nolock) inner join payhistory p with (nolock) on m.number = p.number
where m.customer = '0000993' and status in ('pif', 'sif') and month(closed) = month(@date)
group by id2, name, received, m.closed, original, status, m.number, m.current0, m.paid1, m.paid2
GO

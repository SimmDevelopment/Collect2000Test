SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Thornton_Putback]

@startDate datetime,
@endDate datetime

 AS

select id2 as thornacct, convert(varchar, getdate(), 101) as filedate, case STATUS WHEN 'BKY' THEN 'BANK' WHEN 'CAD' THEN 'CEASE' WHEN 'DEC' THEN 'DEATH' WHEN 'FRD' THEN 'FRAUD' WHEN 'PIF' THEN 'PAID' WHEN 'SIF' THEN 'SETTLED' end AS reason
from master with (nolock)
where customer = '0000974' and status in ('bky', 'cad', 'dec', 'frd', 'pif', 'sif') and dbo.date(closed) between @startDate and @endDate
order by id2
GO

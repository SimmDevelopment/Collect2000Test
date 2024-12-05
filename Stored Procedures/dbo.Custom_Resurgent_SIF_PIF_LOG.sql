SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Resurgent_SIF_PIF_LOG]

@startDate datetime,
@endDate datetime


AS
select '1647' as [ServicerID], m.id1 as [Resurgent Account ID], status as [Status (SIF or PIF?)]
--select m.id1 as [Resurgent Account ID], m.id2 as [Batch ID], d.lastname as [Last Name], d.firstname as [First Name], m.received as [Date Placed], 
	--m.lastpaid as [Last Pay Date], original1 as [Initial Principal Balance], original2 as [Initial Interest Balance], original1 + original2 as [Combined Balance], abs(paid1 + paid2) as [Total $ Paid], convert(varchar, abs((paid1 + paid2) / (original1 + original2) * 100))+'%' as [SIF %], status as [Disposition Code]
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number
where m.customer = '0000996' and d.seq = 0 and status in ('sif', 'pif') and datepart(mm, closed) =  datepart(mm, @startDate) and datepart(yyyy, closed) = datepart(yyyy, @endDate)
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_IDT_Report_Settlement]

@date datetime

 AS

select account as Account, ssn as [Social Security], (select thedata from miscextra with (nolock) where m.number = number and title = 'Portfolio') as Portfolio, received as [Place Date], (original+abs(accrued2)) as [Principal Balance], (current1+current2) as [Current Balance], abs(paid1 + paid2) as [Settlement Amount], (abs(paid1+paid2))/(original+abs(accrued2)) as [Settlement Percentage], closed as [Settlement Date]
from master m with (nolock)
where status = 'sif' and customer in (select customerid from fact with (nolock) where customgroupid = 96) and month(closed) = month(@date) and year(closed) = year(@date)
GO

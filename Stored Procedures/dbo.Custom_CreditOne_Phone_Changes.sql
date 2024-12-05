SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CreditOne_Phone_Changes]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select distinct dbo.date(getdate()) as FileDate, right(m.account, 6) as Acct, d.firstname as First, d.lastname as Last, d.homephone as newphone, case pc.phonetype when 1 then 'R' when 2 then 'B' when 3 then 'C' end as phonetype
from debtors d with (nolock) inner join 
		(select distinct ph.debtorid, ph.newnumber, ph.phonetype
		from phonehistory ph with (nolock) inner join debtors d with (nolock) on ph.debtorid = d.debtorid inner join master m with (Nolock) on d.number = m.number
		where m.customer = '0001038' and ph.datechanged >= dateadd(dd, -1, getdate()) and ph.datechanged <= getdate()) pc on pc.debtorid = d.debtorid inner join master m with (Nolock) on d.number = m.number
where pc.phonetype = 1

union

select distinct dbo.date(getdate()) as FileDate, right(m.account, 6) as Acct, d.firstname as First, d.lastname as Last, d.Workphone as newphone, case pc.phonetype when 1 then 'R' when 2 then 'B' when 3 then 'C' end as phonetype
from debtors d with (nolock) inner join 
		(select distinct ph.debtorid, ph.newnumber, ph.phonetype
		from phonehistory ph with (nolock) inner join debtors d with (nolock) on ph.debtorid = d.debtorid inner join master m with (Nolock) on d.number = m.number
		where m.customer = '0001038' and ph.datechanged >= dateadd(dd, -1, getdate()) and ph.datechanged <= getdate()) pc on pc.debtorid = d.debtorid inner join master m with (Nolock) on d.number = m.number
where pc.phonetype = 2

union

select distinct dbo.date(getdate()) as FileDate, right(m.account, 6) as Acct, d.firstname as First, d.lastname as Last, d.otherphone1 as newphone, case pc.phonetype when 1 then 'R' when 2 then 'B' when 3 then 'C' end as phonetype
from debtors d with (nolock) inner join 
		(select distinct ph.debtorid, ph.newnumber, ph.phonetype
		from phonehistory ph with (nolock) inner join debtors d with (nolock) on ph.debtorid = d.debtorid inner join master m with (Nolock) on d.number = m.number
		where m.customer = '0001038' and ph.datechanged >= dateadd(dd, -1, getdate()) and ph.datechanged <= getdate()) pc on pc.debtorid = d.debtorid inner join master m with (Nolock) on d.number = m.number
where pc.phonetype = 3




END
GO

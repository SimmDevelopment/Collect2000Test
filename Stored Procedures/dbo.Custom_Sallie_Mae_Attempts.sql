SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Attempts]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select dbo.date(getdate()) as Date, count(*) as numrecs
	from notes n with (nolock) inner join master m with (nolock) on n.number = m.number inner join debtors d with (nolock) on n.number = d.number and d.seq = 0
	where n.user0 not in ('+++++') and n.action in ('tr', 'te', 'to', 'dt', 't') and customer = '0001004'
	and dbo.date(n.created) = dbo.date(getdate())


    -- Insert statements for procedure here
	select d.firstname, d.lastname, case when n.action = 'tr' then m.homephone 
		when n.action = 'te' then m.workphone 
		when n.action = 'to' then m.homephone 
		end as deviceattempted, convert(varchar(8), n.created, 1) as deliverydate, 
	convert(varchar(2), datepart(hh, n.created)) + ':' + convert(varchar(2), datepart(mi, n.created)) + ':' + convert(varchar(2), datepart(ss, n.created)) + ' ' + case when datepart(hh, n.created) > 12 then 'PM' Else 'AM' end as timeattempted, 
	n.result as status, m.id2 as facs
from notes n with (nolock) inner join master m with (nolock) on n.number = m.number inner join debtors d with (nolock) on n.number = d.number and d.seq = 0
where n.user0 not in ('+++++') and n.action in ('tr', 'te', 'to', 'dt', 't') and customer = '0001004'
	and dbo.date(n.created) = dbo.date(getdate())

END
GO

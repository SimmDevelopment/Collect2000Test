SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_FMC_Export_OCA_Calls]
	-- Add the parameters for the stored procedure here
	@startDate datetime,
	@endDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select convert(varchar(8), getdate(), 112) as asofdate, n.number as ocaid, m.ssn, 'P' as commtype, 
		case when n.action like 't%' or n.action = 'mnual' or n.action = 'dial' then 'O' else 'I' end as ioindicator,
		convert(varchar(8), n.created, 112) as actdate, replace(convert(varchar(8), n.created, 108), ':', '') as acttime, user0 as collid,
		case when action in ('to', '3p') then 'O' when action ='dt' then 'B' when n.comment like '%(2)%' then 'C' else 'B' end as personcalled,
		case when action = 'TR' AND result <> 'WN' AND  n.comment like '%(1)%' then d1.homephone
				when action = 'TE' AND result <> 'WN' and n.comment like '%(1)%' then d1.workphone
				when action = 'TR' AND result <> 'WN' and n.comment like '%(2)%' then d2.homephone
				when action = 'TE' AND result <> 'WN' and n.comment like '%(2)%' then d2.workphone
				when action = 'mnual' then right(convert(varchar(60), n.comment), 10)
else d1.homephone end as numbercalled, n.action,
n.result, r.description, case r.contacted when 1 then 'Y' else 'N' end as rpc
from notes n with (Nolock) inner join master m with (nolock) on n.number = m.number left outer join debtors d1 with (nolock) on m.number = d1.number and d1.seq = 0 
		left outer join debtors d2 with (Nolock) on m.number = d2.number and d2.seq = 1 inner join result r with (Nolock) on n.result = r.code
where m.customer in (select customerid from fact with (Nolock) where customgroupid = 134) and dbo.date(created) between @startDate and @endDate and (action like 't%' or action in ('dt', 'mnual', '3P'))

END
GO

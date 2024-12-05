SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Object:  View dbo.AIM_DebtorView    */

CREATE      VIEW [dbo].[AIM_DebtorView] AS
SELECT 
	dt.*
	,m.account
from
	[dbo].[master] m
	join [dbo].[desk] d on m.desk = d.code
	left outer join [dbo].[debtors] dt on dt.number = m.number
	left outer join AIM_AccountReference ar on m.number = ar.referencenumber	
where
	d.desktype = 'AIM'

--select * from [collect2000].[dbo].[AIM_debtors]


GO

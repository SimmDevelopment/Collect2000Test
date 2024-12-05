SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Object:  View dbo.AIM_PaymentView    */

CREATE      VIEW [dbo].[AIM_PaymentView] AS
SELECT 
	p.*
	,m.account
from
	[dbo].[master] m
	join [dbo].[desk] d on m.desk = d.code
	left outer join [dbo].[payhistory] p on p.number = m.number
	left outer join AIM_AccountReference ar on m.number = ar.referencenumber	
where
	d.desktype = 'AIM'

GO

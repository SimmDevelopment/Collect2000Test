SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Object:  View dbo.AIM_MiscView    */


CREATE     VIEW [dbo].[AIM_MiscView] AS
SELECT 
	misc.*
	,m.account
from
	[dbo].[master] m
	join [dbo].[desk] d on m.desk = d.code
	left outer join [dbo].[miscextra] misc on misc.number = m.number
	left outer join AIM_AccountReference ar on m.number = ar.referencenumber	
where
	d.desktype = 'AIM'

GO

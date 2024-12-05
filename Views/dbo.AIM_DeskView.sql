SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Object:  View dbo.AIM_DeskView    */

CREATE        VIEW [dbo].[AIM_DeskView] AS
SELECT 
	code,
	code +' - '+ name as name
from
	[dbo].[desk] d

where
	d.desktype <> 'AIM'


GO

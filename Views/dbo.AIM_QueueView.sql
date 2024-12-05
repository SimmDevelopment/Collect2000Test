SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Object:  View dbo.AIM_QueueView    */

CREATE       VIEW [dbo].[AIM_QueueView] AS
SELECT 
	code,
	code +' - '+ qname as qname
from
	[dbo].[qlevel] d


GO

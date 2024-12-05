SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  View dbo.vMasterStatusDesc    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE VIEW [dbo].[vMasterStatusDesc]
AS
SELECT     dbo.master.*, lower(dbo.status.Description) AS statusdesc
FROM         dbo.master INNER JOIN
                      dbo.status ON dbo.master.status = dbo.status.code


GO

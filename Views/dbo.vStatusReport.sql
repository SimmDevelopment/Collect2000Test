SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  View dbo.vStatusReport    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE VIEW [dbo].[vStatusReport]
AS
SELECT     lower(dbo.master.Name) AS Name, dbo.master.Account, CONVERT(varchar, dbo.master.received, 107) AS [Date Placed],
                      CONVERT(varchar, dbo.master.lastpaid, 107) AS [Date Last Paid],
                      CASE WHEN qlevel in ('015','998') THEN 'active account' ELSE lower(dbo.status.Description) END AS Status, 

CONVERT(varchar(19), 
                      dbo.master.original, 1) AS [Balance Placed], CONVERT(varchar(19), dbo.master.current0, 1) AS [Current Balance], Customer
FROM         dbo.master INNER JOIN
                      dbo.status ON dbo.master.status = dbo.status.code
WHERE   dbo.master.qlevel <> '999'

GO

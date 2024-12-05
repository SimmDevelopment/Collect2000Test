SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[InventoryReport]
AS
SELECT NULL AS sortdata, m.number, m.Name, m.other, m.account, m.received, m.lastpaid, m.status, m.original, m.current0, m.customer, m.desk, 
               d.name AS deskname, c.Name AS customername, NULL AS company, m.qlevel
FROM  master AS m WITH (NOLOCK) INNER JOIN
               Customer AS c WITH (NOLOCK) ON m.customer = c.customer INNER JOIN
               desk AS d ON d.code = m.desk
GO

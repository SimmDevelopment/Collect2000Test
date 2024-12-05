SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  View dbo.vDebtorSearch    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE VIEW [dbo].[vDebtorSearch]
AS
SELECT     dbo.master.number, lower(Name) AS Name, Status, lower(dbo.status.Description) AS StatusDescription, CONVERT(varchar(19), dbo.master.original, 1) 
                      AS original, CONVERT(varchar(19), dbo.master.current0, 1) AS current0, CONVERT(varchar, received, 107) AS received, dbo.master.account, 
                      dbo.master.customer, dbo.master.SSN, CASE substring(dbo.status.statustype, 1, 1) WHEN 0 THEN 0 ELSE 1 END AS accountclosed
FROM         dbo.master INNER JOIN
                      dbo.status ON dbo.master.status = dbo.status.code

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionDebtorView    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionDebtorView]
AS
SELECT     d.DebtorID, m.number, m.account, d.Name, m.desk AS [Desk Code], desk.name AS [Desk Description], m.received, m.status AS [Status Code], 
                      s.Description AS [Status Description], d.Seq AS [Debtor Seq], d.HomePhone, d.WorkPhone, d.Street1, d.Street2, d.City, d.State, m.MR, m.closed, 
                      m.returned, m.lastpaid, m.lastpaidamt, m.lastinterest, m.SSN, d.Zipcode, d.DOB, d.MR AS Expr1
FROM         dbo.Debtors AS d WITH (nolock) INNER JOIN
                      dbo.master AS m ON m.number = d.Number LEFT OUTER JOIN
                      dbo.desk AS desk ON desk.code = m.desk LEFT OUTER JOIN
                      dbo.status AS s ON s.code = m.status

GO

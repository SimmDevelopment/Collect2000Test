SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*VIEW OISummaries*/
CREATE VIEW [dbo].[OISummaries]
AS
SELECT     dbo.OpenItem.Invoice, dbo.OpenItem.Tdate, dbo.OpenItem.SyMonth, dbo.OpenItem.Syyear, dbo.OpenItem.customer, 
                      dbo.OpenItem.Amount AS OriginalBal, dbo.OIDebitAmts.DebitTotal, dbo.OICreditAmts.CreditTotal, dbo.OpenItem.Retired
FROM         dbo.OpenItem FULL OUTER JOIN
                      dbo.OIDebitAmts ON dbo.OpenItem.Invoice = dbo.OIDebitAmts.Invoice FULL OUTER JOIN
                      dbo.OICreditAmts ON dbo.OpenItem.Invoice = dbo.OICreditAmts.Invoice
WHERE     (dbo.OpenItem.Retired = 0) OR
                      (dbo.OpenItem.Retired IS NULL)
GO

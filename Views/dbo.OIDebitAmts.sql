SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[OIDebitAmts]
AS
SELECT     Invoice, SUM(Amount) AS DebitTotal
FROM         dbo.OpenItemTransactions
WHERE     (TransType IN (20, 21))
GROUP BY Invoice
GO

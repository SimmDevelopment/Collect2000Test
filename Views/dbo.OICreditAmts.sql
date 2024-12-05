SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[OICreditAmts]
AS
SELECT     Invoice, SUM(Amount) AS CreditTotal
FROM         dbo.OpenItemTransactions
WHERE     (TransType IN (10, 11))
GROUP BY Invoice
GO

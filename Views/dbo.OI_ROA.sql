SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[OI_ROA]
AS
SELECT     Invoice, SUM(Amount) AS AmtRcvd
FROM         dbo.OpenItemTransactions
WHERE     (TransType = 10)
GROUP BY Invoice
GO

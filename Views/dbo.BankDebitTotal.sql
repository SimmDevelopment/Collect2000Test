SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[BankDebitTotal]
AS
SELECT     BankCode, SUM(Amount) AS DebitAmts
FROM         dbo.BankEntries
WHERE     (GLEntryType = 0)
GROUP BY BankCode
GO

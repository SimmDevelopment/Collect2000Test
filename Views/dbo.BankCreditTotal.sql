SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[BankCreditTotal]  AS
SELECT     BankCode, SUM(Amount) AS CreditAmts
FROM         dbo.BankEntries
WHERE     (GLEntryType = 1)
GROUP BY BankCode

GO

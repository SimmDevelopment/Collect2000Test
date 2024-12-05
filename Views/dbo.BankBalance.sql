SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[BankBalance]
AS
SELECT     TOP 100 PERCENT dbo.bank.code, dbo.bank.Name, SUM(CONVERT(money, dbo.BankDebitTotal.DebitAmts)) AS Debit, SUM(CONVERT(money, 
                      dbo.BankCreditTotal.CreditAmts)) AS Credit
FROM         dbo.BankCreditTotal FULL OUTER JOIN
                      dbo.bank ON dbo.BankCreditTotal.BankCode = dbo.bank.code FULL OUTER JOIN
                      dbo.BankDebitTotal ON dbo.bank.code = dbo.BankDebitTotal.BankCode
GROUP BY dbo.bank.code, dbo.bank.Name
ORDER BY dbo.bank.code
GO

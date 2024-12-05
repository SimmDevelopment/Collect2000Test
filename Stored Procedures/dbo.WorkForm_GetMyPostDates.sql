SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkForm_GetMyPostDates] @Desk VARCHAR(10), @DueDate DATETIME, @IncludePPA BIT = 1, @IncludePDC BIT = 1, @IncludePCC BIT = 1
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT
	'PPA' AS [type],
	[Promises].[AcctID] AS [number],
	[Debtors].[Name] AS [name],
	CASE [Promises].[Suspended]
		WHEN 1 THEN [Promises].[DateUpdated]
		ELSE NULL
	END AS [hold],
	[master].[customer] AS [customer],
	[Promises].[DueDate] AS [duedate],
	CAST('Promise' AS VARCHAR(50)) AS [checknumber],
	[Promises].[Amount] AS [amount]
FROM [dbo].[Promises]
INNER JOIN [dbo].[master]
ON [Promises].[AcctID] = [master].[number]
INNER JOIN [dbo].[Debtors]
ON [Promises].[AcctID] = [Debtors].[number]
AND [Promises].[DebtorID] = [Debtors].[Seq]
WHERE [Promises].[Desk] = @Desk
AND [Promises].[DueDate] <= @DueDate
AND [Promises].[Active] = 1
AND @IncludePPA = 1
UNION ALL
SELECT
	'PDC' AS [type],
	[pdc].[number] AS [number],
	[Debtors].[name] AS [name],
	[pdc].[onhold] AS [hold],
	[master].[customer] AS [customer],
	[pdc].[deposit] AS [duedate],
	'Check #' + [pdc].[checknbr] AS [comment],
	[pdc].[amount] AS [amount]
FROM [dbo].[pdc]
INNER JOIN [dbo].[master]
ON [pdc].[number] = [master].[number]
INNER JOIN [dbo].[Debtors]
ON [pdc].[number] = [Debtors].[number]
AND ISNULL([pdc].[SEQ], 0) = [Debtors].[Seq]
WHERE [master].[desk] = @Desk
AND [pdc].[deposit] <= @DueDate
AND [pdc].[Active] = 1
AND @IncludePDC = 1
UNION ALL
SELECT
	'PCC' AS [creditcard],
	[DebtorCreditCards].[Number] AS [number],
	[Debtors].[name] AS [name],
	[DebtorCreditCards].[OnHoldDate] AS [hold],
	[master].[customer] AS [customer],
	[DebtorCreditCards].[DepositDate] AS [duedate],
	ISNULL([CreditCardTypes].[Description], 'Unknown Credit Card') AS [comment],
	[DebtorCreditCards].[Amount] AS [amount]
FROM [dbo].[DebtorCreditCards]
INNER JOIN [dbo].[master]
ON [DebtorCreditCards].[Number] = [master].[number]
INNER JOIN [dbo].[Debtors]
ON [DebtorCreditCards].[Number] = [Debtors].[Number]
AND [DebtorCreditCards].[DebtorID] = [Debtors].[DebtorID]
INNER JOIN dbo.PaymentVendorToken with (nolock)
ON [DebtorCreditCards].PaymentVendorTokenId = [PaymentVendorToken].Id
LEFT OUTER JOIN [dbo].[CreditCardTypes] WITH (NOLOCK)
ON PaymentVendorToken.PayMethodSubTypeCode = [CreditCardTypes].[Code]
WHERE [master].[desk] = @Desk
AND [DebtorCreditCards].[DepositDate] <= @DueDate
AND [DebtorCreditCards].[IsActive] = 1
AND @IncludePCC = 1
ORDER BY [duedate] ASC;

RETURN 0;
GO

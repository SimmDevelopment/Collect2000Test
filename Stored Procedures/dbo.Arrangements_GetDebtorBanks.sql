SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetDebtorBanks] @DebtorID INTEGER
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @AccountID INTEGER;
DECLARE @Seq INTEGER;
DECLARE @LinkID INTEGER;

DECLARE @Accounts TABLE (
	[AccountID] INTEGER NOT NULL,
	[Seq] INTEGER NOT NULL,
	PRIMARY KEY CLUSTERED ([AccountID], [Seq])
);

SELECT @LinkID = COALESCE([master].[link], 0),
	@AccountID = [Debtors].[number],
	@Seq = [Debtors].[Seq]
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
WHERE [Debtors].[DebtorID] = @DebtorID;

IF @LinkID > 0 AND @Seq = 0 BEGIN
	INSERT INTO @Accounts ([AccountID], [Seq])
	SELECT [Debtors].[number], [Debtors].[Seq]
	FROM [dbo].[master]
	INNER JOIN [dbo].[Debtors]
	ON [master].[number] = [Debtors].[number]
	WHERE [master].[link] = @LinkID;
END;
ELSE IF @Seq = 0 BEGIN
	INSERT INTO @Accounts ([AccountID], [Seq])
	SELECT [Debtors].[number], [Debtors].[Seq]
	FROM [dbo].[master]
	INNER JOIN [dbo].[Debtors]
	ON [master].[number] = [Debtors].[number]
	WHERE [master].[number] = @AccountID;
END;
ELSE BEGIN
	INSERT INTO @Accounts ([AccountID], [Seq])
	VALUES (@AccountID, @Seq);
END;

SELECT DISTINCT [DebtorBankInfo].[ABANumber],
	[DebtorBankInfo].[AccountNumber],
	[DebtorBankInfo].[AccountName],
	[DebtorBankInfo].[AccountAddress1],
	[DebtorBankInfo].[AccountAddress2],
	[DebtorBankInfo].[AccountCity],
	[DebtorBankInfo].[AccountState],
	[DebtorBankInfo].[AccountZipCode],
	[DebtorBankInfo].[AccountVerified],
	[DebtorBankInfo].[LastCheckNumber],
	[DebtorBankInfo].[BankName],
	[DebtorBankInfo].[BankAddress],
	[DebtorBankInfo].[BankCity],
	[DebtorBankInfo].[BankState],
	[DebtorBankInfo].[BankZipcode],
	[DebtorBankInfo].[BankPhone],
	[DebtorBankInfo].[AccountType],
	[DebtorBankInfo].[BankID],
	[DebtorBankInfo].[PaymentVendorTokenId],
	[TOKEN].[TokenOrigin],
	[TOKEN].[PayMethodId],
	[TOKEN].[PayMethodCode],
	[TOKEN].[PayMethodSubTypeCode]
FROM 
([dbo].[DebtorBankInfo] LEFT JOIN [dbo].[PaymentVendorToken] [TOKEN] ON [DebtorBankInfo].[PaymentVendorTokenId] = [TOKEN].[Id])
INNER JOIN (
	SELECT TOP 100 PERCENT [DebtorBankInfo].[BankID]
	FROM [dbo].[DebtorBankInfo]
	INNER JOIN @Accounts AS [Accounts]
	ON [DebtorBankInfo].[AcctID] = [Accounts].[AccountID]
	AND [DebtorBankInfo].[DebtorID] = [Accounts].[Seq]
	LEFT OUTER JOIN [dbo].[pdc]
	ON [DebtorBankInfo].[AcctID] = [pdc].[number]
	ORDER BY [pdc].[entered] DESC,
		[DebtorBankInfo].[AcctID] DESC
) AS [Banks]
ON [DebtorBankInfo].[BankID] = [Banks].[BankID];

RETURN 0;
GO

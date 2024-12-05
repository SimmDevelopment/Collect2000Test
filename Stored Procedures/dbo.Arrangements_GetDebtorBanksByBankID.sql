SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetDebtorBanksByBankID] @BankID INTEGER
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT [DebtorBankInfo].[ABANumber],
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
FROM [dbo].[DebtorBankInfo] LEFT JOIN [dbo].[PaymentVendorToken] [TOKEN] ON [DebtorBankInfo].[PaymentVendorTokenId] = [TOKEN].[Id]
WHERE [DebtorBankInfo].[BankID] = @BankID;

RETURN 0;
GO

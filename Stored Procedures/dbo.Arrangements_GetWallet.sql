SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetWallet] @AccountId INTEGER, @LinkId INTEGER
AS

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


DECLARE @DebtorWallet TABLE (
	[DebtorId] INTEGER NOT NULL PRIMARY KEY CLUSTERED
);

IF @LinkID IS NOT NULL AND @LinkId <> 0 
BEGIN
	INSERT INTO @DebtorWallet ([DebtorId])
	SELECT [DebtorId] from [dbo].[Debtors]
	WHERE [Debtors].[number] IN
	(SELECT [number] FROM [dbo].[master]
		WHERE [master].[link] = @LinkId)
END;

ELSE 
BEGIN
	INSERT INTO @DebtorWallet ([DebtorId])
	SELECT [DebtorId] FROM [dbo].[Debtors]
	WHERE [Debtors].[number] = @AccountId
END

SELECT 
--wallet--
    w.[Id]
      ,[ModeStatus]
	  ,[LastOperation]
      ,[Type]
      ,[PaymentVendorTokenId]
      ,[DebtorId]
      ,[SearchKey]
      ,[AccountNumber]
      ,[InstitutionCode]
      ,[AccountType]
      ,[PayorName]
      ,[CCExpiration]
      ,[DisplayName]
      ,[DisplayOrder]
	  ,[CreatedWhen]
	  ,[CreatedBy]
-- wallet contact--
    ,[AccountAddress1]
      ,[AccountAddress2]
      ,[AccountCity]
      ,[AccountState]
      ,[AccountZipcode]
      ,[BankAddress]
      ,[BankCity]
      ,[BankState]
      ,[BankZipcode]
      ,[BankName]
      ,[BankPhone]
  FROM [dbo].[Wallet] AS [W] INNER JOIN [dbo].[WalletContact] AS [WC] 
  ON [W].[ID] = [WC].[WalletId] WHERE w.DebtorId in (SELECT [DebtorId] FROM @DebtorWallet)
  

RETURN 0;
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_SearchWallet]
  --Wallet columns--
  @SearchKey varchar(14)

AS

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

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
  ON [W].[ID] = [WC].[WalletId] WHERE W.ModeStatus = 'Searchable' AND W.SearchKey = @SearchKey;

RETURN 0;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_UpdateDebtorBankAddress]
	@BankID INTEGER,
	@AccountID INTEGER,
	@Seq INTEGER,
	@AccountName VARCHAR(50),
	@AccountAddress1 VARCHAR(50),
	@AccountAddress2 VARCHAR(50),
	@AccountCity VARCHAR(50),
	@AccountState VARCHAR(10),
	@AccountZipCode VARCHAR(50)
AS
SET NOCOUNT ON;

	UPDATE [dbo].[DebtorBankInfo]
	SET
		[AccountName] = @AccountName,
		[AccountAddress1] = @AccountAddress1,
		[AccountAddress2] = @AccountAddress2,
		[AccountCity] = @AccountCity,
		[AccountState] = @AccountState,
		[AccountZipcode] = @AccountZipcode
	WHERE ([AcctID] = @AccountID
	AND [DebtorID] = @Seq) OR  [BankID] = @BankID;

RETURN 0;SET ANSI_NULLS ON
GO

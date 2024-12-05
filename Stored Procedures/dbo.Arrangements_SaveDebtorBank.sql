SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_SaveDebtorBank]
	@AccountID INTEGER,
	@Seq INTEGER,
	@ABANumber VARCHAR(10),
	@AccountNumber VARCHAR(20),
	@AccountName VARCHAR(50),
	@AccountAddress1 VARCHAR(50),
	@AccountAddress2 VARCHAR(50),
	@AccountCity VARCHAR(50),
	@AccountState VARCHAR(10),
	@AccountZipCode VARCHAR(50),
	@AccountVerified BIT,
	@LastCheckNumber INTEGER,
	@BankName VARCHAR(50),
	@BankAddress VARCHAR(50),
	@BankCity VARCHAR(50),
	@BankState VARCHAR(10),
	@BankZipcode VARCHAR(10),
	@BankPhone VARCHAR(20),
	@AccountType CHAR(1),
	@BankID INTEGER OUTPUT
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM [dbo].[DebtorBankInfo] WHERE [AcctID] = @AccountID AND [DebtorID] = @Seq) BEGIN
	UPDATE [dbo].[DebtorBankInfo]
	SET @BankID = [BankID],
		[AcctID] = @AccountID,
		[DebtorID] = @Seq,
		[ABANumber] = @ABANumber,
		[AccountNumber] = @AccountNumber,
		[AccountName] = @AccountName,
		[AccountAddress1] = @AccountAddress1,
		[AccountAddress2] = @AccountAddress2,
		[AccountCity] = @AccountCity,
		[AccountState] = @AccountState,
		[AccountZipcode] = @AccountZipcode,
		[AccountVerified] = @AccountVerified,
		[LastCheckNumber] = @LastCheckNumber,
		[BankName] = @BankName,
		[BankAddress] = @BankAddress,
		[BankCity] = @BankCity,
		[BankState] = @BankState,
		[BankZipcode] = @BankZipcode,
		[BankPhone] = @BankPhone,
		[AccountType] = @AccountType
	WHERE [AcctID] = @AccountID
	AND [DebtorID] = @Seq;
END;
ELSE BEGIN
    INSERT INTO [dbo].[DebtorBankInfo] ([AcctID], [DebtorID], [ABANumber], [AccountNumber], [AccountName], [AccountAddress1], [AccountAddress2], [AccountCity], [AccountState], [AccountZipcode], [AccountVerified], [LastCheckNumber], [BankName], [BankAddress], [BankCity], [BankState], [BankZipcode], [BankPhone], [AccountType])
	VALUES (@AccountID, @Seq, @ABANumber, @AccountNumber, @AccountName, @AccountAddress1, @AccountAddress2, @AccountCity, @AccountState, @AccountZipcode, @AccountVerified, @LastCheckNumber, @BankName, @BankAddress, @BankCity, @BankState, @BankZipcode, @BankPhone, @AccountType);

	SET @BankID = SCOPE_IDENTITY();
END;

RETURN 0;

GO

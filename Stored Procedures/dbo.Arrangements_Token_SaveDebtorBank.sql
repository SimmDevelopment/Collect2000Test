SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_Token_SaveDebtorBank]
	@AccountID INTEGER,
	@Seq INTEGER,
	@ABANumber VARCHAR(10),
	@PaymentVendorTokenId INTEGER,
	@MaskedAccountNumber VARCHAR(20),
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

SELECT @BankID = BankID FROM [dbo].[DebtorBankInfo] WHERE [AcctID] = @AccountID AND [DebtorID] = @Seq AND  [PaymentVendorTokenId] = @PaymentVendorTokenId;
IF (@BankID IS NULL) 
BEGIN
    INSERT INTO [dbo].[DebtorBankInfo] 
    ([AcctID], 
	[DebtorID], 
    [ABANumber], 
	[AccountNumber],
    [PaymentVendorTokenId], 
    [AccountName], 
    [AccountAddress1], 
    [AccountAddress2], 
    [AccountCity], 
    [AccountState], 
    [AccountZipcode], 
    [AccountVerified], 
    [LastCheckNumber], 
    [BankName], 
    [BankAddress], 
    [BankCity], 
    [BankState], 
    [BankZipcode], 
    [BankPhone], 
    [AccountType])
	VALUES 
	(@AccountID, 
	@Seq, 
	@ABANumber, 
	@MaskedAccountNumber,
	@PaymentVendorTokenId, 
	@AccountName, 
	@AccountAddress1, 
	@AccountAddress2, 
	@AccountCity, 
	@AccountState, 
	@AccountZipcode, 
	@AccountVerified, 
	@LastCheckNumber, 
	@BankName, 
	@BankAddress, 
	@BankCity, 
	@BankState, 
	@BankZipcode, 
	@BankPhone, 
	@AccountType);

	SET @BankID = SCOPE_IDENTITY();
END;

RETURN 0;
GO

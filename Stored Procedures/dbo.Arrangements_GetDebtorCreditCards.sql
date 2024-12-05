SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetDebtorCreditCards] @DebtorID INTEGER
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

SELECT  [DebtorCreditCards].[ID],
	[DebtorCreditCards].[Name],
	[DebtorCreditCards].[Street1],
	[DebtorCreditCards].[Street2],
	[DebtorCreditCards].[City],
	[DebtorCreditCards].[State],
	[DebtorCreditCards].[ZipCode],
	[DebtorCreditCards].[CardNumber],
	[DebtorCreditCards].[EXPMonth],
	[DebtorCreditCards].[EXPYear],
	[DebtorCreditCards].[CCImageID],
	[DebtorCreditCards].[DateEntered],
	[ImageFiles].[data] AS [CCData],
	[DebtorCreditCards].[CreditCard],
	[DebtorCreditCards].[PaymentVendorTokenId]
FROM [dbo].[DebtorCreditCards]
INNER JOIN @Accounts AS [Accounts]
ON [DebtorCreditCards].[Number] = [Accounts].[AccountID]
LEFT OUTER JOIN [dbo].[ImageFiles]
ON [DebtorCreditCards].[CCImageID] = [ImageFiles].[id];

RETURN 0;
GO

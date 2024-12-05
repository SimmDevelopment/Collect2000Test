SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Linking_AnalyzeAccounts] @AccountID INTEGER, @Target INTEGER = NULL, @ExpandLinks BIT = 1
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF @AccountID IS NULL BEGIN
	RAISERROR('@AccountID cannot be null.', 16, 1);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @AccountID) BEGIN
	RAISERROR('Account #%d does not exist.', 16, 1, @AccountID);
	RETURN 1;
END;

IF @Target IS NOT NULL AND NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @Target) BEGIN
	RAISERROR('Account #%d does not exist.', 16, 1, @Target);
	RETURN 1;
END;

DECLARE @Accounts TABLE (
	[AccountID] INTEGER NOT NULL PRIMARY KEY NONCLUSTERED
);

DECLARE @Links TABLE (
	[LinkID] INTEGER NOT NULL PRIMARY KEY NONCLUSTERED
);

INSERT INTO @Accounts ([AccountID])
VALUES (@AccountID);

IF @ExpandLinks = 1 BEGIN
	INSERT INTO @Accounts ([AccountID])
	SELECT DISTINCT [Linking_Results].[Target]
	FROM [dbo].[Linking_Results]
	WHERE [Linking_Results].[Number] = @AccountID
	UNION
	SELECT DISTINCT [Linking_Results].[Number]
	FROM [dbo].[Linking_Results]
	WHERE [Linking_Results].[Target] = @AccountID
	
	IF @Target IS NOT NULL AND NOT EXISTS (SELECT * FROM @Accounts WHERE [AccountID] = @Target) BEGIN
		INSERT INTO @Accounts ([AccountID])
		VALUES (@Target);
	END;
	
	INSERT INTO @Links ([LinkID])
	SELECT DISTINCT [master].[link]
	FROM [dbo].[master]
	INNER JOIN @Accounts AS [Accounts]
	ON [master].[number] = [Accounts].[AccountID]
	WHERE [master].[link] > 0;
	
	INSERT INTO @Accounts ([AccountID])
	SELECT [master].[number]
	FROM [dbo].[master]
	INNER JOIN @Links AS [Links]
	ON [master].[link] = [Links].[LinkID]
	WHERE NOT EXISTS (SELECT *
		FROM @Accounts AS [Accounts]
		WHERE [Accounts].[AccountID] = [master].[number]);
END;

SELECT [Accounts].[AccountID], ISNULL([master].[link], 0) AS [Link]
FROM @Accounts AS [Accounts]
INNER JOIN [dbo].[master]
ON [Accounts].[AccountID] = [master].[number]
ORDER BY CASE [Accounts].[AccountID]
		WHEN @AccountID THEN 0
		ELSE 1
	END,
	[Accounts].[AccountID];

SELECT [SourceAccounts].[AccountID] AS [SourceAccountID],
	[TargetAccounts].[AccountID] AS [TargetAccountID],
	[SourceMaster].[link] AS [SourceLink],
	[TargetMaster].[link] AS [TargetLink],
	ISNULL((SELECT TOP 1 [Linking_Results].[Score]
		FROM [dbo].[Linking_Results]
		WHERE [Linking_Results].[Number] = [SourceAccounts].[AccountID]
		AND [Linking_Results].[Target] = [TargetAccounts].[AccountID]
		ORDER BY [Linking_Results].[Evaluated] DESC), 0) AS [Score],
	CASE [SourceMaster].[link]
		WHEN 0 THEN CAST(0 AS BIT)
		WHEN [TargetMaster].[link] THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [Linked]
FROM @Accounts AS [SourceAccounts]
INNER JOIN @Accounts AS [TargetAccounts]
ON [SourceAccounts].[AccountID] < [TargetAccounts].[AccountID]
INNER JOIN [dbo].[master] AS [SourceMaster]
ON [SourceAccounts].[AccountID] = [SourceMaster].[number]
INNER JOIN [dbo].[master] AS [TargetMaster]
ON [TargetAccounts].[AccountID] = [TargetMaster].[number]
ORDER BY CASE
		WHEN @Target IS NOT NULL AND ([SourceAccounts].[AccountID] = @AccountID AND [TargetAccounts].[AccountID] = @Target) THEN 0
		ELSE 1
	END,
	[Linked] DESC,
	[Score] DESC;

SELECT [master].[number] AS [AccountID],
	[master].[link] AS [LinkID],
	[master].[customer] AS [CustomerCode],
	[customer].[name] AS [CustomerName],
	[master].[desk] AS [DeskCode],
	[desk].[name] AS [DeskName],
	[master].[status] AS [StatusCode],
	[status].[description] AS [StatusName],
	[master].[qlevel] AS [QueueLevel],
	[master].[account] AS [Account],
	[master].[ID1] AS [ID1],
	[master].[ID2] AS [ID2],
	[master].[received] AS [ReceivedDate],
	[master].[original] AS [OriginalBalance],
	[master].[current0] AS [CurrentBalance],
	[Debtors].[name] AS [Name],
	[Debtors].[SSN] AS [SSN],
	[Debtors].[homephone] AS [Phone],
	[Debtors].[Street1] AS [Street1],
	[Debtors].[Street2] AS [Street2],
	[Debtors].[City] AS [City],
	[Debtors].[State] AS [State],
	[Debtors].[ZipCode] AS [ZipCode],
	[Debtors].[DOB] AS [DOB],
	[Debtors].[DLNum] AS [DLNum]
FROM @Accounts AS [Accounts]
INNER JOIN [dbo].[master]
ON [Accounts].[AccountID] = [master].[number]
INNER JOIN [dbo].[customer]
ON [master].[customer] = [customer].[customer]
INNER JOIN [dbo].[desk]
ON [master].[desk] = [desk].[code]
INNER JOIN [dbo].[status]
ON [master].[status] = [status].[code]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
WHERE [Debtors].[Seq] = 0;

SELECT [Accounts].[AccountID] AS [AccountID],
	[notes].[user0] AS [UserName],
	[notes].[created] AS [CreatedDate],
	[notes].[action] AS [ActionCode],
	[notes].[result] AS [ResultCode],
	[notes].[comment] AS [Comment]
FROM @Accounts AS [Accounts]
INNER JOIN [dbo].[notes]
ON [Accounts].[AccountID] = [notes].[number];

SELECT [payhistory].[number] AS [AccountID],
	CASE [payhistory].[batchtype]
		WHEN 'PU' THEN 'Paid Us'
		WHEN 'PC' THEN 'Paid Customer'
		WHEN 'PA' THEN 'Paid Agency'
		WHEN 'PUR' THEN 'Reversal'
		WHEN 'PCR' THEN 'Customer Reversal'
		WHEN 'PAR' THEN 'Agency Reversal'
		WHEN 'DA' THEN 'Credit Adjustment'
		WHEN 'DAR' THEN 'Debit Adjustment'
		ELSE 'Unknown'
	END AS [BatchType],
	[payhistory].[entered] AS [DateEntered],
	[payhistory].[datepaid] AS [DatePaid],
	[payhistory].[totalpaid] AS [TotalPaymentAmount],
	[payhistory].[OverPaidAmt] AS [OverPaymentAmount],
	[payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10] AS [Paid],
	[payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10] AS [Fee]
FROM @Accounts AS [Accounts]
INNER JOIN [dbo].[payhistory]
ON [Accounts].[AccountID] = [payhistory].[number];

RETURN 0;

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_RequestInitialLetter] @PrimaryDebtor BIT, @CoDebtor BIT, @IncludeLinkedBalance BIT, @Resend BIT, @RequesterID INTEGER, @SenderID INTEGER, @AccountDeskSender BIT
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @DateCreated DATETIME;
DECLARE @JobName VARCHAR(50);

DECLARE @Requests TABLE (
	[LetterCode] VARCHAR(5) NOT NULL,
	[LetterID] INTEGER NOT NULL,
	[LetterDescription] VARCHAR(50) NULL,
	[AccountID] INTEGER NOT NULL,
	[Contacts] INTEGER NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[CustomerCode] VARCHAR(7) NOT NULL,
	[Open] BIT NOT NULL,
	[ZipCodeLength] INTEGER NOT NULL,
	[Street1Length] INTEGER NOT NULL,
	[MR] BIT NOT NULL,
	[DueDate] DATETIME NOT NULL,
	[Balance] MONEY NOT NULL,
	[LinkedBalance] MONEY NOT NULL,
	[SifPercentage] MONEY NOT NULL,
	[AmountDue] MONEY NOT NULL,
	[DebtorID] INTEGER NOT NULL,
	[Seq] INTEGER NOT NULL,
	[SenderID] INTEGER NULL,
	[RequesterID] INTEGER NULL,
	[AlreadyRequested] BIT NOT NULL,
	[ErrorMessage] VARCHAR(500) NULL
);

SET @PrimaryDebtor = ISNULL(@PrimaryDebtor, 0);
SET @CoDebtor = ISNULL(@CoDebtor, 0);

IF @PrimaryDebtor = 0 AND @CoDebtor = 0
	RETURN 0;

IF @PrimaryDebtor = 1 BEGIN
	INSERT INTO @Requests ([LetterCode], [LetterID], [LetterDescription], [AccountID], [Contacts], [Desk], [CustomerCode], [Open], [ZipCodeLength], [Street1Length], [MR], [DueDate], [Balance], [LinkedBalance], [SifPercentage], [AmountDue], [DebtorID], [Seq], [RequesterID], [SenderID], [AlreadyRequested])
	SELECT DISTINCT
		[customer].[lettercode],
		[letter].[LetterID],
		ISNULL([letter].[Description], [letter].[code]) AS [LetterDescription],
		[master].[number] AS [AccountID],
		ISNULL([master].[TotalContacted], 0) AS [Contacts],
		ISNULL([master].[desk], '') AS [Desk],
		ISNULL([master].[customer], '') AS [CustomerCode],
		CASE
			WHEN [master].[qlevel] IN ('998', '999') THEN 0
			ELSE 1
		END AS [Open],
		LEN(ISNULL(dbo.StripNonDigits([Debtors].[ZipCode]), '')) AS [ZipCodeLength],
		LEN(ISNULL(dbo.CompactWhiteSpace([Debtors].[Street1]), '')) AS [Street1Length],
		CASE [Debtors].[MR]
			WHEN 'Y' THEN 1
			ELSE 0
		END AS [MR],
		{ fn CURDATE() } AS [DueDate],
		[master].[current0] AS [Balance],
		CASE
			WHEN [master].[link] != 0
			THEN ISNULL((SELECT SUM([linked].[current0]) FROM [dbo].[master] AS [linked] WHERE [master].[link] = [linked].[link] AND ([linked].[qlevel] NOT IN ('998', '999') OR [linked].[number] = [master].[number])), [master].[current0])
			ELSE [master].[current0]
		END AS [LinkedBalance],
		CASE
			WHEN [customer].[BlanketSif] IS NULL THEN 100
			WHEN [customer].[BlanketSif] <= 0 THEN 100
			WHEN [customer].[BlanketSif] > 100 THEN 100
			ELSE CAST(ISNULL([customer].[BlanketSif], 0) AS MONEY)
		END AS [SifPercentage],
		0 AS [AmountDue],
		[Debtors].[DebtorID] AS [DebtorID],
		[Debtors].[Seq] AS [Seq],
		@RequesterID AS [RequesterID],
		@SenderID AS [SenderID],
		CASE
			WHEN EXISTS (
				SELECT *
				FROM [dbo].[LetterRequest]
				WHERE [LetterRequest].[AccountID] = [WorkFlowAcct].[AccountID]
				AND [LetterRequest].[RecipientDebtorID] = [Debtors].[DebtorID]
				AND [LetterRequest].[LetterCode] = [letter].[code]
			)
			THEN 1
			ELSE 0
		END AS [AlreadyRequested]
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN [dbo].[master] WITH (NOLOCK)
	ON [WorkFlowAcct].[AccountID] = [master].[number]
	INNER JOIN (
		SELECT [customer].[customer],
			[customer].[BlanketSIF],
			CASE
				WHEN CHARINDEX('-', [customer].[lettercode]) > 0 THEN LTRIM(RTRIM(SUBSTRING([customer].[lettercode], 1, CHARINDEX('-', [customer].[lettercode]) - 1)))
				ELSE [customer].[lettercode]
			END AS [lettercode]
		FROM [dbo].[customer] WITH (NOLOCK)
	) AS [customer]
	ON [master].[customer] = [customer].[customer]
	INNER JOIN [dbo].[letter] WITH (NOLOCK)
	ON [customer].[lettercode] = [letter].[code]
	INNER JOIN [dbo].[Debtors] WITH (NOLOCK)
	ON [master].[number] = [Debtors].[number]
	AND [Debtors].[Seq] = [master].[PSeq]
	LEFT OUTER JOIN [dbo].[DebtorAttorneys]
	ON [Debtors].[DebtorID] = [DebtorAttorneys].[DebtorID];
END;
IF @CoDebtor = 1 BEGIN
	INSERT INTO @Requests ([LetterCode], [LetterID], [LetterDescription], [AccountID], [Contacts], [Desk], [CustomerCode], [Open], [ZipCodeLength], [Street1Length], [MR], [DueDate], [Balance], [LinkedBalance], [SifPercentage], [AmountDue], [DebtorID], [Seq], [RequesterID], [SenderID], [AlreadyRequested])
	SELECT DISTINCT
		[customer].[lettercode],
		[letter].[LetterID],
		ISNULL([letter].[Description], [letter].[code]) AS [LetterDescription],
		[master].[number] AS [AccountID],
		ISNULL([master].[TotalContacted], 0) AS [Contacts],
		ISNULL([master].[desk], '') AS [Desk],
		ISNULL([master].[customer], '') AS [CustomerCode],
		CASE
			WHEN [master].[qlevel] IN ('998', '999') THEN 0
			ELSE 1
		END AS [Open],
		LEN(ISNULL(dbo.StripNonDigits([Debtors].[ZipCode]), '')) AS [ZipCodeLength],
		LEN(ISNULL(dbo.CompactWhiteSpace([Debtors].[Street1]), '')) AS [Street1Length],
		CASE [Debtors].[MR]
			WHEN 'Y' THEN 1
			ELSE 0
		END AS [MR],
		{ fn CURDATE() } AS [DueDate],
		[master].[current0] AS [Balance],
		CASE
			WHEN [master].[link] != 0
			THEN ISNULL((SELECT SUM([linked].[current0]) FROM [dbo].[master] AS [linked] WHERE [master].[link] = [linked].[link] AND ([linked].[qlevel] NOT IN ('998', '999') OR [linked].[number] = [master].[number])), [master].[current0])
			ELSE [master].[current0]
		END AS [LinkedBalance],
		CASE
			WHEN [customer].[BlanketSif] IS NULL THEN 100
			WHEN [customer].[BlanketSif] <= 0 THEN 100
			WHEN [customer].[BlanketSif] > 100 THEN 100
			ELSE CAST(ISNULL([customer].[BlanketSif], 0) AS MONEY)
		END AS [SifPercentage],
		0 AS [AmountDue],
		[Debtors].[DebtorID] AS [DebtorID],
		[Debtors].[Seq] AS [Seq],
		@RequesterID AS [RequesterID],
		CASE @AccountDeskSender
			WHEN 1 THEN COALESCE((
					SELECT TOP 1 [Users].[ID]
					FROM [dbo].[Users] WITH (NOLOCK)
					WHERE [Users].[DeskCode] = [master].[desk]
					AND [Users].[Active] = 1
				), @SenderID)
			ELSE @SenderID
		END AS [SenderID],
		CASE
			WHEN EXISTS (
				SELECT *
				FROM [dbo].[LetterRequest]
				WHERE [LetterRequest].[AccountID] = [WorkFlowAcct].[AccountID]
				AND [LetterRequest].[RecipientDebtorID] = [Debtors].[DebtorID]
				AND [LetterRequest].[LetterCode] = [letter].[code]
			)
			THEN 1
			ELSE 0
		END AS [AlreadyRequested]
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN [dbo].[master] WITH (NOLOCK)
	ON [WorkFlowAcct].[AccountID] = [master].[number]
	INNER JOIN (
		SELECT [customer].[customer],
			[customer].[BlanketSIF],
			CASE
				WHEN CHARINDEX('-', [customer].[lettercode]) > 0 THEN LTRIM(RTRIM(SUBSTRING([customer].[lettercode], 1, CHARINDEX('-', [customer].[lettercode]) - 1)))
				ELSE [customer].[lettercode]
			END AS [lettercode]
		FROM [dbo].[customer] WITH (NOLOCK)
	) AS [customer]
	ON [master].[customer] = [customer].[customer]
	INNER JOIN [dbo].[letter] WITH (NOLOCK)
	ON [customer].[lettercode] = [letter].[code]
	INNER JOIN [dbo].[Debtors] WITH (NOLOCK)
	ON [master].[number] = [Debtors].[number]
	AND [Debtors].[Seq] = [master].[PSeq] + 1
	LEFT OUTER JOIN [dbo].[DebtorAttorneys]
	ON [Debtors].[DebtorID] = [DebtorAttorneys].[DebtorID];
END;

UPDATE @Requests
SET [ErrorMessage] = 'Letter not permitted on closed accounts'
WHERE [Open] = 0
AND [ErrorMessage] IS NULL;

UPDATE @Requests
SET [ErrorMessage] = 'Letter not permitted on accounts with zero balance'
WHERE [Balance] <= 0
AND [ErrorMessage] IS NULL;

IF @Resend = 0 BEGIN
	UPDATE @Requests
	SET [ErrorMessage] = 'Initial letter has already been requested on this account.'
	WHERE [AlreadyRequested] = 1
	AND [ErrorMessage] IS NULL;
END;

UPDATE @Requests
SET [AmountDue] = ROUND((CASE @IncludeLinkedBalance WHEN 1 THEN [LinkedBalance] ELSE [Balance] END), 2);

DELETE [r1]
FROM @Requests AS [r1]
WHERE [ErrorMessage] IS NOT NULL
AND EXISTS (
	SELECT *
	FROM @Requests AS [r2]
	WHERE [r2].[AccountID] = [r1].[AccountID]
	AND [r2].[ErrorMessage] IS NULL
);

SET @DateCreated = GETDATE();
SET @JobName = 'WorkFlow_' + CAST(NEWID() AS CHAR(36)) + CAST(NEWID() AS CHAR(36)) + CAST(NEWID() AS CHAR(36)) + CONVERT(VARCHAR(50), GETDATE(), 126);

BEGIN TRANSACTION;

INSERT INTO [dbo].[LetterRequest] ([AccountID], [CustomerCode], [LetterID], [LetterCode], [DateRequested], [DateProcessed], [JobName], [DueDate], [AmountDue], [UserName], [Suspend], [SifPmt1], [SifPmt2], [SifPmt3], [SifPmt4], [SifPmt5], [SifPmt6], [Manual], [AddEditMode], [Edited], [DocumentData], [Deleted], [CopyCustomer], [SaveImage], [ProcessingMethod], [ErrorDescription], [DateCreated], [DateUpdated], [SubjDebtorID], [SenderID], [RequesterID], [FutureID], [RecipientDebtorID], [RecipientDebtorSeq], [LtrSeriesQueueID])
SELECT [Requests].[AccountID],
	[Requests].[CustomerCode],
	[LetterID] AS [LetterID],
	[LetterCode] AS [LetterCode],
	@DateCreated AS [DateRequested],
	'1753-01-01 12:00:00 PM' AS [DateProcessed],
	@JobName AS [JobName],
	@DateCreated AS [DueDate],
	[Requests].[AmountDue] AS [AmountDue],
	'WORKFLOW' AS [UserName],
	0 AS [Suspend],
	'' AS [SifPmt1],
	'' AS [SifPmt2],
	'' AS [SifPmt3],
	'' AS [SifPmt4],
	'' AS [SifPmt5],
	'' AS [SifPmt6],
	0 AS [Manual],
	0 AS [AddEditMode],
	0 AS [Edited],
	0x AS [DocumentData],
	0 AS [Deleted],
	0 AS [CopyCustomer],
	0 AS [SaveImage],
	0 AS [ProcessingMethod],
	NULL AS [ErrorDescription],
	@DateCreated AS [DateCreated],
	@DateCreated AS [DateUpdated],
	[Requests].[DebtorID] AS [SubjDebtorID],
	[Requests].[SenderID] AS [SenderID],
	[Requests].[RequesterID] AS [RequesterID],
	0 AS [FutureID],
	[Requests].[DebtorID] AS [RecipientDebtorID],
	[Requests].[Seq] AS [RecipientDebtorSeq],
	NULL AS [LtrSeriesQueue]
FROM @Requests AS [Requests]
WHERE [Requests].[ErrorMessage] IS NULL;

INSERT INTO [dbo].[LetterRequestRecipient] ([LetterRequestID], [AccountID], [Seq], [DebtorID], [CustomerCode], [DebtorAttorney], [DateCreated], [DateUpdated], [AttorneyID])
SELECT [LetterRequest].[LetterRequestID],
	[Requests].[AccountID],
	[Requests].[Seq],
	[Requests].[DebtorID],
	NULL AS [CustomerCode],
	0 AS [DebtorAttorney],
	@DateCreated AS [DateCreated],
	@DateCreated AS [DateUpdated],
	NULL AS [AttorneyID]
FROM [dbo].[LetterRequest]
INNER JOIN @Requests AS [Requests]
ON [LetterRequest].[SubjDebtorID] = [Requests].[DebtorID]
WHERE [LetterRequest].[DateCreated] = @DateCreated
AND [LetterRequest].[UserName] = 'WORKFLOW'
AND [LetterRequest].[JobName] = @JobName
AND [Requests].[ErrorMessage] IS NULL;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [IsPrivate])
SELECT [Requests].[AccountID], 'WKF', @DateCreated, 'WORKFLOW', 'LETTR', 'REQST',
	'Initial letter ' + [LetterCode] + ISNULL(': ' + [LetterDescription], '') + ' requested' AS [comment],
	0 AS [IsPrivate]
FROM @Requests AS [Requests]
WHERE [Requests].[ErrorMessage] IS NULL;

UPDATE #WorkFlowAcct
SET [Comment] = COALESCE([Requests].[ErrorMessage],
	'Initial letter ' + [LetterCode] + ISNULL(': ' + [LetterDescription], '') + ' requested')
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Requests AS [Requests]
ON [WorkFlowAcct].[AccountID] = [Requests].[AccountID];

COMMIT TRANSACTION;

RETURN 0;
GO

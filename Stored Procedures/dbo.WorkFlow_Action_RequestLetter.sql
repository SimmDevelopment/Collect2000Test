SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_RequestLetter] @LetterCode VARCHAR(5), @PrimaryDebtor BIT, @Codebtor BIT, @IncludeLinkedBalance BIT, @SettlementPercent MONEY, @Installments TINYINT, @IncludeDueDates BIT, @DueDate1 SMALLINT, @DueDate2 SMALLINT, @DueDate3 SMALLINT, @DueDate4 SMALLINT, @DueDate5 SMALLINT, @DueDate6 SMALLINT, @RequesterID INTEGER, @SenderID INTEGER, @AccountDeskSender BIT
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @LetterID INTEGER;
DECLARE @LetterType CHAR(3);
DECLARE @LetterDescription VARCHAR(50);
DECLARE @AllowClosed BIT;
DECLARE @AllowZeroBalance BIT;
DECLARE @AllowFirst30 BIT;
DECLARE @AllowAfter30 BIT;
DECLARE @SaveImage BIT;
DECLARE @CopyCustomer BIT;
DECLARE @Due1 DATETIME;
DECLARE @Due2 DATETIME;
DECLARE @Due3 DATETIME;
DECLARE @Due4 DATETIME;
DECLARE @Due5 DATETIME;
DECLARE @Due6 DATETIME;
DECLARE @OldDateFirst INTEGER;
DECLARE @JobName VARCHAR(256);
DECLARE @DateCreated DATETIME;

SELECT @LetterID = [LetterID],
	@LetterType = CASE
		WHEN [type] IN ('SIF', 'PIF', 'PPS', 'PDC', 'ATT', 'CUS') THEN [type]
		ELSE 'DUN'
	END,
	@LetterDescription = ISNULL([Description], ''),
	@AllowClosed = ISNULL([allowclosed], 0),
	@AllowZeroBalance = ISNULL([allowzero], 0),
	@AllowFirst30 = ISNULL([AllowFirst30], 0),
	@AllowAfter30 = ISNULL([AllowAfter30], 0),
	@CopyCustomer = [CopyCustomer],
	@SaveImage = [SaveImage]
FROM [dbo].[letter]
WHERE [code] = @LetterCode;

IF @@ROWCOUNT = 0 BEGIN
	RAISERROR('Letter code "%s" does not exist.', 16, 1, @LetterCode);
	RETURN 1;
END;

DECLARE @AllowedCustomers TABLE (
	[CustomerCode] VARCHAR(7) PRIMARY KEY CLUSTERED,
	[CopyCustomer] BIT NOT NULL,
	[SaveImage] BIT NOT NULL
);

INSERT INTO @AllowedCustomers ([CustomerCode], [CopyCustomer], [SaveImage])
SELECT RTRIM(LTRIM([CustLtrAllow].[CustCode])) AS [CustomerCode],
	MAX(CAST([CustLtrAllow].[CopyCustomer] AS TINYINT)),
	MAX(CAST([CustLtrAllow].[SaveImage] AS TINYINT))
FROM [dbo].[CustLtrAllow]
WHERE [CustLtrAllow].[LtrCode] = @LetterCode
GROUP BY RTRIM(LTRIM([CustLtrAllow].[CustCode]));

INSERT INTO @AllowedCustomers ([CustomerCode], [CopyCustomer], [SaveImage])
SELECT [Fact].[CustomerID],
	MAX(CAST([CustomCustGroupLetter].[CopyCustomer] AS TINYINT)),
	MAX(CAST([CustomCustGroupLetter].[SaveImage] AS TINYINT))
FROM [dbo].[Fact]
INNER JOIN [dbo].[CustomCustGroupLetter]
ON [Fact].[CustomGroupID] = [CustomCustGroupLetter].[CustomCustGroupID]
WHERE [CustomCustGroupLetter].[LetterID] = @LetterID
AND NOT [Fact].[CustomerID] IN (SELECT [CustomerCode] FROM @AllowedCustomers)
GROUP BY [Fact].[CustomerID];

DECLARE @Requests TABLE (
	[AccountID] INTEGER NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[CustomerCode] VARCHAR(7) NOT NULL,
	[DaysOnSystem] INTEGER NOT NULL,
	[Open] BIT NOT NULL,
	[ZipCodeLength] INTEGER NOT NULL,
	[Street1Length] INTEGER NOT NULL,
	[MR] BIT NOT NULL,
	[DueDate] DATETIME NOT NULL,
	[Balance] MONEY NOT NULL,
	[LinkedBalance] MONEY NOT NULL,
	[SifPercentage] MONEY NOT NULL,
	[AmountDue] MONEY NOT NULL,
	[Amount1] MONEY NOT NULL,
	[Due1] DATETIME NOT NULL,
	[Amount2] MONEY NOT NULL,
	[Due2] DATETIME NOT NULL,
	[Amount3] MONEY NOT NULL,
	[Due3] DATETIME NOT NULL,
	[Amount4] MONEY NOT NULL,
	[Due4] DATETIME NOT NULL,
	[Amount5] MONEY NOT NULL,
	[Due5] DATETIME NOT NULL,
	[Amount6] MONEY NOT NULL,
	[Due6] DATETIME NOT NULL,
	[DebtorID] INTEGER NOT NULL,
	[Seq] INTEGER NOT NULL,
	[DebtorAttorney] BIT NOT NULL,
	[AttorneyID] INTEGER NULL,
	[SenderID] INTEGER NULL,
	[RequesterID] INTEGER NULL,
	[ErrorMessage] VARCHAR(500) NULL
);

SET @OldDateFirst = @@DATEFIRST;
SET DATEFIRST 1;

SET @Due1 = DATEADD(DAY, ISNULL(@DueDate1, 15), { fn CURDATE() });
IF DATEPART(WEEKDAY, @Due1) = 6
	SET @Due1 = DATEADD(DAY, 2, @Due1);
ELSE IF DATEPART(WEEKDAY, @Due1) = 7
	SET @Due1 = DATEADD(DAY, 1, @Due1);

SET @Due2 = DATEADD(DAY, ISNULL(@DueDate2, 45), { fn CURDATE() });
IF DATEPART(WEEKDAY, @Due2) = 6
	SET @Due2 = DATEADD(DAY, 2, @Due2);
ELSE IF DATEPART(WEEKDAY, @Due1) = 7
	SET @Due2 = DATEADD(DAY, 1, @Due2);

SET @Due3 = DATEADD(DAY, ISNULL(@DueDate3, 75), { fn CURDATE() });
IF DATEPART(WEEKDAY, @Due3) = 6
	SET @Due3 = DATEADD(DAY, 2, @Due3);
ELSE IF DATEPART(WEEKDAY, @Due1) = 7
	SET @Due3 = DATEADD(DAY, 1, @Due3);

SET @Due4 = DATEADD(DAY, ISNULL(@DueDate4, 105), { fn CURDATE() });
IF DATEPART(WEEKDAY, @Due4) = 6
	SET @Due4 = DATEADD(DAY, 2, @Due4);
ELSE IF DATEPART(WEEKDAY, @Due1) = 7
	SET @Due4 = DATEADD(DAY, 1, @Due4);

SET @Due5 = DATEADD(DAY, ISNULL(@DueDate5, 135), { fn CURDATE() });
IF DATEPART(WEEKDAY, @Due5) = 6
	SET @Due5 = DATEADD(DAY, 2, @Due5);
ELSE IF DATEPART(WEEKDAY, @Due1) = 7
	SET @Due5 = DATEADD(DAY, 1, @Due5);

SET @Due6 = DATEADD(DAY, ISNULL(@DueDate6, 165), { fn CURDATE() });
IF DATEPART(WEEKDAY, @Due6) = 6
	SET @Due6 = DATEADD(DAY, 2, @Due6);
ELSE IF DATEPART(WEEKDAY, @Due1) = 7
	SET @Due6 = DATEADD(DAY, 1, @Due6);

SET DATEFIRST @OldDateFirst;

IF @PrimaryDebtor = 1 OR @LetterType IN ('CUS', 'ATT') BEGIN
	INSERT INTO @Requests ([AccountID], [Desk], [CustomerCode], [DaysOnSystem], [Open], [ZipCodeLength], [Street1Length], [MR], [DueDate], [Balance], [LinkedBalance], [SifPercentage], [AmountDue], [Amount1], [Due1], [Amount2], [Due2], [Amount3], [Due3], [Amount4], [Due4], [Amount5], [Due5], [Amount6], [Due6], [DebtorID], [Seq], [DebtorAttorney], [AttorneyID], [RequesterID], [SenderID])
	SELECT DISTINCT [master].[number] AS [AccountID],
		ISNULL([master].[desk], '') AS [Desk],
		ISNULL([master].[customer], '') AS [CustomerCode],
		DATEDIFF(DAY, ISNULL([master].[received], { fn CURDATE() }), { fn CURDATE() }) AS [DaysOnSystem],
		CASE [master].[qlevel]
			WHEN '998' THEN 0
			WHEN '999' THEN 0
			ELSE 1
		END AS [Open],
		LEN(ISNULL(dbo.StripNonDigits([Debtors].[ZipCode]), '')) AS [ZipCodeLength],
		LEN(ISNULL(dbo.CompactWhiteSpace([Debtors].[Street1]), '')) AS [Street1Length],
		CASE [Debtors].[MR]
			WHEN 'Y' THEN 1
			ELSE 0
		END AS [MR],
		@Due1 AS [DueDate],
		[master].[current0] AS [Balance],
		CASE
			WHEN [master].[link] != 0
			THEN ISNULL((SELECT SUM([linked].[current0]) FROM [dbo].[master] AS [linked] WHERE [master].[link] = [linked].[link] AND ([linked].[qlevel] NOT IN ('998', '999') OR [linked].[number] = [master].[number])), [master].[current0])
			ELSE [master].[current0]
		END AS [LinkedBalance],
		CASE @SettlementPercent
			WHEN 0 THEN
				CASE
					WHEN [customer].[BlanketSif] IS NULL THEN 100
					WHEN [customer].[BlanketSif] <= 0 THEN 100
					WHEN [customer].[BlanketSif] > 100 THEN 100
					ELSE CAST(ISNULL([customer].[BlanketSif], 0) AS MONEY)
				END
			ELSE @SettlementPercent
		END AS [SifPercentage],
		0 AS [AmountDue],
		0 AS [Amount1],
		@Due1 AS [Due1],
		0 AS [Amount2],
		@Due2 AS [Due2],
		0 AS [Amount3],
		@Due3 AS [Due3],
		0 AS [Amount4],
		@Due4 AS [Due4],
		0 AS [Amount5],
		@Due5 AS [Due5],
		0 AS [Amount6],
		@Due6 AS [Due6],
		[Debtors].[DebtorID] AS [DebtorID],
		[Debtors].[Seq] AS [Seq],
		0 AS [DebtorAttorney],
		[DebtorAttorneys].[ID] AS [AttorneyID],
		@RequesterID AS [RequesterID],
		CASE @AccountDeskSender
			WHEN 1 THEN COALESCE((
					SELECT TOP 1 [Users].[ID]
					FROM [dbo].[Users] WITH (NOLOCK)
					WHERE [Users].[DeskCode] = [master].[desk]
					AND [Users].[Active] = 1
				), @SenderID)
			ELSE @SenderID
		END AS [SenderID]
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN [dbo].[master] WITH (NOLOCK)
	ON [WorkFlowAcct].[AccountID] = [master].[number]
	INNER JOIN [dbo].[customer] WITH (NOLOCK)
	ON [master].[customer] = [customer].[customer]
	INNER JOIN [dbo].[Debtors] WITH (NOLOCK)
	ON [master].[number] = [Debtors].[number]
	AND [Debtors].[Seq] = [master].[PSeq]
	LEFT OUTER JOIN [dbo].[DebtorAttorneys]
	ON [Debtors].[DebtorID] = [DebtorAttorneys].[DebtorID];
END;
IF @Codebtor = 1 AND @LetterType NOT IN ('CUS', 'ATT') BEGIN
	INSERT INTO @Requests ([AccountID], [Desk], [CustomerCode], [DaysOnSystem], [Open], [ZipCodeLength], [Street1Length], [MR], [DueDate], [Balance], [LinkedBalance], [SifPercentage], [AmountDue], [Amount1], [Due1], [Amount2], [Due2], [Amount3], [Due3], [Amount4], [Due4], [Amount5], [Due5], [Amount6], [Due6], [DebtorID], [Seq], [DebtorAttorney], [AttorneyID], [RequesterID], [SenderID])
	SELECT DISTINCT [master].[number] AS [AccountID],
		ISNULL([master].[desk], '') AS [Desk],
		ISNULL([master].[customer], '') AS [CustomerCode],
		DATEDIFF(DAY, ISNULL([master].[received], { fn CURDATE() }), { fn CURDATE() }) AS [DaysOnSystem],
		CASE [master].[qlevel]
			WHEN '998' THEN 0
			WHEN '999' THEN 0
			ELSE 1
		END AS [Open],
		LEN(ISNULL(dbo.StripNonDigits([Debtors].[ZipCode]), '')) AS [ZipCodeLength],
		LEN(ISNULL(dbo.CompactWhiteSpace([Debtors].[Street1]), '')) AS [Street1Length],
		CASE [Debtors].[MR]
			WHEN 'Y' THEN 1
			ELSE 0
		END AS [MR],
		@Due1 AS [DueDate],
		[master].[current0] AS [Balance],
		CASE
			WHEN [master].[link] != 0
			THEN ISNULL((SELECT SUM([linked].[current0]) FROM [dbo].[master] AS [linked] WHERE [master].[link] = [linked].[link] AND ([linked].[qlevel] NOT IN ('998', '999') OR [linked].[number] = [master].[number])), [master].[current0])
			ELSE [master].[current0]
		END AS [LinkedBalance],
		CASE @SettlementPercent
			WHEN 0 THEN
				CASE
					WHEN [customer].[BlanketSif] IS NULL THEN 100
					WHEN [customer].[BlanketSif] <= 0 THEN 100
					WHEN [customer].[BlanketSif] > 100 THEN 100
					ELSE CAST(ISNULL([customer].[BlanketSif], 0) AS MONEY)
				END
			ELSE @SettlementPercent
		END AS [SifPercentage],
		0 AS [AmountDue],
		0 AS [Amount1],
		@Due1 AS [Due1],
		0 AS [Amount2],
		@Due2 AS [Due2],
		0 AS [Amount3],
		@Due3 AS [Due3],
		0 AS [Amount4],
		@Due4 AS [Due4],
		0 AS [Amount5],
		@Due5 AS [Due5],
		0 AS [Amount6],
		@Due6 AS [Due6],
		[Debtors].[DebtorID] AS [DebtorID],
		[Debtors].[Seq] AS [Seq],
		0 AS [DebtorAttorney],
		[DebtorAttorneys].[ID] AS [AttorneyID],
		@RequesterID AS [RequesterID],
		@SenderID AS [SenderID]
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN [dbo].[master] WITH (NOLOCK)
	ON [WorkFlowAcct].[AccountID] = [master].[number]
	INNER JOIN [dbo].[customer] WITH (NOLOCK)
	ON [master].[customer] = [customer].[customer]
	INNER JOIN [dbo].[Debtors] WITH (NOLOCK)
	ON [master].[number] = [Debtors].[number]
	AND [Debtors].[Seq] = [master].[PSeq] + 1
	LEFT OUTER JOIN [dbo].[DebtorAttorneys]
	ON [Debtors].[DebtorID] = [DebtorAttorneys].[DebtorID];
END;

UPDATE @Requests
SET [ErrorMessage] = 'Letter not permitted on customer'
FROM @Requests AS [Requests]
LEFT OUTER JOIN @AllowedCustomers AS [AllowedCustomers]
ON [Requests].[CustomerCode] = [AllowedCustomers].[CustomerCode]
WHERE [AllowedCustomers].[CustomerCode] IS NULL
AND [Requests].[ErrorMessage] IS NULL;

IF @LetterType NOT IN ('CUS', 'ATT') BEGIN
	UPDATE @Requests
	SET [ErrorMessage] = 'Invalid address'
	WHERE [ZipCodeLength] < 5
	OR [Street1Length] < 4
	OR [MR] = 1
	AND [ErrorMessage] IS NULL;
END;

UPDATE @Requests
SET [ErrorMessage] = 'Letter not permitted on closed accounts'
WHERE [Open] = 0
AND @AllowClosed = 0
AND [ErrorMessage] IS NULL;

UPDATE @Requests
SET [ErrorMessage] = 'Letter not permitted on accounts with zero balance'
WHERE [Balance] <= 0
AND @AllowZeroBalance = 0
AND [ErrorMessage] IS NULL;

UPDATE @Requests
SET [ErrorMessage] = 'Letter not permitted on accounts in first 30 days'
WHERE [DaysOnSystem] <= 30
AND @AllowFirst30 = 0
AND @AllowAfter30 = 1
AND [ErrorMessage] IS NULL;

UPDATE @Requests
SET [ErrorMessage] = 'Letter not permitted on accounts after 30 days'
WHERE [DaysOnSystem] > 30
AND @AllowAfter30 = 0
AND @AllowFirst30 = 1
AND [ErrorMessage] IS NULL;

IF @LetterType = 'PPS' BEGIN
	UPDATE @Requests
	SET [Amount1] = ROUND(((CASE @IncludeLinkedBalance WHEN 1 THEN [LinkedBalance] ELSE [Balance] END  * ([SifPercentage] / 100)) / @Installments), 2);

	UPDATE @Requests
	SET [AmountDue] = [Amount1] * @Installments,
		[Amount2] = CASE WHEN @Installments >= 2 THEN [Amount1] ELSE 0 END,
		[Amount3] = CASE WHEN @Installments >= 3 THEN [Amount1] ELSE 0 END,
		[Amount4] = CASE WHEN @Installments >= 4 THEN [Amount1] ELSE 0 END,
		[Amount5] = CASE WHEN @Installments >= 5 THEN [Amount1] ELSE 0 END,
		[Amount6] = CASE WHEN @Installments >= 6 THEN [Amount1] ELSE 0 END;
END;
ELSE IF @LetterType = 'SIF' BEGIN
	UPDATE @Requests
	SET [AmountDue] = ROUND((CASE @IncludeLinkedBalance WHEN 1 THEN [LinkedBalance] ELSE [Balance] END  * ([SifPercentage] / 100)), 2),
		[Amount1] = ROUND((CASE @IncludeLinkedBalance WHEN 1 THEN [LinkedBalance] ELSE [Balance] END  * ([SifPercentage] / 100)), 2);	
END;
ELSE BEGIN
	UPDATE @Requests
	SET [AmountDue] = ROUND((CASE @IncludeLinkedBalance WHEN 1 THEN [LinkedBalance] ELSE [Balance] END), 2),
		[Amount1] = ROUND((CASE @IncludeLinkedBalance WHEN 1 THEN [LinkedBalance] ELSE [Balance] END), 2);
END;

SET @DateCreated = GETDATE();
SET @JobName = 'WorkFlow_' + CAST(NEWID() AS CHAR(36)) + CAST(NEWID() AS CHAR(36)) + CAST(NEWID() AS CHAR(36)) + CONVERT(VARCHAR(50), GETDATE(), 126);

BEGIN TRANSACTION;

INSERT INTO [dbo].[LetterRequest] ([AccountID], [CustomerCode], [LetterID], [LetterCode], [DateRequested], [DateProcessed], [JobName], [DueDate], [AmountDue], [UserName], [Suspend], [SifPmt1], [SifPmt2], [SifPmt3], [SifPmt4], [SifPmt5], [SifPmt6], [Manual], [AddEditMode], [Edited], [DocumentData], [Deleted], [CopyCustomer], [SaveImage], [ProcessingMethod], [ErrorDescription], [DateCreated], [DateUpdated], [SubjDebtorID], [SenderID], [RequesterID], [FutureID], [RecipientDebtorID], [RecipientDebtorSeq], [LtrSeriesQueueID])
SELECT [Requests].[AccountID],
	[Requests].[CustomerCode],
	@LetterID AS [LetterID],
	@LetterCode AS [LetterCode],
	@DateCreated AS [DateRequested],
	'1753-01-01 12:00:00 PM' AS [DateProcessed],
	@JobName AS [JobName],
	[Requests].[Due1] AS [DueDate],
	[Requests].[AmountDue] AS [AmountDue],
	'WORKFLOW' AS [UserName],
	0 AS [Suspend],
	CASE
		WHEN @LetterType = 'PPS'
		THEN CASE @IncludeDueDates
			WHEN 1 THEN '$' + CONVERT(VARCHAR(30), [Requests].[Amount1], 1) + ' due ' + CONVERT(VARCHAR(30), [Requests].[Due1], 101)
			ELSE CAST(@Installments AS VARCHAR(30))
		END
		WHEN @LetterType = 'SIF'
		THEN CASE @IncludeDueDates
			WHEN 1 THEN '$' + CONVERT(VARCHAR(30), [Requests].[Amount1], 1) + ' due ' + CONVERT(VARCHAR(30), [Requests].[Due1], 101)
			ELSE '$' + CONVERT(VARCHAR(29), [Requests].[Amount1], 1)
		END
		ELSE ''
	END AS [SifPmt1],
	CASE
		WHEN @LetterType = 'PPS'
		THEN CASE @IncludeDueDates
			WHEN 1 THEN CASE
				WHEN @Installments >= 2 THEN '$' + CONVERT(VARCHAR(30), [Requests].[Amount2], 1) + ' due ' + CONVERT(VARCHAR(30), [Requests].[Due2], 101)
				ELSE ''
			END
			ELSE '$' + CONVERT(VARCHAR(29), [Requests].[Amount1], 1)
		END
		ELSE ''
	END AS [SifPmt2],
	CASE
		WHEN @LetterType = 'PPS'
		THEN CASE @IncludeDueDates
			WHEN 1 THEN CASE
				WHEN @Installments >= 3 THEN '$' + CONVERT(VARCHAR(30), [Requests].[Amount3], 1) + ' due ' + CONVERT(VARCHAR(30), [Requests].[Due3], 101)
				ELSE ''
			END
			ELSE ''
		END
		ELSE ''
	END AS [SifPmt3],
	CASE
		WHEN @LetterType = 'PPS'
		THEN CASE @IncludeDueDates
			WHEN 1 THEN CASE
				WHEN @Installments >= 4 THEN '$' + CONVERT(VARCHAR(30), [Requests].[Amount4], 1) + ' due ' + CONVERT(VARCHAR(30), [Requests].[Due4], 101)
				ELSE ''
			END
			ELSE ''
		END
		ELSE ''
	END AS [SifPmt4],
	CASE
		WHEN @LetterType = 'PPS'
		THEN CASE @IncludeDueDates
			WHEN 1 THEN CASE
				WHEN @Installments >= 5 THEN '$' + CONVERT(VARCHAR(30), [Requests].[Amount5], 1) + ' due ' + CONVERT(VARCHAR(30), [Requests].[Due5], 101)
				ELSE ''
			END
			ELSE ''
		END
		ELSE ''
	END AS [SifPmt5],
	CASE
		WHEN @LetterType = 'PPS'
		THEN CASE @IncludeDueDates
			WHEN 1 THEN CASE
				WHEN @Installments >= 6 THEN '$' + CONVERT(VARCHAR(30), [Requests].[Amount6], 1) + ' due ' + CONVERT(VARCHAR(30), [Requests].[Due6], 101)
				ELSE ''
			END
			ELSE ''
		END
		ELSE ''
	END AS [SifPmt6],
	0 AS [Manual],
	0 AS [AddEditMode],
	0 AS [Edited],
	0x AS [DocumentData],
	0 AS [Deleted],
	CASE @CopyCustomer
		WHEN 1 THEN 1
		ELSE [AllowedCustomers].[CopyCustomer]
	END AS [CopyCustomer],
	CASE @SaveImage
		WHEN 1 THEN 1
		ELSE [AllowedCustomers].[SaveImage]
	END AS [SaveImage],
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
INNER JOIN @AllowedCustomers AS [AllowedCustomers]
ON [Requests].[CustomerCode] = [AllowedCustomers].[CustomerCode]
WHERE [Requests].[ErrorMessage] IS NULL;

INSERT INTO [dbo].[LetterRequestRecipient] ([LetterRequestID], [AccountID], [Seq], [DebtorID], [CustomerCode], [DebtorAttorney], [DateCreated], [DateUpdated], [AttorneyID])
SELECT [LetterRequest].[LetterRequestID],
	[Requests].[AccountID],
	[Requests].[Seq],
	[Requests].[DebtorID],
	CASE @LetterType
		WHEN 'CUS' THEN [Requests].[CustomerCode]
		ELSE NULL
	END AS [CustomerCode],
	CASE @LetterType
		WHEN 'ATT' THEN 1
		ELSE 0
	END AS [DebtorAttorney],
	@DateCreated AS [DateCreated],
	@DateCreated AS [DateUpdated],
	CASE @LetterType
		WHEN 'ATT' THEN [Requests].[AttorneyID]
		ELSE NULL
	END AS [AttorneyID]
FROM [dbo].[LetterRequest]
INNER JOIN @Requests AS [Requests]
ON [LetterRequest].[SubjDebtorID] = [Requests].[DebtorID]
WHERE [LetterRequest].[DateCreated] = @DateCreated
AND [LetterRequest].[UserName] = 'WORKFLOW'
AND [LetterRequest].[JobName] = @JobName
AND [Requests].[ErrorMessage] IS NULL;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [IsPrivate])
SELECT [Requests].[AccountID], 'WKF', @DateCreated, 'WORKFLOW', 'LETTR', 'REQST',
	CASE @LetterType
		WHEN 'PDC' THEN 'Reminder letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
		WHEN 'PPA' THEN 'Reminder letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
		WHEN 'SIF' THEN
			CASE @IncludeDueDates
--BGM CHANGED NOTE TO NOT USE MONETARY VALUES AS THEY ARE MISLEADING.  12/20/2016
				WHEN 1 THEN 'Settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
				ELSE 'Settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
				--WHEN 1 THEN 'Settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested for $' + CONVERT(VARCHAR(20), [Requests].[AmountDue], 1) + ' due ' + CONVERT(VARCHAR(10), [Requests].[Due1], 101)
				--ELSE 'Settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested for $' + CONVERT(VARCHAR(20), [Requests].[AmountDue], 1)
			END
		WHEN 'PIF' THEN
			CASE @IncludeDueDates
				WHEN 1 THEN 'Pay off letter ' + @LetterCode + ': ' + @LetterDescription + ' requested due ' + CONVERT(VARCHAR(10), [Requests].[Due1], 101)
				ELSE 'Pay off letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
			END
		WHEN 'PPS' THEN
			CASE @IncludeDueDates
--BGM CHANGED NOTE TO NOT USE MONETARY VALUES AS THEY ARE MISLEADING.  12/20/2016
				WHEN 1 THEN 'Multipart settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
				ELSE 'Multipart settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
				--WHEN 1 THEN 'Multipart settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested for $' + CONVERT(VARCHAR(20), [Requests].[AmountDue], 1) + ' due in ' + CAST(@Installments AS VARCHAR(1)) + ' installments of $' + CONVERT(VARCHAR(20), [Requests].[Amount1], 1) + ' first due ' + CONVERT(VARCHAR(10), [Requests].[Due1], 101)
				--ELSE 'Multipart settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested for $' + CONVERT(VARCHAR(20), [Requests].[AmountDue], 1) + ' due in ' + CAST(@Installments AS VARCHAR(1)) + ' installments of $' + CONVERT(VARCHAR(20), [Requests].[Amount1], 1)
			END
		WHEN 'ATT' THEN 'Attorney letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
		WHEN 'CUS' THEN 'Customer letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
		ELSE 'Dunning letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
	END AS [comment],
	0 AS [IsPrivate]
FROM @Requests AS [Requests]
WHERE [Requests].[ErrorMessage] IS NULL;

UPDATE #WorkFlowAcct
SET [Comment] = COALESCE([Requests].[ErrorMessage],
	CASE @LetterType
		WHEN 'PDC' THEN 'Reminder letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
		WHEN 'PPA' THEN 'Reminder letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
		WHEN 'SIF' THEN
			CASE @IncludeDueDates
--BGM CHANGED NOTE TO NOT USE MONETARY VALUES AS THEY ARE MISLEADING.  12/20/2016
				WHEN 1 THEN 'Settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
				ELSE 'Settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
				--WHEN 1 THEN 'Settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested for $' + CONVERT(VARCHAR(20), [Requests].[AmountDue], 1) + ' due ' + CONVERT(VARCHAR(10), [Requests].[Due1], 101)
				--ELSE 'Settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested for $' + CONVERT(VARCHAR(20), [Requests].[AmountDue], 1)
			END
		WHEN 'PIF' THEN
			CASE @IncludeDueDates
				WHEN 1 THEN 'Pay off letter ' + @LetterCode + ': ' + @LetterDescription + ' requested due ' + CONVERT(VARCHAR(10), [Requests].[Due1], 101)
				ELSE 'Pay off letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
			END
		WHEN 'PPS' THEN
			CASE @IncludeDueDates
--BGM CHANGED NOTE TO NOT USE MONETARY VALUES AS THEY ARE MISLEADING.  12/20/2016
				WHEN 1 THEN 'Multipart settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
				ELSE 'Multipart settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
				--WHEN 1 THEN 'Multipart settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested for $' + CONVERT(VARCHAR(20), [Requests].[AmountDue], 1) + ' due in ' + CAST(@Installments AS VARCHAR(1)) + ' installments of $' + CONVERT(VARCHAR(20), [Requests].[Amount1], 1) + ' first due ' + CONVERT(VARCHAR(10), [Requests].[Due1], 101)
				--ELSE 'Multipart settlement letter ' + @LetterCode + ': ' + @LetterDescription + ' requested for $' + CONVERT(VARCHAR(20), [Requests].[AmountDue], 1) + ' due in ' + CAST(@Installments AS VARCHAR(1)) + ' installments of $' + CONVERT(VARCHAR(20), [Requests].[Amount1], 1)
			END
		WHEN 'ATT' THEN 'Attorney letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
		WHEN 'CUS' THEN 'Customer letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
		ELSE 'Dunning letter ' + @LetterCode + ': ' + @LetterDescription + ' requested'
	END)
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Requests AS [Requests]
ON [WorkFlowAcct].[AccountID] = [Requests].[AccountID];

COMMIT TRANSACTION;

RETURN 0;
GO

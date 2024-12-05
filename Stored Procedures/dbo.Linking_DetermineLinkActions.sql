SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_DetermineLinkActions]
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

IF OBJECT_ID('tempdb..#NewAccts') IS NULL BEGIN
	RAISERROR('Linking temporary table %s does not exist.', 16, 1, '#NewAccts');
	RETURN -1;
END;
IF OBJECT_ID('tempdb..#Matches') IS NULL BEGIN
	RAISERROR('Linking temporary table %s does not exist.', 16, 1, '#Matches');
	RETURN -1;
END;
IF OBJECT_ID('tempdb..#Possibles') IS NULL BEGIN
	RAISERROR('Linking temporary table %s does not exist.', 16, 1, '#Possibles');
	RETURN -1;
END;
IF OBJECT_ID('tempdb..#Exceptions') IS NULL BEGIN
	RAISERROR('Linking temporary table %s does not exist.', 16, 1, '#Exceptions');
	RETURN -1;
END;

IF OBJECT_ID('tempdb..#ToBeLinked') IS NOT NULL BEGIN
	DROP TABLE tempdb..#ToBeLinked
END;

SELECT DISTINCT [Possibles].[Source], [Possibles].[Target]
INTO #ToBeLinked
FROM #Possibles AS [Possibles]
WHERE [Possibles].[Link] = 1;

BEGIN TRANSACTION;

INSERT INTO [dbo].[Linking_ActionsPending] ([Source], [Customer], [Target])
SELECT [ToBeLinked].[Source], [NewAccts].[Customer], [ToBeLinked].[Target]
FROM #ToBeLinked AS [ToBeLinked]
INNER JOIN #NewAccts AS [NewAccts]
ON [ToBeLinked].[Source] = [NewAccts].[Number];

INSERT INTO [dbo].[Linking_ActionsPending] ([Source], [Customer], [Target])
SELECT [NewAccts].[Number], [NewAccts].[Customer], NULL AS [Target]
FROM #NewAccts AS [NewAccts]
WHERE NOT EXISTS (SELECT *
	FROM #ToBeLinked AS [ToBeLinked]
	WHERE [ToBeLinked].[Source] = [NewAccts].[Number]
	OR [ToBeLinked].[Target] = [NewAccts].[Number]);

DELETE FROM [dbo].[Linking_ActionsPending]
WHERE [Linking_ActionsPending].[Source] > [Linking_ActionsPending].[Target]
AND EXISTS (SELECT *
	FROM [dbo].[Linking_ActionsPending] AS [Inner]
	WHERE [Inner].[Source] = [Linking_ActionsPending].[Target]
	AND [Inner].[Target] = [Linking_ActionsPending].[Source]);

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Recording linking results.';

INSERT INTO [dbo].[Linking_Results] ([LinkID], [Number], [Target], [Score], [Threshold], [Linked], [Evaluated])
SELECT [ID], [Source], [Target], [TotalScore], [LinkThreshold], [Link], [Evaluated]
FROM #Possibles AS [Possibles];

INSERT INTO [dbo].[Linking_ResultTests] ([LinkID], [Test], [Score], [SourceDebtorID], [TargetDebtorID], [SourceData], [TargetData])
SELECT DISTINCT [Possibles].[ID], [Matches].[Test], [Matches].[Score], [SourceDebtors].[DebtorID], [TargetDebtors].[DebtorID],
	CASE [Matches].[Test]
		WHEN 'SSN' THEN [SourceDebtors].[SSN]
		WHEN 'Full Name' THEN [SourceDebtors].[name]
		WHEN 'Last Name' THEN [SourceDebtors].[name]
		WHEN 'Phone' THEN [SourceDebtors].[homephone]
		WHEN 'Date of Birth' THEN CONVERT(VARCHAR(10), [SourceDebtors].[DOB], 101)
		WHEN 'Driver License' THEN [SourceDebtors].[DLNum]
		WHEN 'Street Address' THEN [SourceDebtors].[Street1]
		WHEN 'City' THEN [SourceDebtors].[City]
		WHEN 'Zip Code' THEN [SourceDebtors].[ZipCode]
		WHEN 'Cust. Acct. #' THEN [Source].[account]
		WHEN 'ID1' THEN [Source].[ID1]
		WHEN 'ID2' THEN [Source].[ID2]
		ELSE 'PROBLEM'
	END AS [SourceData],
	CASE [Matches].[Test]
		WHEN 'SSN' THEN [TargetDebtors].[SSN]
		WHEN 'Full Name' THEN [TargetDebtors].[name]
		WHEN 'Last Name' THEN [TargetDebtors].[name]
		WHEN 'Phone' THEN [TargetDebtors].[homephone]
		WHEN 'Date of Birth' THEN CONVERT(VARCHAR(10), [TargetDebtors].[DOB], 101)
		WHEN 'Driver License' THEN [TargetDebtors].[DLNum]
		WHEN 'Street Address' THEN [TargetDebtors].[Street1]
		WHEN 'City' THEN [TargetDebtors].[City]
		WHEN 'Zip Code' THEN [TargetDebtors].[ZipCode]
		WHEN 'Cust. Acct. #' THEN [Target].[account]
		WHEN 'ID1' THEN [Target].[ID1]
		WHEN 'ID2' THEN [Target].[ID2]
		ELSE 'PROBLEM'
	END AS [TargetData]
FROM #Possibles AS [Possibles]
INNER JOIN #Matches AS [Matches]
ON [Possibles].[Source] = [Matches].[Source]
AND [Possibles].[Target] = [Matches].[Target]
INNER JOIN [master] AS [Source] WITH (NOLOCK)
ON [Matches].[Source] = [Source].[number]
INNER JOIN [master] AS [Target] WITH (NOLOCK)
ON [Matches].[Target] = [Target].[number]
LEFT OUTER JOIN [Debtors] AS [SourceDebtors] WITH (NOLOCK)
ON [Matches].[SourceDebtor] = [SourceDebtors].[DebtorID]
LEFT OUTER JOIN [Debtors] AS [TargetDebtors] WITH (NOLOCK)
ON [Matches].[TargetDebtor] = [TargetDebtors].[DebtorID];

INSERT INTO [dbo].[Linking_ResultTests] ([LinkID], [Test], [Score], [SourceDebtorID], [TargetDebtorID], [SourceData], [TargetData], [Exception])
SELECT [Possibles].[ID], [Exceptions].[Type], -1, NULL, NULL, [Exceptions].[SourceData], [Exceptions].[TargetData], [Exceptions].[Exception]
FROM #Possibles AS [Possibles]
INNER JOIN #Exceptions AS [Exceptions]
ON [Possibles].[ID] = [Exceptions].[ID];

COMMIT TRANSACTION;

IF OBJECT_ID('tempdb..#ToBeLinked') IS NOT NULL BEGIN
	DROP TABLE tempdb..#ToBeLinked
END;

RETURN 0;
GO

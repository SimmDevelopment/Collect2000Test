SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_DetermineLinkableAccounts]
WITH RECOMPILE
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

DECLARE @Evaluated DATETIME;

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

IF NOT EXISTS (SELECT * FROM #NewAccts) BEGIN
	RAISERROR('Linking temporary table %s contains no accounts to evaluate.', 16, 1, '#NewAccts');
	RETURN -1;
END;

SET @Evaluated = GETDATE();

IF OBJECT_ID('tempdb..#Config') IS NOT NULL BEGIN
	DROP TABLE tempdb..#Config	
END;

SELECT [Linking_EffectiveConfiguration].[Customer], [Linking_EffectiveConfiguration].[LinkThreshold], [Linking_EffectiveConfiguration].[PossibleLinkThreshold], [Linking_EffectiveConfiguration].[LastNameScore], [Linking_EffectiveConfiguration].[FullNameScore], [Linking_EffectiveConfiguration].[SSNScore], 
[Linking_EffectiveConfiguration].[PhoneScore], [Linking_EffectiveConfiguration].[DLNumScore], [Linking_EffectiveConfiguration].[DOBScore], [Linking_EffectiveConfiguration].[StreetScore], [Linking_EffectiveConfiguration].[CityScore], [Linking_EffectiveConfiguration].[ZipCodeScore], [Linking_EffectiveConfiguration].[AccountScore], [Linking_EffectiveConfiguration].[ID1Score], [Linking_EffectiveConfiguration].[ID2Score]
INTO #Config
FROM [Linking_EffectiveConfiguration] WITH (NOLOCK)
WHERE EXISTS (
	SELECT *
	FROM #NewAccts AS [NewAccts]
	WHERE [Linking_EffectiveConfiguration].[Customer] = [NewAccts].[Customer]
);

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[SSNScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing SSN data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'SSN' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[SSNScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[SSN_Hash] = [Target].[SSN_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE NOT [Source].[SSN_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[SSNScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[SSNScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[FullNameScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing full name data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'Full Name' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[FullNameScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[FirstName_Hash] = [Target].[FirstName_Hash]
	AND [Source].[LastName_Hash] = [Target].[LastName_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE NOT [Source].[FirstName_Hash] = 0
	AND NOT [Source].[LastName_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[FullNameScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[FullNameScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[PhoneScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing phone number data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'Phone' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[PhoneScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[Phone_Hash] = [Target].[Phone_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE NOT [Source].[Phone_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[PhoneScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[PhoneScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[DOBScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing Date of Birth data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'Date of Birth' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[DOBScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[DOB_Hash] = [Target].[DOB_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE NOT [Source].[DOB_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[DOBScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[DOBScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[DLNumScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing Driver License data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'Driver License' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[DLNumScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[DLNum_Hash] = [Target].[DLNum_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE NOT [Source].[DLNum_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[DLNumScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[DLNumScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[StreetScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing street address data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'Street Address' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[StreetScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[Street_Hash] = [Target].[Street_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE NOT [Source].[Street_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[StreetScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[StreetScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[AccountScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing account number data.';

	INSERT INTO #Matches ([Test], [Source], [Customer], [Target], [Score])
	SELECT 'Cust. Acct. #' AS [Test], [Source].[Number] AS [Source], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], [SourceConfiguration].[AccountScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[Account_Hash] = [Target].[Account_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	INNER JOIN [dbo].[master] AS [Source_master] WITH (NOLOCK)
	ON [Source].[Number] = [Source_master].[number]
	INNER JOIN [dbo].[master] AS [Target_master] WITH (NOLOCK)
	ON [Target].[Number] = [Target_master].[number]
	WHERE NOT [Source].[Account_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[AccountScore] > 0
	AND [Source_master].[account] = [Target_master].[account]
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[AccountScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[ID1Score] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing ID1 data.';

	INSERT INTO #Matches ([Test], [Source], [Customer], [Target], [Score])
	SELECT 'ID1' AS [Test], [Source].[Number] AS [Source], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], [SourceConfiguration].[ID1Score] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[ID1_Hash] = [Target].[ID1_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	INNER JOIN [dbo].[master] AS [Source_master] WITH (NOLOCK)
	ON [Source].[Number] = [Source_master].[number]
	INNER JOIN [dbo].[master] AS [Target_master] WITH (NOLOCK)
	ON [Target].[Number] = [Target_master].[number]
	WHERE NOT [Source].[ID1_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[ID1Score] > 0
	AND [Source_master].[id1] = [Target_master].[id1]
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[ID1Score];

END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[ID2Score] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing ID2 data.';

	INSERT INTO #Matches ([Test], [Source], [Customer], [Target], [Score])
	SELECT 'ID2' AS [Test], [Source].[Number] AS [Source], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], [SourceConfiguration].[ID2Score] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[ID2_Hash] = [Target].[ID2_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	INNER JOIN [dbo].[master] AS [Source_master] WITH (NOLOCK)
	ON [Source].[Number] = [Source_master].[number]
	INNER JOIN [dbo].[master] AS [Target_master] WITH (NOLOCK)
	ON [Target].[Number] = [Target_master].[number]
	WHERE NOT [Source].[ID2_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[ID2Score] > 0
	AND [Source_master].[id2] = [Target_master].[id2]
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[ID2Score];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[ZipCodeScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing zip code data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'Zip Code' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[ZipCodeScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[ZipCode_Hash] = [Target].[ZipCode_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE EXISTS (SELECT [Matches].[Source] FROM #Matches AS [Matches] WHERE [Matches].[Source] = [Source].[Number] AND [Matches].[Target] = [Target].[Number])
	AND NOT [Source].[ZipCode_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[ZipCodeScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[ZipCodeScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[CityScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing city data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'City' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[CityScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[City_Hash] = [Target].[City_Hash]
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE EXISTS (SELECT [Matches].[Source] FROM #Matches AS [Matches] WHERE [Matches].[Source] = [Source].[Number] AND [Matches].[Target] = [Target].[Number])
	AND NOT [Source].[City_Hash] = 0
	AND NOT [Source].[Number] = [Target].[Number]
	AND [SourceConfiguration].[CityScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[CityScore];
END;

IF EXISTS (SELECT * FROM #Config AS [Config] WHERE [Config].[LastNameScore] > 0) BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Comparing last name data.';

	INSERT INTO #Matches ([Test], [Source], [SourceDebtor], [Customer], [Target], [TargetDebtor], [Score])
	SELECT 'Last Name' AS [Test], [Source].[Number] AS [Source], MIN([Source].[DebtorID]) AS [SourceDebtor], [NewAccts].[Customer] AS [Customer], [Target].[Number] AS [Target], MIN([Target].[DebtorID]) AS [TargetDebtor], [SourceConfiguration].[LastNameScore] AS [Score]
	FROM [dbo].[Linking_HashData] AS [Source] WITH (NOLOCK)
	INNER JOIN [dbo].[Linking_HashData] AS [Target] WITH (NOLOCK)
	ON [Source].[LastName_Hash] = [Target].[LastName_Hash]
	AND (NOT [Source].[FirstName_Hash] = [Target].[FirstName_Hash]
		OR [Source].[FirstName_Hash] = 0)
	INNER JOIN #NewAccts AS [NewAccts]
	ON [Source].[number] = [NewAccts].[Number]
	INNER JOIN #Config AS [SourceConfiguration]
	ON [NewAccts].[Customer] = [SourceConfiguration].[Customer]
	WHERE EXISTS (SELECT [Matches].[Source] FROM #Matches AS [Matches] WHERE [Matches].[Source] = [Source].[Number] AND [Matches].[Target] = [Target].[Number])
	AND NOT EXISTS (SELECT [Matches].[Source] FROM #Matches AS [Matches] WHERE [Matches].[Source] = [Source].[Number] AND [Matches].[Target] = [Target].[Number] AND [Matches].[Test] = 'Full Name')
	AND NOT [Source].[Number] = [Target].[Number]
	AND NOT [Source].[LastName_Hash] = 0
	AND [SourceConfiguration].[LastNameScore] > 0
	AND [Source].[Seq] = 0
	AND [Target].[Seq] = 0
	GROUP BY [Source].[Number], [NewAccts].[Customer], [Target].[Number], [SourceConfiguration].[LastNameScore];
END;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Tallying total linking scores.';

INSERT INTO #Possibles ([Source], [Target], [PossibleLinkThreshold], [LinkThreshold], [TotalScore], [Link], [Evaluated])
SELECT [Matches].[Source],
	[Matches].[Target],
	[Config].[PossibleLinkThreshold],
	[Config].[LinkThreshold],
	SUM([Matches].[Score]) AS [TotalScore],
	CASE
		WHEN SUM([Matches].[Score]) > [Config].[LinkThreshold] THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [Link],
	@Evaluated AS [Evaluated]
FROM #Matches AS [Matches]
INNER JOIN #Config AS [Config]
ON [Matches].[Customer] = [Config].[Customer]
GROUP BY [Matches].[Source],
	[Matches].[Target],
	[Matches].[Customer],
	[Config].[PossibleLinkThreshold],
	[Config].[LinkThreshold]
HAVING SUM([Matches].[Score]) > [Config].[PossibleLinkThreshold];

DECLARE @PossiblesCount INT;
SELECT @PossiblesCount = COUNT(*) FROM #Possibles;
PRINT CONVERT(VARCHAR, GETDATE(), 120)  + ': Found ' + CONVERT(VARCHAR, @PossiblesCount)  + ' Possibilities.';

IF OBJECT_ID('tempdb..#Config') IS NOT NULL BEGIN
	DROP TABLE tempdb..#Config	
END;

RETURN 0;
GO

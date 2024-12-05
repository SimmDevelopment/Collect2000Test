SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_UpdateHashData] 
WITH RECOMPILE
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

	IF NOT OBJECT_ID('TempDB..#LinkingHashDataTest') IS NULL
	DROP TABLE #LinkingHashDataTest
	
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Updating missing link information.';
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Filter Accounts Start time';
	SELECT [master].[number],
			[Debtors].[DebtorID],
			[Debtors].[Seq],
			COALESCE(CASE
				WHEN [Debtors].[isParsed] = 1 AND [Debtors].[isBusiness] = 1 THEN LOWER(LTRIM(RTRIM([Debtors].[businessName])))
				WHEN [Debtors].[isParsed] = 1 THEN [dbo].[DoubleMetaPhone]([Debtors].[lastName])
				WHEN [Debtors].[isParsed] = 0 AND LEN([dbo].[GetBusinessNameEx]([Debtors].[name])) > 0 THEN [dbo].[DoubleMetaPhone]([dbo].[GetBusinessNameEx]([Debtors].[name]))
				ELSE [dbo].[DoubleMetaPhone]([dbo].[GetLastName]([Debtors].[name]))
			END, '') AS [LastName_Hash],
			COALESCE(CASE
				WHEN [Debtors].[isParsed] = 1 AND [Debtors].[isBusiness] = 1 THEN 'BUSINESS'
				WHEN [Debtors].[isParsed] = 1 THEN [dbo].[DoubleMetaPhone]([Debtors].[firstName]) 
				WHEN [Debtors].[isParsed] = 0 AND LEN([dbo].[GetBusinessNameEx]([Debtors].[name])) > 0 THEN 'BUSINESS'
				ELSE [dbo].[DoubleMetaPhone]([dbo].[GetFirstName]([Debtors].[name]))
			END, '') AS [FirstName_Hash],
			CAST(ISNULL([dbo].[ValidateSSN]([Debtors].[ssn]), '') AS INTEGER) AS [SSN_Hash],
			dbo.StripNonDigits(ISNULL([Debtors].[homephone], '')) AS [Phone_Hash],
			ISNULL([Debtors].[DLNum], '') AS [DLNum_Hash],
			CASE
				WHEN [Debtors].[DOB] IS NULL THEN 0
				WHEN [Debtors].[DOB] <= '1900-01-01' THEN 0
				ELSE [Debtors].[DOB]
			END AS [DOB_Hash],
			UPPER(LEFT(dbo.CompactWhiteSpace(ISNULL([Debtors].[Street1], '')), 10)) AS [Street_Hash], 
			UPPER(LEFT(ISNULL([Debtors].[city], ''), 8)) AS [City_Hash],
			LEFT(dbo.StripNonDigits(ISNULL([Debtors].[zipcode], '')), 5) AS [ZipCode_Hash],
			ISNULL([master].[account], '') AS [Account_Hash],
			ISNULL([master].[id1], '') AS [ID1_Hash],
			ISNULL([master].[id2], '') AS [ID2_Hash]
	INTO #LinkingHashDataTest
	FROM [dbo].[master] WITH (NOLOCK)
	INNER JOIN [dbo].[Debtors] WITH (NOLOCK)
	ON [master].[number] = [Debtors].[number]
	WHERE [master].customer IN (SELECT CUSTOMER FROM Linking_EffectiveConfiguration WITH (NOLOCK)
	WHERE LinkMode != 0
		)
	AND  NOT EXISTS (SELECT *
		FROM [dbo].[Linking_HashData] WITH (NOLOCK)
		WHERE [Debtors].[DebtorID] = [Linking_HashData].[DebtorID]
		);

	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Filter Accounts End time';
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Insert Hashing Data Start time';
	
	INSERT INTO [Linking_HashData] ([Number], [DebtorID], [Seq], [LastName_Hash], [FirstName_Hash], [SSN_Hash], [Phone_Hash], [DLNum_Hash], 
				[DOB_Hash], [Street_Hash], [City_Hash], [ZipCode_Hash], [Account_Hash], [ID1_Hash], [ID2_Hash])
	SELECT [Number],
		[DebtorID], 
		[Seq], 
		CHECKSUM([LastName_Hash]), 
		CHECKSUM([FirstName_Hash]), 
		[SSN_Hash],
		CHECKSUM([Phone_Hash]), 
		CHECKSUM([DLNum_Hash]), 
		CHECKSUM([DOB_Hash]), 
		CHECKSUM([Street_Hash]), 
		CHECKSUM([City_Hash]), 
		CHECKSUM([ZipCode_Hash]), 
		CHECKSUM([Account_Hash]), 
		CHECKSUM([ID1_Hash]), 
		CHECKSUM([ID2_Hash])
	FROM #LinkingHashDataTest

	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Insert Hashing Data End time';
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Updating changed link information.';

	IF OBJECT_ID('TempDB..#Update') IS NULL
	CREATE TABLE #Update(
		[DebtorID] INTEGER NOT NULL PRIMARY KEY 
	);
	
	IF OBJECT_ID('tempdb..#Completed') IS NOT NULL BEGIN
		DROP TABLE tempdb..#Completed	
	END;

	INSERT INTO #Update ([DebtorID])
	SELECT [DebtorID]
	FROM [dbo].[Linking_DataUpdateEvent] WITH (NOLOCK);

	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Update HashData Start time';
	WHILE @@ROWCOUNT > 0 BEGIN

		UPDATE TOP (10000) [dbo].[Linking_HashData]
		SET [Seq] =	[Debtors].[Seq],
			[LastName_Hash] = CHECKSUM(COALESCE(CASE
				WHEN [Debtors].[isParsed] = 1 AND [Debtors].[isBusiness] = 1 THEN LOWER(LTRIM(RTRIM([Debtors].[businessName])))
				WHEN [Debtors].[isParsed] = 1 THEN [dbo].[DoubleMetaPhone]([Debtors].[lastName])
				WHEN [Debtors].[isParsed] = 0 AND LEN([dbo].[GetBusinessNameEx]([Debtors].[name])) > 0 THEN [dbo].[DoubleMetaPhone]([dbo].[GetBusinessNameEx]([Debtors].[name]))
				ELSE [dbo].[DoubleMetaPhone]([dbo].[GetLastName]([Debtors].[name]))
				END, '')) ,
			[FirstName_Hash] = CHECKSUM(COALESCE(CASE
				WHEN [Debtors].[isParsed] = 1 AND [Debtors].[isBusiness] = 1 THEN 'BUSINESS'
				WHEN [Debtors].[isParsed] = 1 THEN [dbo].[DoubleMetaPhone]([Debtors].[firstName])
				WHEN [Debtors].[isParsed] = 0 AND LEN([dbo].[GetBusinessNameEx]([Debtors].[name])) > 0 THEN 'BUSINESS'
				ELSE [dbo].[DoubleMetaPhone]([dbo].[GetFirstName]([Debtors].[name]))
				END, '')) ,
			[SSN_Hash] = CAST(ISNULL([dbo].[ValidateSSN]([Debtors].[ssn]), '') AS INTEGER),
			[Phone_Hash] = CHECKSUM(dbo.StripNonDigits(ISNULL([Debtors].[homephone], ''))),
			[DLNum_Hash] = CHECKSUM(ISNULL([Debtors].[DLNum], '')),
			[DOB_Hash] = CASE
				WHEN [Debtors].[DOB] IS NULL THEN 0
				WHEN [Debtors].[DOB] <= '1900-01-01' THEN 0
				ELSE CHECKSUM([Debtors].[DOB])
				END,
			[Street_Hash] = CHECKSUM(UPPER(LEFT(dbo.CompactWhiteSpace(ISNULL([Debtors].[Street1], '')), 10))), 
			[City_Hash] = CHECKSUM(UPPER(LEFT(ISNULL([Debtors].[city], ''), 8))),
			[ZipCode_Hash] = CHECKSUM(LEFT(dbo.StripNonDigits(ISNULL([Debtors].[zipcode], '')), 5)),
			[Account_Hash] = CHECKSUM(ISNULL([master].[account], '')),
			[ID1_Hash] = CHECKSUM(ISNULL([master].[id1], '')),
			[ID2_Hash] = CHECKSUM(ISNULL([master].[id2], ''))

		OUTPUT INSERTED.DEBTORID INTO #Completed

		FROM #Update [Upd]
		INNER JOIN [dbo].[Debtors] WITH (NOLOCK) ON [Upd].[DebtorID] = [Debtors].[DebtorID]
		INNER JOIN [dbo].[master] WITH (NOLOCK)	ON [Debtors].[number] = [master].[number]
		INNER JOIN [dbo].[Linking_HashData] ON [Debtors].[DebtorID] = [Linking_HashData].[DebtorID]

		UPDATE  [dbo].[master]
		SET [link] = NULL
		FROM #Completed [Upd]
		INNER JOIN [dbo].[Debtors] ON [Upd].[DebtorID] = [Debtors].[DebtorID]
		INNER JOIN [dbo].[master] ON [Debtors].[Number] = [master].[number]
		WHERE [master].[link] = 0;

		DELETE FROM [dbo].[Linking_DataUpdateEvent]
		WHERE [DebtorID] IN (SELECT [DebtorID] FROM #Completed);


		DELETE FROM #Update WHERE [DebtorID] IN (SELECT [DebtorID] FROM #Completed);
	
		DELETE FROM #Completed

	END
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Update HashData End time';
	
	IF NOT OBJECT_ID('TempDB..#Update') IS NULL
	TRUNCATE TABLE #Update

	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Removing hashes of deleted accounts.';

	DELETE FROM [dbo].[Linking_HashData]
	WHERE NOT EXISTS (SELECT *
		FROM [dbo].[master]
		WHERE [Linking_HashData].[Number] = [master].[number]);

	DELETE FROM [dbo].[Linking_HashData]
	WHERE NOT EXISTS (SELECT *
		FROM [dbo].[Debtors]
		WHERE [Linking_HashData].[DebtorID] = [Debtors].[DebtorID]);

	IF OBJECT_ID('TempDB..#LinkingHashDataTest') IS NOT NULL
	DROP TABLE #LinkingHashDataTest
	
	IF OBJECT_ID('tempdb..#Completed') IS NOT NULL BEGIN
		DROP TABLE tempdb..#Completed	
	END;

RETURN 0;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Debtors_ParsedNamesView]
AS
WITH [ParsedNames] AS (
	SELECT
		[Debtors].[number] AS [Number],
		[Debtors].[DebtorID],
		[Debtors].[Seq] AS [Seq],
		ROW_NUMBER() OVER (PARTITION BY [Debtors].[number] ORDER BY CASE WHEN [Debtors].[Seq] = 0 THEN 0 ELSE 1 END, [Debtors].[Seq], [Debtors].[DebtorID]) AS [DebtorIndex],
		[Debtors].[name] AS [RawName],
		[Debtors].[isParsed] AS [IsParsed],
		CASE
			WHEN [Debtors].[isParsed] = 1
			THEN COALESCE([Debtors].[isBusiness], 0)
			WHEN LEN([dbo].[GetBusinessNameEx]([Debtors].[name])) > 0
			THEN 1
			ELSE 0
		END AS [IsBusiness],
		COALESCE(
			CASE
				WHEN [Debtors].[isParsed] = 1 THEN [Debtors].[gender]
				ELSE [dbo].[GetGenderEx]([Debtors].[name])
			END,
		'') AS [Gender],
		COALESCE(
			CASE
				WHEN [Debtors].[isParsed] = 1 THEN [Debtors].[prefix]
				ELSE [dbo].[GetPrefixEx]([Debtors].[name])
			END,
		'') AS [Prefix],
		COALESCE(
			CASE
				WHEN [Debtors].[isParsed] = 1 THEN [Debtors].[firstName]
				ELSE [dbo].[GetFirstNameEx]([Debtors].[name])
			END,
		'') AS [FirstName],
		COALESCE(
			CASE
				WHEN [Debtors].[isParsed] = 1 THEN [Debtors].[middleName]
				ELSE [dbo].[GetMiddleNameEx]([Debtors].[name])
			END,
		'') AS [MiddleName],
		COALESCE(
			CASE
				WHEN [Debtors].[isParsed] = 1 THEN [Debtors].[lastName]
				ELSE [dbo].[GetLastNameEx]([Debtors].[name])
			END,
		'') AS [LastName],
		COALESCE(
			CASE
				WHEN [Debtors].[isParsed] = 1 THEN [Debtors].[suffix]
				ELSE [dbo].[GetSuffixEx]([Debtors].[name])
			END,
		'') AS [Suffix],
		COALESCE(
			CASE
				WHEN [Debtors].[isParsed] = 1 THEN [Debtors].[businessName]
				ELSE [dbo].[GetBusinessNameEx]([Debtors].[name])
			END,
		'') AS [BusinessName]
	FROM [dbo].[Debtors]
), [Parts] AS (
	SELECT
		[ParsedNames].[DebtorID],
		[ParsedNames].[IsBusiness],
		CASE
			WHEN LEN(RTRIM(LTRIM([ParsedNames].[Prefix]))) > 0 THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT)
		END AS [HasPrefix],
		CASE
			WHEN LEN(RTRIM(LTRIM([ParsedNames].[FirstName]))) > 0 THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT)
		END AS [HasFirstName],
		CASE
			WHEN LEN(RTRIM(LTRIM([ParsedNames].[MiddleName]))) > 0 THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT)
		END AS [HasMiddleName],
		CASE
			WHEN LEN(RTRIM(LTRIM([ParsedNames].[LastName]))) > 0 THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT)
		END AS [HasLastName],
		CASE
			WHEN LEN(RTRIM(LTRIM([ParsedNames].[Suffix]))) > 0 THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT)
		END AS [HasSuffix]
	FROM [ParsedNames]
), [Formatted] AS (
	SELECT
		[ParsedNames].[DebtorID],
		CASE 
			WHEN [Parts].[HasFirstName] = 1 AND [Parts].[HasLastName] = 1
			THEN CASE
				WHEN [Parts].[HasMiddleName] = 1 AND [Parts].[HasSuffix] = 1
				THEN [ParsedNames].[LastName] + ', ' + [ParsedNames].[FirstName] + ' ' + SUBSTRING([ParsedNames].[MiddleName], 1, 1) + ' ' + [ParsedNames].[Suffix]
				WHEN [Parts].[HasMiddleName] = 1
				THEN [ParsedNames].[LastName] + ', ' + [ParsedNames].[FirstName] + ' ' + SUBSTRING([ParsedNames].[MiddleName], 1, 1)
				WHEN [Parts].[HasSuffix] = 1
				THEN [ParsedNames].[LastName] + ', ' + [ParsedNames].[FirstName] + ' ' + [ParsedNames].[Suffix]
				ELSE [ParsedNames].[LastName] + ', ' + [ParsedNames].[FirstName]
			END
			WHEN [Parts].[HasLastName] = 1 AND [Parts].[HasPrefix] = 1
			THEN CASE
				WHEN [Parts].[HasSuffix] = 1
				THEN [ParsedNames].[Prefix] + ' ' + [ParsedNames].[LastName] + ' ' + [ParsedNames].[Suffix]
				ELSE [ParsedNames].[Prefix] + ' ' + [ParsedNames].[LastName]
			END
			WHEN [Parts].[HasFirstName] = 1 AND [Parts].[HasMiddleName] = 1
			THEN [ParsedNames].[FirstName] + ' ' + SUBSTRING([ParsedNames].[MiddleName], 1, 1)
			WHEN [Parts].[HasFirstName] = 1
			THEN [ParsedNames].[FirstName]
			WHEN [Parts].[HasLastName] = 1
			THEN [ParsedNames].[LastName]
			ELSE ''
		END AS [FullName],
		CASE
			WHEN [Parts].[HasFirstName] = 1 AND [Parts].[HasLastName] = 1
			THEN CASE
				WHEN [Parts].[HasMiddleName] = 1 AND [Parts].[HasSuffix] = 1
				THEN [ParsedNames].[FirstName] + ' ' + SUBSTRING([ParsedNames].[MiddleName], 1, 1) + ' ' + [ParsedNames].[LastName] + ', ' + [ParsedNames].[Suffix]
				WHEN [Parts].[HasMiddleName] = 1
				THEN [ParsedNames].[FirstName] + ' ' + SUBSTRING([ParsedNames].[MiddleName], 1, 1) + ' ' + [ParsedNames].[LastName]
				WHEN [Parts].[HasSuffix] = 1
				THEN [ParsedNames].[FirstName] + ' ' + [ParsedNames].[LastName] + ', ' + [ParsedNames].[Suffix]
				ELSE [ParsedNames].[FirstName] + ' ' + [ParsedNames].[LastName]
			END
			WHEN [Parts].[HasLastName] = 1 AND [Parts].[HasPrefix] = 1
			THEN CASE
				WHEN [Parts].[HasSuffix] = 1
				THEN [ParsedNames].[Prefix] + ' ' + [ParsedNames].[LastName] + ' ' + [ParsedNames].[Suffix]
				ELSE [ParsedNames].[Prefix] + ' ' + [ParsedNames].[LastName]
			END
			WHEN [Parts].[HasFirstName] = 1 AND [Parts].[HasMiddleName] = 1
			THEN [ParsedNames].[FirstName] + ' ' + SUBSTRING([ParsedNames].[MiddleName], 1, 1)
			WHEN [Parts].[HasFirstName] = 1
			THEN [ParsedNames].[FirstName]
			WHEN [Parts].[HasLastName] = 1
			THEN [ParsedNames].[LastName]
			ELSE ''
		END AS [FirstNameFirst]
	FROM [ParsedNames]
	INNER JOIN [Parts]
	ON [ParsedNames].[DebtorID] = [Parts].[DebtorID]
)
SELECT
	[ParsedNames].[Number],
	[ParsedNames].[DebtorID],
	[ParsedNames].[Seq],
	[ParsedNames].[DebtorIndex],
	[ParsedNames].[RawName],
	[ParsedNames].[IsParsed],
	[ParsedNames].[IsBusiness],
	CASE [ParsedNames].[IsBusiness]
		WHEN 1 THEN 'C'
		ELSE [ParsedNames].[Gender]
	END AS [Gender],
	[ParsedNames].[Prefix],
	[ParsedNames].[FirstName],
	[ParsedNames].[MiddleName],
	[ParsedNames].[LastName],
	[ParsedNames].[Suffix],
	[ParsedNames].[BusinessName],
	[Formatted].[FullName],
	[Formatted].[FirstNameFirst],
	CASE [ParsedNames].[IsBusiness]
		WHEN 1 THEN [ParsedNames].[BusinessName]
		ELSE [Formatted].[FullName]
	END AS [FormattedName]
FROM [ParsedNames]
INNER JOIN [Parts]
ON [ParsedNames].[DebtorID] = [Parts].[DebtorID]
INNER JOIN [Formatted]
ON [ParsedNames].[DebtorID] = [Formatted].[DebtorID];


GO

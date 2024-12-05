SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_DetermineLinkExceptions]
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

IF OBJECT_ID('tempdb..#Permitted') IS NOT NULL BEGIN
	DROP TABLE tempdb..#Permitted	
END;

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

/*

Linking_Configuration Flags
	LinkMode:
		0 - do not link
		1 - link within same customer
		2 - link within same class of business
		3 - link within customer group

	DeskLinkingMode:
		0 - require that any open account permit linking
		1 - require that all open accounts permit linking
		2 - require that any account permit linking
		3 - require that all accounts permit linking

*/

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Evaluating linking exceptions.';

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Evaluating status of existing linked accounts.';

SELECT [Pairs].[Source] AS [Number],
	[Pairs].[Target] AS [Linked],
	CASE
		WHEN [master].[qlevel] IN ('998', '999') THEN CAST(0 AS BIT)
		ELSE CAST(1 AS BIT)
	END AS [Open],
	CASE
		WHEN [master].[PreventLinking] = 0 AND [desk].[PreventLinking] = 0
		THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [Permitted]
INTO #Permitted
FROM (
	SELECT [Possibles].[Source] AS [Source],
		[Linking_LinkedAccounts].[linked_number] AS [Target]
	FROM #Possibles AS [Possibles]
	INNER JOIN [dbo].[Linking_LinkedAccounts] WITH (NOLOCK)
	ON [Possibles].[Source] = [Linking_LinkedAccounts].[number]
	UNION
	SELECT [Possibles].[Target] AS [Source],
		[Linking_LinkedAccounts].[linked_number] AS [Target]
	FROM #Possibles AS [Possibles]
	INNER JOIN [dbo].[Linking_LinkedAccounts] WITH (NOLOCK)
	ON [Possibles].[Target] = [Linking_LinkedAccounts].[number]
) AS [Pairs]
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [master].[number] = [Pairs].[Target]
INNER JOIN [dbo].[desk] WITH (NOLOCK)
ON [desk].[code] = [master].[desk]
OPTION (RECOMPILE);


PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Insert into Permitted complete.';

INSERT INTO #Exceptions ([ID], [Type], [Exception])
SELECT [Possibles].[ID], 'DoNotLink', 'Account #' + CAST([Possibles].[Source] AS VARCHAR(50)) + ' is not permitted to link to account #' + CAST([Possibles].[Target] AS VARCHAR(50)) + '.'
FROM #Possibles AS [Possibles]
INNER JOIN [dbo].[Linking_DoNotLink] WITH (NOLOCK)
ON ([Possibles].[Source] = [Linking_DoNotLink].[Source]
	AND [Possibles].[Target] = [Linking_DoNotLink].[Target])
OR ([Possibles].[Source] = [Linking_DoNotLink].[Target]
	AND [Possibles].[Target] = [Linking_DoNotLink].[Source]);

INSERT INTO #Exceptions ([ID], [Type], [Exception])
SELECT [Possibles].[ID], 'DoNotLink', 'Account #' + CAST([Possibles].[Source] AS VARCHAR(50)) + ' is linked to account #' + CAST([linked].[number] AS VARCHAR(50)) + ' which is not permitted to link to account #' + CAST([Possibles].[Target] AS VARCHAR(50)) + '.'
FROM #Possibles AS [Possibles]
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [Possibles].[Source] = [master].[number]
INNER JOIN [dbo].[master] AS [linked] WITH (NOLOCK)
ON [master].[link] = [linked].[link]
AND [master].[number] <> [linked].[number]
INNER JOIN [dbo].[Linking_DoNotLink] WITH (NOLOCK)
ON ([Possibles].[Target] = [Linking_DoNotLink].[Source]
	AND [linked].[number] = [Linking_DoNotLink].[Target])
OR ([Possibles].[Target] = [Linking_DoNotLink].[Target]
	AND [linked].[number] = [Linking_DoNotLink].[Source])
LEFT OUTER JOIN #Exceptions AS [Exceptions]
ON [Exceptions].[ID] = [Possibles].[ID]
WHERE [master].[link] IS NOT NULL
AND [master].[link] <> 0
AND [Exceptions].[ID] IS NULL;

INSERT INTO #Exceptions ([ID], [Type], [Exception])
SELECT [Possibles].[ID], 'DoNotLink', 'Account #' + CAST([Possibles].[Target] AS VARCHAR(50)) + ' is linked to account #' + CAST([linked].[number] AS VARCHAR(50)) + ' which is not permitted to link to account #' + CAST([Possibles].[Source] AS VARCHAR(50)) + '.'
FROM #Possibles AS [Possibles]
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [Possibles].[Target] = [master].[number]
INNER JOIN [dbo].[master] AS [linked] WITH (NOLOCK)
ON [master].[link] = [linked].[link]
AND [master].[number] <> [linked].[number]
INNER JOIN [dbo].[Linking_DoNotLink] WITH (NOLOCK)
ON ([Possibles].[Source] = [Linking_DoNotLink].[Source]
	AND [linked].[number] = [Linking_DoNotLink].[Target])
OR ([Possibles].[Source] = [Linking_DoNotLink].[Target]
	AND [linked].[number] = [Linking_DoNotLink].[Source])
LEFT OUTER JOIN #Exceptions AS [Exceptions]
ON [Exceptions].[ID] = [Possibles].[ID]
WHERE [master].[link] IS NOT NULL
AND [master].[link] <> 0
AND [Exceptions].[ID] IS NULL;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Evaluating link mode exceptions.';

INSERT INTO #Exceptions ([ID], [Type], [SourceData], [TargetData], [Exception])
SELECT [E].[ID], 
	CASE [E].[ExceptionCode]
		WHEN 0 THEN 'LinkMode(None)'
		WHEN 1 THEN 'LinkMode(None)'
		WHEN 2 THEN 'LinkMode(Customer)'
		WHEN 3 THEN 'LinkMode(Customer)'
		WHEN 4 THEN 'LinkMode(Class)'
		WHEN 5 THEN 'LinkMode(Class)'
		WHEN 6 THEN 'LinkMode(Group)'
		WHEN 7 THEN 'LinkMode(Group)'
	END AS [Type],
	CASE [E].[ExceptionCode]
		WHEN 0 THEN CAST(NULL AS VARCHAR(500))
		WHEN 1 THEN CAST(NULL AS VARCHAR(500))
		WHEN 2 THEN [E].[SourceCustomer]
		WHEN 3 THEN [E].[SourceCustomer]
		WHEN 4 THEN [E].[SourceClass]
		WHEN 5 THEN [E].[SourceClass]
		WHEN 6 THEN [E].[SourceCustomerGroup]
		WHEN 7 THEN CAST(NULL AS VARCHAR(500))
	END AS [SourceData],
	CASE [E].[ExceptionCode]
		WHEN 0 THEN CAST(NULL AS VARCHAR(500))
		WHEN 1 THEN CAST(NULL AS VARCHAR(500))
		WHEN 2 THEN [E].[TargetCustomer]
		WHEN 3 THEN [E].[TargetCustomer]
		WHEN 4 THEN [E].[TargetClass]
		WHEN 5 THEN [E].[TargetClass]
		WHEN 6 THEN CAST(NULL AS VARCHAR(500))
		WHEN 7 THEN [E].[TargetCustomerGroup]
	END AS [TargetData],
	CASE [E].[ExceptionCode]
		WHEN 0 THEN 'Source account does not permit linking to other accounts'
		WHEN 1 THEN 'Target account does not permit linking to other accounts'
		WHEN 2 THEN 'Source account does not permit linking to accounts in other customers'
		WHEN 3 THEN 'Target account does not permit linking to accounts in other customers'
		WHEN 4 THEN 'Source account does not permit linking to accounts in other business classes'
		WHEN 5 THEN 'Target account does not permit linking to accounts in other business classes'
		WHEN 6 THEN 'Source account does not permit linking to accounts in customers not assigned to customer group ' + [E].[SourceCustomerGroup]
		WHEN 7 THEN 'Target account does not permit linking to accounts in customers not assigned to customer group ' + [E].[TargetCustomerGroup]
	END AS [Exception]
FROM (
	SELECT
		[Possibles].[ID],
		[Possibles].[Source],
		[Possibles].[Target],
		[SourceCustomer].[Customer] AS [SourceCustomer],
		[TargetCustomer].[Customer] AS [TargetCustomer],
		[SourceCustomer].[COB] AS [SourceClass],
		[TargetCustomer].[COB] AS [TargetClass],
		[SourceCustomerGroup].[Name] AS [SourceCustomerGroup],
		[TargetCustomerGroup].[Name] AS [TargetCustomerGroup],
		CASE
			WHEN [SourceConfiguration].[LinkMode] = 0
			THEN 0
			WHEN [TargetConfiguration].[LinkMode] = 0
			THEN 1
			WHEN [SourceConfiguration].[LinkMode] = 1 AND NOT [SourceMaster].[customer] = [TargetMaster].[customer]
			THEN 2
			WHEN [TargetConfiguration].[LinkMode] = 1 AND NOT [SourceMaster].[customer] = [TargetMaster].[customer]
			THEN 3
			WHEN [SourceConfiguration].[LinkMode] = 2 AND NOT COALESCE([SourceMaster].[ClassOfBusiness], [SourceCustomer].[COB], '') = COALESCE([TargetMaster].[ClassOfBusiness], [TargetCustomer].[COB], '')
			THEN 4
			WHEN [TargetConfiguration].[LinkMode] = 2 AND NOT COALESCE([SourceMaster].[ClassOfBusiness], [SourceCustomer].[COB], '') = COALESCE([TargetMaster].[ClassOfBusiness], [TargetCustomer].[COB], '')
			THEN 5
			WHEN [SourceConfiguration].[LinkMode] = 3
				AND NOT EXISTS (SELECT *
					FROM [Fact] AS [SourceGroup] WITH (NOLOCK)
					INNER JOIN [Fact] AS [TargetGroup] WITH (NOLOCK)
					ON [SourceGroup].[CustomGroupID] = [TargetGroup].[CustomGroupID]
					WHERE [SourceGroup].[CustomGroupID] = [SourceConfiguration].[CustomGroupID]
					AND [SourceGroup].[CustomerID] = [SourceMaster].[customer]
					AND [TargetGroup].[CustomerID] = [TargetMaster].[customer])
			THEN 6
			WHEN [TargetConfiguration].[LinkMode] = 3
				AND NOT EXISTS (SELECT *
					FROM [Fact] AS [SourceGroup] WITH (NOLOCK)
					INNER JOIN [Fact] AS [TargetGroup] WITH (NOLOCK)
					ON [SourceGroup].[CustomGroupID] = [TargetGroup].[CustomGroupID]
					WHERE [TargetGroup].[CustomGroupID] = [SourceConfiguration].[CustomGroupID]
					AND [SourceGroup].[CustomerID] = [SourceMaster].[customer]
					AND [TargetGroup].[CustomerID] = [TargetMaster].[customer])
			THEN 7
			ELSE NULL
		END AS [ExceptionCode]
	FROM #Possibles AS [Possibles]
	INNER JOIN [master] AS [SourceMaster] WITH (NOLOCK)
	ON [Possibles].[Source] = [SourceMaster].[number]
	INNER JOIN [master] AS [TargetMaster] WITH (NOLOCK)
	ON [Possibles].[Target] = [TargetMaster].[number]
	INNER JOIN [vCustomerCOB] AS [SourceCustomer] WITH (NOLOCK)
	ON [SourceMaster].[customer] = [SourceCustomer].[customer]
	INNER JOIN [vCustomerCOB] AS [TargetCustomer] WITH (NOLOCK)
	ON [TargetMaster].[customer] = [TargetCustomer].[customer]
	INNER JOIN [Linking_EffectiveConfiguration] AS [SourceConfiguration] WITH (NOLOCK)
	ON [SourceMaster].[customer] = [SourceConfiguration].[Customer]
	INNER JOIN [Linking_EffectiveConfiguration] AS [TargetConfiguration] WITH (NOLOCK)
	ON [TargetMaster].[customer] = [TargetConfiguration].[Customer]
	LEFT OUTER JOIN [dbo].[CustomCustGroups] AS [SourceCustomerGroup] WITH (NOLOCK)
	ON [SourceConfiguration].[CustomGroupID] = [SourceCustomerGroup].[ID]
	LEFT OUTER JOIN [dbo].[CustomCustGroups] AS [TargetCustomerGroup] WITH (NOLOCK)
	ON [TargetConfiguration].[CustomGroupID] = [TargetCustomerGroup].[ID]
) AS [E]
WHERE [E].[ExceptionCode] IS NOT NULL;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Evaluating cross branch exceptions.';

INSERT INTO #Exceptions ([ID], [Type], [SourceData], [TargetData], [Exception])
SELECT [E].[ID], 
	CASE [E].[ExceptionCode]
		WHEN 0 THEN 'CrossBranch'
		WHEN 1 THEN 'CrossBranch'
	END AS [Type],
	[E].[SourceBranch] AS [SourceData],
	[E].[TargetBranch] AS [TargetData],
	CASE [E].[ExceptionCode]
		WHEN 0 THEN 'Source account does not permit linking to accounts in other branches'
		WHEN 1 THEN 'Target account does not permit linking to accounts in other branches'
	END AS [Exception]
FROM (
	SELECT
		[Possibles].[ID],
		[Possibles].[Source],
		[Possibles].[Target],
		[SourceDesk].[branch] AS [SourceBranch],
		[TargetDesk].[branch] AS [TargetBranch],
		CASE
			WHEN [SourceConfiguration].[CrossBranch] = 0
			THEN 0
			WHEN [TargetConfiguration].[CrossBranch] = 0
			THEN 1
			ELSE NULL
		END AS [ExceptionCode]
	FROM #Possibles AS [Possibles]
	INNER JOIN [master] AS [SourceMaster] WITH (NOLOCK)
	ON [Possibles].[Source] = [SourceMaster].[number]
	INNER JOIN [master] AS [TargetMaster] WITH (NOLOCK)
	ON [Possibles].[Target] = [TargetMaster].[number]
	INNER JOIN [desk] AS [SourceDesk] WITH (NOLOCK)
	ON [SourceMaster].[desk] = [SourceDesk].[code]
	INNER JOIN [desk] AS [TargetDesk] WITH (NOLOCK)
	ON [TargetMaster].[desk] = [TargetDesk].[code]
	INNER JOIN [Linking_EffectiveConfiguration] AS [SourceConfiguration] WITH (NOLOCK)
	ON [SourceMaster].[customer] = [SourceConfiguration].[Customer]
	INNER JOIN [Linking_EffectiveConfiguration] AS [TargetConfiguration] WITH (NOLOCK)
	ON [TargetMaster].[customer] = [TargetConfiguration].[Customer]
	WHERE NOT [SourceDesk].[branch] = [TargetDesk].[branch]
) AS [E]
WHERE [E].[ExceptionCode] IS NOT NULL;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Evaluating desk mode exceptions.';

INSERT INTO #Exceptions ([ID], [Type], [SourceData], [TargetData], [Exception])
SELECT [E].[ID], 
	CASE [E].[ExceptionCode]
		WHEN 0 THEN 'DeskLink(AllOpen)'
		WHEN 1 THEN 'DeskLink(AllOpen)'
		WHEN 2 THEN 'DeskLink(AnyOpen)'
		WHEN 3 THEN 'DeskLink(AnyOpen)'
		WHEN 4 THEN 'DeskLink(All)'
		WHEN 5 THEN 'DeskLink(All)'
		WHEN 6 THEN 'DeskLink(Any)'
		WHEN 7 THEN 'DeskLink(Any)'
	END AS [Type],
	[E].[SourceDesk] AS [SourceData],
	[E].[TargetDesk] AS [TargetData],
	CASE [E].[ExceptionCode]
		WHEN 0 THEN 'Source account does not permit linking when all open accounts do not permit linking'
		WHEN 1 THEN 'Target account does not permit linking when all open accounts do not permit linking'
		WHEN 2 THEN 'Source account does not permit linking when any open account does not permit linking'
		WHEN 3 THEN 'Target account does not permit linking when any open account does not permit linking'
		WHEN 4 THEN 'Source account does not permit linking when all accounts do not permit linking'
		WHEN 5 THEN 'Target account does not permit linking when all accounts do not permit linking'
		WHEN 6 THEN 'Source account does not permit linking when any account does not permit linking'
		WHEN 7 THEN 'Target account does not permit linking when any account does not permit linking'
	END AS [Exception]
FROM (
	SELECT
		[Possibles].[ID],
		[Possibles].[Source],
		[Possibles].[Target],
		[SourceMaster].[desk] AS [SourceDesk],
		[TargetMaster].[desk] AS [TargetDesk],
		CASE
			WHEN [SourceConfiguration].[DeskLinkingMode] = 0
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Open] = 1
				)
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Open] = 1
					AND [Permitted].[Permitted] = 0
				)
			THEN 0
			WHEN [SourceConfiguration].[DeskLinkingMode] = 0
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Open] = 1
				)
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Permitted] = 0
				)
			THEN 0
			WHEN [TargetConfiguration].[DeskLinkingMode] = 0
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Open] = 1
				)
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Open] = 1
					AND [Permitted].[Permitted] = 0
				)
			THEN 1
			WHEN [TargetConfiguration].[DeskLinkingMode] = 0
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Open] = 1
				)
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Permitted] = 0
				)
			THEN 1
			WHEN [SourceConfiguration].[DeskLinkingMode] = 1
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Open] = 1
				)
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Open] = 1
					AND [Permitted].[Permitted] = 1
				)
			THEN 2
			WHEN [SourceConfiguration].[DeskLinkingMode] = 1
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Open] = 1
				)
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Permitted] = 1
				)
			THEN 2
			WHEN [TargetConfiguration].[DeskLinkingMode] = 1
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Open] = 1
				)
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Open] = 1
					AND [Permitted].[Permitted] = 1
				)
			THEN 3
			WHEN [TargetConfiguration].[DeskLinkingMode] = 1
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Open] = 1
				)
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Permitted] = 1
				)
			THEN 3
			WHEN [SourceConfiguration].[DeskLinkingMode] = 2
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Permitted] = 0
				)
			THEN 4
			WHEN [TargetConfiguration].[DeskLinkingMode] = 2
				AND EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Permitted] = 0
				)
			THEN 5
			WHEN [SourceConfiguration].[DeskLinkingMode] = 3
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Target]
					AND [Permitted].[Permitted] = 1
				)
			THEN 6
			WHEN [TargetConfiguration].[DeskLinkingMode] = 3
				AND NOT EXISTS (SELECT *
					FROM #Permitted AS [Permitted]
					WHERE [Permitted].[Number] = [Possibles].[Source]
					AND [Permitted].[Permitted] = 1
				)
			THEN 7
			ELSE NULL
		END AS [ExceptionCode]
	FROM #Possibles AS [Possibles]
	INNER JOIN [master] AS [SourceMaster] WITH (NOLOCK)
	ON [Possibles].[Source] = [SourceMaster].[number]
	INNER JOIN [master] AS [TargetMaster] WITH (NOLOCK)
	ON [Possibles].[Target] = [TargetMaster].[number]
	INNER JOIN [desk] AS [SourceDesk] WITH (NOLOCK)
	ON [SourceMaster].[desk] = [SourceDesk].[code]
	INNER JOIN [desk] AS [TargetDesk] WITH (NOLOCK)
	ON [TargetMaster].[desk] = [TargetDesk].[code]
	INNER JOIN [Linking_EffectiveConfiguration] AS [SourceConfiguration] WITH (NOLOCK)
	ON [SourceMaster].[customer] = [SourceConfiguration].[Customer]
	INNER JOIN [Linking_EffectiveConfiguration] AS [TargetConfiguration] WITH (NOLOCK)
	ON [TargetMaster].[customer] = [TargetConfiguration].[Customer]
) AS [E]
WHERE [E].[ExceptionCode] IS NOT NULL;

UPDATE [Possibles]
SET [Link] = 0
FROM #Possibles AS [Possibles]
INNER JOIN #Exceptions AS [Exceptions]
ON [Possibles].[ID] = [Exceptions].[ID]
WHERE [Possibles].[Link] = 1;


Drop Table tempdb..#Permitted
RETURN 0;
GO

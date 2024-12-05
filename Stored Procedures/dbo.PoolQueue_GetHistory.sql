SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PoolQueue_GetHistory] @Name VARCHAR(255) = NULL, @Version BINARY(8) = NULL, @UserID INTEGER = NULL, @StartDate DATETIME = NULL, @EndDate DATETIME = NULL
WITH RECOMPILE
AS
SET NOCOUNT ON;

IF @Name IS NULL BEGIN
	SELECT [pools].[Name],
		[pools].[Description],
		[pools].[Version] AS [CurrentVersion],
		ISNULL([Users].[LoginName], 'GLOBAL') AS [LastModifiedBy],
		[pools].[StartDate] AS [LastModified],
		ISNULL(SUM(DATEDIFF(SECOND, [work].[StartDate], [work].[EndDate])), 0) AS [TimeSeconds],
		ISNULL(SUM([work].[Accounts]), 0) AS [Queued],
		ISNULL(SUM([work].[Worked]), 0) AS [Worked],
		ISNULL(SUM([work].[Contacted]), 0) AS [Contacted]
	FROM [dbo].[PoolQueueDefinitions_History] AS [pools] WITH (NOLOCK)
	LEFT OUTER JOIN [dbo].[Users] WITH (NOLOCK)
	ON [pools].[ChangedBy] = [Users].[ID]
	LEFT OUTER JOIN [dbo].[PoolQueueAssignments_WorkHistory] AS [work] WITH (NOLOCK)
	ON [pools].[ID] = [work].[DefinitionID]
	WHERE [pools].[UID] = (SELECT TOP 1 [in].[UID]
		FROM [dbo].[PoolQueueDefinitions_History] AS [in]
		WHERE [pools].[Name] = [in].[Name]
		ORDER BY [in].[StartDate])
	GROUP BY [pools].[Name],
		[pools].[Description],
		[pools].[Version],
		ISNULL([Users].[LoginName], 'GLOBAL'),
		[pools].[StartDate]
	ORDER BY [pools].[Name];
END;
ELSE IF @Version IS NULL BEGIN
	SELECT [pools].[Name],
		[pools].[Description],
		[pools].[Version] AS [Version],
		ISNULL([Users].[LoginName], 'GLOBAL') AS [ModifiedBy],
		[pools].[StartDate] AS [Modified],
		ISNULL(SUM(DATEDIFF(SECOND, [work].[StartDate], [work].[EndDate])), 0) AS [TimeSeconds],
		ISNULL(SUM([work].[Accounts]), 0) AS [Queued],
		ISNULL(SUM([work].[Worked]), 0) AS [Worked],
		ISNULL(SUM([work].[Contacted]), 0) AS [Contacted]
	FROM [dbo].[PoolQueueDefinitions_History] AS [pools] WITH (NOLOCK)
	LEFT OUTER JOIN [dbo].[Users] WITH (NOLOCK)
	ON [pools].[ChangedBy] = [Users].[ID]
	LEFT OUTER JOIN [dbo].[PoolQueueAssignments_WorkHistory] AS [work] WITH (NOLOCK)
	ON [pools].[ID] = [work].[DefinitionID]
	AND [pools].[Version] = [work].[Version]
	WHERE [pools].[Name] = @Name
	GROUP BY [pools].[Name],
		[pools].[Description],
		[pools].[Version],
		ISNULL([Users].[LoginName], 'GLOBAL'),
		[pools].[StartDate]
	ORDER BY [pools].[Name],
		[pools].[Version];
END;
ELSE IF @UserID IS NULL BEGIN
	SELECT [pools].[Name],
		[pools].[Description],
		[pools].[Version] AS [Version],
		ISNULL([Users].[LoginName], 'GLOBAL') AS [ModifiedBy],
		[pools].[StartDate] AS [Modified],
		ISNULL([PoolUsers].[ID], 0) AS [UserID],
		ISNULL([PoolUsers].[LoginName], 'GLOBAL') AS [User],
		ISNULL(SUM(DATEDIFF(SECOND, [work].[StartDate], [work].[EndDate])), 0) AS [TimeSeconds],
		ISNULL(SUM([work].[Accounts]), 0) AS [Queued],
		ISNULL(SUM([work].[Worked]), 0) AS [Worked],
		ISNULL(SUM([work].[Contacted]), 0) AS [Contacted]
	FROM [dbo].[PoolQueueDefinitions_History] AS [pools] WITH (NOLOCK)
	LEFT OUTER JOIN [dbo].[Users] WITH (NOLOCK)
	ON [pools].[ChangedBy] = [Users].[ID]
	LEFT OUTER JOIN [dbo].[PoolQueueAssignments_WorkHistory] AS [work] WITH (NOLOCK)
	ON [pools].[ID] = [work].[DefinitionID]
	AND [pools].[Version] = [work].[Version]
	LEFT OUTER JOIN [dbo].[Users] AS [PoolUsers] WITH (NOLOCK)
	ON [work].[UserID] = [PoolUsers].[ID]
	WHERE [pools].[Name] = @Name
	AND [pools].[Version] = @Version
	GROUP BY [pools].[Name],
		[pools].[Description],
		[pools].[Version],
		ISNULL([Users].[LoginName], 'GLOBAL'),
		[pools].[StartDate],
		ISNULL([PoolUsers].[ID], 0),
		ISNULL([PoolUsers].[LoginName], 'GLOBAL')
	ORDER BY [pools].[Name],
		[pools].[Version],
		ISNULL([PoolUsers].[LoginName], 'GLOBAL');
END;
ELSE BEGIN
	SELECT [pools].[Name],
		[pools].[Description],
		[pools].[Version] AS [Version],
		ISNULL([Users].[LoginName], 'GLOBAL') AS [ModifiedBy],
		[pools].[StartDate] AS [Modified],
		ISNULL([PoolUsers].[ID], 0) AS [UserID],
		ISNULL([PoolUsers].[LoginName], 'GLOBAL') AS [User],
		[work].[StartDate],
		[work].[EndDate],
		DATEDIFF(SECOND, [work].[StartDate], [work].[EndDate]) AS [TimeSeconds],
		ISNULL([work].[Accounts], 0) AS [Queued],
		ISNULL([work].[Worked], 0) AS [Worked],
		ISNULL([work].[Contacted], 0) AS [Contacted]
	FROM [dbo].[PoolQueueDefinitions_History] AS [pools] WITH (NOLOCK)
	LEFT OUTER JOIN [dbo].[Users] WITH (NOLOCK)
	ON [pools].[ChangedBy] = [Users].[ID]
	LEFT OUTER JOIN [dbo].[PoolQueueAssignments_WorkHistory] AS [work] WITH (NOLOCK)
	ON [pools].[ID] = [work].[DefinitionID]
	AND [pools].[Version] = [work].[Version]
	LEFT OUTER JOIN [dbo].[Users] AS [PoolUsers] WITH (NOLOCK)
	ON [work].[UserID] = [PoolUsers].[ID]
	WHERE [pools].[Name] = @Name
	AND [pools].[Version] = @Version
	AND [work].[UserID] = @UserID
	AND ([work].[StartDate] >= @StartDate
		OR @StartDate IS NULL)
	AND ([work].[EndDate] >= @EndDate
		OR @EndDate IS NULL)
	ORDER BY [pools].[Name],
		[pools].[Version],
		ISNULL([PoolUsers].[LoginName], 'GLOBAL');
END;

RETURN 0;

GO

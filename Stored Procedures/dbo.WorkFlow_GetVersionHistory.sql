SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_GetVersionHistory] @ID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

SELECT [WorkFlows].[Name],
	[WorkFlows].[Version] AS [Version],
	CASE
		WHEN [Users].[ID] IS NOT NULL
		THEN [Users].[LoginName]
		WHEN [Users].[ID] IS NULL AND [WorkFlows].[ModifiedBy] = 0
		THEN 'ADMIN'
		ELSE 'UNKNOWN'
	END AS [LoginName],
	CASE
		WHEN [Users].[ID] IS NOT NULL
		THEN [Users].[UserName]
		WHEN [Users].[ID] IS NULL AND [WorkFlows].[ModifiedBy] = 0
		THEN 'Administrator'
		ELSE 'Unknown User'
	END AS [UserName],
	[WorkFlows].[ModifiedDate],
	COUNT(ALL [WorkFlow_Activities].[Version]) AS [ActivitiesUpdated]
FROM [dbo].[WorkFlows]
LEFT OUTER JOIN [dbo].[Users]
ON [WorkFlows].[ModifiedBy] = [Users].[ID]
LEFT OUTER JOIN [dbo].[WorkFlow_Activities]
ON [WorkFlows].[ID] = [WorkFlow_Activities].[WorkFlowID]
AND [WorkFlows].[Version] = [WorkFlow_Activities].[Version]
WHERE [WorkFlows].[ID] = @ID
GROUP BY [WorkFlows].[Name], [WorkFlows].[Version], [Users].[ID], [WorkFlows].[ModifiedBy], [Users].[LoginName], [Users].[UserName], [WorkFlows].[ModifiedDate]
UNION ALL
SELECT [WorkFlow_VersionHistory].[Name],
	[WorkFlow_VersionHistory].[Version] AS [Version],
	CASE
		WHEN [Users].[ID] IS NOT NULL
		THEN [Users].[LoginName]
		WHEN [Users].[ID] IS NULL AND [WorkFlow_VersionHistory].[ModifiedBy] = 0
		THEN 'ADMIN'
		ELSE 'UNKNOWN'
	END AS [LoginName],
	CASE
		WHEN [Users].[ID] IS NOT NULL
		THEN [Users].[UserName]
		WHEN [Users].[ID] IS NULL AND [WorkFlow_VersionHistory].[ModifiedBy] = 0
		THEN 'Administrator'
		ELSE 'Unknown User'
	END AS [UserName],
	[WorkFlow_VersionHistory].[ModifiedDate],
	COUNT(ALL [WorkFlow_ActivityVersionHistory].[Version]) AS [ActivitiesUpdated]
FROM [WorkFlow_VersionHistory]
LEFT OUTER JOIN [dbo].[Users]
ON [WorkFlow_VersionHistory].[ModifiedBy] = [Users].[ID]
LEFT OUTER JOIN (
	SELECT [ID], [WorkFlowID], [Version]
	FROM [dbo].[WorkFlow_Activities]
	WHERE [WorkFlowID] = @ID
	UNION ALL
	SELECT [ID], [WorkFlowID], [Version]
	FROM [dbo].[WorkFlow_ActivityVersionHistory]
	WHERE [WorkFlowID] = @ID
) AS [WorkFlow_ActivityVersionHistory]
ON [WorkFlow_VersionHistory].[ID] = [WorkFlow_ActivityVersionHistory].[WorkFlowID]
AND [WorkFlow_VersionHistory].[Version] = [WorkFlow_ActivityVersionHistory].[Version]
WHERE [WorkFlow_VersionHistory].[ID] = @ID
GROUP BY [WorkFlow_VersionHistory].[Name], [WorkFlow_VersionHistory].[Version], [Users].[ID], [WorkFlow_VersionHistory].[ModifiedBy], [Users].[LoginName], [Users].[UserName], [WorkFlow_VersionHistory].[ModifiedDate]
ORDER BY [Version] DESC;

RETURN 0;
GO

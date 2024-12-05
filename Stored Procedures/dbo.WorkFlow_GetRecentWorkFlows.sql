SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_GetRecentWorkFlows] @UserID INTEGER
AS
SET NOCOUNT ON;

SELECT TOP 5 [ID], [Name]
FROM (
	SELECT [ID], [Name], MAX([ModifiedDate]) AS [ModifiedDate]
	FROM (
		SELECT [WorkFlows].[ID], [WorkFlows].[Name], [WorkFlows].[ModifiedDate]
		FROM [dbo].[WorkFlows]
		WHERE [WorkFlows].[Active] = 1
		AND [WorkFlows].[ModifiedBy] = @UserID
		UNION ALL
		SELECT [WorkFlows].[ID], [WorkFlows].[Name], [WorkFlow_VersionHistory].[ModifiedDate]
		FROM [dbo].[WorkFlow_VersionHistory]
		INNER JOIN [dbo].[WorkFlows]
		ON [WorkFlow_VersionHistory].[ID] = [WorkFlows].[ID]
		WHERE [WorkFlows].[Active] = 1
		AND [WorkFlow_VersionHistory].[ModifiedBy] = @UserID
	) AS [History]
	GROUP BY [ID], [Name]
) AS [History]
ORDER BY [ModifiedDate] DESC;

RETURN 0;
GO

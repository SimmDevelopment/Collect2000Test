SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_ListWorkFlows]
AS
SET NOCOUNT ON;

SELECT [WorkFlows].[ID],
	[WorkFlows].[Name],
	[WorkFlows].[Version],
	CASE
		WHEN [CreatedUsers].[ID] IS NOT NULL
		THEN [CreatedUsers].[LoginName]
		WHEN [CreatedUsers].[ID] IS NULL AND [WorkFlows].[CreatedBy] = 0
		THEN 'ADMIN'
		ELSE 'UNKNOWN'
	END AS [CreatedLoginName],
	CASE
		WHEN [CreatedUsers].[ID] IS NOT NULL
		THEN [CreatedUsers].[UserName]
		WHEN [CreatedUsers].[ID] IS NULL AND [WorkFlows].[CreatedBy] = 0
		THEN 'Administrator'
		ELSE 'Unknown User'
	END AS [CreatedUserName],
	[WorkFlows].[CreatedDate],
	CASE
		WHEN [ModifiedUsers].[ID] IS NOT NULL
		THEN [ModifiedUsers].[LoginName]
		WHEN [ModifiedUsers].[ID] IS NULL AND [WorkFlows].[ModifiedBy] = 0
		THEN 'ADMIN'
		ELSE 'UNKNOWN'
	END AS [ModifiedLoginName],
	CASE
		WHEN [ModifiedUsers].[ID] IS NOT NULL
		THEN [ModifiedUsers].[UserName]
		WHEN [ModifiedUsers].[ID] IS NULL AND [WorkFlows].[ModifiedBy] = 0
		THEN 'Administrator'
		ELSE 'Unknown User'
	END AS [ModifiedUserName],
	[WorkFlows].[ModifiedDate]
FROM [dbo].[WorkFlows]
LEFT OUTER JOIN [dbo].[Users] AS [CreatedUsers]
ON [WorkFlows].[CreatedBy] = [CreatedUsers].[ID]
LEFT OUTER JOIN [dbo].[Users] AS [ModifiedUsers]
ON [WorkFlows].[ModifiedBy] = [ModifiedUsers].[ID]
ORDER BY [Name] ASC;

RETURN 0;
GO

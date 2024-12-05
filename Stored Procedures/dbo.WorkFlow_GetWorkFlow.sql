SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_GetWorkFlow] @ID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

SELECT [WorkFlows].[Name],
	[WorkFlows].[StartingActivity],
	[WorkFlows].[LayoutXML],
	[WorkFlows].[Version],
	[WorkFlows].[CreatedBy],
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
	[WorkFlows].[ModifiedBy],
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
ON [WorkFlows].[ModifiedBy] = [CreatedUsers].[ID]
LEFT OUTER JOIN [dbo].[Users] AS [ModifiedUsers]
ON [WorkFlows].[ModifiedBy] = [ModifiedUsers].[ID]
WHERE [WorkFlows].[ID] = @ID;

SELECT [ID], [TypeName], [ActivityXML]
FROM [dbo].[WorkFlow_Activities]
WHERE [WorkFlowID] = @ID
AND [Active] = 1;

RETURN 0;
GO

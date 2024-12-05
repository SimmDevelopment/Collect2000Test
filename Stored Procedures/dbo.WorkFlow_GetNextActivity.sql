SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_GetNextActivity] @LastActivityID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT TOP 1
	[WorkFlow_Activities].[ID] AS [ActivityID],
	[WorkFlow_Activities].[Active],
	[WorkFlow_Activities].[RedirectActivityID],
	[WorkFlows].[Name] AS [WorkFlowName],
	[WorkFlow_Activities].[Title] AS [ActivityTitle],
	[WorkFlow_Activities].[TypeName],
	[WorkFlow_Activities].[ActivityXML]
FROM [dbo].[WorkFlow_Activities]
INNER JOIN [dbo].[WorkFlow_Execution]
ON [WorkFlow_Activities].[ID] = [WorkFlow_Execution].[ActivityID]
INNER JOIN [dbo].[WorkFlows]
ON [WorkFlow_Activities].[WorkFlowID] = [WorkFlows].[ID]
WHERE [WorkFlow_Execution].[PauseCount] <= 0
AND [WorkFlow_Execution].[ChildExecID] IS NULL
AND [WorkFlow_Execution].[NextEvaluateDate] <= GETDATE()
ORDER BY
	CASE
		WHEN @LastActivityID IS NOT NULL AND [WorkFlow_Execution].[ActivityID] = @LastActivityID THEN 1
		ELSE 0
	END,
	[WorkFlow_Execution].[LastEvaluatedWithPriority] ASC;

RETURN 0;
GO

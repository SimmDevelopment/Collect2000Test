SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_GetPanelInformation] @AccountID INTEGER
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT [WorkFlow_Execution].[ID] AS [ExecID], [WorkFlows].[Name] AS [WorkFlow], [WorkFlow_Activities].[Title] AS [Activity], [WorkFlow_Execution].[PauseCount], [WorkFlow_Execution].[ChildExecID], GETDATE() AS [CurrentDate], [WorkFlow_Execution].[NextEvaluateDate], [WorkFlow_Activities].[NextEvaluateDate] AS [ActivityNextEvaluateDate], [WorkFlow_Execution].[EnteredDate], [WorkFlow_Execution].[LastEvaluated]
FROM [dbo].[WorkFlow_Execution]
INNER JOIN [dbo].[WorkFlow_Activities]
ON [WorkFlow_Execution].[ActivityID] = [WorkFlow_Activities].[ID]
INNER JOIN [dbo].[WorkFlows]
ON [WorkFlow_Activities].[WorkFlowID] = [WorkFlows].[ID]
WHERE [WorkFlow_Execution].[AccountID] = @AccountID
ORDER BY [WorkFlow_Execution].[LastEvaluated];

SELECT [WorkFlow_ExecutionHistory].[ID] AS [HistoryID], [WorkFlow_ExecutionHistory].[ExecID], [WorkFlow_ExecutionHistory].[AccountID], [WorkFlows].[Name] AS [WorkFlow], [WorkFlow_Activities].[Title] AS [Activity], [WorkFlow_ExecutionHistory].[Entered], [WorkFlow_ExecutionHistory].[Evaluated], [WorkFlow_NextActivity].[Title] AS [NextActivity], COALESCE([WorkFlow_ExecutionHistoryComments].[AccountID], [WorkFlow_ExecutionHistory].[AccountID]) AS [CommentAccountID], [WorkFlow_ExecutionHistoryComments].[Comment]
FROM [dbo].[WorkFlow_ExecutionHistory]
INNER JOIN [dbo].[WorkFlow_Activities]
ON [WorkFlow_ExecutionHistory].[ActivityID] = [WorkFlow_Activities].[ID]
INNER JOIN [dbo].[WorkFlows]
ON [WorkFlow_Activities].[WorkFlowID] = [WorkFlows].[ID]
LEFT OUTER JOIN [dbo].[WorkFlow_Activities] AS [WorkFlow_NextActivity]
ON [WorkFlow_ExecutionHistory].[NextActivityID] = [WorkFlow_NextActivity].[ID]
LEFT OUTER JOIN [dbo].[WorkFlow_ExecutionHistoryComments]
ON [WorkFlow_ExecutionHistory].[ID] = [WorkFlow_ExecutionHistoryComments].[HistoryID]
WHERE [WorkFlow_ExecutionHistory].[AccountID] = @AccountID
UNION ALL
SELECT [WorkFlow_ExecutionHistory].[ID] AS [HistoryID], [WorkFlow_ExecutionHistory].[ExecID], [WorkFlow_ExecutionHistory].[AccountID], [WorkFlows].[Name] AS [WorkFlow], [WorkFlow_Activities].[Title] AS [Activity], [WorkFlow_ExecutionHistory].[Entered], [WorkFlow_ExecutionHistory].[Evaluated], [WorkFlow_NextActivity].[Title] AS [NextActivity], COALESCE([WorkFlow_ExecutionHistoryComments].[AccountID], [WorkFlow_ExecutionHistory].[AccountID]) AS [CommentAccountID], [WorkFlow_ExecutionHistoryComments].[Comment]
FROM [dbo].[WorkFlow_ExecutionHistory]
INNER JOIN [dbo].[WorkFlow_Activities]
ON [WorkFlow_ExecutionHistory].[ActivityID] = [WorkFlow_Activities].[ID]
INNER JOIN [dbo].[WorkFlows]
ON [WorkFlow_Activities].[WorkFlowID] = [WorkFlows].[ID]
LEFT OUTER JOIN [dbo].[WorkFlow_Activities] AS [WorkFlow_NextActivity]
ON [WorkFlow_ExecutionHistory].[NextActivityID] = [WorkFlow_NextActivity].[ID]
INNER JOIN [dbo].[WorkFlow_ExecutionHistoryComments]
ON [WorkFlow_ExecutionHistory].[ID] = [WorkFlow_ExecutionHistoryComments].[HistoryID]
AND [WorkFlow_ExecutionHistory].[AccountID] <> [WorkFlow_ExecutionHistoryComments].[AccountID]
WHERE [WorkFlow_ExecutionHistory].[AccountID] <> @AccountID
AND [WorkFlow_ExecutionHistoryComments].[AccountID] = @AccountID
ORDER BY [Evaluated] DESC;

SELECT CAST(0 AS BIT) AS [Queued], [WorkFlow_EventHistory].[EventName], [WorkFlow_EventHistory].[Occurred], [WorkFlows].[Name] AS [WorkFlow], [WorkFlow_EventHistory].[ActionType], [WorkFlow_EventHistory].[Reentrance], [WorkFlow_EventHistory].[WorkFlowDelay]
FROM [dbo].[WorkFlow_EventHistory]
LEFT OUTER JOIN [dbo].[WorkFlows]
ON [WorkFlow_EventHistory].[WorkFlowID] = [WorkFlows].[ID]
WHERE [WorkFlow_EventHistory].[AccountID] = @AccountID
UNION ALL
SELECT CAST(1 AS BIT) AS [Queued], [WorkFlow_Events].[Name], [WorkFlow_EventQueue].[Occurred], NULL, NULL, NULL, NULL
FROM [dbo].[WorkFlow_EventQueue]
INNER JOIN [dbo].[WorkFlow_Events]
ON [WorkFlow_EventQueue].[EventID] = [WorkFlow_Events].[ID]
WHERE [WorkFlow_EventQueue].[AccountID] = @AccountID
ORDER BY [Occurred] DESC;

RETURN 0;
GO

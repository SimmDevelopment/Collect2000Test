SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_StatusChanged]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

UPDATE [WorkFlowAcct]
SET [ActivityVariable] = [master].[status]
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
WHERE [WorkFlowAcct].[ActivityVariable] IS NULL;

UPDATE [WorkFlowAcct]
SET [True] = 1,
	[Comment] = 'Status changed from "' + [StatusHistory].[OldStatus] + '" to "' + [StatusHistory].[NewStatus] + '"'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[StatusHistory]
ON [WorkFlowAcct].[AccountID] = [StatusHistory].[AccountID]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
WHERE [StatusHistory].[OldStatus] <> [StatusHistory].[NewStatus]
AND [StatusHistory].[DateChanged] >= [WorkFlowExec].[EnteredDate];

UPDATE [WorkFlowAcct]
SET [True] = 1,
	[Comment] = 'Desk changed from "' + CAST([WorkFlowAcct].[ActivityVariable] AS VARCHAR(50)) + '" to "' + [master].[status] + '"'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
AND [WorkFlowAcct].[ActivityVariable] <> [master].[status]
AND [WorkFlowAcct].[True] = 0;

RETURN 0;
GO

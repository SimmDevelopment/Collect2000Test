SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_DeskChanged]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

UPDATE [WorkFlowAcct]
SET [ActivityVariable] = [master].[desk]
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
WHERE [WorkFlowAcct].[ActivityVariable] IS NULL;

UPDATE [WorkFlowAcct]
SET [True] = 1,
	[Comment] = 'Desk changed from "' + [DeskChangeHistory].[OldDesk] + '" to "' + [DeskChangeHistory].[NewDesk] + '"'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[DeskChangeHistory]
ON [WorkFlowAcct].[AccountID] = [DeskChangeHistory].[Number]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
WHERE [DeskChangeHistory].[OldDesk] <> [DeskChangeHistory].[NewDesk]
AND [DeskChangeHistory].[DMDateStamp] >= [WorkFlowExec].[EnteredDate];

UPDATE [WorkFlowAcct]
SET [True] = 1,
	[Comment] = 'Desk changed from "' + CAST([WorkFlowAcct].[ActivityVariable] AS VARCHAR(50)) + '" to "' + [master].[desk] + '"'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
AND [WorkFlowAcct].[ActivityVariable] <> [master].[desk]
AND [WorkFlowAcct].[True] = 0;

RETURN 0;
GO

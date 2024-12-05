SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Switch_RestoreMovedAccounts]
AS
SET NOCOUNT ON;

INSERT INTO #WorkFlowExec ([ExecID], [ActivityID], [AccountID], [EnteredDate], [NextActivityID], [UndoState])
SELECT [WorkFlowExec_Switch].[ExecID], [WorkFlowExec_Switch].[ActivityID], [WorkFlowExec_Switch].[AccountID], [WorkFlowExec_Switch].[EnteredDate], [WorkFlowExec_Switch].[NextActivityID], [WorkFlowExec_Switch].[UndoState]
FROM #WorkFlowExec_Switch AS [WorkFlowExec_Switch];

INSERT INTO #WorkFlowAcct ([ExecID], [AccountID], [Linked], [Comment], [ActivityVariable])
SELECT [WorkFlowAcct_Switch].[ExecID], [WorkFlowAcct_Switch].[AccountID], CASE [WorkFlowAcct_Switch].[AccountID] WHEN [WorkFlowExec].[AccountID] THEN 0 ELSE 1 END, [WorkFlowAcct_Switch].[Comment], NULL
FROM #WorkFlowAcct_Switch AS [WorkFlowAcct_Switch]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct_Switch].[ExecID] = [WorkFlowExec].[ExecID];

INSERT INTO #WorkFlowAcct ([ExecID], [AccountID], [Linked], [Comment], [ActivityVariable])
SELECT [WorkFlowExec].[ExecID], [WorkFlowExec].[AccountID], 0, NULL, NULL
FROM #WorkFlowExec AS [WorkFlowExec]
WHERE [WorkFlowExec].[NextActivityID] IS NULL;

RETURN 0;
GO

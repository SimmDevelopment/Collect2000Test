SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Switch_SaveMovedAccounts]
AS
SET NOCOUNT ON;

UPDATE #WorkFlowExec
SET [NextActivityID] = NULL
WHERE [NextActivityID] = '00000000-0000-0000-0000-000000000000';

INSERT INTO #WorkFlowExec_Switch ([ExecID], [ActivityID], [AccountID], [EnteredDate], [NextActivityID], [UndoState])
SELECT [WorkFlowExec].[ExecID], [WorkFlowExec].[ActivityID], [WorkFlowExec].[AccountID], [WorkFlowExec].[EnteredDate], [WorkFlowExec].[NextActivityID], [WorkFlowExec].[UndoState]
FROM #WorkFlowExec AS [WorkFlowExec]
LEFT OUTER JOIN #WorkFlowExec_Switch As [WorkFlowExec_Switch]
ON [WorkFlowExec].[ExecID] = [WorkFlowExec_Switch].[ExecID]
WHERE [WorkFlowExec].[NextActivityID] IS NOT NULL;

INSERT INTO #WorkFlowAcct_Switch ([ExecID], [AccountID], [Linked], [Comment])
SELECT [WorkFlowExec].[ExecID], [WorkFlowAcct].[AccountID], [WorkFlowAcct].[Linked], [WorkFlowAcct].[Comment]
FROM #WorkFlowExec AS [WorkFlowExec]
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [WorkFlowExec].[ExecID] = [WorkFlowAcct].[ExecID]
WHERE [WorkFlowExec].[NextActivityID] IS NOT NULL;

DELETE
FROM #WorkFlowExec
WHERE [NextActivityID] IS NOT NULL;

DROP TABLE #WorkFlowAcct;

RETURN 0;
GO

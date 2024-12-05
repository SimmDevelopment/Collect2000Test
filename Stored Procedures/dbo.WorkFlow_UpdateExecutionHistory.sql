SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_UpdateExecutionHistory] @DateStamp DATETIME
AS
SET NOCOUNT ON;

IF NOT OBJECT_ID('tempdb..#History') IS NULL DROP TABLE #History;
						
CREATE TABLE #History (
	[HistoryID] UNIQUEIDENTIFIER NOT NULL,
	[ExecID] UNIQUEIDENTIFIER NOT NULL
)

INSERT INTO [dbo].[WorkFlow_ExecutionHistory] ([ExecID], [AccountID], [ActivityID], [Entered], [Evaluated], [NextActivityID], [UndoState], [Undone])
OUTPUT [INSERTED].[ID], [INSERTED].[ExecID]
INTO #History ([HistoryID], [ExecID])
SELECT [WorkFlowExec].[ExecID], [WorkFlowExec].[AccountID], [WorkFlowExec].[ActivityID], [WorkFlowExec].[EnteredDate], @DateStamp, [WorkFlowExec].[NextActivityID], [WorkFlowExec].[UndoState], 0
FROM #WorkFlowExec AS [WorkFlowExec]
WHERE [WorkFlowExec].[NextActivityID] IS NOT NULL;

INSERT INTO [dbo].[WorkFlow_ExecutionHistoryComments] ([HistoryID], [AccountID], [Comment])
SELECT [History].[HistoryID], [WorkFlowAcct].[AccountID], [WorkFlowAcct].[Comment]
FROM #History AS [History]
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [History].[ExecID] = [WorkFlowAcct].[ExecID]
WHERE [WorkFlowAcct].[Comment] IS NOT NULL;

RETURN 0;
GO

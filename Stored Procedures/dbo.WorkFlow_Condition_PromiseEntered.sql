SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_PromiseEntered]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

UPDATE #WorkFlowAcct
SET [True] = 1,
	[Comment] = 'Promise for ' + CONVERT(VARCHAR(50), [Promises].[Amount], 1) + ' due ' + CONVERT(VARCHAR(50), [Promises].[DueDate], 101) + ' entered on ' + CONVERT(VARCHAR(50), [Promises].[Entered], 101)
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
INNER JOIN [dbo].[Promises]
ON [WorkFlowAcct].[AccountID] = [Promises].[AcctID]
WHERE [Promises].[Entered] > [WorkFlowExec].[EnteredDate];

RETURN 0;
GO

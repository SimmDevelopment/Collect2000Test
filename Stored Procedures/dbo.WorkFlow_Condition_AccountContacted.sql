SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_AccountContacted]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

UPDATE [WorkFlowAcct]
SET [True] = 1,
	[Comment] = 'Account contacted at ' + CONVERT(VARCHAR(50), [master].[contacted], 100)
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
WHERE [master].[contacted] >= [WorkFlowExec].[EnteredDate];

RETURN 0;
GO

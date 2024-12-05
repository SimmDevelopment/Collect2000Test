SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_JoinWorkFlow]
AS
SET NOCOUNT ON;

UPDATE [WorkFlowAcct]
SET [True] = 1,
	[Comment] = 'Forked children joined'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
LEFT OUTER JOIN [dbo].[WorkFlow_ForkRelationships]
ON [WorkFlowExec].[ExecID] = [WorkFlow_ForkRelationships].[ParentID]
LEFT OUTER JOIN [dbo].[WorkFlow_Execution]
ON [WorkFlow_ForkRelationships].[ChildID] = [WorkFlow_Execution].[ID]
WHERE [WorkFlow_Execution].[ID] IS NULL;

RETURN 0;
GO

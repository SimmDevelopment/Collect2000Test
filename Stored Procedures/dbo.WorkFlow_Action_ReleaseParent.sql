SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_ReleaseParent]
AS
SET NOCOUNT ON;

UPDATE [dbo].[WorkFlow_Execution]
SET [ChildExecID] = NULL
FROM [dbo].[WorkFlow_Execution]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlow_Execution].[ChildExecID] = [WorkFlowExec].[ExecID];

RETURN 0;
GO

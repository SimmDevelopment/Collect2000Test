SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_PauseWorkFlow] @WorkFlowID UNIQUEIDENTIFIER, @PauseAll BIT
AS
SET NOCOUNT ON;

IF @WorkFlowID IS NOT NULL BEGIN
	UPDATE [dbo].[WorkFlow_Execution]
	SET [PauseCount] = [PauseCount] + 1
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN [dbo].[WorkFlow_Execution]
	ON [WorkFlowExec].[AccountID] = [WorkFlow_Execution].[AccountID]
	INNER JOIN [dbo].[WorkFlow_Activities]
	ON [WorkFlow_Execution].[ActivityID] = [WorkFlow_Activities].[ID]
	WHERE [WorkFlow_Activities].[WorkFlowID] = @WorkFlowID;
END;
ELSE IF @PauseAll IS NOT NULL AND @PauseAll = 1 BEGIN
	UPDATE [dbo].[WorkFlow_Execution]
	SET [PauseCount] = [PauseCount] + 1
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN [dbo].[WorkFlow_Execution]
	ON [WorkFlowExec].[AccountID] = [WorkFlow_Execution].[AccountID];
END;
ELSE BEGIN
	UPDATE [dbo].[WorkFlow_Execution]
	SET [PauseCount] = [PauseCount] + 1
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN [dbo].[WorkFlow_Execution]
	ON [WorkFlowExec].[ExecID] = [WorkFlow_Execution].[ID];
END;

RETURN 0;
GO

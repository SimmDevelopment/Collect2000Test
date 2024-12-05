SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_ResumeWorkFlow] @WorkFlowID UNIQUEIDENTIFIER, @ResumeCompletely BIT
AS
SET NOCOUNT ON;

IF @WorkFlowID IS NOT NULL BEGIN
	UPDATE [dbo].[WorkFlow_Execution]
	SET [PauseCount] = CASE @ResumeCompletely
		WHEN 1 THEN 0
		ELSE [PauseCount] - 1
	END
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN [dbo].[WorkFlow_Execution]
	ON [WorkFlowExec].[AccountID] = [WorkFlow_Execution].[AccountID]
	INNER JOIN [dbo].[WorkFlow_Activities]
	ON [WorkFlow_Execution].[ActivityID] = [WorkFlow_Activities].[ID]
	WHERE [WorkFlow_Activities].[WorkFlowID] = @WorkFlowID
	AND [WorkFlow_Execution].[PauseCount] > 0;
END;
ELSE BEGIN
	UPDATE [dbo].[WorkFlow_Execution]
	SET [PauseCount] = CASE @ResumeCompletely
		WHEN 1 THEN 0
		ELSE [PauseCount] - 1
	END
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN [dbo].[WorkFlow_Execution]
	ON [WorkFlowExec].[AccountID] = [WorkFlow_Execution].[AccountID]
	WHERE [WorkFlow_Execution].[PauseCount] > 0;
END;

RETURN 0;
GO

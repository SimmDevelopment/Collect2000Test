SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_MoveToNextActivity] @ActivityID UNIQUEIDENTIFIER, @TrueActivityID UNIQUEIDENTIFIER, @FalseActivityID UNIQUEIDENTIFIER, @Duration BIGINT, @RetryDelay BIGINT
AS
SET NOCOUNT ON;

UPDATE [WorkFlowExec]
SET [NextActivityID] = @TrueActivityID
FROM #WorkFlowExec AS [WorkFlowExec]
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [WorkFlowExec].[ExecID] = [WorkFlowAcct].[ExecID]
WHERE [WorkFlowAcct].[True] = 1
AND [WorkFlowExec].[NextActivityID] IS NULL;

IF @Duration IS NULL OR @Duration < 0 SET @Duration = 0;
IF @RetryDelay IS NULL OR @RetryDelay < 0 SET @RetryDelay = 0;

IF @Duration > 0 BEGIN
	UPDATE #WorkFlowExec
	SET [NextActivityID] = @FalseActivityID
	WHERE [NextActivityID] IS NULL
	AND [EnteredDate] < DATEADD(MINUTE, -@Duration, GETDATE());

	UPDATE #WorkFlowExec
	SET [NextEvaluateDate] = DATEADD(MINUTE, @RetryDelay, GETDATE())
	WHERE [NextActivityID] IS NULL;
END;
ELSE BEGIN
	UPDATE #WorkFlowExec
	SET [NextActivityID] = @FalseActivityID
	WHERE [NextActivityID] IS NULL;
END;

RETURN 0;
GO

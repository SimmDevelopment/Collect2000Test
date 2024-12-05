SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[WorkFlow_ProgressExecution] @NextEvaluationDelay BIGINT
AS
SET NOCOUNT ON;
DECLARE @Progressed INTEGER;
DECLARE @Remaining INTEGER;
DECLARE @Completed INTEGER;
DECLARE @DateStamp DATETIME;

IF OBJECT_ID('tempdb..#WorkFlowExec') IS NULL BEGIN
	RAISERROR('#WorkFlowExec table does not exist.', 16, 1);
	RETURN 1;
END;

SET @DateStamp = GETDATE();

-- Change the attempt to move the account to the same activity to keep the account on the same activity
UPDATE #WorkFlowExec
SET [NextActivityID] = NULL
WHERE [NextActivityID] = [ActivityID];

-- Remove invalid next activities
UPDATE [WorkFlowExec]
SET [NextActivityID] = '00000000-0000-0000-0000-000000000000'
FROM #WorkFlowExec AS [WorkFlowExec]
WHERE [NextActivityID] IS NOT NULL
AND NOT EXISTS (SELECT * FROM [dbo].[WorkFlow_Activities] WHERE [WorkFlow_Activities].[ID] = [WorkFlowExec].[NextActivityID]);

-- Move accounts to their next activity
UPDATE [dbo].[WorkFlow_Execution]
SET [ActivityID] = [WorkFlowExec].[NextActivityID],
	[EnteredDate] = @DateStamp,
	[LastEvaluated] = @DateStamp,
	[LastEvaluatedWithPriority] = p.PriorityDate
FROM [dbo].[WorkFlow_Execution]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlow_Execution].[ID] = [WorkFlowExec].[ExecID]
CROSS APPLY ( Select * FROM [dbo].[WorkFlow_GetPriorityDate](@DateStamp, [WorkFlow_Execution].[Priority])) p
WHERE [WorkFlowExec].[NextActivityID] IS NOT NULL
AND [WorkFlowExec].[NextActivityID] != '00000000-0000-0000-0000-000000000000';

SET @Progressed = @@ROWCOUNT;

-- Update dates of accounts remaining in current activity
UPDATE [dbo].[WorkFlow_Execution]
SET [LastEvaluated] = @DateStamp,
	[NextEvaluateDate] = ISNULL([WorkFlowExec].[NextEvaluateDate], @DateStamp),
	[LastEvaluatedWithPriority] = p.PriorityDate
FROM [dbo].[WorkFlow_Execution]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlow_Execution].[ID] = [WorkFlowExec].[ExecID]
CROSS APPLY ( Select * FROM [dbo].[WorkFlow_GetPriorityDate](@DateStamp, [WorkFlow_Execution].[Priority])) p
WHERE [WorkFlowExec].[NextActivityID] IS NULL;

SET @Remaining = @@ROWCOUNT;

-- Remove accounts moving to empty activity
UPDATE [dbo].[WorkFlow_Execution]
SET [ChildExecID] = NULL,
	[LastEvaluatedWithPriority] = p.PriorityDate
FROM [dbo].[WorkFlow_Execution]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowExec].[ExecID] = [WorkFlow_Execution].[ChildExecID]
AND [WorkFlowExec].[NextActivityID] = '00000000-0000-0000-0000-000000000000'
CROSS APPLY ( Select * FROM [dbo].[WorkFlow_GetPriorityDate](@DateStamp, [WorkFlow_Execution].[Priority])) p;


DELETE [WorkFlow_Execution]
FROM [dbo].[WorkFlow_Execution]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlow_Execution].[ID] = [WorkFlowExec].[ExecID]
WHERE [WorkFlowExec].[NextActivityID] = '00000000-0000-0000-0000-000000000000';

SET @Completed = @@ROWCOUNT;

SELECT @Progressed AS [Progressed], @Remaining AS [Remaining], @Completed AS [Completed];

-- Update execution variables
EXEC [dbo].[WorkFlow_UpdateExecutionVariables];

-- Record execution history
EXEC [dbo].[WorkFlow_UpdateExecutionHistory] @DateStamp = @DateStamp;

UPDATE [dbo].[WorkFlow_Activities]
SET [LastEvaluated] = @DateStamp,
	[NextEvaluateDate] = n.[NextEvaluateDate]
FROM [dbo].[WorkFlow_Activities]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlow_Activities].[ID] = [WorkFlowExec].[ActivityID]
CROSS APPLY (SELECT * FROM  [dbo].[WorkFlow_GetNextEvaluateDate]([WorkFlow_Activities].[NextEvaluateDate], @DateStamp, @NextEvaluationDelay)) n;

UPDATE [dbo].[WorkFlows]
SET [LastEvaluated] = @DateStamp
FROM [dbo].[WorkFlows]
INNER JOIN [dbo].[WorkFlow_Activities]
ON [WorkFlows].[ID] = [WorkFlow_Activities].[WorkFlowID]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlow_Activities].[ID] = [WorkFlowExec].[ActivityID];

RETURN 0;


GO

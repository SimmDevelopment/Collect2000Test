SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[WorkFlow_Action_StartWorkFlow] @WorkFlowID UNIQUEIDENTIFIER, @Concurrent BIT = 0, @Priority TINYINT = NULL
AS
SET NOCOUNT ON;

DECLARE @StartID UNIQUEIDENTIFIER;

SELECT @StartID = [StartingActivity]
FROM [dbo].[WorkFlows]
WHERE [ID] = @WorkFlowID;

IF @StartID IS NOT NULL BEGIN
	IF @Concurrent = 1
		INSERT INTO [dbo].[WorkFlow_Execution] ([AccountID], [ActivityID], [EnteredDate], [LastEvaluated], [Priority], [LastEvaluatedWithPriority], [PauseCount], [ChildExecID])
		SELECT [WorkFlowExec].[AccountID], @StartID, GETDATE(), GETDATE(), COALESCE(@Priority, [WorkFlow_Execution].[Priority]), p.PriorityDate, 0, NULL
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[WorkFlow_Execution] AS [WorkFlow_Execution]
		ON [WorkFlowExec].[ExecID] = [WorkFlow_Execution].[ID]
		CROSS APPLY ( Select * FROM [dbo].[WorkFlow_GetPriorityDate](GETDATE(), COALESCE(@Priority, [WorkFlow_Execution].[Priority]))) p;
	ELSE BEGIN
		BEGIN TRANSACTION;

		DECLARE @ChildExec TABLE (
			[ID] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY NONCLUSTERED,
			[ChildID] UNIQUEIDENTIFIER NOT NULL
		);

		INSERT INTO @ChildExec ([ID], [ChildID])
		SELECT [WorkFlowExec].[ExecID], NEWID()
		FROM #WorkFlowExec AS [WorkFlowExec];

		INSERT INTO [dbo].[WorkFlow_Execution] ([ID], [AccountID], [ActivityID], [EnteredDate], [LastEvaluated], [Priority], [LastEvaluatedWithPriority], [PauseCount], [ChildExecID])
		SELECT [ChildExec].[ChildID], [WorkFlowExec].[AccountID], @StartID, GETDATE(), GETDATE(), COALESCE(@Priority, [WorkFlow_Execution].[Priority]), p.PriorityDate, 0, NULL
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[WorkFlow_Execution] AS [WorkFlow_Execution]
		ON [WorkFlowExec].[ExecID] = [WorkFlow_Execution].[ID]
		INNER JOIN @ChildExec AS [ChildExec]
		ON [ChildExec].[ID] = [WorkFlowExec].[ExecID]
		CROSS APPLY ( Select * FROM [dbo].[WorkFlow_GetPriorityDate](GETDATE(), COALESCE(@Priority, [WorkFlow_Execution].[Priority]))) p;

		IF @@ERROR <> 0 GOTO ErrorHandler;

		UPDATE [dbo].[WorkFlow_Execution]
		SET [ChildExecID] = [ChildExec].[ChildID]
		FROM [dbo].[WorkFlow_Execution]
		INNER JOIN @ChildExec AS [ChildExec]
		ON [ChildExec].[ID] = [WorkFlow_Execution].[ID];

		IF @@ERROR <> 0 GOTO ErrorHandler;

		COMMIT TRANSACTION;
	END;
END;

RETURN 0;
ErrorHandler:
IF @@TRANCOUNT > 0 BEGIN
	ROLLBACK TRANSACTION;
END;
RETURN 1;

GO

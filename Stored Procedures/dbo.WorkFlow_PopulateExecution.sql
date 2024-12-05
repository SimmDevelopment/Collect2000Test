SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_PopulateExecution] @ActivityID UNIQUEIDENTIFIER, @MaximumAccounts INTEGER = 0
AS
SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#WorkFlowExec') IS NULL BEGIN
	RAISERROR('#WorkFlowExec table does not exist.', 16, 1);
	RETURN 1;
END;

DECLARE @Accounts INTEGER;

SET ROWCOUNT @MaximumAccounts;

INSERT INTO #WorkFlowExec ([ExecID], [ActivityID], [AccountID], [EnteredDate])
SELECT [WorkFlow_Execution].[ID], [WorkFlow_Execution].[ActivityID], [WorkFlow_Execution].[AccountID], [WorkFlow_Execution].[EnteredDate]
FROM [dbo].[WorkFlow_Execution]
LEFT OUTER JOIN [dbo].[WorkFlow_EventQueue]
ON [WorkFlow_Execution].[AccountID] = [WorkFlow_EventQueue].[AccountID]
WHERE [WorkFlow_Execution].[ActivityID] = @ActivityID
AND [WorkFlow_Execution].[NextEvaluateDate] <= GETDATE()
AND [WorkFlow_Execution].[PauseCount] = 0
AND [WorkFlow_Execution].[ChildExecID] IS NULL
AND [WorkFlow_EventQueue].[AccountID] IS NULL
ORDER BY [LastEvaluatedWithPriority] ASC;

SET @Accounts = @@ROWCOUNT;

SET ROWCOUNT 0;

SELECT @Accounts AS [Accounts];

RETURN 0;
GO

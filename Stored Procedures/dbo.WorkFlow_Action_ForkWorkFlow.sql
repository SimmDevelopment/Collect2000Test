SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_ForkWorkFlow] @NextActivityID UNIQUEIDENTIFIER, @ChildActivityID UNIQUEIDENTIFIER, @CopyLocalCounters BIT = 1, @CopyVariables BIT = 1
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Now DATETIME;
SET @Now = GETDATE();

DECLARE @ForkTable TABLE (
	[ParentID] UNIQUEIDENTIFIER NOT NULL,
	[ChildID] UNIQUEIDENTIFIER NOT NULL
);

INSERT INTO @ForkTable ([ParentID], [ChildID])
SELECT [ExecID], NEWID()
FROM #WorkFlowExec;

UPDATE #WorkFlowExec
SET [NextActivityID] = @NextActivityID;

UPDATE #WorkFlowAcct
SET [Comment] = 'Parent of fork activity';

BEGIN TRANSACTION;

INSERT INTO #WorkFlowExec ([ExecID], [ActivityID], [AccountID], [EnteredDate], [NextActivityID])
SELECT [ForkTable].[ChildID], [WorkFlowExec].[ActivityID], [WorkFlowExec].[AccountID], [WorkFlowExec].[EnteredDate], @ChildActivityID
FROM #WorkFlowExec AS [WorkFlowExec]
INNER JOIN @ForkTable AS [ForkTable]
ON [WorkFlowExec].[ExecID] = [ForkTable].[ParentID];

INSERT INTO #WorkFlowAcct ([ExecID], [AccountID], [Linked], [Comment])
SELECT [ForkTable].[ChildID], [WorkFlowAcct].[AccountID], [WorkFlowAcct].[Linked], 'Child of fork activity'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @ForkTable AS [ForkTable]
ON [WorkFlowAcct].[ExecID] = [ForkTable].[ParentID];

INSERT INTO [dbo].[WorkFlow_Execution] ([ID], [AccountID], [ActivityID], [EnteredDate], [NextEvaluateDate], [LastEvaluated], [Priority], [LastEvaluatedWithPriority], [PauseCount], [ChildExecID])
SELECT [ForkTable].[ChildID], [WorkFlow_Execution].[AccountID], [WorkFlow_Execution].[ActivityID], [WorkFlow_Execution].[EnteredDate], @Now, @Now, [Priority], @Now, 0, NULL
FROM [dbo].[WorkFlow_Execution]
INNER JOIN @ForkTable AS [ForkTable]
ON [WorkFlow_Execution].[ID] = [ForkTable].[ParentID];

IF @@ERROR <> 0 GOTO ErrorHandler;

INSERT INTO [dbo].[WorkFlow_ForkRelationships] ([ParentID], [ChildID])
SELECT [ParentID], [ChildID]
FROM @ForkTable;

IF @@ERROR <> 0 GOTO ErrorHandler;

IF @CopyLocalCounters = 1 BEGIN
	INSERT INTO [dbo].[WorkFlow_Counters] ([AccountID], [WorkFlowID], [ExecID], [Name], [Value])
	SELECT [WorkFlow_Counters].[AccountID], [WorkFlow_Counters].[WorkFlowID], [ForkTable].[ChildID], [WorkFlow_Counters].[Name], [WorkFlow_Counters].[Value]
	FROM @ForkTable AS [ForkTable]
	INNER JOIN #WorkFlowExec AS [WorkFlowExec]
	ON [ForkTable].[ParentID] = [WorkFlowExec].[ExecID]
	INNER JOIN [dbo].[WorkFlow_Activities]
	ON [WorkFlowExec].[ActivityID] = [WorkFlow_Activities].[ID]
	INNER JOIN [dbo].[WorkFlow_Counters]
	ON [WorkFlowExec].[AccountID] = [WorkFlow_Counters].[AccountID]
	AND [WorkFlow_Activities].[WorkFlowID] = [WorkFlow_Counters].[WorkFlowID]
	AND [ForkTable].[ParentID] = [WorkFlow_Counters].[ExecID];

	IF @@ERROR <> 0 GOTO ErrorHandler;
END;

IF @CopyVariables = 1 BEGIN
	INSERT INTO [dbo].[WorkFlow_ExecutionVariables] ([ExecID], [AccountID], [Name], [Variable])
	SELECT [ForkTable].[ChildID], [WorkFlow_ExecutionVariables].[AccountID], [WorkFlow_ExecutionVariables].[Name], [WorkFlow_ExecutionVariables].[Variable]
	FROM @ForkTable AS [ForkTable]
	INNER JOIN [dbo].[WorkFlow_ExecutionVariables]
	ON [ForkTable].[ParentID] = [WorkFlow_ExecutionVariables].[ExecID]
	WHERE [WorkFlow_ExecutionVariables].[ActivityID] IS NULL;

	IF @@ERROR <> 0 GOTO ErrorHandler;
END;

COMMIT TRANSACTION;

RETURN 0;
ErrorHandler:

ROLLBACK TRANSACTION;

RETURN 1;
GO

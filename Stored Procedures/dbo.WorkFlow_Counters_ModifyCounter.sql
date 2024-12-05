SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Counters_ModifyCounter] @CounterScope TINYINT, @CounterName VARCHAR(50), @Operation TINYINT, @Value INTEGER
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Counters TABLE (
	[WFEID] UNIQUEIDENTIFIER NOT NULL,
	[New] BIT NOT NULL,
	[ID] UNIQUEIDENTIFIER NOT NULL,
	[AccountID] INTEGER NOT NULL,
	[WorkFlowID] UNIQUEIDENTIFIER NULL,
	[ExecID] UNIQUEIDENTIFIER NULL,
	[Name] VARCHAR(50) NOT NULL,
	[OldValue] INTEGER NULL,
	[Value] INTEGER NOT NULL
);

IF @CounterScope = 0 BEGIN
	INSERT INTO @Counters ([WFEID], [New], [ID], [AccountID], [WorkFlowID], [ExecID], [Name], [OldValue], [Value])
	SELECT [WorkFlowExec].[ExecID],
		CASE
			WHEN [WorkFlow_Counters].[ID] IS NULL THEN 1
			ELSE 0
		END AS [New],
		COALESCE([WorkFlow_Counters].[ID], NEWID()) AS [ID],
		[WorkFlowExec].[AccountID] AS [AccountID],
		[WorkFlow_Activities].[WorkFlowID] AS [WorkFlowID],
		[WorkFlowExec].[ExecID] AS [ExecID],
		@CounterName AS [Name],
		[WorkFlow_Counters].[Value] AS [OldValue],
		CASE @Operation
			WHEN 0 THEN @Value
			WHEN 1 THEN COALESCE([WorkFlow_Counters].[Value], 0) + @Value
			WHEN 2 THEN COALESCE([WorkFlow_Counters].[Value], 0) - @Value
			ELSE @Value
		END AS [NewValue]
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN [dbo].[WorkFlow_Activities]
	ON [WorkFlowExec].[ActivityID] = [WorkFlow_Activities].[ID]
	LEFT OUTER JOIN [dbo].[WorkFlow_Counters]
	ON [WorkFlow_Counters].[AccountID] = [WorkFlowExec].[AccountID]
	AND [WorkFlow_Counters].[WorkFlowID] = [WorkFlow_Activities].[WorkFlowID]
	AND [WorkFlow_Counters].[ExecID] = [WorkFlowExec].[ExecID]
	AND [WorkFlow_Counters].[Name] = @CounterName;
END;
ELSE IF @CounterScope = 1 BEGIN
	INSERT INTO @Counters ([WFEID], [New], [ID], [AccountID], [WorkFlowID], [ExecID], [Name], [OldValue], [Value])
	SELECT [WorkFlowExec].[ExecID],
		CASE
			WHEN [WorkFlow_Counters].[ID] IS NULL THEN 1
			ELSE 0
		END AS [New],
		COALESCE([WorkFlow_Counters].[ID], NEWID()) AS [ID],
		[WorkFlowExec].[AccountID] AS [AccountID],
		[WorkFlow_Activities].[WorkFlowID] AS [WorkFlowID],
		NULL AS [ExecID],
		@CounterName AS [Name],
		[WorkFlow_Counters].[Value] AS [OldValue],
		CASE @Operation
			WHEN 0 THEN @Value
			WHEN 1 THEN COALESCE([WorkFlow_Counters].[Value], 0) + @Value
			WHEN 2 THEN COALESCE([WorkFlow_Counters].[Value], 0) - @Value
			ELSE @Value
		END AS [NewValue]
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN [dbo].[WorkFlow_Activities]
	ON [WorkFlowExec].[ActivityID] = [WorkFlow_Activities].[ID]
	LEFT OUTER JOIN [dbo].[WorkFlow_Counters]
	ON [WorkFlow_Counters].[AccountID] = [WorkFlowExec].[AccountID]
	AND [WorkFlow_Counters].[WorkFlowID] = [WorkFlow_Activities].[WorkFlowID]
	AND [WorkFlow_Counters].[ExecID] IS NULL
	AND [WorkFlow_Counters].[Name] = @CounterName;
END;
ELSE BEGIN
	INSERT INTO @Counters ([WFEID], [New], [ID], [AccountID], [WorkFlowID], [ExecID], [Name], [OldValue], [Value])
	SELECT [WorkFlowExec].[ExecID],
		CASE
			WHEN [WorkFlow_Counters].[ID] IS NULL THEN 1
			ELSE 0
		END AS [New],
		COALESCE([WorkFlow_Counters].[ID], NEWID()) AS [ID],
		[WorkFlowExec].[AccountID] AS [AccountID],
		NULL AS [WorkFlowID],
		NULL AS [ExecID],
		@CounterName AS [Name],
		[WorkFlow_Counters].[Value] AS [OldValue],
		CASE @Operation
			WHEN 0 THEN @Value
			WHEN 1 THEN COALESCE([WorkFlow_Counters].[Value], 0) + @Value
			WHEN 2 THEN COALESCE([WorkFlow_Counters].[Value], 0) - @Value
			ELSE @Value
		END AS [NewValue]
	FROM #WorkFlowExec AS [WorkFlowExec]
	LEFT OUTER JOIN [dbo].[WorkFlow_Counters]
	ON [WorkFlow_Counters].[AccountID] = [WorkFlowExec].[AccountID]
	AND [WorkFlow_Counters].[WorkFlowID] IS NULL
	AND [WorkFlow_Counters].[ExecID] IS NULL
	AND [WorkFlow_Counters].[Name] = @CounterName;
END;

UPDATE [dbo].[WorkFlow_Counters]
SET [Value] = [Counters].[Value]
FROM [dbo].[WorkFlow_Counters]
INNER JOIN @Counters AS [Counters]
ON [WorkFlow_Counters].[ID] = [Counters].[ID]
WHERE [Counters].[New] = 0;

INSERT INTO [dbo].[WorkFlow_Counters] ([ID], [AccountID], [WorkFlowID], [ExecID], [Name], [Value])
SELECT [ID], [AccountID], [WorkFlowID], [ExecID], [Name], [Value]
FROM @Counters AS [Counters]
WHERE [Counters].[New] = 1;

DECLARE @ScopeName VARCHAR(50);
DECLARE @ActionType VARCHAR(50);

SET @ScopeName = CASE @CounterScope
		WHEN 1 THEN 'Work Flow'
		WHEN 2 THEN 'Account'
		ELSE 'Local'
	END;

SET @ActionType = CASE @Operation
		WHEN 1 THEN 'incremented by ' + CAST(@Value AS VARCHAR(50))
		WHEN 2 THEN 'decremented by ' + CAST(@Value AS VARCHAR(50))
		ELSE 'set to'
	END;


UPDATE [WorkFlowAcct]
SET [Comment] = @ScopeName + ' counter "' + @CounterName + '" ' + @ActionType + ' from ' + CAST(COALESCE([Counters].[OldValue], 0) AS VARCHAR(50)) + ' to ' + CAST([Counters].[Value] AS VARCHAR(50)) + '.'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Counters AS [Counters]
ON [WorkFlowAcct].[ExecID] = [Counters].[WFEID];

RETURN 0;
GO

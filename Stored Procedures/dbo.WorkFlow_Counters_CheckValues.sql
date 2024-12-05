SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Counters_CheckValues] @CounterScope TINYINT, @CounterName VARCHAR(50), @Value INTEGER, @GreaterRange BIT
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Counters TABLE (
	[WFEID] UNIQUEIDENTIFIER NOT NULL,
	[AccountID] INTEGER NOT NULL,
	[Value] INTEGER NOT NULL
);

IF @CounterScope = 0 BEGIN
	INSERT INTO @Counters ([WFEID], [AccountID], [Value])
	SELECT [WorkFlowExec].[ExecID],
		[WorkFlowExec].[AccountID] AS [AccountID],
		COALESCE([WorkFlow_Counters].[Value], 0) AS [Value]
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
	INSERT INTO @Counters ([WFEID], [AccountID], [Value])
	SELECT [WorkFlowExec].[ExecID],
		[WorkFlowExec].[AccountID] AS [AccountID],
		COALESCE([WorkFlow_Counters].[Value], 0) AS [Value]
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
	INSERT INTO @Counters ([WFEID], [AccountID], [Value])
	SELECT [WorkFlowExec].[ExecID],
		[WorkFlowExec].[AccountID] AS [AccountID],
		COALESCE([WorkFlow_Counters].[Value], 0) AS [Value]
	FROM #WorkFlowExec AS [WorkFlowExec]
	LEFT OUTER JOIN [dbo].[WorkFlow_Counters]
	ON [WorkFlow_Counters].[AccountID] = [WorkFlowExec].[AccountID]
	AND [WorkFlow_Counters].[WorkFlowID] IS NULL
	AND [WorkFlow_Counters].[ExecID] IS NULL
	AND [WorkFlow_Counters].[Name] = @CounterName;
END;

DECLARE @ScopeName VARCHAR(50);

SET @ScopeName = CASE @CounterScope
		WHEN 1 THEN 'Work Flow'
		WHEN 2 THEN 'Account'
		ELSE 'Local'
	END;

UPDATE [WorkFlowAcct]
SET [True] = CASE
		WHEN @GreaterRange = 0 AND [Counters].[Value] < @Value THEN 1
		WHEN @GreaterRange = 1 AND [Counters].[Value] > @Value THEN 1
		ELSE 0
	END,
	[Comment] = @ScopeName + ' counter "' + @CounterName + '" is ' + CAST([Counters].[Value] AS VARCHAR(50)) + '.'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Counters AS [Counters]
ON [WorkFlowAcct].[ExecID] = [Counters].[WFEID]
AND [WorkFlowAcct].[AccountID] = [Counters].[AccountID];

RETURN 0;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[WorkFlow_PopulateAccounts] @LinkEvaluationMode TINYINT, @IncludeClosedAccounts BIT = 0, @CustomGroupID INTEGER = 0
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF OBJECT_ID('tempdb..#WorkFlowAcct') IS NULL BEGIN
	RAISERROR('#WorkFlowAcct table does not exist.', 16, 1);
	RETURN 1;
END;

SET @IncludeClosedAccounts = COALESCE(@IncludeClosedAccounts, 0);
SET @CustomGroupID = COALESCE(@CustomGroupID, 0);

CREATE TABLE #Accounts (
	[ExecID] UNIQUEIDENTIFIER NOT NULL,
	[AccountID] INTEGER NOT NULL
);

IF @LinkEvaluationMode BETWEEN 1 AND 9 BEGIN
	-- Insert non-linked accounts
	INSERT INTO #Accounts ([ExecID], [AccountID])
	SELECT [WorkFlowExec].[ExecID], [WorkFlowExec].[AccountID]
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN [dbo].[master]
	ON [WorkFlowExec].[AccountID] = [master].[number]
	WHERE [master].[link] IS NULL
	OR [master].[link] = 0;

	IF @LinkEvaluationMode = 1 BEGIN -- Link Drivers
		INSERT INTO #Accounts ([ExecID], [AccountID])
		SELECT [WorkFlowExec].[ExecID], [linked].[number]
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[master]
		ON [WorkFlowExec].[AccountID] = [master].[number]
		INNER JOIN [dbo].[master] AS [linked]
		ON [master].[link] = [linked].[link]
		WHERE [master].[link] <> 0
		AND [linked].[LinkDriver] = 1;
	END;
	ELSE IF @LinkEvaluationMode = 2 BEGIN -- Custom Group
		IF @CustomGroupID IS NULL OR @CustomGroupID = 0 BEGIN
			INSERT INTO #Accounts ([ExecID], [AccountID])
			SELECT [WorkFlowExec].[ExecID], [linked].[number]
			FROM #WorkFlowExec AS [WorkFlowExec]
			INNER JOIN [dbo].[master]
			ON [WorkFlowExec].[AccountID] = [master].[number]
			INNER JOIN [dbo].[master] AS [linked]
			ON [master].[link] = [linked].[link]
			INNER JOIN [dbo].[Fact]
			ON [linked].[customer] = [Fact].[CustomerID]
			WHERE [master].[link] <> 0
			AND [Fact].[CustomGroupID] IN (
				SELECT [Fact].[CustomGroupID]
				FROM [dbo].[Fact]
				INNER JOIN [dbo].[master]
				ON [Fact].[CustomerID] = [master].[customer]
				WHERE [master].[number] = [WorkFlowExec].[AccountID]
			)
			AND (@IncludeClosedAccounts = 1
				OR [linked].[qlevel] NOT IN ('998', '999')
			);
		END;
		ELSE BEGIN
			INSERT INTO #Accounts ([ExecID], [AccountID])
			SELECT [WorkFlowExec].[ExecID], [linked].[number]
			FROM #WorkFlowExec AS [WorkFlowExec]
			INNER JOIN [dbo].[master]
			ON [WorkFlowExec].[AccountID] = [master].[number]
			INNER JOIN [dbo].[master] AS [linked]
			ON [master].[link] = [linked].[link]
			INNER JOIN [dbo].[Fact]
			ON [linked].[customer] = [Fact].[CustomerID]
			WHERE [master].[link] <> 0
			AND [Fact].[CustomGroupID] = @CustomGroupID
			AND (@IncludeClosedAccounts = 1
				OR [linked].[qlevel] NOT IN ('998', '999')
			);
		END;
	END;
	ELSE IF @LinkEvaluationMode = 3 BEGIN -- Customer
		INSERT INTO #Accounts ([ExecID], [AccountID])
		SELECT [WorkFlowExec].[ExecID], [linked].[number]
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[master]
		ON [WorkFlowExec].[AccountID] = [master].[number]
		INNER JOIN [dbo].[master] AS [linked]
		ON [master].[link] = [linked].[link]
		WHERE [master].[link] <> 0
		AND [master].[customer] = [linked].[customer]
		AND (@IncludeClosedAccounts = 1
			OR [linked].[qlevel] NOT IN ('998', '999')
		);
	END;
	ELSE IF @LinkEvaluationMode = 4 BEGIN -- Class of Business
		INSERT INTO #Accounts ([ExecID], [AccountID])
		SELECT [WorkFlowExec].[ExecID], [linked].[number]
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[master]
		ON [WorkFlowExec].[AccountID] = [master].[number]
		INNER JOIN [dbo].[master] AS [linked]
		ON [master].[link] = [linked].[link]
		INNER JOIN [dbo].[vCustomerCOB] AS [master_cob]
		ON [master].[customer] = [master_cob].[customer]
		INNER JOIN [dbo].[vCustomerCOB] AS [linked_cob]
		ON [linked].[customer] = [linked_cob].[customer]
		WHERE [master].[link] <> 0
		AND [master_cob].[COB] = [linked_cob].[COB]
		AND (@IncludeClosedAccounts = 1
			OR [linked].[qlevel] NOT IN ('998', '999')
		);
	END;
	ELSE IF @LinkEvaluationMode = 5 BEGIN -- Branch
		INSERT INTO #Accounts ([ExecID], [AccountID])
		SELECT [WorkFlowExec].[ExecID], [linked].[number]
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[master]
		ON [WorkFlowExec].[AccountID] = [master].[number]
		INNER JOIN [dbo].[master] AS [linked]
		ON [master].[link] = [linked].[link]
		INNER JOIN [dbo].[desk] AS [master_desk]
		ON [master].[desk] = [master_desk].[code]
		INNER JOIN [dbo].[desk] AS [linked_desk]
		ON [linked].[desk] = [linked_desk].[code]
		WHERE [master].[link] <> 0
		AND [master_desk].[Branch] = [linked_desk].[Branch]
		AND (@IncludeClosedAccounts = 1
			OR [linked].[qlevel] NOT IN ('998', '999')
		);
	END;
	ELSE IF @LinkEvaluationMode = 6 BEGIN -- Department
		INSERT INTO #Accounts ([ExecID], [AccountID])
		SELECT [WorkFlowExec].[ExecID], [linked].[number]
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[master]
		ON [WorkFlowExec].[AccountID] = [master].[number]
		INNER JOIN [dbo].[master] AS [linked]
		ON [master].[link] = [linked].[link]
		INNER JOIN [dbo].[desk] AS [master_desk]
		ON [master].[desk] = [master_desk].[code]
		INNER JOIN [dbo].[Teams] AS [master_Teams]
		ON [master_desk].[TeamID] = [master_Teams].[ID]
		INNER JOIN [dbo].[desk] AS [linked_desk]
		ON [linked].[desk] = [linked_desk].[code]
		INNER JOIN [dbo].[Teams] AS [linked_Teams]
		ON [linked_desk].[TeamID] = [linked_Teams].[ID]
		WHERE [master].[link] <> 0
		AND [linked_Teams].[DepartmentID] = [master_Teams].[DepartmentID]
		AND (@IncludeClosedAccounts = 1
			OR [linked].[qlevel] NOT IN ('998', '999')
		);
	END;
	ELSE IF @LinkEvaluationMode = 7 BEGIN -- Team
		INSERT INTO #Accounts ([ExecID], [AccountID])
		SELECT [WorkFlowExec].[ExecID], [linked].[number]
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[master]
		ON [WorkFlowExec].[AccountID] = [master].[number]
		INNER JOIN [dbo].[master] AS [linked]
		ON [master].[link] = [linked].[link]
		INNER JOIN [dbo].[desk] AS [master_desk]
		ON [master].[desk] = [master_desk].[code]
		INNER JOIN [dbo].[desk] AS [linked_desk]
		ON [linked].[desk] = [linked_desk].[code]
		WHERE [master].[link] <> 0
		AND [linked_desk].[TeamID] = [master_desk].[TeamID]
		AND (@IncludeClosedAccounts = 1
			OR [linked].[qlevel] NOT IN ('998', '999')
		);
	END;
	ELSE IF @LinkEvaluationMode = 8 BEGIN -- Desk
		INSERT INTO #Accounts ([ExecID], [AccountID])
		SELECT [WorkFlowExec].[ExecID], [linked].[number]
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[master]
		ON [WorkFlowExec].[AccountID] = [master].[number]
		INNER JOIN [dbo].[master] AS [linked]
		ON [master].[link] = [linked].[link]
		WHERE [master].[link] <> 0
		AND [master].[desk] = [linked].[desk]
		AND (@IncludeClosedAccounts = 1
			OR [linked].[qlevel] NOT IN ('998', '999')
		);
	END;
	ELSE IF @LinkEvaluationMode = 9 BEGIN -- All Accounts
		INSERT INTO #Accounts ([ExecID], [AccountID])
		SELECT [WorkFlowExec].[ExecID], [linked].[number]
		FROM #WorkFlowExec AS [WorkFlowExec]
		INNER JOIN [dbo].[master]
		ON [WorkFlowExec].[AccountID] = [master].[number]
		INNER JOIN [dbo].[master] AS [linked]
		ON [master].[link] = [linked].[link]
		WHERE [master].[link] <> 0;
	END;
END;
ELSE BEGIN
	INSERT INTO #Accounts ([ExecID], [AccountID])
	SELECT [ExecID], [AccountID]
	FROM #WorkFlowExec;
END;

INSERT INTO #WorkFlowAcct ([ExecID], [AccountID], [Linked], [ActivityVariable])
SELECT [Accounts].[ExecID], [Accounts].[AccountID], CASE [Accounts].[AccountID] WHEN [WorkFlowExec].[AccountID] THEN 1 ELSE 0 END, [WorkFlow_ExecutionVariables].[Variable]
FROM #Accounts AS [Accounts]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowExec].[ExecID] = [Accounts].[ExecID]
LEFT OUTER JOIN [dbo].[WorkFlow_ExecutionVariables]
ON [Accounts].[ExecID] = [WorkFlow_ExecutionVariables].[ExecID]
AND [WorkFlowExec].[ActivityID] = [WorkFlow_ExecutionVariables].[ActivityID]
AND [Accounts].[AccountID] = [WorkFlow_ExecutionVariables].[AccountID]
AND [WorkFlow_ExecutionVariables].[Name] = '(ActivityVariable)';

RETURN 0;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_QueryAction_StopWorkFlows] @WorkFlowID UNIQUEIDENTIFIER, @Accounts IMAGE
AS
SET NOCOUNT ON;

DECLARE @LoginName VARCHAR(10);
DECLARE @UserName VARCHAR(50);
DECLARE @Now DATETIME;

SET @Now = GETDATE();

SELECT @LoginName = [LoginName],
	@UserName = [UserName]
FROM [dbo].[GetCurrentLatitudeUser]();

DECLARE @Accts TABLE (
	[AccountID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
);

DECLARE @Exec TABLE (
	[ExecID] UNIQUEIDENTIFIER NOT NULL,
	[AccountID] INTEGER NOT NULL,
	[HistoryID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID())
);

INSERT INTO @Accts ([AccountID])
SELECT DISTINCT [Value]
FROM [dbo].[fnExtractIDs](@Accounts, 1);

INSERT INTO @Exec ([ExecID], [AccountID])
SELECT [WorkFlow_Execution].[ID], [Accts].[AccountID]
FROM [dbo].[WorkFlow_Execution]
INNER JOIN [dbo].[WorkFlow_Activities]
ON [WorkFlow_Execution].[ActivityID] = [WorkFlow_Activities].[ID]
INNER JOIN @Accts AS [Accts]
ON [WorkFlow_Execution].[AccountID] = [Accts].[AccountID]
WHERE [WorkFlow_Activities].[WorkFlowID] = @WorkFlowID;

INSERT INTO [dbo].[WorkFlow_ExecutionHistory] ([ID], [ExecID], [AccountID], [ActivityID], [Entered], [Evaluated], [NextActivityID])
SELECT [Exec].[HistoryID], [Exec].[ExecID], [WorkFlow_Execution].[AccountID], [WorkFlow_Execution].[ActivityID], [WorkFlow_Execution].[EnteredDate], @Now, '00000000-0000-0000-0000-000000000000'
FROM @Exec AS [Exec]
INNER JOIN [dbo].[WorkFlow_Execution]
ON [Exec].[ExecID] = [WorkFlow_Execution].[ID];

INSERT INTO [dbo].[WorkFlow_ExecutionHistoryComments] ([HistoryID], [AccountID], [Comment])
SELECT [Exec].[HistoryID], [Exec].[AccountID], 'WorkFlow stopped manually by ' + @LoginName + ' - ' + @UserName
FROM @Exec AS [Exec];

DELETE [dbo].[WorkFlow_Execution]
FROM [dbo].[WorkFlow_Execution]
INNER JOIN @Exec AS [Exec]
ON [Exec].[ExecID] = [WorkFlow_Execution].[ID];

RETURN 0;
GO

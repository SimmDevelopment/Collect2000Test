SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_ChangeDesk] @Desk VARCHAR(10)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;

DECLARE @Updates TABLE (
	[AccountID] INTEGER NOT NULL,
	[OldDesk] VARCHAR(10) NOT NULL,
	[OldBranch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Branch] VARCHAR(5) NOT NULL
);

DECLARE @ID INTEGER;
DECLARE @AccountID INTEGER;
DECLARE @Branch VARCHAR(5);
DECLARE @OldBranch VARCHAR(5);
DECLARE @OldDesk VARCHAR(10);
DECLARE @JobNumber VARCHAR(50);

SELECT @Branch = [desk].[branch]
FROM [dbo].[desk] WITH (NOLOCK)
WHERE [desk].[code] = @Desk;

IF @@ROWCOUNT = 0 BEGIN
	RAISERROR('Desk "%s" does not exist.', 16, 1, @Desk);
	RETURN 1;
END;

SET @JobNumber = 'WorkFlow-' + CONVERT(VARCHAR(30), GETDATE(), 126);

INSERT INTO @Updates ([AccountID], [OldDesk], [OldBranch], [Desk], [Branch])
SELECT DISTINCT [master].[number], [master].[desk], COALESCE([desk].[Branch], '00000'), @Desk, [newdesk].[Branch]
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
LEFT OUTER JOIN [dbo].[desk]
ON [master].[desk] = [desk].[code]
CROSS JOIN [dbo].[desk] AS [newdesk]
WHERE [newdesk].[code] = @Desk;

UPDATE [WorkFlowAcct]
SET [Comment] = 'Account already in desk "' + @Desk + '"'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Updates AS [Updates]
ON [WorkFlowAcct].[AccountID] = [Updates].[AccountID]
WHERE [Updates].[OldDesk] = [Updates].[Desk];

UPDATE [dbo].[master]
SET [desk] = [Updates].[Desk],
	[branch] = [Updates].[Branch]
FROM [dbo].[master]
INNER JOIN @Updates AS [Updates]
ON [master].[number] = [Updates].[AccountID]
WHERE [Updates].[Desk] <> [Updates].[OldDesk];

INSERT INTO [dbo].[DeskChangeHistory] ([Number], [JobNumber], [OldDesk], [NewDesk], [OldQLevel], [NewQLevel], [OldQDate], [NewQDate], [OldBranch], [NewBranch], [User], [DMDateStamp])
SELECT [master].[number], @JobNumber, [Updates].[OldDesk], [Updates].[Desk], [master].[qlevel], [master].[qlevel], [master].[qdate], [master].[qdate], [Updates].[OldBranch], [Updates].[Branch], 'WORKFLOW', GETDATE()
FROM [dbo].[master]
INNER JOIN @Updates AS [Updates]
ON [master].[number] = [Updates].[AccountID]
WHERE [Updates].[Desk] <> [Updates].[OldDesk];

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [IsPrivate])
SELECT [Updates].[AccountID], 'WKF', GETDATE(), 'WORKFLOW', 'DESK', 'CHNG', 'Desk Changed from ' + [Updates].[OldDesk] + ' to ' + [Updates].[Desk], 0
FROM [dbo].[master]
INNER JOIN @Updates AS [Updates]
ON [master].[number] = [Updates].[AccountID]
WHERE [Updates].[Desk] <> [Updates].[OldDesk];

UPDATE [WorkFlowAcct]
SET [Comment] = 'Desk changed from "' + [Updates].[OldDesk] + '" to "' + [Updates].[Desk] + '"'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Updates AS [Updates]
ON [WorkFlowAcct].[AccountID] = [Updates].[AccountID]
WHERE [Updates].[OldDesk] <> [Updates].[Desk];

RETURN 0;
GO

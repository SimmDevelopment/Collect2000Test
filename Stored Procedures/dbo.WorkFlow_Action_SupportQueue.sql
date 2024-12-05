SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_SupportQueue] @QueueCode VARCHAR(3), @ShouldQueue BIT, @Comment VARCHAR(4000)
AS
SET NOCOUNT ON;

DECLARE @QueueType TINYINT;
DECLARE @accts TABLE (
	[AccountID] INTEGER NOT NULL PRIMARY KEY NONCLUSTERED
);

IF NOT EXISTS (SELECT * FROM [dbo].[QLevel] WHERE [code] BETWEEN '600' AND '799' AND [code] = @QueueCode) BEGIN
	RAISERROR('Supervisor queue "%s" does not exist.', 16, 1, @QueueCode);
	RETURN 1;
END;

IF @ShouldQueue IS NULL
	SELECT TOP 1 @ShouldQueue = [ShouldQueue]
	FROM [dbo].[QLevel]
	WHERE [QLevel].[code] = @QueueCode;

IF @QueueCode LIKE '6%'
	SET @QueueType = 0;
ELSE
	SET @QueueType = 1;

INSERT INTO @Accts ([AccountID])
SELECT DISTINCT [WorkFlowExec].[AccountID]
FROM #WorkFlowExec AS [WorkFlowExec]
WHERE NOT EXISTS (SELECT *
	FROM [dbo].[SupportQueueItems]
	WHERE [SupportQueueItems].[AccountID] = [WorkFlowExec].[AccountID]
	AND [SupportQueueItems].[QueueCode] = @QueueCode);

BEGIN TRANSACTION;

UPDATE [dbo].[master]
SET [ShouldQueue] = @ShouldQueue
FROM [dbo].[master] WITH (ROWLOCK)
INNER JOIN @Accts AS [Accts]
ON [master].[number] = [Accts].[AccountID];

IF @@ERROR <> 0 GOTO ErrorHandler;

INSERT INTO [dbo].[SupportQueueItems] ([QueueCode], [QueueType], [AccountID], [DateAdded], [DateDue], [LastAccessed], [ShouldQueue], [UserName], [Comment])
SELECT @QueueCode, @QueueType, [Accts].[AccountID], GETDATE(), { fn CURDATE() }, GETDATE(), @ShouldQueue, 'WORKFLOW', @Comment
FROM @Accts AS [Accts];

IF @@ERROR <> 0 GOTO ErrorHandler;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [IsPrivate])
SELECT [Accts].[AccountID], 'WKF', GETDATE(), 'WORKFLOW', CASE @QueueType WHEN 0 THEN 'CC' ELSE 'SC' END, @QueueCode, @Comment, 0
FROM @Accts AS [Accts];

IF @@ERROR <> 0 GOTO ErrorHandler;

UPDATE #WorkFlowAcct
SET [Comment] = 'Account moved to ' + CASE @QueueType WHEN 0 THEN 'Clerical' ELSE 'Supervisor' END + ' queue "' + @QueueCode + '": ' + @Comment;

COMMIT TRANSACTION;

RETURN 0;
ErrorHandler:
ROLLBACK TRANSACTION;
RETURN 1;
GO

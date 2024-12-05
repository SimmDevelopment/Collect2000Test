SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_ChangeStatus] @Status VARCHAR(5), @AllowClose BIT, @AllowReclose BIT, @AllowReturn BIT, @AllowReopen BIT, @AllowReinstate BIT
AS
SET NOCOUNT ON;

DECLARE @StatusType BIT;

SELECT @StatusType = CASE LEFT([status].[statustype], 1)
	WHEN '1' THEN 0
	ELSE 1
END
FROM [dbo].[status]
WHERE [status].[code] = @Status;

IF @@ROWCOUNT = 0 BEGIN
	RAISERROR('Status code "%s" does not exist.', 16, 1, @Status);
	RETURN 1;
END;

DECLARE @Accounts TABLE (
	[AccountID] INTEGER NOT NULL,
	[OldStatus] CHAR(3) NOT NULL,
	[OldQLevel] CHAR(3) NOT NULL,
	[Open] BIT NOT NULL,
	[OldClosed] DATETIME NULL,
	[OldReturned] DATETIME NULL,
	[QLevel] CHAR(3) NULL,
	[Closed] DATETIME NULL,
	[Returned] DATETIME NULL,
	[Comment] VARCHAR(260) NULL,
	[Note] VARCHAR(260) NULL,
	[Change] BIT NOT NULL DEFAULT(1)
);

INSERT INTO @Accounts ([AccountID], [OldStatus], [OldQLevel], [Open], [OldClosed], [OldReturned], [Comment])
SELECT DISTINCT [master].[number],
	[master].[status],
	COALESCE([master].[qlevel], '000'),
	CASE
		WHEN LEFT([status].[statustype], 1) = '0' THEN 1
		WHEN LEFT([status].[statustype], 1) = '1' THEN 0
		WHEN [master].[qlevel] IN ('998', '999') THEN 0
		ELSE 1
	END,
	[master].[closed],
	[master].[returned],
	'Can not change status from "' + [master].[status] + '" to "' + @Status + '": '
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [WorkFlowAcct].[AccountID] = [master].[number]
INNER JOIN [dbo].[status]
ON [master].[status] = [status].[code];

UPDATE @Accounts
SET [Change] = 0,
	[Comment] = [Comment] + 'Account already in status'
WHERE [OldStatus] = @Status
AND [Change] = 1;

IF @StatusType = 1 BEGIN
	IF @AllowReinstate = 0 BEGIN
		UPDATE @Accounts
		SET [Change] = 0,
			[Comment] = [Comment] + 'Can not reinstate account'
		WHERE [Open] = 0
		AND [OldQLevel] = '999'
		AND [Change] = 1;
	END;
	IF @AllowReopen = 0 BEGIN
		UPDATE @Accounts
		SET [Change] = 0,
			[Comment] = [Comment] + 'Can not reopen account'
		WHERE [Open] = 0
		AND [Change] = 1;
	END;
END;
ELSE BEGIN
	UPDATE @Accounts
	SET [Change] = 0,
		[Comment] = [Comment] + 'Account is returned to the customer'
	WHERE [OldQLevel] = '999'
	AND [Change] = 1;

	IF @AllowClose = 0 AND @AllowReturn = 0 BEGIN
		UPDATE @Accounts
		SET [Change] = 0,
			[Comment] = [Comment] + 'Can not close account'
		WHERE [Open] = 1
		AND [Change] = 1;
	END;
	IF @AllowReclose = 0 BEGIN
		UPDATE @Accounts
		SET [Change] = 0,
			[Comment] = [Comment] + 'Can not close account'
		WHERE [Open] = 0
		AND [Change] = 1;
	END;
END;

UPDATE @Accounts
SET [Comment] = 'Changed status from "' + [OldStatus] + '" to "' + @Status + '"',
	[Note] = 'Status Changed  |  ' + [OldStatus] + '  |  ' + @Status,
	[QLevel] = [OldQLevel],
	[Closed] = [OldClosed],
	[Returned] = [OldReturned]
WHERE [Change] = 1;

UPDATE @Accounts
SET [Comment] = [Comment] + ': Account Returned',
	[Note] = [Note] + '  |  Account Returned',
	[QLevel] = '999',
	[Closed] = GETDATE(),
	[Returned] = GETDATE()
WHERE [Change] = 1
AND [Open] = 1
AND @StatusType = 0
AND @AllowReturn = 1;

UPDATE @Accounts
SET [Comment] = [Comment] + ': Account Closed',
	[Note] = [Note] + '  |  Account Closed',
	[QLevel] = '998',
	[Closed] = GETDATE(),
	[Returned] = NULL
WHERE [Change] = 1
AND [Open] = 1
AND @StatusType = 0
AND @AllowClose = 1
AND @AllowReturn = 0;

UPDATE @Accounts
SET [Comment] = [Comment] + ': Account Reinstated',
	[Note] = [Note] + '  |  Account Reopened',
	[QLevel] = '100',
	[Closed] = NULL,
	[Returned] = NULL
WHERE [Change] = 1
AND [Open] = 0
AND [OldQLevel] = '999'
AND @StatusType = 1
AND @AllowReinstate = 1;

UPDATE @Accounts
SET [Comment] = [Comment] + ': Account Reopened',
	[Note] = [Note] + '  |  Account Reopened',
	[QLevel] = '100',
	[Closed] = NULL,
	[Returned] = NULL
WHERE [Change] = 1
AND [Open] = 0
AND [OldQLevel] <> '999'
AND @StatusType = 1
AND @AllowReopen = 1;

BEGIN TRANSACTION;

UPDATE [master]
SET [status] = @Status,
	[qlevel] = [Accounts].[QLevel],
	[closed] = [Accounts].[Closed],
	[returned] = [Accounts].[Returned]
FROM [dbo].[master]
INNER JOIN @Accounts AS [Accounts]
ON [master].[number] = [Accounts].[AccountID]
WHERE [Accounts].[Change] = 1;

INSERT INTO [dbo].[StatusHistory] ([AccountID], [DateChanged], [UserName], [OldStatus], [NewStatus])
SELECT [Accounts].[AccountID], GETDATE(), 'WORKFLOW', [Accounts].[OldStatus], @Status
FROM @Accounts AS [Accounts]
WHERE [Accounts].[Change] = 1;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [IsPrivate])
SELECT [Accounts].[AccountID], 'WKF', GETDATE(), 'WORKFLOW', '+++++', '+++++', [Accounts].[Note], 0
FROM @Accounts AS [Accounts]
WHERE [Accounts].[Change] = 1;

UPDATE [WorkFlowAcct]
SET [Comment] = [Accounts].[Comment]
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Accounts AS [Accounts]
ON [WorkFlowAcct].[AccountID] = [Accounts].[AccountID];

COMMIT TRANSACTION;

RETURN 0;
GO

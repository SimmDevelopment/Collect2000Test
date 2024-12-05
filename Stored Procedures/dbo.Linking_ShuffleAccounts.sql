SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[Linking_ShuffleAccounts] @Link INTEGER, @AccountID INTEGER = NULL, @LoginName VARCHAR(10) = 'SYSTEM'
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

IF @Link IS NULL OR @Link <= 0 BEGIN
	RAISERROR('@Link parameter is not valid.', 16, 1);
	RETURN 1;
END;

IF @AccountID <= 0 BEGIN
	RAISERROR('@AccountID parameter is not valid.', 16, 1);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[link] = @Link) BEGIN
	RAISERROR('Link #%d does not exist.', 16, 1, @Link);
	RETURN 1;
END;

IF @AccountID IS NULL BEGIN
	SELECT TOP 1
		@AccountID = [master].[number]
	FROM [dbo].[master]
	WHERE [master].[link] = @Link
	ORDER BY [master].[LinkDriver] DESC,
		CASE
			WHEN [master].[qlevel] < '998' THEN 1
			ELSE 0
		END,
		[master].[received] DESC;

	IF @AccountID IS NULL BEGIN
		RAISERROR('Link #%d does not contain any open accounts.', 16, 1, @Link);
		RETURN 1;
	END;
END;
ELSE BEGIN
	IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @AccountID) BEGIN
		RAISERROR('Account #%d does not exist.', 16, 1, @AccountID);
		RETURN 1;
	END;
	ELSE IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @AccountID AND [master].[link] = @Link) BEGIN
		RAISERROR('Account #%d does not belong to link #%d.', 16, 1, @AccountID, @Link);
		RETURN 1;
	END;
END;

DECLARE @Customer VARCHAR(7);
DECLARE @ShuffleAccounts BIT;
DECLARE @MoveInventoryToCollectorDesk BIT;
DECLARE @DeskConflictSupervisorQueueLevel VARCHAR(3);
DECLARE @DeskCount INTEGER;
DECLARE @Desk VARCHAR(10);
DECLARE @Branch VARCHAR(5);
DECLARE @DeskList TABLE (
	[desk] VARCHAR(10) NOT NULL PRIMARY KEY NONCLUSTERED,
	[Branch] VARCHAR(5) NOT NULL,
	[DriverDesk] BIT NOT NULL,
	[Worked] BIT NOT NULL,
	[Fees] MONEY NOT NULL
);
DECLARE @AccountList TABLE (
	[AccountID] INTEGER NOT NULL PRIMARY KEY NONCLUSTERED
);

SELECT @Customer = [master].[customer]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

SELECT TOP 1
	@ShuffleAccounts = [Linking_EffectiveConfiguration].[ShuffleAccounts],
	@MoveInventoryToCollectorDesk = [Linking_EffectiveConfiguration].[MoveInventoryToCollectorDesk],
	@DeskConflictSupervisorQueueLevel = [Linking_EffectiveConfiguration].[DeskConflictSupervisorQueueLevel]
FROM [dbo].[Linking_EffectiveConfiguration]
WHERE [Linking_EffectiveConfiguration].[Customer] = @Customer;

IF @ShuffleAccounts IS NULL BEGIN
	RAISERROR('Linking is not configured.', 16, 1);
	RETURN 1;
END;

IF @ShuffleAccounts = 0 BEGIN
	RETURN 0;
END;

INSERT INTO @DeskList ([desk], [Branch], [DriverDesk], [Worked], [Fees])
SELECT RTRIM([master].[desk]),
	RTRIM([desk].[branch]),
	MAX(CASE
		WHEN [master].[LinkDriver] = 1 THEN 1
		ELSE 0
	END) AS [DriverDesk],
	MAX(CASE
		WHEN [master].[TotalWorked] > 0 THEN 1
		ELSE 0
	END) AS [Worked],
	ISNULL([desk].[fees], 0) AS [Fees]
FROM [dbo].[master]
INNER JOIN [dbo].[desk]
ON [master].[desk] = [desk].[code]
WHERE [master].[link] = @Link
AND [master].[qlevel] < '998'
AND [desk].[desktype] = 'COLLECTOR'
GROUP BY [master].[desk], [desk].[branch], [desk].[fees];

SET @DeskCount = @@ROWCOUNT;

IF @DeskCount = 0 BEGIN
	RETURN 0;
END;
ELSE IF @DeskCount = 1 BEGIN
	SELECT TOP 1
		@Desk = [DeskList].[desk],
		@Branch = [DeskList].[Branch]
	FROM @DeskList AS [DeskList];
END;
ELSE IF @DeskCount > 1 BEGIN
	SELECT @DeskCount = COUNT(*)
	FROM @DeskList AS [DeskList]
	WHERE [DeskList].[Worked] = 1;

	IF @DeskCount = 0 BEGIN
		SELECT TOP 1
			@Desk = [DeskList].[desk],
			@Branch = [DeskList].[Branch]
		FROM @DeskList AS [DeskList]
		ORDER BY [DeskList].[Fees] DESC;
	END;
	ELSE IF @DeskCount = 1 BEGIN
		SELECT TOP 1
			@Desk = [DeskList].[desk],
			@Branch = [DeskList].[Branch]
		FROM @DeskList AS [DeskList]
		WHERE [DeskList].[Worked] > 0;
	END;
	ELSE BEGIN
		PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Could not determine collector desk for account #' + CAST(@AccountID AS VARCHAR) + '.';
		
		BEGIN TRANSACTION;

		INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment])
		VALUES (@AccountID, 'LNK', GETDATE(), @LoginName, 'SC', @DeskConflictSupervisorQueueLevel, 'Could not determine collector desk for linked account.');

		INSERT INTO [dbo].[SupportQueueItems] ([QueueCode], [AccountID], [DateAdded], [DateDue], [LastAccessed], [ShouldQueue], [UserName], [QueueType], [Comment])
		VALUES (@DeskConflictSupervisorQueueLevel, @AccountID, GETDATE(), { fn CURDATE() }, GETDATE(), 1, @LoginName, 1, 'Could not determine collector desk for linked account.');

		COMMIT TRANSACTION;
		RETURN 0;
	END;
END;

IF @Desk IS NOT NULL BEGIN
	INSERT INTO @AccountList ([AccountID])
	SELECT [master].[number]
	FROM [dbo].[master]
	INNER JOIN [dbo].[desk]
	ON [master].[desk] = [desk].[code]
	WHERE [master].[link] = @Link
	AND [master].[qlevel] < '998'
	AND (([desk].[desktype] = 'COLLECTOR'
			OR ([desk].[desktype] = 'INVENTORY'
				AND @MoveInventoryToCollectorDesk = 1)
			OR [master].[LinkDriver] = 1)
		OR [master].[number] = @AccountID)
	AND NOT [master].[desk] = @Desk;

	IF @@ROWCOUNT > 0 BEGIN
		PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Moving accounts on link #' + CAST(@Link AS VARCHAR) + ' onto desk "' + @Desk + '".';

		BEGIN TRANSACTION;

		INSERT INTO [dbo].[notes] ([number], [ctl], [user0], [created], [action], [result], [comment])
		SELECT [master].[number], 'LNK', @LoginName, GETDATE(), 'DESK', 'CHNG',
			'Desk changed from ' + ISNULL([master].[desk], 'N/A') + ' to ' + @Desk
		FROM [dbo].[master]
		INNER JOIN @AccountList AS [AccountList]
		ON [master].[number] = [AccountList].[AccountID];

		INSERT INTO [dbo].[DeskChangeHistory] ([Number], [JobNumber], [OldDesk], [NewDesk], [OldQLevel], [NewQLevel], [OldQDate], [NewQDate], [OldBranch], [NewBranch], [User], [DMDateStamp])
		SELECT [master].[number], 'LNK', ISNULL([master].[desk], ''), @Desk, [master].[qlevel], [master].[qlevel], [master].[qdate], [master].[qdate], [master].[branch], @Branch, @LoginName, GETDATE()
		FROM [dbo].[master]
		INNER JOIN @AccountList AS [AccountList]
		ON [master].[number] = [AccountList].[AccountID];

		UPDATE [dbo].[master]
		SET [desk] = @Desk,
			[branch] = @Branch
		FROM [dbo].[master]
		INNER JOIN @AccountList AS [AccountList]
		ON [master].[number] = [AccountList].[AccountID];

		COMMIT TRANSACTION;
	END;
END;

RETURN 0;


GO

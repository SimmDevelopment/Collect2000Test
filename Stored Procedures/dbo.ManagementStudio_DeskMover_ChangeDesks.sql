SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ManagementStudio_DeskMover_ChangeDesks] @accounts IMAGE, @littleEndian BIT, @desk VARCHAR(10), @qlevel VARCHAR(3), @shouldQueue BIT, @qdate DATETIME, @user VARCHAR(10), @jobNumber VARCHAR(50)
AS
SET NOCOUNT ON;

DECLARE @Now DATETIME;
DECLARE @NewBranch VARCHAR(5);

DECLARE @Accts TABLE (
	[AccountID] INTEGER NOT NULL,
	[OldDesk] VARCHAR(10) NOT NULL,
	[OldBranch] VARCHAR(5) NOT NULL,
	[OldQueueLevel] VARCHAR(3) NOT NULL,
	[OldQueueDate] VARCHAR(8) NOT NULL,
	[NewQueueLevel] VARCHAR(3) NOT NULL,
	[NewQueueDate] VARCHAR(8) NOT NULL,
	[ShouldQueue] BIT NOT NULL
);

SET @Now = GETDATE();
IF @jobNumber IS NULL BEGIN
	SELECT @jobNumber = 'DeskMover.' + [user].[LoginName] + '.' + CONVERT(VARCHAR(10), GETDATE(), 102)
	FROM [dbo].[GetCurrentLatitudeUser]() AS [user];
END;

SELECT @NewBranch = ISNULL([desk].[Branch], '00001')
FROM [dbo].[desk] WITH (NOLOCK)
WHERE [desk].[code] = @desk;

INSERT INTO @Accts ([AccountID], [OldDesk], [OldBranch], [OldQueueLevel], [OldQueueDate], [NewQueueLevel], [NewQueueDate], [ShouldQueue])
SELECT [accounts].[value],
	[master].[desk],
	ISNULL([desk].[Branch], '00001'),
	[master].[qlevel],
	[master].[qdate],
	CASE
		WHEN [master].[qlevel] NOT IN ('998', '999') THEN COALESCE(@qlevel, [master].[qlevel])
		ELSE [master].[qlevel]
	END,
	CASE
		WHEN [master].[qlevel] NOT IN ('998', '999') THEN COALESCE(CONVERT(CHAR(8), @qdate, 112), [master].[qdate])
		ELSE [master].[qdate]
	END,
	CASE
		WHEN [master].[qlevel] NOT IN ('998', '999') THEN COALESCE(@shouldQueue, [master].[ShouldQueue])
		ELSE [master].[ShouldQueue]
	END
FROM [dbo].[fnExtractIDs](@accounts, @littleEndian) AS [accounts]
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [accounts].[value] = [master].[number]
AND NOT [master].[desk] = @desk
INNER JOIN [dbo].[desk] (NOLOCK)
ON [master].[desk] = [desk].[code];

BEGIN TRANSACTION;

UPDATE [dbo].[master] WITH (ROWLOCK)
SET [desk] = @desk,
	[branch] = @NewBranch,
	[qlevel] = [Accts].[NewQueueLevel],
	[ShouldQueue] = [Accts].[ShouldQueue],
	[qdate] = [Accts].[NewQueueDate]
FROM [dbo].[master]
INNER JOIN @Accts AS [Accts]
ON [master].[number] = [Accts].[AccountID];

IF @@ERROR <> 0 GOTO ErrorHandler;

UPDATE [dbo].[pdc] WITH (ROWLOCK)
SET [desk] = @desk
FROM [dbo].[pdc]
INNER JOIN @Accts AS [Accts]
ON [pdc].[number] = [Accts].[AccountID];

IF @@ERROR <> 0 GOTO ErrorHandler;


INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
SELECT [Accts].[AccountID], @Now, @user, 'DESK', 'CHNG', 'Desk Changed from ' + [Accts].[OldDesk] + ' to ' + @desk
FROM @Accts AS [Accts];

IF @@ERROR <> 0 GOTO ErrorHandler;

INSERT INTO [dbo].[DeskChangeHistory] ([Number], [JobNumber], [OldDesk], [NewDesk], [OldQLevel], [NewQLevel], [OldQDate], [NewQDate], [OldBranch], [NewBranch], [User], [DMDateStamp])
SELECT [Accts].[AccountID], @jobNumber, [Accts].[OldDesk], @desk, [Accts].[OldQueueLevel], ISNULL(@qlevel, [Accts].[OldQueueLevel]), [Accts].[OldQueueDate], ISNULL(CONVERT(CHAR(8), @qdate, 112), [Accts].[OldQueueDate]), [Accts].[OldBranch], @NewBranch, @user, @Now
FROM @Accts AS [Accts];

IF @@ERROR <> 0 GOTO ErrorHandler;

COMMIT TRANSACTION;

RETURN 0;
ErrorHandler:
ROLLBACK TRANSACTION;
RETURN 1;

GO

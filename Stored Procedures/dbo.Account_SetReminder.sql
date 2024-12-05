SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[Account_SetReminder] @AccountID INTEGER, @Desk VARCHAR(10), @ReminderDate DATETIME
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @AccountDesk VARCHAR(10);
DECLARE @FollowAccountDesk BIT;

SELECT @AccountDesk = [master].[desk]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

-- If the desk on the account is the same as the desk on the reminder then set the
-- reminder desk to blank.  This will allow the reminder to follow the desk of the
-- account if the account is moved to another desk.
IF @AccountDesk = @Desk
	SET @FollowAccountDesk = 1;
ELSE
	SET @FollowAccountDesk = 0;

BEGIN TRY

	BEGIN TRANSACTION;

	IF EXISTS (SELECT * FROM [dbo].[Reminders] WHERE [AccountID] = @AccountID AND [Desk] = @Desk)
		UPDATE [dbo].[Reminders]
		SET [ReminderDate] = @ReminderDate,
			[Due] = @ReminderDate,
			[FollowAccountDesk] = @FollowAccountDesk
		WHERE [AccountID] = @AccountID
		AND [Desk] = @Desk;
	ELSE
		INSERT INTO [dbo].[Reminders] ([AccountID], [Desk], [ReminderDate], [Due], [FollowAccountDesk])
		VALUES (@AccountID, @Desk, @ReminderDate, @ReminderDate, @FollowAccountDesk);

	UPDATE [dbo].[master]
	SET [QDate] = CONVERT(CHAR(8), @ReminderDate, 112),
		[QTime] = SUBSTRING(CONVERT(CHAR(8), @ReminderDate, 108), 1, 2) + SUBSTRING(CONVERT(CHAR(8), @ReminderDate, 108), 4, 2),
		[QLevel] = '000',
		[ShouldQueue] = 0
	WHERE [number] = @AccountID;

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	RETURN 1;
END CATCH;

RETURN 0;

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Account_RemoveReminder] @AccountID INTEGER, @Desk VARCHAR(10)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	DELETE FROM [dbo].[Reminders]
	WHERE [AccountID] = @AccountID AND [Desk] = @Desk
	AND [ReminderDate] < GETUTCDATE();

	IF NOT EXISTS (SELECT * FROM [dbo].[Reminders] WHERE [AccountID] = @AccountID)
		UPDATE [dbo].[master]
		SET [qlevel] = '599',
			[ShouldQueue] = 1
		WHERE [number] = @AccountID
		AND [qlevel] = '000';

	COMMIT TRANSACTION;
	RETURN 0;
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION;
	RETURN 1;
END CATCH;

GO

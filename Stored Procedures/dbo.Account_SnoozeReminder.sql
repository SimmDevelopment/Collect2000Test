SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Account_SnoozeReminder] @AccountID INTEGER, @Desk VARCHAR(10), @ReminderDateUTC DATETIME
AS
SET NOCOUNT ON;

UPDATE [dbo].[Reminders]
SET [ReminderDate] = @ReminderDateUTC
WHERE [Desk] = @Desk
AND [AccountID] = @AccountID;

RETURN 0;

GO

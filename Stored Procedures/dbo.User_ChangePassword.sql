SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE     PROCEDURE [dbo].[User_ChangePassword] @UserID INTEGER, @OldPassword VARCHAR(128), @NewPassword VARCHAR(128), @NewPasswordSalt VARCHAR(128)
AS
SET NOCOUNT ON;
DECLARE @OldPasswordSalt VARCHAR(128);

IF NOT EXISTS (SELECT * FROM [dbo].[Users] WHERE [ID] = @UserID) BEGIN
	RAISERROR('User does not exist.', 16, 1);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[Users] WHERE [ID] = @UserID AND [Password] = @OldPassword) BEGIN
	RAISERROR('Old password is not correct.', 16, 1);
	RETURN 1;
END;

UPDATE [dbo].[Users]
SET @OldPasswordSalt = [PasswordSalt],
	[Password] = @NewPassword,
	[PasswordSalt] = @NewPasswordSalt,
	[PasswordDate] = { fn CURDATE() }
WHERE [Users].[ID] = @UserID
AND [Users].[Password] = @OldPassword;

INSERT INTO [dbo].[PasswordHistory] ([UserID], [PasswordHashSHA512], [PasswordSalt])
VALUES (@UserID, @OldPassword, @OldPasswordSalt);

RETURN 0;





GO

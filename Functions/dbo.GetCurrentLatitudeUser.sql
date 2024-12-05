SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCurrentLatitudeUser] ()
RETURNS @UserInfo TABLE (
	[UserID] INTEGER NOT NULL,
	[LoginName] VARCHAR(10) NOT NULL,
	[UserName] VARCHAR(50) NOT NULL,
	[ProgramName] VARCHAR(128) NOT NULL
)
AS BEGIN
	DECLARE @ProgramName VARCHAR(128);
	DECLARE @UserString VARCHAR(128);
	DECLARE @ColonPosition INTEGER;
	DECLARE @EndPosition INTEGER;
	DECLARE @UserID INTEGER;
	DECLARE @LoginName VARCHAR(10);
	DECLARE @UserName VARCHAR(50);

	SELECT TOP 1 @ProgramName = RTRIM([program_name])
	FROM [master].[dbo].[sysprocesses]
	WHERE [spid] = @@SPID
	AND [ecid] = 0;

	IF NOT PATINDEX('(%[0-9]:%) %', @ProgramName) = 1 BEGIN
		INSERT INTO @UserInfo ([UserID], [LoginName], [UserName], [ProgramName])
		VALUES (-1, 'anonymous', 'Unauthenticated User', @ProgramName);

		RETURN;
	END;

	SET @ColonPosition = CHARINDEX(':', @ProgramName, 1);
	SET @EndPosition = CHARINDEX(') ', @ProgramName, @ColonPosition);

	SET @UserString = SUBSTRING(@ProgramName, 2, @ColonPosition - 2);
	SET @LoginName = SUBSTRING(SUBSTRING(@ProgramName, @ColonPosition + 1, @EndPosition - @ColonPosition - 1), 1, 10);
	SET @ProgramName = SUBSTRING(@ProgramName, @EndPosition + 2, 128);

	IF ISNUMERIC(@UserString) = 0 BEGIN
		INSERT INTO @UserInfo([UserID], [LoginName], [UserName], [ProgramName])
		VALUES (0, @LoginName, @LoginName, @ProgramName);

		RETURN;
	END;

	SET @UserID = CAST(@UserString AS INTEGER);

	SELECT TOP 1 @LoginName = [LoginName], @UserName = [UserName]
	FROM [dbo].[Users]
	WHERE [ID] = @UserID
	AND [Active] = 1;

	IF @@ROWCOUNT = 0 BEGIN
		INSERT INTO @UserInfo([UserID], [LoginName], [UserName], [ProgramName])
		VALUES (@UserID, @LoginName, @LoginName, @ProgramName);

		RETURN;
	END;

	INSERT INTO @UserInfo([UserID], [LoginName], [UserName], [ProgramName])
	VALUES (@UserID, @LoginName, @UserName, @ProgramName);

	RETURN;
END

GO

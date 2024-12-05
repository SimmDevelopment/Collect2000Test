SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Phones_AddAttempt]
	@MasterPhoneID INTEGER,
	@Attempt DATETIME,
	@LoginName VARCHAR(10)
AS
SET NOCOUNT ON;

IF @Attempt IS NULL BEGIN
	SET @Attempt = GETDATE();
END;

IF @LoginName IS NULL BEGIN
	SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();
END;

INSERT INTO [dbo].[Phones_Attempts] ([MasterPhoneID], [AttemptedDate], [LoginName], [Active])
VALUES (@MasterPhoneID, @Attempt, @LoginName, 1);

RETURN 0;

GO

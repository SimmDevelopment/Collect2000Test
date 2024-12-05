SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[Account_DetachDocument] @AccountID INTEGER, @DocumentID UNIQUEIDENTIFIER, @DeleteDocument BIT OUTPUT
AS
SET NOCOUNT ON;

DECLARE @Name VARCHAR(150);
DECLARE @Index INTEGER;
DECLARE @LoginName VARCHAR(50);

SELECT @LoginName = [LoginName]
FROM [dbo].[GetCurrentLatitudeUser]();

SELECT @Name = [Name],
	@Index = [Index]
FROM [dbo].[Documentation_Attachments] WITH (ROWLOCK, XLOCK)
WHERE [AccountID] = @AccountID
AND [DocumentID] = @DocumentID;

IF @Index IS NOT NULL BEGIN
	DECLARE @Comment VARCHAR(2000);
	SET @Comment = 'Detached document "' + @Name + '", item ' + CAST(@Index AS VARCHAR(15))

	BEGIN TRANSACTION;

	DELETE FROM [dbo].[Documentation_Attachments]
	WHERE [AccountID] = @AccountID
	AND [DocumentID] = @DocumentID;

	INSERT INTO [dbo].[notes] ([number], [created], [UtcCreated], [user0], [action], [result], [comment])
	VALUES (@AccountID, GETDATE(), GETUTCDATE(), @LoginName, '+++++', '+++++', @Comment);

	COMMIT TRANSACTION;

	IF NOT EXISTS (SELECT * FROM [dbo].[Documentation_Attachments] WHERE [DocumentID] = @DocumentID) BEGIN
		DELETE FROM [dbo].[Documentation]
		WHERE [UID] = @DocumentID;

		SET @DeleteDocument = 1;
	END;
	ELSE SET @DeleteDocument = 0;
END;
ELSE SET @DeleteDocument = 0;

RETURN 0;



GO

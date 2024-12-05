SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE     PROCEDURE [dbo].[Account_AttachDocument] @AccountID INTEGER, @DocumentID UNIQUEIDENTIFIER, @Category VARCHAR(100), @Name VARCHAR(50), @Index INTEGER OUTPUT, @AttachedBy VARCHAR(50)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM [dbo].[Documentation_Attachments] WHERE [AccountID] = @AccountID AND [DocumentID] = @DocumentID) BEGIN
	SELECT @Index = [Index]
	FROM [dbo].[Documentation_Attachments]
	WHERE [AccountID] = @AccountID
	AND [DocumentID] = @DocumentID;

	RETURN 0;
END;

IF @Index IS NULL BEGIN
	SELECT @Index = ISNULL(MAX([Index]), 0) + 1
	FROM [dbo].[Documentation_Attachments]
	WHERE [AccountID] = @AccountID
	AND [Name] = @Name;
END;

DECLARE @Comment VARCHAR(2000);

SET @Comment = 'Attached document "' + @Name + '", item ' + CAST(@Index AS VARCHAR(15))

BEGIN TRANSACTION;

INSERT INTO [dbo].[Documentation_Attachments] ([AccountID], [DocumentID], [Category], [Name], [Index], [AttachedBy])
VALUES (@AccountID, @DocumentID, @Category, @Name, @Index, @AttachedBy);

INSERT INTO [dbo].[notes] ([number], [created], [UtcCreated], [user0], [action], [result], [comment])
VALUES (@AccountID, GETDATE(), GETUTCDATE(), @AttachedBy, '+++++', '+++++', @Comment);

COMMIT TRANSACTION;

RETURN 0;





GO

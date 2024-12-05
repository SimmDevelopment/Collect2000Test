SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[Linking_MergeLinks] @FromLink INTEGER, @ToLink INTEGER, @EvaluateDriver BIT = 1, @ShuffleAccounts BIT = 1, @LoginName VARCHAR(10) = 'SYSTEM'
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

IF @FromLink IS NULL OR @ToLink IS NULL OR @FromLink = 0 OR @ToLink = 0 BEGIN
	RAISERROR('Link parameter is invalid.', 16, 1);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[link] = @FromLink) BEGIN
	RAISERROR('Link #%d does not exist.', 16, 1, @FromLink);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[link] = @ToLink) BEGIN
	RAISERROR('Link #%d does not exist.', 16, 1, @ToLink);
	RETURN 1;
END;

DECLARE @FromLinkCount INTEGER;
DECLARE @ToLinkCount INTEGER;
DECLARE @SavePoint CHAR(32);
DECLARE @Success BIT;
DECLARE @ReturnCode INTEGER;

SET @Success = 0;
IF @@TRANCOUNT = 0 BEGIN TRANSACTION;
ELSE BEGIN
	SET @SavePoint = SUBSTRING(CAST(NEWID() AS CHAR(36)), 1, 32);
	SAVE TRANSACTION @SavePoint;
END;

SELECT @FromLinkCount = COUNT(*)
FROM [dbo].[master]
WHERE [master].[link] = @FromLink;

SELECT @ToLinkCount = COUNT(*)
FROM [dbo].[master]
WHERE [master].[link] = @ToLink;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment])
SELECT [number], 'LNK', GETDATE(), @LoginName, 'LINK', 'MERGE', CAST(@FromLinkCount AS VARCHAR) + ' accounts in link #' + CAST(@FromLink AS VARCHAR) + ' merged with ' + CAST(@ToLinkCount AS VARCHAR) + ' accounts in link #' + CAST(@ToLink AS VARCHAR) + '.'
FROM [dbo].[master]
WHERE [master].[link] IN (@FromLink, @ToLink);

UPDATE [dbo].[master]
SET [link] = @ToLink
WHERE [link] = @FromLink;

IF @EvaluateDriver = 1 BEGIN
	EXEC @ReturnCode = [dbo].[Linking_EvaluateDriver] @Link = @ToLink;
	IF @ReturnCode <> 0 GOTO MergeComplete;
END;

IF @ShuffleAccounts = 1 BEGIN
	EXEC @ReturnCode = [dbo].[Linking_ShuffleAccounts] @Link = @ToLink;
	IF @ReturnCode <> 0 GOTO MergeComplete;
END;

SET @Success = 1;

MergeComplete:
IF @Success = 1 BEGIN
	IF @SavePoint IS NULL COMMIT TRANSACTION;
	RETURN 0;
END;
ELSE BEGIN
	IF @SavePoint IS NULL ROLLBACK TRANSACTION;
	ELSE ROLLBACK TRANSACTION @SavePoint;
	RETURN 1;
END;

GO

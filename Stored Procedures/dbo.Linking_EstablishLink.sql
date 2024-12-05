SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[Linking_EstablishLink] @Source INTEGER, @Target INTEGER, @EvaluateDriver BIT, @ShuffleAccounts BIT, @LoginName VARCHAR(10) = 'SYSTEM', @LinkID INTEGER = 0 OUTPUT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

IF @Source IS NULL OR @Target IS NULL BEGIN
	RAISERROR('Invalid account number.', 16, 1);
	RETURN 1;
END;

IF @Source = @Target BEGIN
	RETURN 0;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @Source) BEGIN
	RAISERROR('Account #%d does not exist.', 16, 1, @Source);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @Target) BEGIN
	RAISERROR('Account #%d does not exist.', 16, 1, @Target);
	RETURN 1;
END;

DECLARE @SourceLink INTEGER;
DECLARE @TargetLink INTEGER;
DECLARE @DestinationLink INTEGER;

SELECT @SourceLink = ISNULL([link], 0)
FROM [dbo].[master]
WHERE [master].[number] = @Source;

SELECT @TargetLink = ISNULL([link], 0)
FROM [dbo].[master]
WHERE [master].[number] = @Target;

IF NOT @SourceLink = @TargetLink OR (@SourceLink = 0 AND @TargetLink = 0) BEGIN
	DECLARE @SavePoint CHAR(32);
	DECLARE @Success BIT;

	SET @Success = 0;
	IF @@TRANCOUNT = 0
		BEGIN TRANSACTION;
	ELSE BEGIN
		SET @SavePoint = SUBSTRING(CAST(NEWID() AS CHAR(36)), 1, 32);
		SAVE TRANSACTION @SavePoint;
	END;

	IF @SourceLink = 0 AND @TargetLink = 0 BEGIN
		EXEC @DestinationLink = [dbo].[Linking_Allocate];

		UPDATE [dbo].[master]
		SET [link] = @DestinationLink,
			[LinkDriver] = 1
		WHERE [master].[number] = @Source;

		UPDATE [dbo].[master]
		SET [link] = @DestinationLink,
			[LinkDriver] = 0
		WHERE [master].[number] = @Target;

		INSERT INTO [dbo].[notes] ([number], [ctl], [user0], [created], [action], [result], [comment])
		VALUES (@Source, 'LNK', @LoginName, GETDATE(), 'LINK', 'NEW', 'This account linked to new link #' + CAST(@DestinationLink AS VARCHAR) + ' on account #' + CAST(@Target AS VARCHAR) + '.');

		INSERT INTO [dbo].[notes] ([number], [ctl], [user0], [created], [action], [result], [comment])
		VALUES (@Target, 'LNK', @LoginName, GETDATE(), 'LINK', 'NEW', 'This account linked to new link #' + CAST(@DestinationLink AS VARCHAR) + ' on account #' + CAST(@Source AS VARCHAR) + '.');

		PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Linking account #' + CAST(@Source AS VARCHAR) + ' to account #' + CAST(@Target AS VARCHAR) + ' under new link #' + CAST(@DestinationLink AS VARCHAR) + '.';
	END;
	ELSE IF @SourceLink = 0 BEGIN
		SET @DestinationLink = @TargetLink;

		UPDATE [dbo].[master]
		SET [link] = @DestinationLink
		WHERE [master].[number] = @Source;

		INSERT INTO [dbo].[notes] ([number], [ctl], [user0], [created], [action], [result], [comment])
		SELECT [master].[number], 'LNK', @LoginName, GETDATE(), 'LINK', 'JOIN',
			CASE [master].[number]
				WHEN @Source THEN 'This account joined to existing link #' + CAST(@DestinationLink AS VARCHAR) + ' on account #' + CAST(@Target AS VARCHAR) + '.'
				WHEN @Target THEN 'Account #' + CAST(@Source AS VARCHAR) + ' joined to link #' + CAST(@DestinationLink AS VARCHAR) + ' on this account.'
				ELSE 'Account #' + CAST(@Source AS VARCHAR) + ' joined to link #' + CAST(@DestinationLink AS VARCHAR) + ' on account #' + CAST(@Target AS VARCHAR) + '.'
			END
		FROM [dbo].[master]
		WHERE [master].[link] = @DestinationLink;

		PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Linking account #' + CAST(@Source AS VARCHAR) + ' to account #' + CAST(@Target AS VARCHAR) + ' under existing link #' + CAST(@DestinationLink AS VARCHAR) + '.';
	END;
	ELSE IF @TargetLink = 0 BEGIN
		SET @DestinationLink = @SourceLink;

		UPDATE [dbo].[master]
		SET [link] = @DestinationLink
		WHERE [master].[number] = @Target;

		INSERT INTO [dbo].[notes] ([number], [ctl], [user0], [created], [action], [result], [comment])
		SELECT [master].[number], 'LNK', @LoginName, GETDATE(), 'LINK', 'JOIN',
			CASE [master].[number]
				WHEN @Target THEN 'This account joined to existing link #' + CAST(@DestinationLink AS VARCHAR) + ' on account #' + CAST(@Source AS VARCHAR) + '.'
				WHEN @Source THEN 'Account #' + CAST(@Target AS VARCHAR) + ' joined to link #' + CAST(@DestinationLink AS VARCHAR) + ' on this account.'
				ELSE 'Account #' + CAST(@Target AS VARCHAR) + ' joined to link #' + CAST(@DestinationLink AS VARCHAR) + ' on account #' + CAST(@Source AS VARCHAR) + '.'
			END
		FROM [dbo].[master]
		WHERE [master].[link] = @DestinationLink;

		PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Linking account #' + CAST(@Target AS VARCHAR) + ' to account #' + CAST(@Source AS VARCHAR) + ' under existing link #' + CAST(@DestinationLink AS VARCHAR) + '.';
	END;
	ELSE BEGIN
		SET @DestinationLink = @TargetLink;
		PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Merging link #' + CAST(@SourceLink AS VARCHAR) + ' into link #' + CAST(@TargetLink AS VARCHAR) + ' due to account #' + CAST(@Source AS VARCHAR) + ' being linked to account #' + CAST(@Target AS VARCHAR) + '.';
		EXEC [dbo].[Linking_MergeLinks] @FromLink = @SourceLink, @ToLink = @TargetLink, @EvaluateDriver = 0, @ShuffleAccounts = 0;
	END;

	DECLARE @ReturnCode INTEGER;

	IF @EvaluateDriver = 1 BEGIN
		EXEC @ReturnCode = [dbo].[Linking_ShuffleAccounts] @Link = @DestinationLink, @AccountID = @Source, @LoginName = @LoginName;
		IF @ReturnCode <> 0 GOTO LinkComplete;
	END;

	IF @ShuffleAccounts = 1 BEGIN
		EXEC @ReturnCode = [dbo].[Linking_EvaluateDriver] @Link = @DestinationLink, @AccountID = @Source, @LoginName = @LoginName;
		IF @ReturnCode <> 0 GOTO LinkComplete;
	END;
	SET @LinkID = @DestinationLink;
	SET @Success = 1;

	LinkComplete:
	IF @Success = 1 BEGIN
		IF @SavePoint IS NULL COMMIT TRANSACTION;
		RETURN 0;
	END;
	ELSE BEGIN
		IF @SavePoint IS NULL ROLLBACK TRANSACTION;
		ELSE ROLLBACK TRANSACTION @SavePoint;
		RETURN 1;
	END;
END;
ELSE BEGIN
	SET @LinkID = @TargetLink;
END;

RETURN 0;



GO

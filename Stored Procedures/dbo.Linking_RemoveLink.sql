SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_RemoveLink] @AccountID INTEGER, @LoginName VARCHAR(10) = 'SYSTEM', @PreventLinking BIT = 0
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
SET XACT_ABORT ON;

IF @AccountID IS NULL BEGIN
	RAISERROR('Invalid account number.', 16, 1);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @AccountID) BEGIN
	RAISERROR('Account #%d does not exist.', 16, 1, @AccountID);
	RETURN 1;
END;

DECLARE @LinkID INTEGER;
DECLARE @Accounts INTEGER;

SELECT @LinkID = [master].[link]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

IF @LinkID IS NULL OR @LinkID = 0 BEGIN
	RETURN 0;
END;

BEGIN TRANSACTION;

SELECT @Accounts = COUNT(*)
FROM [dbo].[master]
WHERE [master].[link] = @LinkID;

INSERT INTO [dbo].[Linking_DoNotLink] ([Source], [Target])
SELECT @AccountID, [master].[number]
FROM [dbo].[master]
WHERE [master].[link] = @LinkID
AND NOT [master].[number] = @AccountID
AND NOT EXISTS (SELECT *
	FROM [dbo].[Linking_DoNotLink]
	WHERE [Linking_DoNotLink].[Source] = @AccountID
	AND [Linking_DoNotLink].[Target] = [master].[number])
UNION
SELECT [master].[number], @AccountID
FROM [dbo].[master]
WHERE [master].[link] = @LinkID
AND NOT [master].[number] = @AccountID
AND NOT EXISTS (SELECT *
	FROM [dbo].[Linking_DoNotLink]
	WHERE [Linking_DoNotLink].[Source] = [master].[number]
	AND [Linking_DoNotLink].[Target] = @AccountID);

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment])
SELECT [master].[number], 'LNK', GETDATE(), @LoginName, 'LINK', 'REMOVE',
	CASE [master].[number]
		WHEN @AccountID THEN 'This account removed from link #' + CAST(@LinkID AS VARCHAR) + '.'
		ELSE 'Account #' + CAST(@AccountID AS VARCHAR) + ' removed from link #' + CAST(@LinkID AS VARCHAR) + '.'
	END
FROM [dbo].[master]
WHERE [master].[link] = @LinkID;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Removing account #' + CAST(@AccountID AS VARCHAR) + ' from link #' + CAST(@LinkID AS VARCHAR) + '.';

UPDATE [master]
SET [link] = 0,
	[qlevel] = CASE [master].[qlevel]
		WHEN [Linking_EffectiveConfiguration].[FollowerQueueLevel] THEN [Linking_EffectiveConfiguration].[DriverQueueLevel]
		ELSE [master].[qlevel]
	END,
	[LinkDriver] = 0,
	[ShouldQueue] = CASE [master].[qlevel]
		WHEN '999' THEN 0
		WHEN '998' THEN 0
		ELSE 1
	END,
	[PreventLinking] = CASE COALESCE(@PreventLinking, 0)
		WHEN 1 THEN 1
		ELSE [master].[PreventLinking]
	END
FROM [dbo].[master] AS [master]
INNER JOIN [dbo].[Linking_EffectiveConfiguration]
ON [master].[customer] = [Linking_EffectiveConfiguration].[Customer]
WHERE [master].[link] = @LinkID
AND ([master].[number] = @AccountID
	OR @Accounts = 2);

IF EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[link] = @LinkID AND [master].[qlevel] < '998') BEGIN
	EXEC [dbo].[Linking_ShuffleAccounts] @Link = @LinkID, @LoginName = @LoginName;
	EXEC [dbo].[Linking_EvaluateDriver] @Link = @LinkID, @LoginName = @LoginName;
END;

COMMIT TRANSACTION;

RETURN 0;


GO

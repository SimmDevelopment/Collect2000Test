SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[Linking_PerformLinkActions]
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

IF OBJECT_ID('tempdb..#Actions') IS NOT NULL BEGIN
	DROP TABLE tempdb..#Actions
END;


CREATE TABLE #Actions (
	 [ID] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	 [ActionID] UNIQUEIDENTIFIER NOT NULL,
	 [Source] INTEGER NOT NULL,
	 [Customer] VARCHAR(7) NOT NULL,
	 [Target] INTEGER NOT NULL
 );

DECLARE @ID UNIQUEIDENTIFIER;
DECLARE @Source INTEGER;
DECLARE @Customer VARCHAR(7);
DECLARE @Target INTEGER;
DECLARE @Index INTEGER;
DECLARE @SavePoint CHAR(32);
DECLARE @ReturnCode INTEGER;

BEGIN TRANSACTION;

UPDATE [dbo].[master]
SET [link] = 0,
	[LinkDriver] = 0
FROM [dbo].[master]
INNER JOIN [dbo].[Linking_ActionsPending]
ON [master].[number] = [Linking_ActionsPending].[Source]
WHERE [Linking_ActionsPending].[Target] IS NULL
AND [master].[link] IS NULL;

DELETE FROM [dbo].[Linking_ActionsPending]
WHERE [Linking_ActionsPending].[Target] IS NULL;

COMMIT TRANSACTION;

DELETE FROM [dbo].[Linking_ActionsPending]
WHERE NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = [Linking_ActionsPending].[Source])
OR NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = [Linking_ActionsPending].[Target]);

INSERT INTO #Actions ([ActionID], [Source], [Customer], [Target])
SELECT [Linking_ActionsPending].[UID], [Linking_ActionsPending].[Source], [Linking_ActionsPending].[Customer], [Linking_ActionsPending].[Target]
FROM [dbo].[Linking_ActionsPending] WITH (NOLOCK)
WHERE [Linking_ActionsPending].[Target] IS NOT NULL
ORDER BY [Linking_ActionsPending].[Source], [Linking_ActionsPending].[Target];

SET @Index = 1;

WHILE EXISTS (SELECT * FROM #Actions WHERE [ID] = @Index) BEGIN
	SELECT @ID = [ActionID],
		@Source = [Source],
		@Customer = [Customer],
		@Target = [Target]
	FROM #Actions
	WHERE [ID] = @Index;

	IF @@TRANCOUNT = 0
		BEGIN TRANSACTION;
	ELSE BEGIN
		SET @SavePoint = SUBSTRING(CAST(NEWID() AS CHAR(36)), 1, 32);
		SAVE TRANSACTION @SavePoint;
	END;

	DECLARE @LinkID INTEGER;

	EXEC @ReturnCode = [dbo].[Linking_EstablishLink] @Source = @Source, @Target = @Target, @EvaluateDriver = 1, @ShuffleAccounts = 1, @LoginName = 'SYSTEM', @LinkID = @LinkID OUTPUT;

	IF @ReturnCode = 0 BEGIN
		DELETE FROM [dbo].[Linking_ActionsPending]
		WHERE [UID] = @ID;

		IF @SavePoint IS NULL
			COMMIT TRANSACTION;
	END;
	ELSE BEGIN
		IF @SavePoint IS NULL
			ROLLBACK TRANSACTION;
		ELSE
			ROLLBACK TRANSACTION @SavePoint;
	END;

	SET @Index = @Index + 1;
END;

IF OBJECT_ID('tempdb..#Actions') IS NOT NULL BEGIN
	DROP TABLE tempdb..#Actions
END;

RETURN 0;
GO

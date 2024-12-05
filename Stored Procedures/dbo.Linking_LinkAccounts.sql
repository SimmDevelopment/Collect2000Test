SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_LinkAccounts] @BatchSize INTEGER = 2500
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

IF NOT EXISTS (SELECT * FROM [dbo].[Linking_Configuration] WHERE [Customer] IS NULL AND [Class] IS NULL) BEGIN
	RAISERROR('Linking has not been configured.', 16, 1);
	RETURN -1;
END;

IF NOT OBJECT_ID('tempdb..#NewAccts') IS NULL BEGIN
	DROP TABLE #NewAccts;
END;
IF NOT OBJECT_ID('tempdb..#Matches') IS NULL BEGIN
	DROP TABLE #Matches;
END;
IF NOT OBJECT_ID('tempdb..#Possibles') IS NULL BEGIN
	DROP TABLE #Possibles;
END;
IF NOT OBJECT_ID('tempdb..#Exceptions') IS NULL BEGIN
	DROP TABLE #Exceptions;
END;

CREATE TABLE #NewAccts (
	[Number] INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	[Customer] VARCHAR(7) NOT NULL
);

CREATE TABLE #Matches (
	[Test] VARCHAR(20) NOT NULL,
	[Source] INTEGER NOT NULL,
	[SourceDebtor] INTEGER NULL,
	[Customer] VARCHAR(7) NOT NULL,
	[Target] INTEGER NOT NULL,
	[TargetDebtor] INTEGER NULL,
	[Score] INTEGER NOT NULL
);

CREATE INDEX idx_#Matches_SourceTarget ON #Matches ([Source], [Target]);

CREATE TABLE #Possibles (
	[ID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()),
	[Source] INTEGER NOT NULL,
	[Target] INTEGER NOT NULL,
	[PossibleLinkThreshold] INTEGER NOT NULL,
	[LinkThreshold] INTEGER NOT NULL,
	[TotalScore] INTEGER NOT NULL,
	[Link] BIT NOT NULL DEFAULT(0),
	[Evaluated] DATETIME NOT NULL DEFAULT(GETDATE()),
	PRIMARY KEY CLUSTERED ([Source], [Target])
);

CREATE UNIQUE INDEX idx_#Possibles_ID ON #Possibles ([ID]);

CREATE TABLE #Exceptions (
	[ID] UNIQUEIDENTIFIER NOT NULL,
	[Type] VARCHAR(20) NOT NULL,
	[SourceData] VARCHAR(500) NULL,
	[TargetData] VARCHAR(500) NULL,
	[Exception] VARCHAR(500) NOT NULL
);

CREATE INDEX idx_#Exceptions_ID ON #Exceptions ([ID]);

DECLARE @Affected INTEGER;
SET @Affected = NULL;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Populating HashData Start time';
EXEC [dbo].[Linking_UpdateHashData];
PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Populating HashData End time';

WHILE @Affected IS NULL OR NOT @Affected = 0 BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Determine New Accounts to link Start time';
	EXEC @Affected = [dbo].[Linking_DetermineNewAccounts] @BatchSize = @BatchSize;
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Determine New Accounts to link End time';
	IF @Affected = -1 BEGIN
		RAISERROR('Error during link evaluation.', 16, 1);
		RETURN -1;
	END;
	IF @Affected > 0 BEGIN

	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Determine Linkable Accounts Start time';
		EXEC [dbo].[Linking_DetermineLinkableAccounts];		
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Determine Linkable Accounts End time';

	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Determine Link Exceptions Start time';
		EXEC [dbo].[Linking_DetermineLinkExceptions];
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Determine Link Exceptions End time';

	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Determine Link Actions Start time';
		EXEC [dbo].[Linking_DetermineLinkActions];		
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Determine Link Actions End time';

	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Perform Link Actions Start time';
		EXEC [dbo].[Linking_PerformLinkActions];		
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Perform Link Actions End time';
	END;

	TRUNCATE TABLE #NewAccts;
	TRUNCATE TABLE #Matches;
	TRUNCATE TABLE #Possibles;
	TRUNCATE TABLE #Exceptions;
END;
EXEC [dbo].[Linking_FindConflicts];
EXEC [dbo].[Linking_SynchronizePhones];
RETURN 0;
GO

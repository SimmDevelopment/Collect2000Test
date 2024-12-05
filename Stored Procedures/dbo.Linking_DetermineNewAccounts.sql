SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_DetermineNewAccounts] @BatchSize INTEGER = 2500
WITH RECOMPILE
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

DECLARE @NumberOfAccounts INTEGER;
DECLARE @Error INTEGER;

IF OBJECT_ID('tempdb..#NewAccts') IS NULL BEGIN
	RAISERROR('Linking temporary table %s does not exist.', 16, 1, '#NewAccts');
	RETURN -1;
END;
IF OBJECT_ID('tempdb..#Matches') IS NULL BEGIN
	RAISERROR('Linking temporary table %s does not exist.', 16, 1, '#Matches');
	RETURN -1;
END;
IF OBJECT_ID('tempdb..#Possibles') IS NULL BEGIN
	RAISERROR('Linking temporary table %s does not exist.', 16, 1, '#Possibles');
	RETURN -1;
END;
IF OBJECT_ID('tempdb..#Exceptions') IS NULL BEGIN
	RAISERROR('Linking temporary table %s does not exist.', 16, 1, '#Exceptions');
	RETURN -1;
END;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Getting batch of accounts.';

SET ROWCOUNT @BatchSize;

INSERT INTO #NewAccts ([Number], [Customer])
SELECT DISTINCT [master].[number], [master].[customer]
FROM [dbo].[master] WITH (NOLOCK)
INNER JOIN [dbo].[Debtors] WITH (NOLOCK) ON [Debtors].[Number] = [master].[number] 
INNER JOIN [dbo].[Linking_HashData] WITH (READCOMMITTED) ON [Debtors].[DebtorID] = [Linking_HashData].[DebtorID]
WHERE [master].[link] IS NULL
AND NOT EXISTS (SELECT *
	FROM [dbo].[Linking_ActionsPending] WITH (NOLOCK)
	WHERE [Linking_ActionsPending].[Source] = [master].[number]
	OR [Linking_ActionsPending].[Target] = [master].[number])
AND [master].Customer in (
SELECT customer from 
[Linking_EffectiveConfiguration]
where linkmode != 0);

SELECT @NumberOfAccounts = @@ROWCOUNT, @Error = @@ERROR;

DECLARE @NewAcctsCount INT;
SELECT @NewAcctsCount = COUNT(*) FROM #NewAccts;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Found ' + CONVERT(VARCHAR, @NewAcctsCount)  + ' New Accounts.';

IF @@ERROR <> 0 BEGIN
	RETURN -1;
END;

IF @NumberOfAccounts = 0 BEGIN
	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': No new accounts found.';
	RETURN 0;
END;

SET ROWCOUNT 0;

PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Batch of ' + CAST(@NumberOfAccounts AS VARCHAR) + ' linkable accounts found.';

RETURN @NumberOfAccounts;
GO

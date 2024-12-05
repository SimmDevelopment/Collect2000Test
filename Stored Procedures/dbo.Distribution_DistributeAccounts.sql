SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Distribution_DistributeAccounts]
AS
-------------------------------------------------------------------
--  Purpose:  To process desk subscriptions to distribute        --
--            accounts from a source desk to collector desks.    --
--  Author:   Justin Spindler                                    --
--  Company:  Global Software Services, Inc.                     --
--  Created:  March 03, 2005                                     --
-------------------------------------------------------------------

-------------------------------------------------------------------
--  Set table options for the current connection.                --
-------------------------------------------------------------------
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

BEGIN TRANSACTION;

DECLARE @SubscriptionSources CURSOR;
DECLARE @SourceDesk VARCHAR(10);

-------------------------------------------------------------------
--  Gather all of the subscription source desks into a cursor.    --
-------------------------------------------------------------------
SET @SubscriptionSources = CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT [Subscriptions].[SourceDesk]
	FROM [dbo].[Subscriptions]
	INNER JOIN [dbo].[desk]
	ON [Subscriptions].[SourceDesk] = [desk].[code]
	WHERE [Subscriptions].[Active] = 1
	AND EXISTS (SELECT * FROM [dbo].[master]
		WHERE [master].[desk] = [desk].[code]
		AND [master].[link] IS NOT NULL);

OPEN @SubscriptionSources;

FETCH NEXT FROM @SubscriptionSources INTO @SourceDesk;

WHILE @@FETCH_STATUS = 0 BEGIN

	PRINT '[' + CONVERT(VARCHAR, GETDATE(), 121) + '] Scanning subscriptions for source desk "' + @SourceDesk + '"';

-------------------------------------------------------------------
--  Create a table of all of the destination desks that have     --
--  subscribed to the source desk which are active               --
-------------------------------------------------------------------
	DECLARE @DestinationDesks TABLE (
		[Desk] VARCHAR(10) NOT NULL PRIMARY KEY,
		[SubscriptionID] INTEGER NOT NULL,
		[CaseLimit] INTEGER NOT NULL,
		[CaseCount] INTEGER NOT NULL,
		[DailyRecords] INTEGER NOT NULL,
		[Maximum] AS CASE
			WHEN ([CaseLimit] - [CaseCount]) < [DailyRecords] THEN ([CaseLimit] - [CaseCount])
			ELSE [DailyRecords]
		END,
		[CustomerGroup] INTEGER NULL,
		[MinimumBalance] MONEY NOT NULL,
		[MaximumBalance] MONEY NOT NULL,
		[MaximumDays] INTEGER NOT NULL,
		[Count] INTEGER NOT NULL,
		[Balance] MONEY NOT NULL,
		[SubscriptionHistoryID] BIGINT NULL
	);

	INSERT INTO @DestinationDesks ([Desk], [SubscriptionID], [CaseLimit], [CaseCount], [DailyRecords], [CustomerGroup], [MinimumBalance], [MaximumBalance], [MaximumDays], [Count], [Balance])
	SELECT [Subscriptions].[DestinationDesk],
		[Subscriptions].[UID] AS [SubscriptionID],
		CASE
			--WHEN [desk].[EnforceLimit] IS NULL OR [desk].[EnforceLimit] = 0 OR [desk].[CaseLimit] IS NULL OR [desk].[CaseLimit] <= 0 THEN 999999999
			WHEN [desk].[CaseLimit] IS NULL OR [desk].[CaseLimit] <= 0 THEN 999999999
			ELSE [desk].[CaseLimit]
		END AS [CaseLimit],
		COUNT([master].[number]) AS [CaseCount],
		[Subscriptions].[DailyRecords],
		[Subscriptions].[CustomerGroup],
		ISNULL([Subscriptions].[MinimumBalance], 0) AS [MinimumBalance],
		ISNULL([Subscriptions].[MaximumBalance], 999999999) AS [MaximumBalance],
		[Subscriptions].[MaximumDays],
		0 AS [Count],
		0 AS [Balance]
	FROM [dbo].[Subscriptions]
	INNER JOIN [dbo].[desk]
	ON [Subscriptions].[DestinationDesk] = [desk].[code]
	LEFT OUTER JOIN [master]
	ON [desk].[code] = [master].[desk]
	AND [master].[qlevel] < '800'
	WHERE [Subscriptions].[Active] = 1 and [subscriptions].[sourcedesk] = @SourceDesk
	GROUP BY [Subscriptions].[DestinationDesk],
		[Subscriptions].[UID],
		CASE
--			WHEN [desk].[EnforceLimit] IS NULL OR [desk].[EnforceLimit] = 0 OR [desk].[CaseLimit] IS NULL OR [desk].[CaseLimit] <= 0 THEN 999999999
			WHEN [desk].[CaseLimit] IS NULL OR [desk].[CaseLimit] <= 0 THEN 999999999
			ELSE [desk].[CaseLimit]
		END,
		[Subscriptions].[DailyRecords],
		[Subscriptions].[CustomerGroup],
		[Subscriptions].[MinimumBalance],
		[Subscriptions].[MaximumBalance],
		[Subscriptions].[MaximumDays];

	DECLARE @PendingAccounts CURSOR;
	DECLARE @AccountID INTEGER;
	DECLARE @Balance MONEY;
	DECLARE @Customer VARCHAR(7);

-------------------------------------------------------------------
--  Gather all of the accounts in the source desk which have     --
--  already been evaluated for linking and are queuable, order   --
--  by oldest received to newest.
-------------------------------------------------------------------
	SET @PendingAccounts = CURSOR LOCAL FAST_FORWARD FOR
		SELECT [master].[number], [master].[current0], [master].[customer]
		FROM [dbo].[master]
		WHERE [master].[desk] = @SourceDesk
		AND [master].[link] IS NOT NULL
		AND [master].[qlevel] < '599'
		ORDER BY [master].[received] ASC;

	OPEN @PendingAccounts;

	BEGIN TRANSACTION;

	FETCH NEXT FROM @PendingAccounts INTO @AccountID, @Balance, @Customer;

	WHILE @@FETCH_STATUS = 0 BEGIN

		DECLARE @DestinationDesk VARCHAR(10);
		DECLARE @SubscriptionID INTEGER;
		DECLARE @SubscriptionHistoryID BIGINT;
		DECLARE @MaximumDays INTEGER;

		SET @DestinationDesk = NULL;

-------------------------------------------------------------------
--  Attempt to query the next available desk which has a         --
--  subscription which satisfies the required business rules     --
--  and can still accept more accounts based on case count       --
--  and the subscription daily maximum.                          --
-------------------------------------------------------------------
		SELECT TOP 1 @DestinationDesk = [DestinationDesks].[Desk],
			@SubscriptionID = [DestinationDesks].[SubscriptionID],
			@SubscriptionHistoryID = [DestinationDesks].[SubscriptionHistoryID],
			@MaximumDays = [DestinationDesks].[MaximumDays]
		FROM @DestinationDesks AS [DestinationDesks]
		WHERE [DestinationDesks].[Count] < [DestinationDesks].[Maximum] and [DestinationDesks].[Count] < [DestinationDesks].[CaseLimit]
		AND @Balance BETWEEN [DestinationDesks].[MinimumBalance] AND [DestinationDesks].[MaximumBalance]
		AND ([DestinationDesks].[CustomerGroup] IS NULL
			OR EXISTS (SELECT *
				FROM [dbo].[Fact]
				WHERE [Fact].[CustomerID] = @Customer
				AND [Fact].[CustomGroupID] = [DestinationDesks].[CustomerGroup])
		)
		ORDER BY [DestinationDesks].[Count] ASC,
			[DestinationDesks].[Balance] ASC;

-------------------------------------------------------------------
--  Check to see if there is an available desk to accept this    --
--  account.  If not the reasons would be that there are no      --
--  desks remaining that still may accept more accounts and      --
--  whose subscription business rules permit this account.       --
-------------------------------------------------------------------
		IF @DestinationDesk IS NOT NULL BEGIN
			BEGIN TRANSACTION;

-------------------------------------------------------------------
--  If no subscription history is being tracked for this         --
--  particular source desk to destination desk subscription      --
--  create a new subscription history record and store the       --
--  identifier to the destination desks table variable for       --
--  future reference.                                            --
-------------------------------------------------------------------
			IF @SubscriptionHistoryID IS NULL BEGIN
				INSERT INTO [dbo].[SubscriptionHistory] ([SubscriptionID])
				VALUES (@SubscriptionID);

				SET @SubscriptionHistoryID = SCOPE_IDENTITY();

				UPDATE @DestinationDesks
				SET [SubscriptionHistoryID] = @SubscriptionHistoryID
				WHERE [Desk] = @DestinationDesk;
			END;

-------------------------------------------------------------------
--  Move the account to the destination desk.                    --
-------------------------------------------------------------------
			DECLARE @ReturnStatus INTEGER;
			DECLARE @NextQueueDate CHAR(8);

			SET @NextQueueDate = CONVERT(CHAR(8), GETDATE(), 112);

			EXEC [dbo].[SP_DeskChange1]
				@number = @AccountID,
				@qdate = @NextQueueDate,
				@newdesk = @DestinationDesk,
				@UserID = 'Distro',
				@returnSts = @ReturnStatus OUTPUT;

-------------------------------------------------------------------
--  Record the desk move to the subscription history.            --
-------------------------------------------------------------------
			DECLARE @ExpirationDate DATETIME;

			IF @MaximumDays = 0 BEGIN
				SET @ExpirationDate = '9999-01-01'
			END;
			ELSE BEGIN
				SET @ExpirationDate = DATEADD(DAY, @MaximumDays, { fn CURDATE() });
			END;
			INSERT INTO [dbo].[SubscriptionHistoryItems] ([SubscriptionHistoryID], [AccountID], [SourceDesk], [DestinationDesk], [ExpirationDate])
			VALUES (@SubscriptionHistoryID, @AccountID, @SourceDesk, @DestinationDesk, @ExpirationDate);

-------------------------------------------------------------------
--  Add the account to the destination desks table variable so   --
--  that the next pass can determine if this desk has received   --
--  the maximum number of accounts for this distribution.        --
-------------------------------------------------------------------
			UPDATE @DestinationDesks
			SET [Count] = [Count] + 1,
				[Balance] = [Balance] + @Balance
			WHERE [Desk] = @DestinationDesk;

			PRINT '[' + CONVERT(VARCHAR, GETDATE(), 121) + '] Moving account ' + CAST(@AccountID AS VARCHAR) + ' with balance $' + CONVERT(VARCHAR, @Balance, 1) + ' to desk "' + @DestinationDesk + '"';

			COMMIT TRANSACTION;
		END;
		ELSE BEGIN
-------------------------------------------------------------------
--  If no desk was found to distribute this account check if     --
--  any desks are remaining that can accept more accounts.  If   --
--  not then cancel out of evaluating accounts for this source   --
--  desk immediately.                                            --
-------------------------------------------------------------------
			IF NOT EXISTS (SELECT * FROM @DestinationDesks WHERE [Count] < [Maximum]) BEGIN
				GOTO OutOfDesks;
			END;
		END;

		FETCH NEXT FROM @PendingAccounts INTO @AccountID, @Balance, @Customer;
	END;

	OutOfDesks:

-------------------------------------------------------------------
--  Clean up cursor resources allocated for this task.           --
-------------------------------------------------------------------
	COMMIT TRANSACTION;

	CLOSE @PendingAccounts;
	DEALLOCATE @PendingAccounts;	
	delete from @destinationdesks
	FETCH NEXT FROM @SubscriptionSources INTO @SourceDesk;
END;

CLOSE @SubscriptionSources;
DEALLOCATE @SubscriptionSources;

COMMIT TRANSACTION;

RETURN 0;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[Linking_EvaluateDriver] @Link INTEGER, @AccountID INTEGER = NULL, @LoginName VARCHAR(10) = 'SYSTEM'
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

DECLARE @RC int;

-- validate that we were passed a valid link id...
IF @Link IS NULL OR @Link <= 0 BEGIN
	RAISERROR('@Link parameter is not valid.', 16, 1);
	RETURN 1;
END;

-- validate the existence of the accountid if it was passed in...
IF @AccountID <= 0 BEGIN
	RAISERROR('@AccountID parameter is not valid.', 16, 1);
	RETURN 1;
END;

-- validate that the link exists in at least one master record...
IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[link] = @Link) BEGIN
	RAISERROR('Link #%d does not exist.', 16, 1, @Link);
	RETURN 1;
END;

-- was the new link driver accountid given...
IF @AccountID IS NULL BEGIN
	-- link driver accountid was not passed, so try to find an open account to use as the new link driver... 
	SELECT TOP 1
		@AccountID = [master].[number]
	FROM [dbo].[master]
	WHERE [master].[link] = @Link
	ORDER BY [master].[LinkDriver] DESC,
		CASE
			WHEN [master].[qlevel] < '998' THEN 1
			ELSE 0
		END,
		[master].[received] DESC;

	-- could not find an open account to use as the new link driver...
	IF @AccountID IS NULL BEGIN
		RAISERROR('Link #%d does not contain any open accounts.', 16, 1, @Link);
		RETURN 1;
	END;
END;
ELSE BEGIN
	-- a link driver accountid was passed, validate that it exists...and then if it has a matching link.
	IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @AccountID) BEGIN
		RAISERROR('Account #%d does not exist.', 16, 1, @AccountID);
		RETURN 1;
	END;
	ELSE IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @AccountID AND [master].[link] = @Link) BEGIN
		RAISERROR('Account #%d does not belong to link #%d.', 16, 1, @AccountID, @Link);
		RETURN 1;
	END;
END;

DECLARE @Customer VARCHAR(7);
DECLARE @EvaluateDriver BIT;
DECLARE @LinkDriverMode INTEGER;
DECLARE @FavorCollectorDesk BIT;
DECLARE @FavorPDCs BIT;
DECLARE @FavorPromises BIT;
DECLARE @DriverQueueLevel VARCHAR(3);
DECLARE @FollowerQueueLevel VARCHAR(3);
DECLARE @CurrentDriver INTEGER;
DECLARE @NewDriver INTEGER;
DECLARE @QueueDate DATETIME;
DECLARE @MovePromisesToNewDriver BIT;
DECLARE @FailMessage VARCHAR(255);

-- Get the customer of the new link driver...
SELECT @Customer = [master].[customer]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

-- get our configuration values for the customer...
SELECT TOP 1
	@EvaluateDriver = [Linking_EffectiveConfiguration].[EvaluateDriver],
	@LinkDriverMode = [Linking_EffectiveConfiguration].[LinkDriverMode],
	@FavorCollectorDesk = [Linking_EffectiveConfiguration].[FavorCollectorDesk],
	@FavorPDCs = [Linking_EffectiveConfiguration].[FavorPDCs],
	@FavorPromises = [Linking_EffectiveConfiguration].[FavorPromises],
	@DriverQueueLevel = [Linking_EffectiveConfiguration].[DriverQueueLevel],
	@FollowerQueueLevel = [Linking_EffectiveConfiguration].[FollowerQueueLevel],
	@MovePromisesToNewDriver = [Linking_EffectiveConfiguration].[MovePromisesToNewDriver]
FROM [dbo].[Linking_EffectiveConfiguration]
WHERE [Linking_EffectiveConfiguration].[Customer] = @Customer;

-- validate that linking has been configured...
IF @EvaluateDriver IS NULL BEGIN
	RAISERROR('Linking is not configured.', 16, 1);
	RETURN 1;
END;

-- if they have turned off evaluatedriver in configuration, then we just stop here...
IF @EvaluateDriver = 0 BEGIN
	RETURN 0;
END;

-- now lets get the current link driver accoundid...
SELECT TOP 1
	@CurrentDriver = [master].[number]
FROM [dbo].[master]
WHERE [master].[link] = @Link
AND [master].[LinkDriver] = 1;

-- (???) use our rules to query for a new driver account, shouldn't we only do this if we didn't pass one in...
SELECT TOP 1
	@NewDriver = [master].[number]
FROM [master]
INNER JOIN [desk]
ON [master].[desk] = [desk].[code]
WHERE [master].[link] = @Link
ORDER BY -- Favor open accounts
	CASE
		WHEN [qlevel] < '998' THEN 1
		ELSE 0
	END DESC,
	-- Favor accounts on collector desks
	CASE
		WHEN @FavorCollectorDesk = 1 AND [desk].[desktype] = 'COLLECTOR' THEN 1
		ELSE 0
	END DESC,
	-- Favor accounts with Post-Dated checks
	CASE
		WHEN @FavorPDCs = 1 AND EXISTS (SELECT * FROM [dbo].[pdc] WHERE [pdc].[number] = [master].[number] AND [pdc].[Active] = 1 AND [pdc].[onhold] IS NULL) THEN 1
		ELSE 0
	END DESC,
	-- Favor accounts with Promises
	CASE
		WHEN @FavorPromises = 1 AND EXISTS (SELECT * FROM [dbo].[Promises] WHERE [Promises].[AcctID] = [master].[number] AND [Promises].[Active] = 1 AND NOT [Promises].[Suspended] = 1) THEN 1
		ELSE 0
	END DESC,
	-- Use configured driver mode
	CASE @LinkDriverMode
		-- Newest account
		WHEN 0 THEN CASE WHEN [master].[linkdriver] = 1 THEN CAST(DATEADD(HOUR,1,[master].[received]) AS MONEY) ELSE CAST([master].[received] AS MONEY) END
		-- Oldest account
		WHEN 1 THEN CASE WHEN [master].[linkdriver] = 1 THEN CAST(DATEADD(HOUR,-1,[master].[received]) AS MONEY) * -1 ELSE CAST([master].[received] AS MONEY) * -1 END
		-- Highest current balance
		WHEN 2 THEN [master].[current0]
		-- Highest placed balance
		WHEN 3 THEN [master].[original]
		-- Most worked account
		WHEN 4 THEN CAST([master].[TotalWorked] AS MONEY)
		-- Least worked account
		WHEN 5 THEN CAST([master].[TotalWorked] AS MONEY) * -1
		ELSE 0
	END DESC,
	[master].[current0] DESC,
	[master].[received] ASC;

-- if we didn't find a new driver account using our rules, then use the passed in value for the new driver.
IF @NewDriver IS NULL BEGIN
	SET @NewDriver = @AccountID;
END;

-- if the current driver either did not exist, or if it's not the same as our new link driver...
-- in other words, does the link driver change...
IF @CurrentDriver IS NULL OR NOT @CurrentDriver = @NewDriver BEGIN
	IF @CurrentDriver IS NULL BEGIN
		PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Assigning Link Driver for link #' + CAST(@Link AS VARCHAR) + ' to account #' + CAST(@NewDriver AS VARCHAR) + '.';
	END;
	ELSE BEGIN
		PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Changing Link Driver for link #' + CAST(@Link AS VARCHAR) + ' from account #' + CAST(@CurrentDriver AS VARCHAR) + ' to account #' + CAST(@NewDriver AS VARCHAR) + '.';
	END;
	
	-- initialize the new qdate to today...
	SET @QueueDate = { fn CURDATE() };

	-- if any of the linked accounts have been worked today (or any future date?), then we need to increment our qdate one day (tomorrow)...
	IF EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[link] = @Link AND [master].[worked] >= { fn CURDATE() }) BEGIN
		SET @QueueDate = DATEADD(DAY, 1, @QueueDate);
	END;

	-- (???) Begin a transaction here...why, it doesn't appear that we ever do a rollback.
	BEGIN TRANSACTION;

	-- set the new link driver account to be link driver...
	UPDATE [dbo].[master]
		SET [LinkDriver] = 1,
		[qlevel] = CASE
			WHEN [master].[qlevel] IN ('015', '998', '999') THEN [master].[qlevel]
			WHEN @DriverQueueLevel = '' THEN [master].[qlevel]
			ELSE @DriverQueueLevel
		END,
		[ShouldQueue] = CASE
			WHEN [master].[qlevel] < '998' THEN 1
			ELSE 0
		END,
		[qdate] = CASE
			WHEN [master].[qlevel] < '998' THEN CONVERT(VARCHAR(8), @QueueDate, 112)
			ELSE [master].[qdate]
		END
	WHERE [master].[number] = @NewDriver;

	-- set the current link driver to be follower...
	UPDATE [dbo].[master]
		SET [LinkDriver] = 0,
		[qlevel] = CASE
			WHEN [master].[qlevel] IN ('998', '999') THEN [master].[qlevel]
			WHEN @FollowerQueueLevel = '' THEN [master].[qlevel]
			ELSE @FollowerQueueLevel
		END,
		[ShouldQueue] = 0,
		[qdate] = CASE
			WHEN [master].[qlevel] < '998' THEN CONVERT(VARCHAR(8), @QueueDate, 112)
			ELSE [master].[qdate]
		END
	WHERE [master].[link] = @Link
	AND NOT [master].[number] = @NewDriver;

	-- Add notes to linked accounts, noting "from" account if current driver exists...
	IF @CurrentDriver IS NULL BEGIN
		INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment])
		SELECT [master].[number],
			'LNK',
			GETDATE(),
			@LoginName,
			'LINK',
			'EVAL',
			CASE [master].[number]
				WHEN @NewDriver THEN 'Assigned Link Driver to this account.'
				ELSE 'Assigned Link Driver to account #' + CAST(@NewDriver AS VARCHAR) + '.'
			END
		FROM [dbo].[master]
		WHERE [master].[link] = @Link
		AND [master].[qlevel] < '998';
	END;
	ELSE BEGIN
		INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment])
		SELECT [master].[number],
			'LNK',
			GETDATE(),
			@LoginName,
			'LINK',
			'EVAL',
			CASE [master].[number]
				WHEN @CurrentDriver THEN 'Changed Link Driver from this account to account #' + CAST(@NewDriver AS VARCHAR) + '.'
				WHEN @NewDriver THEN 'Changed Link Driver from account #' + CAST(@CurrentDriver AS VARCHAR) + ' to this account.'
				ELSE 'Changed Link Driver from account #' + CAST(@CurrentDriver AS VARCHAR) + ' to account #' + CAST(@NewDriver AS VARCHAR) + '.'
			END
		FROM [dbo].[master]
		WHERE [master].[link] = @Link
		AND [master].[qlevel] < '998';
	END;

	-- Add logic here to move any promises, pdc's, or debtorcreditcard records to the new link driver account...
	IF @MovePromisesToNewDriver <> 0 
	BEGIN
		EXEC @RC = Linking_MovePromises @CurrentDriver, @NewDriver, @LoginName, @FailMessage = FailMessage
		IF @RC <> 0
		BEGIN
			PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Linking_MovePromises to Account #' + CAST(@NewDriver AS VARCHAR) + ' failed: ' + @FailMessage + '.';
		END
	END

	--(???) commit the transaction that we started above...
	-- again why did we start a transaction, we are not checking @@ERROR and there is no possible rollback...
	COMMIT TRANSACTION;
END;
ELSE BEGIN
	-- The driver did not change...
	SELECT @Customer = [master].[customer]
	FROM [dbo].[master]
	WHERE [master].[number] = @CurrentDriver;

	-- get the config values for the customer of our current driver...
	SELECT TOP 1
		@DriverQueueLevel = [Linking_EffectiveConfiguration].[DriverQueueLevel],
		@FollowerQueueLevel = [Linking_EffectiveConfiguration].[FollowerQueueLevel]
	FROM [dbo].[Linking_EffectiveConfiguration]
	WHERE [Linking_EffectiveConfiguration].[Customer] = @Customer;

	-- initialize the qdate to today...
	SET @QueueDate = { fn CURDATE() };

	-- if any of the linked accounts have been worked today (or any future date?), then we need to increment our qdate one day (tomorrow)...
	IF EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[link] = @Link AND [master].[worked] >= { fn CURDATE() }) BEGIN
		SET @QueueDate = DATEADD(DAY, 1, @QueueDate);
	END;

	-- update the current driver account with new qdate and qlevel if not closed...
	-- (???) shouldn't we also update the shouldqueue value?
	UPDATE [dbo].[master]
	SET [qdate] = CASE
		WHEN [master].[qlevel] NOT IN ('998', '999') THEN CONVERT(VARCHAR(8), @QueueDate, 112)
		ELSE [master].[qdate]
	END,
	[qlevel] = CASE
		WHEN @DriverQueueLevel = '' THEN [master].[qlevel]
		WHEN [master].[qlevel] IN ('998', '999') THEN [master].[qlevel]
		WHEN [master].[qlevel] = @FollowerQueueLevel THEN @DriverQueueLevel
		ELSE [master].[qlevel]
	END
	WHERE [master].[number] = @CurrentDriver;

	-- update any follower accounts with qlevel, linkdriver, and shouldqueue values...
	UPDATE [dbo].[master]
	SET [qlevel] = CASE
		WHEN @FollowerQueueLevel = '' THEN [master].[qlevel]
		WHEN [master].[qlevel] IN ('998', '999') THEN [master].[qlevel]
		ELSE @FollowerQueueLevel
	END,
	[LinkDriver] = 0,
	[ShouldQueue] = 0
	WHERE [master].[link] = @Link
	AND NOT [master].[number] = @CurrentDriver;
END;

RETURN 0;

GO

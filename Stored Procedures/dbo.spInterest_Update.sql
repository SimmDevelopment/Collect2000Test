SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spInterest_Update]
	@AccountID INTEGER,
	@AllAccounts BIT,
	@NewInterest MONEY = NULL OUTPUT,
	@DeferredInterest MONEY = NULL OUTPUT
WITH RECOMPILE
AS
-- Name:                        spInterest_Update
-- Function:        Updates interest on a single account or on all accounts
-- Creation:        2003 mr
--                                  Used by C2KPromise and EndOfDay
-- Change History:9/26/2003 Added Update of Accrued2 Where Accrued2 is null
--                      1/12/2003 Removes Update of Accrued2 Where Accrued2 is null. It has a default value
--                      5/1/2004 added to the where condition to update accounts only where current0 > 0
--                      5/25/2004 removed () grouping from numeric terms causing miscalculation because interestrate
--                      is a money type column.
--                      8/2/2004  Added statement that sets InterestRate to 0 if InterestRate is null
--                      4/11/2005 jc performance enhancement: changed else condition to perform a single update 
--                      with case logic rather than three separate updates. 
--			3/20/2007 jbs Added ability for multiple accruing buckets using InterestBuckets bitfield
--			6/7/2007 - mdd - removed bucket2 from the @Principal calculation (there are several good reasons for this)
--			10/24/2007 - jbs - updated stored procedure to return calculated interest to consolidate interest stored procedures
--			02/24/2009 - jbs - updated stored procedure to support interest deferral
 
DECLARE @Today SMALLDATETIME;
DECLARE @InterestBuckets SMALLINT;
DECLARE @Principal MONEY;
DECLARE @Accrued MONEY;
DECLARE @Deferred MONEY;
DECLARE @IsDeferred BIT;
DECLARE @IBInterest MONEY;
SET @Today = { fn CURDATE() };
SET NOCOUNT ON;
SET @NewInterest = 0;
 
IF @AccountID = 0 AND @AllAccounts = 1 BEGIN
	UPDATE [dbo].[master]
	SET [LastInterest] = [received]
	WHERE [LastInterest] IS NULL
	OR [LastInterest] <= '1900-01-01';

	UPDATE [dbo].[master]
	SET [InterestRate] = 0
	WHERE [InterestRate] IS NULL;

	UPDATE [dbo].[master]
	SET
		@InterestBuckets = COALESCE([master].[InterestBuckets], [customer].[InterestBuckets], 1),
		@Principal = CASE WHEN @InterestBuckets & 1 = 1 THEN [master].[current1] ELSE 0 END +
			CASE WHEN @InterestBuckets & 4 = 4 THEN [master].[current3] ELSE 0 END +
			CASE WHEN @InterestBuckets & 8 = 8 THEN [master].[current4] ELSE 0 END +
			CASE WHEN @InterestBuckets & 16 = 16 THEN [master].[current5] ELSE 0 END +
			CASE WHEN @InterestBuckets & 32 = 32 THEN [master].[current6] ELSE 0 END +
			CASE WHEN @InterestBuckets & 64 = 64 THEN [master].[current7] ELSE 0 END +
			CASE WHEN @InterestBuckets & 128 = 128 THEN [master].[current8] ELSE 0 END +
			CASE WHEN @InterestBuckets & 256 = 256 THEN [master].[current9] ELSE 0 END +
			CASE WHEN @InterestBuckets & 512 = 512 THEN [master].[current10] ELSE 0 END,
		@Deferred = COALESCE([master].[DeferredInterest], 0),
		@Accrued = ISNULL([dbo].[CalculateInterest](@Principal, [InterestRate], [LastInterest], @Today), 0),
		[current0] = CASE [master].[IsInterestDeferred]
			WHEN 1 THEN [master].[current0]
			ELSE [master].[current0] + ROUND(@Accrued + @Deferred, 2, 1)
		END,
		[current2] = CASE [master].[IsInterestDeferred]
			WHEN 1 THEN [master].[current2]
			ELSE [master].[current2] + ROUND(@Accrued + @Deferred, 2, 1)
		END,
		[accrued2] = CASE [master].[IsInterestDeferred]
			WHEN 1 THEN [master].[accrued2]
			ELSE [master].[accrued2] + ROUND(@Accrued + @Deferred, 2, 1)
		END,
		[DeferredInterest] = CASE [master].[IsInterestDeferred]
			WHEN 1 THEN ROUND(@Accrued + @Deferred, 2, 1)
			ELSE NULL
		END,
		[LastInterest] = @Today
		
	OUTPUT	inserted.number, @Today, inserted.interestrate,
			deleted.lastinterest, inserted.current0, 
			COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1),
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 1 = 1 THEN [inserted].[current1] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 4 = 4 THEN [inserted].[current3] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 8 = 8 THEN [inserted].[current4] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 16 = 16 THEN [inserted].[current5] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 32 = 32 THEN [inserted].[current6] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 64 = 64 THEN [inserted].[current7] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 128 = 128 THEN [inserted].[current8] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 256 = 256 THEN [inserted].[current9] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 512 = 512 THEN [inserted].[current10] ELSE 0 END,
			deleted.current2, inserted.current2-deleted.current2

    INTO [dbo].[Account_InterestAccrual]
				([AccountID], [Date], [InterestRate],
				[LastInterest], [Balance], 
				[InterestBuckets],
				[InterestBearingAmount], 
				[PreviousInterest], [Accrued])
		
	FROM [dbo].[master]
	INNER JOIN [dbo].[status]
	ON [master].[status] = [status].[code]
	INNER JOIN [dbo].[customer]
	ON [master].[customer] = [customer].[customer]	
	WHERE [status].[StatusType] = '0 - ACTIVE'
	AND [master].[Current0] > 0
	AND [master].[LastInterest] < @Today
	AND (
		[master].[InterestRate] > 0
		OR (
			[master].[IsInterestDeferred] = 0
			AND [master].[DeferredInterest] > 0
		)
	);

	UPDATE ib SET 
	@InterestBuckets = COALESCE([master].[InterestBuckets], [customer].[InterestBuckets], 1),
	@Principal = CASE WHEN @InterestBuckets & 1 = 1 THEN [master].[current1] ELSE 0 END +
		CASE WHEN @InterestBuckets & 4 = 4 THEN [master].[current3] ELSE 0 END +
		CASE WHEN @InterestBuckets & 8 = 8 THEN [master].[current4] ELSE 0 END +
		CASE WHEN @InterestBuckets & 16 = 16 THEN [master].[current5] ELSE 0 END +
		CASE WHEN @InterestBuckets & 32 = 32 THEN [master].[current6] ELSE 0 END +
		CASE WHEN @InterestBuckets & 64 = 64 THEN [master].[current7] ELSE 0 END +
		CASE WHEN @InterestBuckets & 128 = 128 THEN [master].[current8] ELSE 0 END +
		CASE WHEN @InterestBuckets & 256 = 256 THEN [master].[current9] ELSE 0 END +
		CASE WHEN @InterestBuckets & 512 = 512 THEN [master].[current10] ELSE 0 END,
	@Deferred = COALESCE([master].[DeferredInterest], 0),
	@Accrued = ISNULL([dbo].[CalculateInterest](@Principal, [InterestRate], [LastInterest], @Today), 0),
	ib.ItemizationBalance2 = COALESCE(ib.ItemizationBalance2, 0) + CASE [master].[IsInterestDeferred]
	WHEN 1 THEN 0 ELSE ROUND(@Accrued + @Deferred, 2, 1) END
	FROM [dbo].[master] 
	INNER JOIN [dbo].[customer] ON [master].[customer] = [customer].[customer]	
	INNER JOIN ItemizationBalance ib ON ib.AccountID = [master].number
	INNER JOIN [dbo].[status]
	ON [master].[status] = [status].[code]
	WHERE [status].[StatusType] = '0 - ACTIVE'
	AND [master].[Current0] > 0
	AND [master].[LastInterest] < @Today
	AND (
		[master].[InterestRate] > 0
		OR (
			[master].[IsInterestDeferred] = 0
			AND [master].[DeferredInterest] > 0
		)
	);
END;
ELSE BEGIN
	UPDATE [dbo].[master]
	SET [LastInterest] = [received]
	WHERE [number] = @AccountID
	AND ([LastInterest] IS NULL
		OR [LastInterest] <= '1900-01-01');

	UPDATE [dbo].[master]
	SET [InterestRate] = 0
	WHERE [number] = @AccountID
	AND [InterestRate] IS NULL;

	UPDATE [dbo].[master]
	SET
		@InterestBuckets = COALESCE([master].[InterestBuckets], [customer].[InterestBuckets], 1),
		@Principal = CASE WHEN @InterestBuckets & 1 = 1 THEN [master].[current1] ELSE 0 END +
			CASE WHEN @InterestBuckets & 4 = 4 THEN [master].[current3] ELSE 0 END +
			CASE WHEN @InterestBuckets & 8 = 8 THEN [master].[current4] ELSE 0 END +
			CASE WHEN @InterestBuckets & 16 = 16 THEN [master].[current5] ELSE 0 END +
			CASE WHEN @InterestBuckets & 32 = 32 THEN [master].[current6] ELSE 0 END +
			CASE WHEN @InterestBuckets & 64 = 64 THEN [master].[current7] ELSE 0 END +
			CASE WHEN @InterestBuckets & 128 = 128 THEN [master].[current8] ELSE 0 END +
			CASE WHEN @InterestBuckets & 256 = 256 THEN [master].[current9] ELSE 0 END +
			CASE WHEN @InterestBuckets & 512 = 512 THEN [master].[current10] ELSE 0 END,
		@IsDeferred = [master].[IsInterestDeferred],
		@Deferred = COALESCE([master].[DeferredInterest], 0),
		@Accrued = ISNULL([dbo].[CalculateInterest](@Principal, [InterestRate], [LastInterest], @Today), 0),
		[current0] = CASE @IsDeferred
			WHEN 1 THEN [master].[current0]
			ELSE [master].[current0] + ROUND(@Accrued + @Deferred, 2, 1)
		END,
		[current2] = CASE @IsDeferred
			WHEN 1 THEN [master].[current2]
			ELSE [master].[current2] + ROUND(@Accrued + @Deferred, 2, 1)
		END,
		[accrued2] = CASE @IsDeferred
			WHEN 1 THEN [master].[accrued2]
			ELSE [master].[accrued2] + ROUND(@Accrued + @Deferred, 2, 1)
		END,
		[DeferredInterest] = CASE @IsDeferred
			WHEN 1 THEN ROUND(@Accrued + @Deferred, 2, 1)
			ELSE NULL
		END,
		[LastInterest] = @Today
		
	OUTPUT	inserted.number, @Today, inserted.interestrate,
			deleted.lastinterest, inserted.current0, 
			COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1),
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 1 = 1 THEN [inserted].[current1] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 4 = 4 THEN [inserted].[current3] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 8 = 8 THEN [inserted].[current4] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 16 = 16 THEN [inserted].[current5] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 32 = 32 THEN [inserted].[current6] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 64 = 64 THEN [inserted].[current7] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 128 = 128 THEN [inserted].[current8] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 256 = 256 THEN [inserted].[current9] ELSE 0 END +
			CASE WHEN COALESCE([inserted].[InterestBuckets], [customer].[InterestBuckets], 1) & 512 = 512 THEN [inserted].[current10] ELSE 0 END,
			deleted.current2, inserted.current2-deleted.current2

    INTO [dbo].[Account_InterestAccrual]
				([AccountID], [Date], [InterestRate],
				[LastInterest], [Balance], 
				[InterestBuckets],
				[InterestBearingAmount], 
				[PreviousInterest], [Accrued])
		
	FROM [dbo].[master]
	INNER JOIN [dbo].[status]
	ON [master].[status] = [status].[code]
	INNER JOIN [dbo].[customer]
	ON [master].[customer] = [customer].[customer]
	WHERE [master].[number] = @AccountID
	AND [master].[Current0] > 0
	AND [status].[StatusType] = '0 - ACTIVE'
	AND ((
			[master].[LastInterest] < @Today
			AND [master].[InterestRate] > 0
		)
		OR (
			[master].[IsInterestDeferred] = 0
			AND [master].[DeferredInterest] > 0
		)
	);


	IF @IsDeferred = 1 BEGIN
		SET @DeferredInterest = ROUND(@Accrued + @Deferred, 2, 1);
		SET @NewInterest = 0;
	END;
	ELSE BEGIN
		SET @NewInterest = ROUND(@Accrued, 2, 1);
		SET @DeferredInterest = 0;
	END;

	SET @IBInterest = ROUND(@Accrued + @Deferred, 2, 1);
	IF @IBInterest <> 0
	BEGIN
		UPDATE ItemizationBalance WITH (ROWLOCK) SET ItemizationBalance2 = ISNULL(ItemizationBalance2, 0) + @IBInterest
		FROM ItemizationBalance
		WHERE AccountID = @AccountID;
	END

END;
RETURN @@ERROR;
GO

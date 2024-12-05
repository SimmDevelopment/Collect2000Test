SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/08/17
-- Description:	Evaluate payments for keeping promises
-- Notes: 
--	1) New field in payhistory table for PromiseAppliedAmt. This field is the amount of a 
--		payment that has been applied to a promise. Null value means no promises apply.
--	2) Payment can be used to fulfill a promise on linked accounts, even if not in arrangement.
--	3) Any payment with a null value in PromiseAppliedAmt will not be considered. 
--		(ie ISNULL(PromiseAppliedAmt, totalpaid)).
--	4) Only future promises or promises due within the last 10 days (see @MaxDaysPastDue) are considered.
-- Modified By: Luke Searcy
-- Modified Date: 2011-12-08
-- Modified Notes: Line # 141 Commented out the part were is was looking at the "suspended" 
-- this was cauing suspended promises not to be deactivated after payments being assign a payment link uid.
-- Modified Date: 2019-12-12: Changed the qlevel to 13 for ACCOUNT once promises are kept - LAT-10609
-- =============================================
CREATE PROCEDURE [dbo].[Payment_PromiseKeptEval]  
	@PayHistoryUID int, 
	@ErrorBlock varchar(30) Output
AS
BEGIN
	DECLARE @DEBUGGING bit
	SET @DEBUGGING = 0
	IF @DEBUGGING <> 1 SET NOCOUNT ON;

	DECLARE @LinkId int
	DECLARE @Rows int
	DECLARE @Err int
	DECLARE @Section varchar(30)
	DECLARE @OwnerNumber int
	DECLARE @PromiseAmt money
	DECLARE @PromiseID int
	DECLARE @PaymentAmt money
	DECLARE @PaymentID int
	DECLARE @UnpromisedAmt money
	DECLARE @AppliedAmt money
	DECLARE @MaxDaysPastDue int
	DECLARE @PaymentLinkUID int
	DECLARE @return_value int
	
	DECLARE @Promises table (
		promiseId int not null,
		number int not null, 
		amount money not null, 
		duedate datetime not null, 
		active bit not null,
		kept bit not null,
		paymentlinkuid int null,
		primary key(promiseId))	

	DECLARE @LinkedAccounts table (
		number int not null, 
		IsDriver bit not null, 
		IsOwner bit not null, 
		LinkId int null, 
		Status varchar(5) null, 
		NewStatus varchar(5) null, 
		QLevel varchar(3) null, 
		NewQLevel varchar(3) null, 
		QDate varchar(8) null, 
		ShouldQueue bit not null, 
		primary key(number))	

	DECLARE @Payments table (
		paymentid int not null,
		number int not null, 
		amount money not null, 
		unpromisedamount money not null, 
		datepaid datetime not null,
		primary key(paymentid))	

	SET @MaxDaysPastDue = 10

	-- get the Payment Link UID
	SELECT @PaymentLinkUID = p.PaymentLinkUID from payhistory as p where p.UID = @PayHistoryUID
	
	-- get all the linked accounts...
	SET @Section = 'Query for link value'
	IF @Debugging = 1 PRINT @Section
	SELECT @LinkId = ISNULL(m.Link, -1), @OwnerNumber = m.number 
	FROM master m INNER JOIN payhistory p ON m.number = p.number
	WHERE p.uid = @PayHistoryUID
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	IF @Err <> 0
	BEGIN
		SET @ErrorBlock = @Section
		RETURN @Err
	END
	IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

	IF @LinkId > 0 
	BEGIN
		IF @Debugging = 1 PRINT 'Account is linked: Link = ' + CAST(@LinkId as varchar(10))
		SET @Section = 'Query for linked accounts'
		IF @Debugging = 1 PRINT @Section
		INSERT INTO @LinkedAccounts (number, IsDriver, 
				IsOwner, 
				LinkId, Status, NewStatus, QLevel, NewQLevel, QDate, ShouldQueue) 
			SELECT m.number, m.LinkDriver, 
				CASE m.number WHEN @OwnerNumber THEN 1 ELSE 0 END, 
				m.Link, m.Status, m.Status, m.QLevel, m.QLevel, m.QDate, m.ShouldQueue 
			FROM master m 
			WHERE m.link = @LinkId AND qlevel not in ('998', '999')
		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
		IF @Err <> 0
		BEGIN
			SET @ErrorBlock = @Section
			IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
			RETURN @Err
		END
		IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

	END
	ELSE
	BEGIN
		IF @Debugging = 1 PRINT 'Account is not linked: Filenumber = ' + CAST(@OwnerNumber as varchar(10))
		SET @Section = 'Query for account'
		IF @Debugging = 1 PRINT @Section
		INSERT INTO @LinkedAccounts (number, IsDriver, IsOwner, LinkId, 
				Status, NewStatus, QLevel, NewQLevel, QDate, ShouldQueue) 
			SELECT m.number, m.LinkDriver, 1, m.Link, 
				m.Status, m.Status, m.QLevel, m.QLevel, m.QDate, m.ShouldQueue 
			FROM master m 
			WHERE m.number = @OwnerNumber
		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
		IF @Err <> 0
		BEGIN
			SET @ErrorBlock = @Section
			IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
			RETURN @Err
		END
		IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))
	END	

	-- Do we have any active promises on this account? Or any linked accounts?
	-- Don't consider promises that are more than 10 days past due...
	SET @Section = 'Query for active promises'
	IF @Debugging = 1 PRINT @Section
	IF @PaymentLinkUID = 0 or @PaymentLinkUID = NULL
	BEGIN
		INSERT INTO @Promises (promiseid, number, amount, duedate, active, kept) 
			SELECT p.ID, p.acctid, p.amount, p.duedate, p.active, ISNULL(p.kept, 0) 
			FROM promises p INNER JOIN @LinkedAccounts l ON p.acctid = l.number
			WHERE p.active = 1 
				AND ISNULL(p.kept,0) = 0 
				--AND ISNULL(p.suspended,0) = 0 
				AND DATEDIFF(d,ISNULL(p.duedate,GETDATE()),GETDATE()) <= @MaxDaysPastDue;
	END
	ELSE
	BEGIN
	INSERT INTO @Promises (promiseid, number, amount, duedate, active, kept) 
		SELECT p.ID, p.acctid, p.amount, p.duedate, p.active, ISNULL(p.kept, 0) 
		FROM promises p INNER JOIN @LinkedAccounts l ON p.acctid = l.number
		WHERE p.active = 1 
			AND ISNULL(p.kept,0) = 0 
			--AND ISNULL(p.suspended,0) = 0 
			AND DATEDIFF(d,ISNULL(p.duedate,GETDATE()),GETDATE()) <= @MaxDaysPastDue
			or p.PaymentLinkUID = @PaymentLinkUID;
	END
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	IF @Err <> 0
	BEGIN
		SET @ErrorBlock = @Section
		IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
		RETURN @Err
	END
	IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))
	IF @Rows = 0 
	BEGIN
		-- no promises, simply return 0
		SET @Section = 'No active promises'
		IF @Debugging = 1 PRINT @Section
		RETURN 0
	END
	ELSE
	BEGIN
		-- has promises, initialize PromiseAppliedAmt to 0
		SET @Section = 'Has active promises'
		IF @Debugging = 1 PRINT @Section
		UPDATE payhistory SET PromiseAppliedAmt = 0 WHERE uid = @PayHistoryUID
		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
		IF @Err <> 0
		BEGIN
			SET @ErrorBlock = @Section
			IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
			RETURN @Err
		END
		IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))
	END

	-- get any payments for the linked accounts that have unpromised money on them...
	SET @Section = 'Query for unpromised pmts'
	IF @Debugging = 1 PRINT @Section
	INSERT INTO @Payments (paymentid, number, amount, unpromisedamount, datepaid)
		SELECT p.uid, p.number, p.totalpaid, 
			(p.totalpaid - ISNULL(p.PromiseAppliedAmt, p.totalpaid)), p.datepaid
		FROM payhistory p INNER JOIN @LinkedAccounts l ON p.number = l.number
		WHERE p.batchtype LIKE 'P_' 
			AND (p.totalpaid - ISNULL(p.PromiseAppliedAmt, p.totalpaid)) > 0
			AND (p.postdateuid is null or p.postdateuid = 0)
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	IF @Err <> 0
	BEGIN
		SET @ErrorBlock = @Section
		IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
		RETURN @Err
	END
	IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

	IF @DEBUGGING = 1
	BEGIN
		SELECT * FROM @LinkedAccounts
		SELECT * FROM @Promises
		SELECT * FROM @Payments
	END

	WHILE 1 = 1
	BEGIN
		-- Find the oldest unkept promise
		SET @Section = 'Query for oldest promise'
		IF @Debugging = 1 PRINT @Section

		SELECT TOP 1 @PromiseAmt = amount, @PromiseID = promiseid 
		FROM @Promises 
		WHERE PaymentLinkUID = @PaymentLinkUID 
			and Kept = 0

		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT

		IF @Rows = 0
		BEGIN
			SELECT TOP 1 @PromiseAmt = amount, @PromiseID = promiseid 
			FROM @Promises 
		WHERE kept = 0 
		ORDER BY duedate ASC

		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
		END

		IF @Err <> 0
		BEGIN
			SET @ErrorBlock = @Section
			IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
			RETURN @Err
		END
		IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

		IF @Rows = 0 
		BEGIN 
			-- we have no more promises to work with...
			IF @Debugging = 1 PRINT 'No more promises to work with.'
			-- if there are no more unkept promises, then we should set to ACT/011
			-- Consider linked...
			IF @LinkId <=0 
			BEGIN
				-- update the status and qlevel if changed...
				SET @Section = 'Update status/qlevel'
				IF @Debugging = 1 PRINT @Section
				
				EXEC	@return_value = [dbo].[RefreshScheduledPaymentCount]
						@AccountID = @OwnerNumber

				
				UPDATE m 
				-- SET Status=ISNULL(spc.Status,'ACT'), QLevel=ISNULL(spc.Qlevel,'011')
				-- LAT-10609 - Promises kept- Status should be ACT/13
				SET Status=ISNULL(spc.Status,'ACT'), QLevel=ISNULL(spc.Qlevel,'013')				
				FROM master m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID
				WHERE number = @OwnerNumber

				SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
				IF @Err <> 0
				BEGIN
					SET @ErrorBlock = @Section
					IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
					RETURN @Err
				END
				IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

			END
			ELSE
			BEGIN
				-- update the status and qlevel if changed...
				SET @Section = 'Update driver status/qlevel'
				IF @Debugging = 1 PRINT @Section

				EXEC	@return_value = [dbo].[RefreshScheduledPaymentCount]
						@AccountID = @OwnerNumber
						
				UPDATE m 
				-- LAT-10609 - Promises kept- Status should be ACT/13
				-- SET Status=ISNULL(spc.status,'ACT'), QLevel=ISNULL(spc.qlevel,'011') 
				SET Status=ISNULL(spc.status,'ACT'), QLevel=ISNULL(spc.qlevel,'013') 
				FROM master m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID
				WHERE number IN (SELECT number FROM @LinkedAccounts WHERE IsDriver = 1)

				SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
				IF @Err <> 0
				BEGIN
					SET @ErrorBlock = @Section
					IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
					RETURN @Err
				END
				IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

				SET @Section = 'Update follower status/qlevel'
				IF @Debugging = 1 PRINT @Section

				UPDATE m 
				SET Status=ISNULL(spc.status,'ACT'), QLevel='875' 
				FROM master m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID
				WHERE number IN (SELECT number FROM @LinkedAccounts WHERE IsDriver <> 1)

				SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
				IF @Err <> 0
				BEGIN
					SET @ErrorBlock = @Section
					IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
					RETURN @Err
				END
				IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

			END
			-- break out of the outer loop now...
			BREAK
		END
		SET @Section = 'Sum unpromised amount'
		IF @Debugging = 1 PRINT @Section

		SELECT @UnpromisedAmt = SUM(unpromisedamount) 
		FROM @Payments

		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
		IF @Err <> 0
		BEGIN
			SET @ErrorBlock = @Section
			IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
			RETURN @Err
		END
		IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

		IF @PromiseAmt <= @UnpromisedAmt
		BEGIN
			SET @AppliedAmt = 0
			SET @Section = 'While money to apply'
			IF @Debugging = 1 PRINT @Section
			WHILE @AppliedAmt < @PromiseAmt
			BEGIN
				SET @Section = 'Select payment amt'
				IF @Debugging = 1 PRINT @Section
				
				SELECT TOP 1 @PaymentAmt = unpromisedamount, @PaymentID = paymentid 
				FROM @Payments 
				WHERE unpromisedamount > 0 
				ORDER BY datepaid

				SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
				IF @Err <> 0
				BEGIN
					SET @ErrorBlock = @Section
					IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
					RETURN @Err
				END
				IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

				IF @PaymentAmt >= @PromiseAmt - @AppliedAmt
				BEGIN
					-- finished with this promise...
					IF @Debugging = 1 PRINT 'Finished with this promise: UID=' + CAST(@PromiseId AS varchar(10))
					SET @Section = 'Update unpromised amt'
					IF @Debugging = 1 PRINT @Section
					SET @UnpromisedAmt = @PaymentAmt - (@PromiseAmt - @AppliedAmt)

					UPDATE @Payments SET unpromisedamount = @UnpromisedAmt 
					WHERE paymentid = @PaymentID

					SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
					IF @Err <> 0
					BEGIN
						SET @ErrorBlock = @Section
						IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
						RETURN @Err
					END
					IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

					SET @Section = 'Update payhistory promised'
					IF @Debugging = 1 PRINT @Section

					UPDATE payhistory SET PromiseAppliedAmt = totalpaid - @UnpromisedAmt 
					WHERE uid = @PaymentId

					SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
					IF @Err <> 0
					BEGIN
						SET @ErrorBlock = @Section
						IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
						RETURN @Err
					END
					IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

					SET @AppliedAmt = @PromiseAmt
					SET @Section = 'Update @promises kept'
					IF @Debugging = 1 PRINT @Section

					UPDATE @Promises SET kept = 1, active = 0 
					WHERE PromiseId = @PromiseID

					SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
					IF @Err <> 0
					BEGIN
						SET @ErrorBlock = @Section
						IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
						RETURN @Err
					END
					IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

					SET @Section = 'Update promises kept'
					IF @Debugging = 1 PRINT @Section

					UPDATE Promises SET kept = 1, active = 0 
					WHERE Id = @PromiseID

					SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
					IF @Err <> 0
					BEGIN
						SET @ErrorBlock = @Section
						IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
						RETURN @Err
					END
					IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

					BREAK
				END
				ELSE 
				BEGIN
					-- finished with this payment...
					IF @Debugging = 1 PRINT 'Finished with this payment: UID=' + CAST(@PaymentId AS varchar(10))
					SET @Section = 'Update @Payments unpromised'
					IF @Debugging = 1 PRINT @Section

					UPDATE @Payments SET unpromisedamount = 0 
					WHERE paymentid = @PaymentID

					SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
					IF @Err <> 0
					BEGIN
						SET @ErrorBlock = @Section
						IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
						RETURN @Err
					END
					IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

					SET @Section = 'Update payhistory promised'
					IF @Debugging = 1 PRINT @Section

					UPDATE payhistory SET PromiseAppliedAmt = totalpaid 
					WHERE uid = @PaymentId

					SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
					IF @Err <> 0
					BEGIN
						SET @ErrorBlock = @Section
						IF @Debugging = 1 PRINT 'ERROR(' + CAST(@Err AS varchar(10)) + ') at ' + @ErrorBlock
						RETURN @Err
					END
					IF @Debugging = 1 PRINT @Section + ': rowcount=' + CAST(@Rows AS varchar(10))

					SET @AppliedAmt = @AppliedAmt + @PaymentAmt
				END
			END -- WHILE
		END
		ELSE
		BEGIN
			-- not enough money to satisfy the promise...
			IF @Debugging = 1 PRINT 'Not enough money (' + CAST(ISNULL(@UnpromisedAmt,0) AS varchar(10)) + ') to satisfy the promise (' + CAST(ISNULL(@PromiseAmt,0) AS varchar(10)) + ').'
			BREAK
		END
	END -- WHILE

	IF @DEBUGGING = 1
	BEGIN
		SELECT * FROM @LinkedAccounts
		SELECT * FROM @Promises
		SELECT * FROM @Payments
	END

RETURN 0;
END
SET ANSI_NULLS ON
GO

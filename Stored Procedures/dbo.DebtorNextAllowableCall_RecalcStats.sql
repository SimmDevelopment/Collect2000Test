SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DebtorNextAllowableCall_RecalcStats] 
	@debtorID INTEGER,  
	@attemptsAllowed INTEGER,  
	@attemptsPeriod INTEGER,  
	@contactsAllowed INTEGER,  
	@contactsPeriod INTEGER,  
	@afterContactRestrictedPeriod INTEGER, 
	@nextAllowableDate DATE OUTPUT, 
	@reasonCode VARCHAR(255) OUTPUT
AS
	SET NOCOUNT ON;
	DECLARE @yesterday DATE;
	DECLARE @attemptsWithinPeriod INTEGER;
	DECLARE @minAttemptDate DATE;
	DECLARE @maxAttemptDate DATE;
	DECLARE @contactsWithinPeriod INTEGER;
	DECLARE @expressConsentDate DATE;
	DECLARE @maxContactDate DATE;
	DECLARE @minContactDate DATE;

	-- initialize next allowable date to yesterday.  If this is still the value at the end, it will get converted to null output value.
	SET @yesterday = CONVERT(DATE, DATEADD(d, -1, getdate()));
	SET @NextAllowableDate = @yesterday;

	-- express permission to call trumps all...so if there is one, and the dates in the future...we are done.
	SELECT 
		@contactsWithinPeriod = Count(*), 
		@expressConsentDate = MAX(ExpressConsentDate),
		@maxContactDate = MAX(ContactDate),
		@minContactDate = MIN(ContactDate)
	FROM Phonecall_Contacts 
	WHERE DebtorId = @debtorID AND ContactDate > DATEADD(d, -(@afterContactRestrictedPeriod), CAST(getdate() AS DATE))

	-- did we have any contacts?
	IF @contactsWithinPeriod > 0 BEGIN
		-- did we get express consent to call them back and is that date today or in future?
		IF CAST(ISNULL(@expressConsentDate, @yesterday) AS DATE) > @yesterday BEGIN
			SET @NextAllowableDate = CAST(@expressConsentDate AS DATE);
			SET @ReasonCode = 'EXPLICIT_PERMISSION';
			-- in this case we are complete, return success with these values.
			RETURN 0;
		END

		-- have we already contacted to the limit allowed OR are we outside the allowable period for multiple contacts?
		IF @contactsWithinPeriod >= @contactsAllowed OR DATEDIFF(d, @minContactDate, getdate()) > @contactsPeriod BEGIN
			SET @NextAllowableDate = DATEADD( d, @afterContactRestrictedPeriod, CAST(@maxContactDate AS DATE));
			SET @ReasonCode = 'CONTACTED';
			-- in this case we are complete, return success with these values.
			RETURN 0;
		END

		-- if we've gotten this far then we've had contact, but within the allowed date range we are still allowed more contact...
		-- the issue with this is that that time frame to contact can possibly run out without another event occurring.
		-- so we need to capture the fact that this should be regenerated before attempting again at a later date.
		IF DATEDIFF(d, @minContactDate, getdate()) > @contactsPeriod BEGIN
			-- Note that any compliance condition met following this can overwrite this reason...
			SET @ReasonCode = 'REQUIRES_RECALC';
		END
	END

	-- check next valid attempt date.
	SELECT
		@attemptsWithinPeriod = Count(*), 
		@maxAttemptDate = MAX(AttemptDate), 
		@minAttemptDate = MIN(AttemptDate)
	FROM Phonecall_Attempts 
	WHERE DebtorId = @debtorID AND AttemptDate > DATEADD(d, -(@attemptsPeriod), CAST(getdate() AS DATE))

	-- did our attempts count reach our limit?
	IF @attemptsWithinPeriod = @attemptsAllowed BEGIN
		SET @NextAllowableDate = DATEADD( d, @attemptsPeriod, CAST(@minAttemptDate AS DATE));
		SET @ReasonCode = 'ATTEMPT_LIMIT';
		-- in this case we are complete, return success with these values.
		RETURN 0;
	END

	-- did our attempts count exceed our limit? This should never happen, but if somehow it does, use the maxattemptsdate instead of min to set next.
	IF @attemptsWithinPeriod > @attemptsAllowed BEGIN
		SET @NextAllowableDate = DATEADD( d, @attemptsPeriod, CAST(@maxAttemptDate AS DATE));
		SET @ReasonCode = 'ATTEMPT_LIMIT';
		-- in this case we are complete, return success with these values.
		RETURN 0;
	END

	-- if we are here lets reset the date to null
	IF @NextAllowableDate = @yesterday BEGIN
		SET @NextAllowableDate = null;
	END;

	-- Debtors columns to update:
	-- NextAllowableCallAttemptDate date
	-- NextAllowableCallReason varchar 255
	RETURN 0;
GO

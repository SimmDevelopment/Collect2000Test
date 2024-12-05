SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DebtorNextAllowableCall_UpdateStats] 
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
	DECLARE @RC INTEGER;
	-- call the recalc sproc, capture the output and update the debtor record.
	-- Debtors columns to update:
	-- NextAllowableCallAttemptDate date
	-- NextAllowableCallReason varchar 255

	EXECUTE @RC = [dbo].[DebtorNextAllowableCall_RecalcStats] 
	   @debtorID
	  ,@attemptsAllowed
	  ,@attemptsPeriod
	  ,@contactsAllowed
	  ,@contactsPeriod
	  ,@afterContactRestrictedPeriod
	  ,@nextAllowableDate OUTPUT
	  ,@reasonCode OUTPUT

	-- SELECT @RC, @nextAllowableDate, @reasonCode
	IF @RC = 0 BEGIN
		UPDATE Debtors 
		SET NextAllowableCallAttemptDate = @nextAllowableDate, NextAllowableCallReason = @reasonCode 
		WHERE DebtorID = @debtorID
	END


	RETURN @RC;
GO

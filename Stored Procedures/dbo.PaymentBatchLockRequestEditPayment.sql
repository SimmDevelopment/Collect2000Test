SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Michael D. Devlin
-- Create date: 2008-06-19
-- Description:	Adds a payment edit lock on a batch...
--				Normally called prior to editing an existing batch payment.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.PaymentBatchLockRequestEditPayment.sql $
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 17:02:02-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  updated to support batch sharing functionality 
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2009-09-18   Time: 09:21:57-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  updated to support batch sharing funcitonality 
-- =============================================
CREATE PROCEDURE [dbo].[PaymentBatchLockRequestEditPayment] 
	-- Add the parameters for the stored procedure here
	@PaymentId int,
	@BatchNumber int, 
	@UserName varchar(255),
	@ApplicationName varchar(255),
	@MachineName varchar(255),
	@TTLMinutes int,
	@Granted bit OUT,
	@Reason varchar(511) OUT,
	@LockID int OUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RC int
	DECLARE @ReadLockType int;
	DECLARE @WriteLockType int;
	DECLARE @EditPaymentLockType int;
	DECLARE @EditLockType int;
	DECLARE @ProcessLockType int;
	DECLARE @RequestLockType int;
	DECLARE @LockType int;
	DECLARE @LockCount int;
	DECLARE @Expiration datetime;
	DECLARE @ChangedByOthers bit;
	DECLARE @Created datetime;
	DECLARE @Count int;

	SET @ReadLockType = 0
	SET @WriteLockType = 1
	SET @EditPaymentLockType = 2
	SET @EditLockType = 3
	SET @ProcessLockType = 4
	SET @RequestLockType = @EditPaymentLockType

	-- check if this batch has been edited by someone else since the readlock was acquired...
	SELECT @ChangedByOthers = ChangedByOthers, @LockId = LockId, @Created = Created
	FROM PaymentBatchLock 
	WHERE BatchNumber = @BatchNumber 
		AND LockType = @ReadLockType
		AND UserName = @UserName
		AND [Application] = @ApplicationName
		AND MachineName = @MachineName
	ORDER BY LockType Desc

	IF @@ROWCOUNT > 0 
	BEGIN
		IF @ChangedByOthers <> 0
		BEGIN
			-- this batch has been changed by others since this app queried for data...
			-- The user needs to refresh batch before attempting to edit...
			SET @Granted = 0
			-- lockid was set in the query above...
			SET @Reason = 'Batch number ' + CAST(@BatchNumber as varchar(12)) + 
				' has been modified by another user and needs to be reopened ' +
				'before this action can be performed. Batch initially opened: ' + 
				CAST(@Created as varchar(24)) + '. '
			RETURN @@ERROR
		END
	END
	ELSE
	BEGIN
		-- lost our read lock...we need to fail...
		-- The read lock has been removed.
		-- The user needs to refresh batch before attempting to add...
		SET @Granted = 0
		-- lockid was set in the query above...
		SET @Reason = 'Your lock on Batch number ' + CAST(@BatchNumber as varchar(12)) + 
			' has been removed. You will need to reopen the batch before any action can be performed. '
		RETURN @@ERROR
	END

	-- check if this batch is being edited by someone else...
	SELECT TOP 1 @LockId = LockId, @Reason = 'The batch currently has a lock (Id=' + CONVERT(varchar(12),LockId) + 
		') of type ' + CONVERT(varchar(12),LockType) + 
		') held on batch ' + CONVERT(varchar(12),BatchNumber) + 
		' by ' + UserName + 
		' using ' + [Application] + 
		' on ' + [MachineName] +
		' until ' + CAST([Expire] as varchar(24)) + '. '
	FROM PaymentBatchLock 
	WHERE BatchNumber = @BatchNumber 
		AND [Expire] > getdate()
		AND NOT (UserName = @UserName
			AND [Application] = @ApplicationName
			AND MachineName = @MachineName)
	ORDER BY LockType Desc

	IF @@ROWCOUNT > 0 
	BEGIN
		-- if this batch is being used by another user then we cannot process it...
		SET @Granted = 0
		-- both reason and lockid were set in the query above...
		RETURN @@ERROR
	END
	ELSE
	BEGIN
		-- OK, lets refresh our edit lock...
		EXECUTE @RC = [PaymentBatchLockRequestEdit] 
		   @BatchNumber
		  ,@UserName
		  ,@ApplicationName
		  ,@MachineName
		  ,@TTLMinutes
		  ,@Granted OUTPUT
		  ,@Reason OUTPUT
		  ,@LockID OUTPUT
	END

	-- At this point, if we are denied, then return as is...
	IF @Granted = 0
	BEGIN
		RETURN @@ERROR
	END

	-- check if this batch payment is being edited by someone else...
	SELECT TOP 1 @LockId = LockId, @Reason = 'The batch currently has a type ' + CONVERT(varchar(9), LockType) + ' lock (Id=' + CONVERT(varchar(9),LockId) + 
		') held on batchitem ' + CONVERT(varchar(9),PaymentID) + 
		' by ' + UserName + 
		' using ' + [Application] + 
		' on ' + [MachineName] +
		' until ' + CAST([Expire] as varchar(24)) + '. '
	FROM PaymentBatchLock 
	WHERE PaymentId = @PaymentId
		AND BatchNumber = @BatchNumber 
		AND [Expire] > getdate()
		AND LockType = @EditPaymentLockType
		AND NOT (UserName = @UserName
			AND [Application] = @ApplicationName
			AND MachineName = @MachineName)
	ORDER BY LockType DESC

	IF @@ROWCOUNT > 0 
	BEGIN
		-- if this batch payment is being edited by someone else then we cannot edit it...
		SET @Granted = 0
		-- both reason and lockid were set in the query above...
		RETURN @@ERROR
	END

	-- verify that the payment has not been deleted...
	SELECT @Count = count(*) FROM paymentbatchitems WHERE uid = @PaymentId
	IF @Count = 0
	BEGIN
		-- the payment has been deleted from the database, and therefore cannot be edited...
		SET @Granted = 0
		SET @Reason = 'The payment with UID ' + CAST(@PaymentId as varchar(12)) + 
			' no longer exists in the database. It was likely deleted by another user. '
		RETURN @@ERROR
	END

	SET @Expiration = DATEADD(minute, @TTLMinutes, getdate())

	-- update the ChangedByOthers flag on all read locks for other users on this batch.
	UPDATE [PaymentBatchLock]
	SET ChangedByOthers = -1
	WHERE BatchNumber = @BatchNumber
		AND LockType = @ReadLockType
		AND NOT (UserName = @UserName
			AND [Application] = @ApplicationName
			AND MachineName = @MachineName)

	-- determine if there is currently a lock in place for this user...
	SELECT TOP 1 @LockID = LockID
	FROM PaymentBatchLock 
	WHERE PaymentId = @PaymentId
		AND BatchNumber = @BatchNumber
		AND UserName = @UserName
		AND [Application] = @ApplicationName
		AND MachineName = @MachineName
		AND LockType = @RequestLockType

	IF @@ROWCOUNT > 0 
	BEGIN
		-- If there is currently a lock, then update it...
		UPDATE [PaymentBatchLock]
		SET Expire = @Expiration
		WHERE LockId = @LockId AND @Expiration > Expire

		SET @Reason = @Reason + 'Updating existing lock. '
	END
	ELSE
	BEGIN
		-- Not currently a lock so insert one...
		INSERT INTO [PaymentBatchLock]
			([PaymentId]
			,[BatchNumber]
			,[UserName]
			,[Expire]
			,[Application]
			,[MachineName]
			,[LockType])
		VALUES
			(@PaymentId
			,@BatchNumber
			,@UserName
			,@Expiration
			,@ApplicationName
			,@MachineName
			,@RequestLockType)	

		SET @LockID = SCOPE_IDENTITY()
	END

	RETURN @@ERROR
END

GO

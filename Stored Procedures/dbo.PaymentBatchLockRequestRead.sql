SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Michael D. Devlin
-- Create date: 2008-06-19
-- Description:	Adds a read lock on a batch...
--				Normally called when opening a batch.
--				Returns false if anyone has something more than a writelock on the batch.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.PaymentBatchLockRequestRead.sql $
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
CREATE PROCEDURE [dbo].[PaymentBatchLockRequestRead] 
	-- Add the parameters for the stored procedure here
	@BatchNumber int, 
	@UserName varchar(255),
	@ApplicationName varchar(255),
	@MachineName varchar(255),
	@TTLMinutes int,
	@Granted bit OUT,
	@Reason varchar(255) OUT,
	@LockID int OUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ReadLockType int;
	DECLARE @WriteLockType int;
	DECLARE @EditPaymentLockType int;
	DECLARE @EditLockType int;
	DECLARE @ProcessLockType int;
	DECLARE @MaxConcurrentLockType int;
	DECLARE @LockType int;
	DECLARE @Expiration datetime;

	SET @ReadLockType = 0
	SET @WriteLockType = 1
	SET @EditPaymentLockType = 2
	SET @EditLockType = 3
	SET @ProcessLockType = 4

	SET @LockType = @ReadLockType
	SET @MaxConcurrentLockType = @WriteLockType
	SET @TTLMinutes = ISNULL(@TTLMinutes, 60) -- default Time to live to 60 minutes for a read lock...

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
		AND LockType > @MaxConcurrentLockType
		AND NOT (UserName = @UserName
			AND [Application] = @ApplicationName
			AND MachineName = @MachineName)
	ORDER BY LockType Desc

	IF @@ROWCOUNT > 0 
	BEGIN
		SET @Granted = 0

		-- both reason and lockid were set in the query above...
		RETURN @@ERROR
	END
	ELSE
	BEGIN
		-- otherwise, grant read lock...
		SET @Granted = -1
		SET @Reason = ''
	END

	SET @Expiration = DATEADD(minute, @TTLMinutes, getdate())

	-- determine if there is currently a lock in place for this user...
	SELECT TOP 1 @LockID = LockID
	FROM PaymentBatchLock 
	WHERE BatchNumber = @BatchNumber
		AND UserName = @UserName
		AND [Application] = @ApplicationName
		AND MachineName = @MachineName
		AND LockType = @LockType

	IF @@ROWCOUNT > 0 
	BEGIN
		-- If there is currently a lock, then update it, only if new expiration greater than previous...
		UPDATE [PaymentBatchLock]
		SET Expire = @Expiration
		WHERE LockId = @LockId AND @Expiration > Expire

		IF @@ROWCOUNT > 0
		BEGIN
			SET @Reason = @Reason + 'Updating existing lock. '
		END
	END
	ELSE
	BEGIN
		-- Not currently a lock so insert one...
		INSERT INTO [PaymentBatchLock]
			   ([BatchNumber]
			   ,[UserName]
			   ,[Expire]
			   ,[Application]
			   ,[MachineName]
			   ,[LockType])
		 VALUES
			   (@BatchNumber
			   ,@UserName
			   ,@Expiration
			   ,@ApplicationName
			   ,@MachineName
			   ,@LockType)	

		SET @LockID = SCOPE_IDENTITY()
	END

	RETURN @@ERROR
END

GO

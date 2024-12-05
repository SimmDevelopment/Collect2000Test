SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Michael D. Devlin
-- Create date: 2008-06-19
-- Description:	Removes lock of locktype within context...
--				Normally called to release a lock where type is known, but not id.
-- =============================================
CREATE PROCEDURE [dbo].[PaymentBatchLockRemoveType]
	@BatchNumber int,
	@UserName varchar(255),
	@ApplicationName varchar(255),
	@MachineName varchar(255),
	@LockType int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE PaymentBatchLock
	WHERE BatchNumber = @BatchNumber 
		AND LockType = @LockType
		AND UserName = @UserName
		AND [Application] = @ApplicationName
		AND MachineName = @MachineName
	RETURN @@ERROR
END


GO

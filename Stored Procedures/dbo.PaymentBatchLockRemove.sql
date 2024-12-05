SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Michael D. Devlin
-- Create date: 2008-06-19
-- Description:	Removes lock given the lockid...
--				Normally called to release lock when id is known.
--				Can be used by an admin to remove a lock forcefully.
-- =============================================
CREATE PROCEDURE [dbo].[PaymentBatchLockRemove] 
	@LockID int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE PaymentBatchLock
	WHERE LockId = @LockID

	RETURN @@ERROR
END


GO

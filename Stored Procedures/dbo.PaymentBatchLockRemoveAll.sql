SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Michael D. Devlin
-- Create date: 2008-06-19
-- Description:	Removes all locks for context...
--				Normally called when closing application.
-- =============================================
CREATE PROCEDURE [dbo].[PaymentBatchLockRemoveAll] 
	@UserName varchar(255),
	@ApplicationName varchar(255),
	@MachineName varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE PaymentBatchLock
	WHERE UserName = @UserName
		AND [Application] = @ApplicationName
		AND MachineName = @MachineName
	RETURN @@ERROR
END


GO

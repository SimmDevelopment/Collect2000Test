SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Michael D. Devlin
-- Create date: 2008-06-19
-- Description:	Removes all locks for batch given within context...
--				Normally called when closing batch.
-- =============================================
CREATE PROCEDURE [dbo].[PaymentBatchLockRemoveAllForBatch]
	@BatchNumber int, 
	@UserName varchar(255),
	@ApplicationName varchar(255),
	@MachineName varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	IF @UserName is null
	BEGIN
		DELETE PaymentBatchLock
		WHERE BatchNumber = @BatchNumber 
	END
	ELSE
	BEGIN
		DELETE PaymentBatchLock
		WHERE BatchNumber = @BatchNumber 
			AND UserName = @UserName
			AND [Application] = @ApplicationName
			AND MachineName = @MachineName
	END
	
	RETURN @@ERROR
END




GO

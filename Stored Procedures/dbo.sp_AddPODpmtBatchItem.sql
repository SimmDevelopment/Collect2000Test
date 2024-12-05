SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[sp_AddPODpmtBatchItem]
	@BatchItemID int,
	@PODID int,
	@Paid money,
	@Fee money,
	@BatchType tinyint,
	@ReturnStatus int output
AS
	-- Mike Devlin - This procedure has been deprecated. Please use [Lib_Insert_PODPmtBatchDetail]
	-- problems with this are: unecessary transaction, Rollback possible, returns 1 on success, doesn't return true error
	DECLARE @RC int

	BEGIN TRAN

	EXECUTE @RC = [Lib_Insert_PODPmtBatchDetail] 
	   @BatchItemID
	  ,@PODID
	  ,@Paid
	  ,@Fee
	  ,@BatchType
	
	IF (@RC <> 0)
	BEGIN
		Set @ReturnStatus = -1
		ROLLBACK TRAN
	END
	ELSE 
	BEGIN
		COMMIT TRAN
		Set @ReturnStatus = 1
		Return 1
	END


GO

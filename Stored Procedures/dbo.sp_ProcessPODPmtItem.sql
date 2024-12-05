SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE Procedure [dbo].[sp_ProcessPODPmtItem]
	@UID int,
	@PayhistoryID int,
	@PODID int,
	@PmtDate datetime,
	@PmtAmt money,
	@FeeAmt money,
	@BatchType tinyint,
	@AcctID int,
	@ReturnStatus int output

AS

	/*Create PayhistoryDetails record */
	INSERT INTO PayhistoryDetails(PayhistoryID, PODID, PmtDate, PaidAmount, FeeAmount, BatchType, AcctID)
	VALUES (@PayhistoryID, @PODID, @PmtDate, @PmtAmt, @FeeAmt, @BatchType, @AcctID)


	/*Update PODDetail */
	IF @BatchType in (1,2,4) 
		UPDATE PODDetail SET PaidAmt = PaidAmt + @PmtAmt, CurrentAmt = CurrentAmt - @PmtAmt  
		WHERE UID = @PODID

	IF @BatchType = 3 
		UPDATE PODDetail SET CurrentAmt = CurrentAmt - @PmtAmt
		WHERE UID = @PODID

	IF @BatchType in (5,6,8) 
		UPDATE PODDetail Set PaidAmt = PaidAmt - @PmtAmt, CurrentAmt = currentAmt + @PmtAmt
		WHERE UID = @PODID

	IF @BatchType = 7 	
		UPDATE PODDetail Set CurrentAmt = CurrentAmt + @PmtAmt
		WHERE UID = @PODID

	DELETE FROM PODPmtBatchDetail WHERE UID = @UID
	

if (@@error = 0) 
	set @ReturnStatus = 1
GO

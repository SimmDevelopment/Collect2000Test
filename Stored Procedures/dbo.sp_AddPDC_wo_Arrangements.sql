SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* sp_AddPDC_wo_Arrangements */
CREATE    Procedure [dbo].[sp_AddPDC_wo_Arrangements]
	@AcctID int,
	@Seq int,
	@PMethodID tinyint,
	@DepositDate datetime,
	@Amount money,
	@CheckNo varchar (20),
	@LetterCode varchar (5),
	@SurCharge money,
	@PromiseMode tinyint,
	@ProjectedFee money,
	@CollectorFee money,
	@LatitudeUser	varchar(255),
	@Desk varchar (10) output,
	@Customer varchar (7) output,
	@ReturnMessage varchar(30) output,
	@ReturnUID int output

 /*
**Name            :sp_AddPDC_wo_Arrangements
**Function        :Calls new sp_AddPDC with null for arrangement values...
**Creation        :
**Used by         :C2KPromise.dll
*/


AS
	DECLARE @SurchargeCheckNbr char(10)
	DECLARE @DepositToGeneralTrust bit
	DECLARE @DebtorBankID int
	DECLARE @ArrangementID int
	DECLARE @ReturnError int 
	DECLARE @Err int
	
	SELECT @SurchargeCheckNbr = null, 
		@DepositToGeneralTrust = null, 
		@DebtorBankID = null, 
		@ArrangementID = null

	EXECUTE @ReturnError = sp_AddPDC
		@AcctID,
		@Seq,
		@PMethodID,
		@DepositDate,
		@Amount,
		@CheckNo,
		@LetterCode,
		@SurCharge,
		@PromiseMode,
		@ProjectedFee,
		@CollectorFee,
		@LatitudeUser,
		@Desk,
		@Customer,
		@ReturnMessage,
		@ReturnUID

	SET @Err = @@ERROR

	IF @Err <> 0 SELECT @ReturnError = @Err

	RETURN @ReturnError


GO

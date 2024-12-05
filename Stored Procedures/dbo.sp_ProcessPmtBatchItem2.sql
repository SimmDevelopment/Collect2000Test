SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE              PROCEDURE [dbo].[sp_ProcessPmtBatchItem2] 
@UID int,  
@LatitudeUser varchar(256),
@ReturnSts int Output,  
@ErrorBlock varchar(30) Output, 
@PayhistoryUID int Output  
AS
/*
**Header: tag removed
**Workfile: tag removed
**History: tag removed
--  
--  ****************** Version 10 ****************** 
--  User: mdevlin   Date: 2010-12-20   Time: 14:09:51-05:00 
--  Updated in: /GSSI/Core/Database/8.3.0/StoredProcedures 
--  case 57200 
--  
--  ****************** Version 10 ****************** 
--  User: mdevlin   Date: 2010-09-30   Time: 11:17:56-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Err handling 
--  
--  ****************** Version 9 ****************** 
--  User: mdevlin   Date: 2010-05-14   Time: 14:44:55-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Case 47217: Don't change status and such if the account is sold 
--  
--  ****************** Version 8 ****************** 
--  User: mdevlin   Date: 2010-04-15   Time: 15:34:49-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Case 47401: notes when account placed in suport queue. 
--  
--  ****************** Version 7 ****************** 
--  User: jbryant   Date: 2010-02-09   Time: 16:22:00-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Added If block to evaluate @LinkID before calling Linking_EvaluateDriver 
--  
--  ****************** Version 5 ****************** 
--  User: mdevlin   Date: 2009-08-21   Time: 08:57:10-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Case 41199: Evaluate promises as kept during the payment processing step. 
--  
--  ****************** Version 4 ****************** 
--  User: mdevlin   Date: 2009-08-21   Time: 08:25:09-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Case 41530: Payhistory balance buckets are now filled with current values 
--  (after payment applied). 
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2009-07-24   Time: 15:48:54-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Pass SubBatchType to exec, not BatchType...ooops 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2009-07-24   Time: 12:10:39-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Handle linked arrangements, setting status and queue info for reversals. 
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:06-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  
--  ****************** Version 16 ****************** 
--  User: mdevlin   Date: 2008-08-07   Time: 11:21:57-04:00 
--  Updated in: /GSSI/Core/Latitude/Dev/DatabaseObjects/Stored Procedures 
--  Use Batch SysDate, For reversals, get status history not PIF or SIF. 
--  
--  ****************** Version 15 ****************** 
--  User: mdevlin   Date: 2008-07-15   Time: 15:00:15-04:00 
--  Updated in: /GSSI/Core/Latitude/Dev/DatabaseObjects/Stored Procedures 
--  Added DebtorId and PaymentLinkUID 
--  
--  ****************** Version 14 ****************** 
--  User: jspindler   Date: 2007-11-07   Time: 11:16:21-05:00 
--  Updated in: /GSSI/Core/Latitude/Dev/DatabaseObjects/Stored Procedures 
--  Replace @@IDENTITY with SCOPE_IDENTITY() 
--  
--  ****************** Version 13 ****************** 
--  User: jspindler   Date: 2007-10-31   Time: 17:33:44-04:00 
--  Updated in: /GSSI/Core/Latitude/Dev/DatabaseObjects/Stored Procedures 
--  NULL out master.closed and master.returned when account is reopened 
--  
--  ****************** Version 12 ****************** 
--  User: mdevlin   Date: 2007-08-29   Time: 14:44:55-04:00 
--  Updated in: /GSSI/Core/Latitude/Dev/DatabaseObjects/Stored Procedures 
--  SupportForce case 14942 
*/

/*
**Name		:sp_ProcessPmtBatchItem2	
**Function	:Reads a record from PaymentBatchItems and Writes it to Payhistory, master then Deletes PaymentBatchItem
**Creation	:mr 2002
**Used by 	:C2KPmt.dll		
**Change History
**		:12/1/2003 Added the line to reopen an account if a closed and a DAR comes in 	
**		:1/15/2004 mr Changed the Update master sections: LastPaid and LastPaidamount are only updated
**			   on PU, PC and PA payments.
**		:6/29/2004 If payment is a reversal the Desk is set to the original payment's Desk not the current Desk
**		:8/18/2004 On NSF payments, when selecting to see if any more PDCs or Promises, a change was made to
**			   select only PDCs or Promises where Active = 1
**		:10/13/2004kmo added @batchtype as parameter to customfeeadjust - added @invoiceflags as output
**		:10/21/2004 mr added support for new Payhistory column CollectorFee
**		:10/21/2004    added support for AIM
**		:12/22/2004 mr the section that updates the master was altered to correctly account for the surcharge amount
**		:	       changed where current0,accrued
**		:03/30/2005 mr altered statements that updated Qlevel to not update if QLevel 998 or 999.
			       also, if payment is received on closed account, a supportQueue item (700) is created.
**		:09/12/2006 mdd, added several parms. IMPORTANT, hard coded SubBatchType 'RFD' to mean overpayment refund...
**		:01/22/2007 mdd hard coded SubBatchType 'XFR' to mean overpayment transfer...
**		:10/31/2007 jbs NULL out master.closed and master.returned dates when account is reopened where applicable
*/

DECLARE @FileNumber int  
DECLARE @BatchNumber int  
DECLARE @BatchTypeNumber tinyint  
DECLARE @BatchType varchar (3)  
DECLARE @PayType varchar (30)  
DECLARE @PayMethod varchar (20)  
DECLARE @Entered datetime  
DECLARE @PaidDate datetime  
DECLARE @SystemMonth tinyint  
DECLARE @SystemYear smallint  
DECLARE @InvKeyCode tinyint   
DECLARE @InvoiceFlags varchar (10)  
DECLARE @OverPaidAmt money   
DECLARE @ForwardeeFee money  
DECLARE @Comment varchar (30)  
DECLARE @Gross money 
DECLARE @Paid0 money   
DECLARE @Paid1 money   
DECLARE @Paid2 money   
DECLARE @Paid3 money  
DECLARE @Paid4 money   
DECLARE @Paid5 money   
DECLARE @Paid6 money  
DECLARE @Paid7 money  
DECLARE @Paid8 money   
DECLARE @Paid9 money  
DECLARE @Paid10 money   
DECLARE @Fee money 
DECLARE @Fee1 money  
DECLARE @Fee2 money   
DECLARE @Fee3 money  
DECLARE @Fee4 money   
DECLARE @Fee5 money   
DECLARE @Fee6 money   
DECLARE @Fee7 money  
DECLARE @Fee8 money  
DECLARE @Fee9 money   
DECLARE @Fee10 money  
DECLARE @Customer varchar (8)  
DECLARE @OldStatus varchar (3) 
DECLARE @QLevel varchar(3) 
DECLARE @IsPIF bit  
DECLARE @IsSIF bit  
DECLARE @ReverseOfUID int  
DECLARE @Err int 
DECLARE @rows int 
DECLARE @Surcharge money
DECLARE @Tax money
DECLARE @Matched varchar(1)
DECLARE @AttyID int
DECLARE @AimAgencyId int
DECLARE @AimDueAgency money
DECLARE @AimAgencyFee money
DECLARE @PAIdentifier varchar(30)
DECLARE @CollectorFee money
DECLARE @IntVariable int
DECLARE @FeeSched char (5)
DECLARE @CollectorFeeSched char (5)
DECLARE @PaidToDate money
DECLARE @Desk varchar(10)
DECLARE @IsFreeDemand bit
DECLARE @IsCorrection bit
DECLARE @BatchPmtCreated datetime
DECLARE @BatchPmtCreatedBy varchar(256)
DECLARE @CheckNumber varchar(30)
DECLARE @PaymentBatchItemsId int
DECLARE @StatusHistory varchar (3) 
DECLARE @ReversalShouldQueue bit
DECLARE @ReversalQDate varchar(8)
DECLARE @ReversalQLevel varchar(3)
DECLARE @ReversalStatus varchar(3)
DECLARE @ShowCurrencyInNotes BIT;
DECLARE @CurrencyISO3 char(3)
DECLARE @AimBatchId int
DECLARE @AimSendingID int
DECLARE @SubBatchType char(3)
DECLARE @PostDateUid int
DECLARE @SurchargeToBucket10 BIT;
DECLARE @MasterLastPaid datetime;
DECLARE @MasterLastPaidAmt money;
DECLARE @DebtorId int;
DECLARE @PaymentLinkUID int;
DECLARE @UseBatchSysDate bit;
DECLARE @LinkID int;
-- MDD: moved the declaration of @SurchargeOffset to here from below...
DECLARE @SurchargeOffset MONEY;
-- MDD: Add balance bucket vars...
DECLARE @Current0 MONEY;
DECLARE @Current1 MONEY;
DECLARE @Current2 MONEY;
DECLARE @Current3 MONEY;
DECLARE @Current4 MONEY;
DECLARE @Current5 MONEY;
DECLARE @Current6 MONEY;
DECLARE @Current7 MONEY;
DECLARE @Current8 MONEY;
DECLARE @Current9 MONEY;
DECLARE @Current10 MONEY;
DECLARE @IsSold bit;

-- Change this value to 0 to disable the automatic calculation of transaction
-- surcharges to the 10th money bucket of the account
SET @SurchargeToBucket10 = 1;

-- validate/default the @LatitudeUser value
IF @LatitudeUser is null 
	SELECT @LatitudeUser = suser_sname() 
ELSE
	SELECT @LatitudeUser = @LatitudeUser

Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
       SET @ErrorBlock = 'Validate LatitudeUser'  
       SET @ReturnSts = @Err  
       Return @Err  
END  


--	GET VARIABLES
SET @Matched = 'N'

SELECT @Filenumber=P.Filenum, @BatchNumber=P.batchnumber, @PaidDate=P.datePaid, @Entered=p.Entered, @BatchTypeNumber=P.PmtType,   
	@PayMethod=P.PayMethod, @InvKeyCode=P.InvKeyCode, @OverPaidAmt=P.OverPaidAmt, @ForwardeeFee=P.ForwardeeFee, @Paid0=P.paid0,   
	@Paid1=P.paid1, @Paid2=P.paid2, @Paid3=P.paid3, @Paid4=P.Paid4, @Paid5=P.paid5, @Paid6=P.paid6, @Paid7=P.paid7, @Paid8=P.paid8,   
	@Paid9=P.paid9, @Paid10=P.paid10, @Fee1=P.fee1, @Fee2=P.fee2, @Fee3=P.fee3, @Fee4=P.fee4, @Fee5=P.fee5, @Fee6=P.fee6, @IsPIF=IsPIF, 
	@IsSIF=IsSettlement, @ReverseOfUID=P.ReverseOfUID, @Fee7=P.fee7,@Fee8=P.fee8, @Fee9=P.fee9, @Fee10=P.fee10, 
	@Comment=P.comment, @Customer=M.customer, @InvoiceFlags=P.InvoiceFlags, @OldStatus=M.Status, 
	@QLevel=M.QLevel, @AttyID=M.AttorneyID,
	@Gross = p.Paid1+P.Paid2+P.Paid3+P.Paid4+P.Paid5+P.Paid6+P.Paid7+P.Paid8+P.Paid9+P.Paid10, 
	@Fee=(P.fee1 + P.fee2 + P.fee3 + P.fee4 + P.fee5 + P.fee6 + P.fee7 + P.fee8 + P.fee9 + P.fee10), @Surcharge = P.Surcharge, @Tax = P.Tax,
	@AimAgencyId = P.aimagencyid, @AimDueAgency = P.aimdueagency, @AimAgencyFee = P.aimagencyfee,
	@PAIdentifier = p.paidentifier, @CollectorFee=CollectorFee, @FeeSched=FeeSched, @CollectorFeeSched=CollectorFeeSched,
	@Current0=M.current0, @Current1=M.current1, @Current2=M.current2, @Current3=M.current3, @Current4=M.current4, @Current5=M.current5, 
	@Current6=M.current6, @Current7=M.current7, @Current8=M.current8, @Current9=M.current9, @Current10=M.current10, 
	@PaidToDate=M.paid, @Desk = P.Desk, @IsFreeDemand = IsFreeDemand, @IsCorrection = IsCorrection, 
	@BatchPmtCreated = Created, @BatchPmtCreatedBy = P.CreatedBy, @CheckNumber = CheckNumber, @PaymentBatchItemsId = UID,
	@ShowCurrencyInNotes = CASE WHEN C.CultureCode IS NULL THEN 0 ELSE 1 END,
	@CurrencyISO3 = ISNULL(CurrencyISO3, 'USD'), @AimBatchId = P.AimBatchId, @AIMSendingID = P.AIMSendingID, @SubBatchType = P.SubBatchType, 
	@PostDateUID = p.PostDateUID, @MasterLastPaid = M.LastPaid, @MasterLastPaidAmt = ISNULL(M.LastPaidAmt, 0),
	@DebtorId = p.DebtorId, @PaymentLinkUID = p.PaymentLinkUID, @LinkID = ISNULL(M.Link, 0)
FROM PaymentBatchItems as P      
INNER JOIN Master as M     ON M.Number = P.FileNum  
INNER JOIN customer AS C   ON M.customer = C.customer
WHERE P.UID = @UID  

Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
       SET @ErrorBlock = 'Select VARIABLES'  
       SET @ReturnSts = @Err  
       Return @Err  
END

IF EXISTS(Select PortfolioID FROM AIM_Portfolio p JOIN Master m ON m.soldportfolio = p.portfolioid WHERE m.number = @FileNumber AND p.portfoliotypeid = 1)
BEGIN
	SET @IsSold = 1
END
ELSE
BEGIN
	SET @IsSold = 0
END


--On bounces use the original pmt Desk instead of current Desk (new in v4.0.27)
IF @ReverseOfUID > 0 Select @Desk=Desk from Payhistory where UID = @ReverseOfUID
Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
       SET @ErrorBlock = 'Select Reversal Desk'  
       SET @ReturnSts = @Err  
       Return @Err  
END  

SELECT @UseBatchSysDate=UseBatchSysDate, @SystemMonth=SysMonth, @SystemYear=SysYear FROM PaymentBatches WHERE BatchNumber = @BatchNumber  
Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
       -- ignore errors here and just set @UseBatchSysDate to false so controlfile values will be used.
       SELECT @UseBatchSysDate = 0, @Err = 0
END  
IF @UseBatchSysDate = 0
	SELECT @SystemMonth=CurrentMonth, @SystemYear=CurrentYear FROM controlfile  
Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
       SET @ErrorBlock = 'Select SysMonth - Year'  
       SET @ReturnSts = @Err  
       Return @Err  
END  
IF (@BatchTypeNumber = 1) 
BEGIN  
       SET @BatchType = 'PU'   
           SET @paytype = 'Paid Us'   
End   
IF (@BatchTypeNumber = 2) 
BEGIN  
	SET @Batchtype = 'PC'  
	SET @PayType = 'Paid Client'   
End  
IF (@BatchTypeNumber = 3) 
BEGIN  
	SET @BatchType = 'DA'   
	SET @Paytype = 'Adjustment Down'  
End  
IF (@BatchTypeNumber = 4) 
BEGIN  
        SET @BatchType = 'PA'               
	SET @Paytype = 'Paid Agency'  
End   
IF (@BatchTypeNumber = 5) 
BEGIN  
	SET @Batchtype = 'PUR'
	IF (@IsCorrection = 0) 
		SET @Paytype = 'Paid Us Reversal - NSF'   
	ELSE
		IF @SubBatchType = 'RFD'
			SET @Paytype = 'Paid Us Refund'   
		ELSE
			IF @SubBatchType = 'XFR'
				SET @Paytype = 'Paid Us Transfer'   
			ELSE
				SET @Paytype = 'Paid Us Reversal'   
End  
IF (@BatchTypeNumber = 6) 
BEGIN  
	SET @Batchtype = 'PCR'   
	IF (@IsCorrection = 0) 
	    SET @Paytype = 'Paid Client Reversal - NSF'  
	ELSE
		IF @SubBatchType = 'RFD'
			SET @Paytype = 'Paid Client Refund'   
		ELSE
			IF @SubBatchType = 'XFR'
				SET @Paytype = 'Paid Client Transfer'   
			ELSE
				SET @Paytype = 'Paid Client Reversal'  
End  
IF (@BatchTypeNumber = 7) 
BEGIN   
	SET @Batchtype = 'DAR'   
	SET @PayType = 'Adjustment Up'  
End  
IF (@BatchTypeNumber = 8) 
BEGIN  
	SET @Batchtype = 'PAR'  
	IF (@IsCorrection = 0) 
	        SET @Paytype = 'Paid Agency Reversal - NSF'  
	ELSE
		IF @SubBatchType = 'RFD'
			SET @Paytype = 'Paid Agency Refund'   
		ELSE
			IF @SubBatchType = 'XFR'
				SET @Paytype = 'Paid Agency Transfer'   
			ELSE
				SET @Paytype = 'Paid Agency Reversal'  
End   

-- MDD: moved the calculation of @SurchargeOffset to here from below...
IF @BatchType LIKE 'P_' AND @SurchargeToBucket10 = 0 AND @Surcharge > 0 AND @Paid10 >= @Surcharge 
BEGIN
	SET @Paid10 = @Paid10 - @Surcharge;
	SET @Paid0 = @Paid0 - @Surcharge;
	SET @SurchargeOffset = 0;
END
ELSE
BEGIN
	SET @SurchargeOffset = @Surcharge;
END

--Custom Call to Adjust Fees for Apex financial
-- 9/27/2004 kmo added @batchtype as parameter to customfeeadjust - added @invoiceflags as output
EXEC CustomFeeAdjust @FileNumber, @Customer, @Paid1, @Paid2, @Paid3, @Paid4, @Paid5, @Paid6, 
                             @Paid7, @Paid8, @Paid9, @Paid10, @batchtype, @Comment, @IsPIF, @IsSIF, 
							 @Fee1 OUTPUT, @Fee2 OUTPUT, @Fee3 OUTPUT, 
                             @Fee4 OUTPUT, @Fee5 OUTPUT, @Fee6 OUTPUT, @Fee7 OUTPUT, @Fee8 OUTPUT, 
                             @Fee9 OUTPUT, @Fee10 OUTPUT, @invoiceFlags OUTPUT

-- calculate paidtodate and currenttodate totals now...
IF (@BatchType in ('PU', 'PC', 'PA')) 
BEGIN
	set @PaidToDate=@PaidToDate-@Paid0
	set @Current0=@Current0-@Paid0+@SurchargeOffset
	set @Current1=@Current1-@Paid1
	set @Current2=@Current2-@Paid2
	set @Current3=@Current3-@Paid3
	set @Current4=@Current4-@Paid4
	set @Current5=@Current5-@Paid5
	set @Current6=@Current6-@Paid6
	set @Current7=@Current7-@Paid7
	set @Current8=@Current8-@Paid8
	set @Current9=@Current9-@Paid9
	set @Current10=@Current10-@Paid10+@SurchargeOffset
END
IF (@BatchType in ('PUR', 'PCR', 'PAR')) 
BEGIN
	set @PaidToDate=@PaidToDate+@Paid0
	set @Current0=@Current0+@Paid0-@SurchargeOffset
	set @Current1=@Current1+@Paid1
	set @Current2=@Current2+@Paid2
	set @Current3=@Current3+@Paid3
	set @Current4=@Current4+@Paid4
	set @Current5=@Current5+@Paid5
	set @Current6=@Current6+@Paid6
	set @Current7=@Current7+@Paid7
	set @Current8=@Current8+@Paid8
	set @Current9=@Current9+@Paid9
	set @Current10=@Current10+@Paid10-@SurchargeOffset
END
IF (@Batchtype = 'DA') 
BEGIN     
	set @PaidToDate=@PaidToDate
	set @Current0=@Current0-@Paid0
	set @Current1=@Current1-@Paid1
	set @Current2=@Current2-@Paid2
	set @Current3=@Current3-@Paid3
	set @Current4=@Current4-@Paid4
	set @Current5=@Current5-@Paid5
	set @Current6=@Current6-@Paid6
	set @Current7=@Current7-@Paid7
	set @Current8=@Current8-@Paid8
	set @Current9=@Current9-@Paid9
	set @Current10=@Current10-@Paid10
END
IF (@Batchtype = 'DAR') 
BEGIN     
	set @PaidToDate=@PaidToDate
	set @Current0=@Current0+@Paid0
	set @Current1=@Current1+@Paid1
	set @Current2=@Current2+@Paid2
	set @Current3=@Current3+@Paid3
	set @Current4=@Current4+@Paid4
	set @Current5=@Current5+@Paid5
	set @Current6=@Current6+@Paid6
	set @Current7=@Current7+@Paid7
	set @Current8=@Current8+@Paid8
	set @Current9=@Current9+@Paid9
	set @Current10=@Current10+@Paid10
END

--	INSERT PAYHISTORY		
INSERT INTO PayHistory (number, Seq, batchtype, matched, customer, paytype, paymethod, systemmonth, systemyear, entered, desk, invoiced, invoicesort, invoicetype,  
	invoicepaytype,  comment, datepaid, totalpaid, paid1, paid2, paid3, paid4, paid5, paid6, paid7, paid8, paid9, paid10, 
	fee1, fee2, fee3, fee4, fee5, fee6, fee7, fee8, fee9, fee10, 
	batchnumber,  Invoice, InvoiceFlags, OverPaidAmt, ForwardeeFee, ReverseOfUID, AccruedSurcharge, Tax, AttorneyID, 
	AimAgencyId, AimDueAgency, AimAgencyFee, PAIdentifier, CollectorFee, FeeSched, CollectorFeeSched, 
	Balance, Balance1, Balance2, Balance3, Balance4, Balance5, Balance6, Balance7, Balance8, Balance9, Balance10, 
	PaidToDate,	IsFreeDemand, IsCorrection, Created, CreatedBy, CheckNbr, BatchPmtCreated, BatchPmtCreatedBy,
	CurrencyISO3, AimBatchId, AimSendingID, SubBatchType, PostDateUID, DebtorId, PaymentLinkUID)  
VALUES (@Filenumber, '0', @BatchType,@Matched, @Customer, @Paytype, @paymethod, @SystemMonth, @SystemYear, @Entered, @Desk, NULL, ' ', ' ',   
	@BatchTypeNumber, @Comment, @PaidDate, @Paid0, @Paid1, @Paid2, @Paid3, @Paid4, @Paid5, @Paid6, @Paid7, @Paid8, @Paid9, @Paid10, 
	@Fee1, @Fee2, @Fee3, @Fee4, @Fee5, @Fee6, @Fee7, @Fee8, @Fee9, @Fee10, 
	@BatchNumber, NULL, @InvoiceFlags, @OverPaidAmt, @ForwardeeFee, @ReverseOfUID,@Surcharge, @Tax, @AttyID,
	@AimAgencyId, @AimDueAgency, @AimAgencyFee, @PAIdentifier, @CollectorFee, @FeeSched, @CollectorFeeSched, 
	@Current0, @Current1, @Current2, @Current3, @Current4, @Current5, @Current6, @Current7, @Current8, @Current9, @Current10, 
	@PaidToDate, @IsFreeDemand, @IsCorrection, GETDATE(), @LatitudeUser, @CheckNumber, @BatchPmtCreated, @BatchPmtCreatedBy,
	@CurrencyISO3, @AimBatchId, @AimSendingID, @SubBatchType, @PostDateUID, @DebtorId, @PaymentLinkUID)   

Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
       SET @ErrorBlock = 'Payhistory Insert'  
       SET @ReturnSts = @Err  
       Return @Err  
END 

Select @PayhistoryUID = SCOPE_IDENTITY()    
Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
       SET @ErrorBlock = 'Select Identity'  
       SET @ReturnSts = @Err  
       Return @Err  
END  

--  UPDATE PAIDENTIFIER
update
	PayHistory
set
	paidentifier = isnull(@PAIdentifier,SCOPE_IDENTITY())
where
	uid = SCOPE_IDENTITY()

--	INSERT NOTE	
IF @ShowCurrencyInNotes = 1
	INSERT INTO Notes (created, number, user0, action, result, comment)   
	VALUES (getdate(),  @Filenumber, 'SYS', '+++++', '+++++', @Paytype + ' ' + cast(@Paid0 as varchar) + ' (' + @CurrencyISO3 + ')')   
ELSE
	INSERT INTO Notes (created, number, user0, action, result, comment)   
	VALUES (getdate(),  @Filenumber, 'SYS', '+++++', '+++++', @Paytype + ' ' + cast(@Paid0 as varchar))

Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
	SET @ErrorBlock = 'Insert Notes'  
	SET @ReturnSts = @Err  
	Return @Err  
END  

IF @IsSold = 0 
BEGIN
	EXECUTE @Err = [dbo].[Payment_PromiseKeptEval] @PayHistoryUID, @ErrorBlock OUTPUT
	IF @Err <> 0 
	BEGIN  
		SET @ReturnSts = @Err  
		Return @Err  
	END  

	--IF THIS IS  PIF THEN UPDATE MASTER AS SUCH..   
	IF (@IsPIF = 1) 
	BEGIN  
			IF @QLevel <> '999'
			BEGIN
				UPDATE master set status = 'PIF', closed= getdate() , qlevel='998' WHERE number = @Filenumber

				Select @Err=@@Error  
				IF @Err <> 0 
				BEGIN  
							SET @ErrorBlock = 'Update master to PIF'  
							SET @ReturnSts = @Err  
							Return @Err  
				END  
			END

			-- insert a StatusHistory record
			EXEC @Err = StatusHistory_Insert @FileNumber, @LatitudeUser, @OldStatus, 'PIF'
			IF @Err <> 0 
			BEGIN  
					SET @ErrorBlock = 'StatusHistory_Insert PIF'
					SET @ReturnSts = @Err  
					Return @Err  
			END  

			DELETE FROM Future   WHERE number = @FileNumber  
			Select @Err=@@Error  
			IF @Err <> 0 
			BEGIN
				SET @ErrorBlock = 'Delete Future records'  
				SET @ReturnSts = @Err  
				Return @Err  
			END  

			INSERT INTO Notes (Number, Created, User0, action, result, comment) VALUES (@FileNumber, GetDate(), 'SYS', '+++++', '+++++', 'Status Changed from ' + @OldStatus + ' to PIF')  
			Select @Err=@@Error  
			IF @Err <> 0 
			BEGIN  
					SET @ErrorBlock = 'Insert Notes PIF'  
				SET @ReturnSts = @Err  
				Return @Err  
			END  

			IF @LinkID IS NOT NULL AND @LinkID > 0 
			BEGIN
				EXEC [Linking_EvaluateDriver] @LinkID, null, @LatitudeUser
			END
	END 
	ELSE
	BEGIN
		--IF THIS IS  SIF THEN UPDATE MASTER AS SUCH.. 
		IF (@IsSIF = 1) 
		BEGIN  
			If @QLevel <> '999'
			BEGIN
				UPDATE master set status = 'SIF', closed = getdate(), qlevel = '998'  WHERE number = @FileNumber  

				Select @Err=@@Error  
				IF @Err <> 0 
				BEGIN  
					SET @ErrorBlock = 'Update Master as SIF'  
					SET @ReturnSts = @Err  
					Return @Err  
				END  
			END

			-- insert a StatusHistory record
			EXEC @Err = StatusHistory_Insert @FileNumber, @LatitudeUser, @OldStatus, 'SIF'
			IF @Err <> 0 
			BEGIN  
					SET @ErrorBlock = 'StatusHistory_Insert SIF'
					SET @ReturnSts = @Err  
					Return @Err  
			END  

			DELETE FROM Future  WHERE number = @FileNumber   
			Select @Err=@@Error  
			IF @Err <> 0 
			BEGIN  
				SET @ErrorBlock = 'Delete From Future-SIF'  
				SET @ReturnSts = @Err  
				Return @Err  
			END  

			INSERT INTO Notes (Number, Created, User0, action, result, comment) VALUES (@FileNumber, GetDate(), 'SYS', '+++++', '+++++', 'Status Changed from ' + @OldStatus + ' to SIF')   
			Select @Err=@@Error  
			IF @Err <> 0 
			BEGIN  
				SET @ErrorBlock = 'Insert Notes SIF'  
				SET @ReturnSts = @Err  
				Return @Err  
			END  

			IF @LinkID IS NOT NULL AND @LinkID > 0 
			BEGIN
				EXEC [Linking_EvaluateDriver] @LinkID, null, @LatitudeUser
			END

		END   
	END

	---------------------------- BOUNCES ---------------------------             
	IF @BatchType in ('PUR', 'PCR', 'PAR') 
	BEGIN   
		IF (@IsCorrection = 0) 
		BEGIN

			DECLARE @pUID INT;
			DECLARE @PostDateType varchar(5);
			SET @PostDateType = 'NOT'

			SELECT @pUID = [postdateuid] FROM [dbo].[payhistory] WHERE [UID] = @ReverseOfUID AND [Paymethod] IN ('ACH DEBIT', 'CHECK', 'POST-DATED CHECK', 'PAPER DRAFT')

			IF (@pUID IS NOT NULL)
			BEGIN
				UPDATE [dbo].[PDC]
				SET [NSFCount] = 1
				WHERE [UID] = @pUID AND ISNULL([NSFCount],0) = 0;
				SET @PostDateType = 'PDC';
			END;

			IF @PostDateType = 'NOT'
			BEGIN	
				SELECT @pUID = [postdateuid] FROM [dbo].[payhistory] WHERE [UID] = @ReverseOfUID AND [Paymethod] IN ('CREDIT CARD')

				IF (@pUID IS NOT NULL)
				BEGIN
					UPDATE [dbo].[DebtorCreditCards]
					SET [NSFCount] = 1
					WHERE [ID] = @pUID AND ISNULL([NSFCount],0) = 0;
					SET @PostDateType = 'PCC';
				END;
			END
			-- call sproc to handle setting queue info and status
			EXEC @ReturnSts = Account_NSFHandling @FileNumber, @pUID, @PostDateType, @ErrorBlock
			IF @ReturnSts <> 0 
			BEGIN  
				Return @Err  
			END  

		END
		ELSE
		BEGIN
			-- Non NSF, and not an overpayment refund or transfer
			IF NOT ((@SubBatchType = 'RFD') OR (@SubBatchType = 'XFR'))
			BEGIN
				-- We need to change the status on closed accounts, if this results in a less than PIF 
				-- and put into a supervisors queue.
				SELECT TOP 1 @StatusHistory = OldStatus FROM StatusHistory WHERE AccountID = @FileNumber AND OldStatus NOT IN ('SIF','PIF') ORDER BY DateChanged DESC
				Select @Err=@@Error, @rows = @@rowcount 
				IF @Err <> 0 
				BEGIN  
					SET @ErrorBlock = 'Select StatusHistory ' + CAST(@FileNumber as varchar)  
					SET @ReturnSts = @Err  
					Return @Err  
				END

				IF @rows > 0
					SELECT @StatusHistory = @StatusHistory
				ELSE
					SELECT @StatusHistory = 'ACT'

				-- MDD: added stuff to where clause...
				UPDATE master
				SET qlevel = '599',
					Status = @StatusHistory,
					ShouldQueue=1,
					qdate = CONVERT(CHAR(10), GETDATE(), 112),
					closed = NULL,
					returned = NULL
				WHERE number = @FileNumber AND qlevel = '998' AND (Current0+@Paid0-@SurchargeOffset) > 0.01

				Select @Err=@@Error, @rows = @@rowcount 
				IF @Err <> 0 
				BEGIN  
					SET @ErrorBlock = 'Update Master Correction'  
					SET @ReturnSts = @Err  
					Return @Err  
				END  

				-- MDD: added this check for number of rows updated, since now it may not update any...
				IF @rows > 0
				BEGIN
					-- insert a StatusHistory record
					EXEC @Err = StatusHistory_Insert @FileNumber, @LatitudeUser, @OldStatus, @StatusHistory
					IF @Err <> 0 
					BEGIN  
							SET @ErrorBlock = 'StatusHistory_Insert ' + @StatusHistory
							SET @ReturnSts = @Err  
							Return @Err  
					END  

					-- insert a note
					INSERT INTO Notes (Number, Created, User0, action, result, comment) VALUES(@FileNumber, GetDate(), 'SYS', '+++++', '+++++',  'Status Changed from ' + @OldStatus + ' to ' + @StatusHistory)  
					Select @Err=@@Error  
					IF @Err <> 0 
					BEGIN  
						SET @ErrorBlock = 'Insert Notes Correction'  
						SET @ReturnSts = @Err  
						Return @Err  
					END  
				END  
			END
		END
	END  
END


-- NEW SECTION 
IF (@Batchtype = 'DA') 
BEGIN     
	Update master set Current0=@Current0, Current1=@Current1, Current2=@Current2, Current3=@Current3, Current4=@Current4, Current5=@Current5, 
		Current6=@Current6, Current7=@Current7, Current8=@Current8, Current9=@Current9, Current10=@Current10
   Where number = @FileNumber  
END  
Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
   SET @ErrorBlock = 'Update Master DA'  
   SET @ReturnSts = @Err  
   Return @Err  
END  
IF (@Batchtype = 'DAR') 
BEGIN     
	Update master set Current0=@Current0, Current1=@Current1, Current2=@Current2, Current3=@Current3, Current4=@Current4, Current5=@Current5, 
		Current6=@Current6, Current7=@Current7, Current8=@Current8, Current9=@Current9, Current10=@Current10        
	Where number = @FileNumber  

	Select @Err=@@Error  
	IF @Err <> 0 
	BEGIN  
	   SET @ErrorBlock = 'Update Master DAR'  
	   SET @ReturnSts = @Err  
	   Return @Err  
	END

	If @QLevel in ('998', '999') 
	BEGIN
		--Update master set QLevel = '100', Status='ACT' Where number = @FileNumber
		EXEC @Err = SupportQueueItem_Insert @FileNumber, '700', 1, NULL, 0, 'System', 'Adjustment received on Closed account.', @IntVariable
		IF @Err = 0
		BEGIN
			INSERT INTO Notes (Number, Created, User0, action, result, comment) VALUES (@FileNumber, GetDate(), 'SYS', 'SC', '700', 'Adjustment received on Closed account.')

			Select @Err=@@Error  
			IF @Err <> 0 
			BEGIN  
			   SET @ErrorBlock = 'Insert Support queue'  
			   SET @ReturnSts = @Err  
			   Return @Err  
			END
		END
		SET @Err = 0
	END
END  

-- MDD: Moved declaration and calculation of @SurchargeOffset and added above
IF (@Batchtype in ('PU', 'PC', 'PA')) 
BEGIN
	IF DATEDIFF(day, ISNULL(@MasterLastPaid, '1961-8-30'), @PaidDate) >= 0
	BEGIN
		SET @MasterLastPaid =@PaidDate     
		SET @MasterLastPaidAmt =@Paid0     
	END
   	Update master set LastPaid=@MasterLastPaid, LastPaidAmt=@MasterLastPaidAmt, 
		Current0=@Current0, Current1=@Current1, Current2=@Current2, Current3=@Current3, Current4=@Current4, Current5=@Current5, 
		Current6=@Current6, Current7=@Current7, Current8=@Current8, Current9=@Current9, Current10=@Current10, 
        Paid=Paid-@Paid0, Paid1=Paid1-@Paid1, Paid2=Paid2-@Paid2, Paid3=Paid3-@Paid3, Paid4=Paid4-@Paid4, Paid5=Paid5-@Paid5, Paid6=Paid6-@Paid6, 
        Paid7=Paid7-@Paid7, Paid8=Paid8-@Paid8, Paid9=Paid9-@Paid9, Paid10=Paid10-@Paid10, Accrued10 = Accrued10 + @Surcharge 
        Where number = @FileNumber  

	Select @Err=@@Error  
	IF @Err <> 0 
	BEGIN  
	   SET @ErrorBlock = 'Update Master PU PC PA'  
	   SET @ReturnSts = @Err  
	   Return @Err  
	END  

	If @QLevel in ('998','999')
	BEGIN
		EXEC @Err = SupportQueueItem_Insert @FileNumber, '700', 1, NULL, 0, 'System', 'Payment received on Closed account.', @IntVariable
		IF @Err = 0
		BEGIN
			INSERT INTO Notes (Number, Created, User0, action, result, comment) VALUES (@FileNumber, GetDate(), 'SYS', 'SC', '700', 'Payment received on Closed account.')

			Select @Err=@@Error  
			IF @Err <> 0 
			BEGIN  
			   SET @ErrorBlock = 'Insert Support queue'  
			   SET @ReturnSts = @Err  
			   Return @Err  
			END
		END
	END
END  

IF (@Batchtype in ('PUR', 'PCR', 'PAR')) 
BEGIN 
       Update master set Current0=@Current0, Current1=@Current1, Current2=@Current2, Current3=@Current3, Current4=@Current4, Current5=@Current5, 
		   Current6=@Current6, Current7=@Current7, Current8=@Current8, Current9=@Current9, Current10=@Current10, 
           Paid=Paid+@Paid0, Paid1=Paid1+@Paid1, Paid2=Paid2+@Paid2, Paid3=Paid3+@Paid3, Paid4=Paid4+@Paid4, Paid5=Paid5+@Paid5, Paid6=Paid6+@Paid6,  
           Paid7=Paid7+@Paid7, Paid8=Paid8+@Paid8, Paid9=Paid9+@Paid9, Paid10=Paid10+@Paid10, Accrued10 = Accrued10 - @Surcharge
           Where number = @FileNumber 
    
   Select @Err=@@Error  
   IF @Err <> 0 
   BEGIN  
           SET @ErrorBlock = 'Update Master PU PC PA'  
           SET @ReturnSts = @Err  
           Return @Err  
   END 
   Set @Gross = @Gross * -1 
   Set @Fee = @Fee * -1
   
   IF (@IsCorrection = 0) 
   BEGIN
   		UPDATE master set NSF = 'T', NSFDate = getdate() WHERE number = @FileNumber
   		Select @Err=@@Error  
	   	IF @Err <> 0 
	   	BEGIN  
			SET @ErrorBlock = 'Update Master NSF'  
			SET @ReturnSts = @Err  
			Return @Err  
	   END 
   END
END 

IF (@BatchType in ('PU', 'PC', 'PA', 'PUR', 'PCR', 'PAR'))  
BEGIN 
   --   Update or Insert DeskStats Record 
   SELECT * FROM DeskStats WHERE Desk = @Desk and TheDate = @Entered  
       and SystemMonth = @SystemMonth and SystemYear = @SystemYear 
   IF (@@Rowcount = 0)  
   BEGIN 
       INSERT INTO DeskStats (TheDate, Desk, Collections, Fees, Worked, Contacted, Touched, SystemMonth, SystemYear)   
       VALUES (@Entered, @Desk, @Gross, @Fee, 0, 0, 0, @SystemMonth, @SystemYear) 
   END 
   ELSE 
   BEGIN 
       UPDATE DeskStats set Collections = Collections+@Gross, Fees = Fees + @Fee 
       WHERE Desk = @Desk and TheDate = @Entered and SystemMonth=@SystemMonth and SystemYear = @SystemYear  
   END 

   Select @Err=@@Error  
   IF @Err <> 0 
   BEGIN  
           SET @ErrorBlock = 'Update DeskStats'  
           SET @ReturnSts = @Err  
           Return @Err  
   END 
   --  Update or Insert CustStats Record 
   SELECT * FROM CustomerStats WHERE Customer = @Customer and TheDate = @Entered 
       and SystemMonth = @SystemMonth and SystemYear = @SystemYear 
   IF (@@Rowcount = 0) 
   BEGIN 
       INSERT INTO CustomerStats (TheDate, Customer, Collections, Fees, Worked, Contacted, Touched, SystemMonth, SystemYear) 
       VALUES (@Entered, @Customer, @Gross, @Fee, 0, 0, 0, @SystemMonth, @SystemYear) 
   END 
   ELSE 
   BEGIN 
       UPDATE CustomerStats set Collections = Collections + @Gross, Fees = Fees + @Fee 
       WHERE Customer = @Customer and TheDate = @Entered and SystemMonth =@SystemMonth and SystemYear = @SystemYear 
   END 
   Select @Err=@@Error  
   IF @Err <> 0 
   BEGIN  
           SET @ErrorBlock = 'Update CustStats'  
           SET @ReturnSts = @Err  
           Return @Err  
   END 
   -- Update Desk Table Record
   UPDATE Desk Set Collections = Collections + @Gross, Fees = Fees + @Fee, MTDCollections = MTDCollections + @Gross, MTDFees = MTDFees + @Fee, 
        YTDCollections = YTDCollections + @Gross, YTDFees = YTDFees + @Fee  
   WHERE Code = @Desk 
       Select @Err=@@Error  
   IF @Err <> 0 
   BEGIN  
           SET @ErrorBlock = 'Update DeskTable'  
           SET @ReturnSts = @Err  
           Return @Err  
   END 
   UPDATE Customer Set Collections = Collections + @Gross, Fees = Fees + @Fee, MTDCollections = MTDCollections + @Gross, MTDFees = MTDFees + @Fee, 
       YTDCollections = YTDCollections + @Gross, YTDFees = YTDFees + @Fee 
   WHERE Customer = @Customer 
   Select @Err=@@Error  
   IF @Err <> 0 
   BEGIN  
           SET @ErrorBlock = 'Update Customer Table'  
           SET @ReturnSts = @Err  
           Return @Err  
   END  

END 

--Update StairStep 
EXEC @Err = sp_UpdateSS2 @FileNumber, @Batchtype, @Paid0, @Fee
IF @Err <> 0 
BEGIN  
	SET @ErrorBlock = 'Update Stairstep'  
	SET @ReturnSts = @Err  
	Return @Err  
END  

-- Update the PayhistoryAudit table
EXEC @Err = UpdatePayhistoryAudit @BatchNumber, @PaymentBatchItemsId, @PayhistoryUID
SET @Err = 0

DELETE FROM PaymentBatchItems WHERE UID = @UID   
Select @Err=@@Error  
IF @Err <> 0 
BEGIN  
       SET @ErrorBlock = 'Delete PaymentBatchItem'  
       SET @ReturnSts = @Err  
       Return @Err  
END  
ELSE  
BEGIN  
       SET @ReturnSts = 0  
       Return 0  
END
GO

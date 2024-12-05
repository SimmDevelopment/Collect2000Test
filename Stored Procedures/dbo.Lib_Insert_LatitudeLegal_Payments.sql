SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Insert_LatitudeLegal_Payments]
(
      @ACCOUNTID   int,
      @RET_CODE   char (2),
      @PAY_DATE   datetime,
      @GROSS_PAY   money,
      @NET_CLIENT   money,
      @CHECK_AMT   money,
      @COST_RET   money,
      @FEES   money,
      @AGENT_FEES   money,
      @FORW_CUT   money,
      @COST_REC   money,
      @BPJ   char (1),
      @TA_NO   char (6),
      @RMIT_NO   char (6),
      @LINE1_3   money,
      @LINE1_5   money,
      @LINE1_6   money,
      @LINE2_1   money,
      @LINE2_2   money,
      @LINE2_5   money,
      @LINE2_6   money,
      @LINE2_7   money,
      @LINE2_8   money,
      @DESCR   varchar (30),
      @POST_DATE   datetime,
      @REMIT_DATE   datetime,
      @TA_CODE   char (8),
      @COMMENT   varchar (25),
	  @FORW_FILE varchar(20),
	  @MASCO_FILE varchar(15),
	  @FIRM_ID varchar(10),
	  @FORW_ID varchar(10)
)
AS
BEGIN


INSERT INTO dbo.LatitudeLegal_Payments
(
        ACCOUNTID  ,
        RET_CODE  ,
        PAY_DATE  ,
        GROSS_PAY  ,
        NET_CLIENT  ,
        CHECK_AMT  ,
        COST_RET  ,
        FEES  ,
        AGENT_FEES  ,
        FORW_CUT  ,
        COST_REC  ,
        BPJ  ,
        TA_NO  ,
        RMIT_NO  ,
        LINE1_3  ,
        LINE1_5  ,
        LINE1_6  ,
        LINE2_1  ,
        LINE2_2  ,
        LINE2_5  ,
        LINE2_6  ,
        LINE2_7  ,
        LINE2_8  ,
        DESCR  ,
        POST_DATE  ,
        REMIT_DATE  ,
        TA_CODE  ,
        COMMENT  ,
	    FORW_FILE,
	    MASCO_FILE,
		FIRM_ID,
		FORW_ID
)
values
(
      @ACCOUNTID,
      @RET_CODE,
      @PAY_DATE,
      @GROSS_PAY,
      @NET_CLIENT,
      @CHECK_AMT,
      @COST_RET,
      @FEES,
      @AGENT_FEES,
      @FORW_CUT,
      @COST_REC,
      @BPJ,
      @TA_NO,
      @RMIT_NO,
      @LINE1_3,
      @LINE1_5,
      @LINE1_6,
      @LINE2_1,
      @LINE2_2,
      @LINE2_5,
      @LINE2_6,
      @LINE2_7,
      @LINE2_8,
      @DESCR,
      @POST_DATE,
      @REMIT_DATE,
      @TA_CODE,
      @COMMENT,
	  @FORW_FILE,
	  @MASCO_FILE,
      @FIRM_ID,
	  @FORW_ID
)

--
----Now insert into Legal_Ledger and AIM_Ledger if needed
--DECLARE @legalledgerinsert bit,@aimledgerinsert bit,@process bit,@amountfield varchar(20),@amount MONEY
--DECLARE @batchtype varchar(3),@attorneyid INT,@AIMAgencyID INT,@legalledgertypeid INT
--SELECT @attorneyid = ISNULL(AttorneyID,0),@AIMAgencyID = ISNULL(AIMAgency,0)
--FROM dbo.master WITH (NOLOCK) WHERE number = @ACCOUNTID
--
--IF(@attorneyid > 0 OR @AIMAgencyID > 0)
--BEGIN
--SELECT
--@legalledgerinsert = legalledgerinsert ,
--@aimledgerinsert = aimledgerinsert ,
--@amountfield = amountfield ,
--@process = process ,
--@batchtype = batchtype
--FROM LatitudeLegal_PaymentMapping WITH (NOLOCK)
--WHERE RET_CODE = @RET_CODE
--END
--
--IF (@amountfield IS NOT NULL)
--BEGIN
--	SELECT @amount = CASE @amountfield 
--					WHEN 'GROSS_PAY' THEN	 abs( @GROSS_PAY)  WHEN 'LINE1_3' THEN abs(@LINE1_3)
--					WHEN 'NET_CLIENT' THEN      abs(@NET_CLIENT) WHEN 'LINE1_5' THEN abs(@LINE1_5)
--					WHEN 'CHECK_AMT' THEN      abs(@CHECK_AMT)  WHEN 'LINE1_6' THEN abs(@LINE1_6)
--					WHEN 'COST_RET' THEN      abs(@COST_RET)   WHEN 'LINE2_1' THEN abs(@LINE2_1)
--					WHEN 'FEES' THEN      abs(@FEES )      WHEN 'LINE2_2' THEN abs(@LINE2_2)
--					WHEN 'AGENT_FEES' THEN      abs(@AGENT_FEES) WHEN 'LINE2_5' THEN abs(@LINE2_5)
--					WHEN 'FORW_CUT' THEN      abs(@FORW_CUT)   WHEN 'LINE2_6' THEN abs(@LINE2_6)
--					WHEN 'COST_REC' THEN      abs(@COST_REC)	  WHEN 'LINE2_7' THEN abs(@LINE2_7)
--					WHEN 'LINE2_8' THEN abs(@LINE2_8) ELSE 0 END
--
--
--	IF (@AIMAgencyID > 0)
--	BEGIN
--		SELECT
--		@legalledgertypeid = ISNULL(ID,0)
--		FROM dbo.LegalLedgerType WITH (NOLOCK)
--		WHERE Code = @RET_CODE
--
--		IF(@legalledgertypeid > 0)
--		BEGIN
--			DECLARE @processFlag INT
--			SET @processFlag = 1
--			
--			IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'AIM_Custom_ProcessLegalLedgerEntry' AND ROUTINE_TYPE='FUNCTION' )
--			BEGIN
--				EXEC @processFlag = AIM_Custom_ProcessLegalLedgerEntry @ACCOUNTID,@PAY_DATE,@Amount,@legalledgertypeid,@TA_NO,@RMIT_NO,@AIMAgencyID
--			END
--
--			IF (@processFlag = 1)
--			BEGIN
--				INSERT INTO Legal_Ledger (AccountID,Customer,ItemDate,[Description],DebitAmt,CreditAmt,Invoiceable,
--					LegalLedgerTypeID,AIMID,AIMUniqueID,AIMInvoiceID,Created)
--			      
--				SELECT @ACCOUNTID,m.customer,@PAY_DATE,LEFT(ISNULL(llt.[Description],'') + ' - ' + ISNULL(@COMMENT,''),50),
--				CASE WHEN ISNULL(llt.IsDebit,0) = 1 THEN @amount ELSE 0 END,
--				CASE WHEN ISNULL(llt.IsDebit,0) = 0 THEN @amount ELSE 0 END,
--				ISNULL(llt.Invoiceable,0),
--				llt.ID,
--				@AIMAgencyID,
--				@TA_NO,
--				@RMIT_NO,
--				GETDATE()
--				FROM dbo.Master m WITH (NOLOCK), dbo.LegalLedgerType llt 
--				WHERE m.Number = @ACCOUNTID AND llt.ID = @legalledgertypeid
--
--			END
--		END
--	END
--
--
--	--Handle older YGC inserts to ledger by use of configuration and AttorneyID
--	ELSE IF(@process is not null and @process = 1)
--	BEGIN
--
--		IF(@legalledgerinsert is not null and @legalledgerinsert = 1)
--		BEGIN
--			INSERT INTO Legal_Ledger
--			(AccountID,Customer,ItemDate,Description,DebitAmt,CreditAmt,Invoiceable,
--			Created)
--			SELECT
--			@ACCOUNTID,m.customer,getdate(),@COMMENT,
--			CASE WHEN @batchtype in ('PUR','PAR','PCR','DAR') THEN @amount ELSE 0 END,
--			CASE WHEN @batchtype in ('PU','PA','PC','DA') THEN @amount ELSE 0 END,
--			1,
--			GETDATE()
--			FROM master m WITH (NOLOCK) WHERE number = @ACCOUNTID
--			
--		END
--
--		IF(@aimledgerinsert is not null and @aimledgerinsert = 1)
--		BEGIN
--			INSERT INTO AIM_Ledger
--			(Number,PortfolioId,Debit,Credit,LedgerTypeID,Comments,ToGroupID,FromGroupID,Status,DateEntered)
--			SELECT
--			@ACCOUNTID,p.portfolioid,
--			CASE WHEN @batchtype in ('PUR','PAR','PCR','DAR') THEN @amount ELSE 0 END,
--			CASE WHEN @batchtype in ('PU','PA','PC','DA') THEN @amount ELSE 0 END,
--			23,LEFT(ISNULL(@COMMENT,''),50),null,p.investorgroupid,'Approved',getdate()
--
--			FROM master m WITH (NOLOCK) JOIN AIM_Portfolio p WITH (NOLOCK)
--			ON m.purchasedportfolio = p.portfolioid WHERE m.number = @ACCOUNTID
--
--		END
--	END
--END
END

GO

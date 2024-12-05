SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[Lib_Update_AIM_Ledger]
(
      @LEDGERID   int,
      @LEDGERTYPEID   int,
      @COMMENTS   text,
      @CREDIT   money,
      @DEBIT   money,
      @DATEENTERED   datetime,
      @PORTFOLIOID   int,
      @NUMBER   int,
      @DATECLEARED   datetime,
      @TOGROUPID   int,
      @FROMGROUPID   int,
      @STATUS   varchar (50),
      @TOINVOICEID   int,
      @FROMINVOICEID   int
)
as
BEGIN


UPDATE dbo.AIM_Ledger set
	  LEDGERTYPEID = @LEDGERTYPEID,
      COMMENTS = @COMMENTS,
      CREDIT = CASE WHEN @STATUS in ('Not Available', 'Declined') THEN 0.00 ELSE @CREDIT END,
      DEBIT = CASE WHEN @STATUS in ('Not Available', 'Declined')  THEN 0.00 ELSE @DEBIT END,
      DATEENTERED = @DATEENTERED,
      PORTFOLIOID = @PORTFOLIOID,
      NUMBER = @NUMBER,
      DATECLEARED = CASE WHEN @STATUS in ('Not Available', 'Declined')  THEN isnull(@DATECLEARED,convert(varchar(10),getdate(),121)) ELSE @DATECLEARED END,
      TOGROUPID = @TOGROUPID,
      FROMGROUPID = @FROMGROUPID,
      STATUS = @STATUS,
      TOINVOICEID = @TOINVOICEID,
      FROMINVOICEID = @FROMINVOICEID
WHERE LEDGERID = @LEDGERID





	DECLARE @action varchar(25)
	IF(@LEDGERTYPEID IN (4,5,18,29,24,19,22,30,31,32,33,34))
	BEGIN
		IF(@STATUS IN ('Pending','Approved','Declined','Requested'))
		BEGIN
			
			SET @action = CASE @STATUS WHEN 'Pending' THEN 'Pending' WHEN 'Approved' THEN 'Approval' WHEN 'Declined' THEN 'Denial' WHEN 'Requested' THEN 'Requesting' END

			EXEC AIM_UpdateAccountAfterRecourseAction @LEDGERID,@action,'Exchange'
		END
	END
	ELSE IF(@LEDGERTYPEID IN (27,28))
	BEGIN
		IF(@STATUS IN ('Pending','Requested','Received','Sent','Not Available'))
		BEGIN
			
			SET @action = CASE @STATUS WHEN 'Pending' THEN 'Pending' WHEN 'Requested' THEN 'Requesting' WHEN 'Received' THEN 'Received' WHEN 'Sent' THEN 'Sending' WHEN 'Not Available' THEN 'NotAvailable' END
			
			EXEC AIM_UpdateAccountAfterMediaAction @LedgerId,@action,'Exchange'

		END
	END



END





GO

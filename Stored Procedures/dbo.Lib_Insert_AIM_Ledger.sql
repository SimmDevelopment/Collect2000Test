SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[Lib_Insert_AIM_Ledger]
(
      @LedgerId   int output,
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




IF NOT EXISTS (SELECT LedgerTypeID FROM AIM_LEDGERTYPE WHERE LedgerTypeID = @LEDGERTYPEID)
BEGIN
	RAISERROR('The Ledger Type ID is invalid', 16, 1)
	RETURN
END

DECLARE @CREDITGROUPTYPEID INT
DECLARE @DEBITGROUPTYPEID INT

SELECT @CREDITGROUPTYPEID = CreditGroupTypeID,@DEBITGROUPTYPEID = DebitGroupTypeID
FROM AIM_LedgerType WHERE LedgerTypeID = @LEDGERTYPEID


INSERT INTO dbo.AIM_Ledger
(
      
      LEDGERTYPEID,
      COMMENTS,
      CREDIT,
      DEBIT,
      DATEENTERED,
      PORTFOLIOID,
      NUMBER,
      DATECLEARED,
      TOGROUPID,
      FROMGROUPID,
      STATUS,
      TOINVOICEID,
      FROMINVOICEID,
	  SOLDPORTFOLIOID
)
SELECT

      @LEDGERTYPEID,
      @COMMENTS,
      CASE WHEN @CREDIT <> 0 THEN @CREDIT ELSE
			CASE --RECOURSE FROM BUYER 
				WHEN @LEDGERTYPEID IN (22,30,31,32,33,34) THEN 0
				 --RECOURSE TO SELLER
				WHEN @LEDGERTYPEID IN (4,5,18,29,24,19) THEN cast(m.original*p.costperfacedollar as decimal(9,2))
				ELSE 0
				END END,
      CASE WHEN @DEBIT <> 0 THEN @DEBIT ELSE
			CASE --RECOURSE FROM BUYER 
				WHEN @LEDGERTYPEID IN (22,30,31,32,33,34) THEN cast(psa.SoldFaceValue*s.costperfacedollar as decimal(9,2))
				 --RECOURSE TO SELLER
				WHEN @LEDGERTYPEID IN (4,5,18,29,24,19) THEN 0
				ELSE 0
				END END,
      @DATEENTERED,
      @PORTFOLIOID,
      @NUMBER,
      @DATECLEARED,
      CASE @CREDITGROUPTYPEID WHEN 0 THEN s.buyergroupid WHEN 1 THEN p.sellergroupid WHEN 2 THEN p.investorgroupid WHEN 3 THEN -1 ELSE NULL END,
      CASE @DEBITGROUPTYPEID WHEN 0 THEN s.buyergroupid WHEN 1 THEN p.sellergroupid WHEN 2 THEN p.investorgroupid WHEN 3 THEN -1 ELSE NULL END,
      @STATUS,
      null,
      null,
	  CASE WHEN m.soldportfolio is null or m.soldportfolio = '' THEN -1 ELSE m.soldportfolio END

FROM master m WITH (NOLOCK) JOIN AIM_Portfolio p WITH (NOLOCK) ON m.purchasedportfolio = p.portfolioid
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON m.soldportfolio = s.portfolioid
LEFT OUTER JOIN AIM_PortfolioSoldAccounts psa WITH (NOLOCK) ON psa.Number = m.number
WHERE m.number = @NUMBER

SELECT @LedgerId =  max(LedgerId) from aim_ledger

	DECLARE @action varchar(25)
	IF(@LEDGERTYPEID IN (4,5,18,29,24,19,22,30,31,32,33,34))
	BEGIN
		IF(@STATUS IN ('Pending','Approved','Declined','Requested'))
		BEGIN
			
			SET @action = CASE @STATUS WHEN 'Pending' THEN 'Pending' WHEN 'Approved' THEN 'Approval' WHEN 'Declined' THEN 'Denial' WHEN 'Requested' THEN 'Requesting' END

			EXEC AIM_UpdateAccountAfterRecourseAction @LedgerId,@action,'Exchange'
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

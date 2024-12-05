SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ChargedOffBalanceDetailViewCalculatedColumn]
    (
      @AccountId INT ,
      @Column INT
    )
RETURNS MONEY

---Supplies values for ChargedOffBalanceDetailView
AS
    BEGIN
        DECLARE @Return MONEY;
        DECLARE @Payments MONEY;
		DECLARE @Interest MONEY;
        DECLARE @Fees MONEY;
        DECLARE @FeesFromHistory MONEY;
        DECLARE @FeesFromHistoryReversal MONEY;
		
		-- Payments
        IF @Column = 1
            BEGIN
                SELECT  @Payments = ABS(master.paid1) + ABS(master.paid2) + ABS(master.paid3) + ABS(master.paid4) + ABS(master.paid5) + ABS(master.paid6) + ABS(master.paid7) + ABS(master.Paid8) + ABS(master.Paid9) + ABS(master.Paid10)
                FROM    master (nolock)
                WHERE   number = @AccountId;
                
                SET @Payments = ISNULL(@Payments,0);
            END

		-- Interest
        IF @Column = 2
            BEGIN
                       
                SELECT  @Interest = Master.Accrued2 
                FROM    master (nolock)
                WHERE   number = @AccountId;
            END
		
		-- Fees	(aka Adjusted)
        IF @Column = 3
            BEGIN
 
                SELECT  @FeesFromHistory =  (SUM(Paid3) + SUM(Paid4) + SUM(Paid5) + SUM(Paid6) + SUM(Paid7) + SUM(Paid8) + SUM(Paid9) + SUM(Paid10))
                FROM    payhistory
                WHERE   batchtype = 'DA'
                        AND BatchNumber IS NOT NULL
                        AND BatchNumber <> 0
                        AND number = @AccountId;
 
 
                SELECT  @FeesFromHistoryReversal = (SUM(Paid3) + SUM(Paid4) + SUM(Paid5) + SUM(Paid6) + SUM(Paid7) + SUM(Paid8) + SUM(Paid9) + SUM(Paid10))
                FROM    payhistory
                WHERE   batchtype =  'DAR'
                        AND BatchNumber IS NOT NULL
                        AND BatchNumber <> 0
                        AND number = @AccountId;
           
 
                SELECT  @Fees =  (master.Accrued10 + ISNULL(@FeesFromHistoryReversal,0) - ISNULL(@FeesFromHistory,0))
                FROM    master (nolock)
                WHERE   number = @AccountId;


            END
		
		--- Now set return values
        SELECT  @Return = CASE @Column
                            WHEN '1' THEN @Payments
                            WHEN '2' THEN @Interest
                            WHEN '3' THEN @Fees
                            ELSE 0
                          END
	  	
        RETURN @Return;
    END

GO

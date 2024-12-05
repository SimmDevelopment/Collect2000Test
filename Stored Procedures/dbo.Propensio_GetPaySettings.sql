SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Divinity Software
-- Create date: 2018/12/06
-- Description:	Stored procedure that defines how or if an account is displayed or interacted with on the site
-- Changes:
--			BGM 2/19/2019 Added qlevel 998 and above to be restricted from payments
--			DIV 4/12/2019 Added logic for Early Out minimum payment accounts
-- =============================================
CREATE PROCEDURE [dbo].[Propensio_GetPaySettings] 
       @FileNum int
AS
BEGIN
       SET NOCOUNT ON;

       DECLARE @minAmount MONEY = 25
       DECLARE @maxAmount MONEY = 99999
       DECLARE @suggestedAmount MONEY = null --Use for EO Min Due balance detail line
       DECLARE @maxCount INT = 1 --Max count of total payments in pay plan
       DECLARE @maxFuturePaymentDate DATETIME = null --Last paymetn date on or befor this. Null for none
       DECLARE @settlementRate DECIMAL = null --For future use
       DECLARE @settlementAmount MONEY = null -- For future use
       DECLARE @allowPayNow CHAR(1) = '1' --1 for yes, 0 for no
       DECLARE @allowFuturePay CHAR(1) = '0' 
       DECLARE @allowCreditCard CHAR(1) = '1'
       DECLARE @allowAch CHAR(1) = '1'


       --ADD LOGIC HERE TO SET ALL ABOVE VARIABLES
       
       
       --ALLOW PAY NOW--
       DECLARE @restrictions INT = 0
		
		--Use Statement below to return a value greater than 0 to restrict accounts from being allowed to accept payments--	

       SELECT @restrictions = COUNT(*) FROM (
			--'return something if there is a restriction'
              SELECT 1 x FROM master 
              WHERE (RestrictedAccess = 1 OR qlevel >= '998' )
              and number = @FileNum 
       ) r
       
       if (@restrictions > 0) 
       BEGIN
              SET @allowPayNow = '0'
       END
       -- END ALLOW PAY NOW --
       

       --Convert binary to int (flags)

       DECLARE @theBinary CHAR(4) = @allowAch + @allowCreditCard + @allowFuturePay + @allowPayNow

       DECLARE @cnt TINYINT = 1
       DECLARE @len TINYINT = 4

       DECLARE @payOptionFlags INT = CAST(SUBSTRING(@theBinary, @Len,1) AS INT)

       WHILE (@cnt < @len)
       BEGIN
              SET @payOptionFlags = @payOptionFlags + POWER(CAST(SUBSTRING(@theBinary, @len - @cnt, 1) * 2 AS INT), @cnt)
              SET @cnt = @cnt + 1
       END

	   --Set min/max
	   --Check for EO/SL-EO account
	   DECLARE @eoMinDue MONEY

	   SELECT @eoMinDue = CurrentMinDue FROM EarlyStageData es
			INNER JOIN master m on es.AccountID = m.number 
			INNER JOIN customer c on m.customer = c.customer
	   WHERE m.number = @FileNum 
			AND c.COB IN ('SL-EO - PSL - PRE-DEFAULT', 'EO - Early Out Accounts')

	   IF (@eoMinDue IS NOT NULL AND @eoMinDue > 0)
	   BEGIN
			SET @minAmount = @eoMinDue
			SET @suggestedAmount = @eoMinDue
	   END

	   SELECT @maxAmount = current0 FROM master WHERE number = @FileNum

	   IF (@maxAmount < @minAmount)
	   BEGIN
			SET @minAmount = @maxAmount
	   END

       SELECT		ROUND(@minAmount, 2) MinAmount, 
					ROUND(@maxAmount, 2) MaxAmount, 
                     @maxCount MaxCount, 
                     @SuggestedAmount SuggestedAmount, 
                     @maxFuturePaymentDate MaxFuturePaymentDate, 
                     @settlementRate SettlementRate,
                     @settlementAmount SettlementAmount,
                     @payOptionFlags PaymentOptionFlags
END
GO

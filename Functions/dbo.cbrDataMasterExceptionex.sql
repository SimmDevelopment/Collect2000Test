SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE FUNCTION [dbo].[cbrDataMasterExceptionex]
    ( @DelinquencyDate Datetime, @ReceivedDate datetime, @ContractDate datetime, @originalCreditor varchar(30), 
      @useaccountoriginalcreditor bit, @usecustomeroriginalcreditor bit, @DefaultOriginalCreditor varchar(30), 
      @CustomerOriginalCreditor varchar(30),  @ConsumerAccountNumber varchar(30), @HasChargeOffRecord bit, 
      @SecondaryAgencyIdenitifier varchar(2), @SecondaryAccountNumber varchar(30), @ChargeOffAmount money, 
      @IsValidAccountType int, @DefaultCreditorClass varchar(2), @IsChargeOffData int, @PortfolioType char(1),
      @OriginalLoan money)
RETURNS TABLE
AS 
    RETURN    
		select cast(sum(isnull(x.acctx,0)) as int) as cbrexception from
		(  SELECT CASE WHEN @DelinquencyDate IS NULL OR @DelinquencyDate <= '1900-01-01' THEN  -1 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN @DelinquencyDate > @ReceivedDate THEN -2 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN @DelinquencyDate > DATEADD(DAY, -4, { fn CURDATE() }) THEN -14 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN @IsValidAccountType = 0 THEN -8 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN @UseAccountOriginalCreditor = 1 AND ISNULL(@originalCreditor,'') = '' THEN -2048 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN @UseAccountOriginalCreditor = 0 AND ISNULL(@DefaultOriginalCreditor,'') = '' THEN -4096 ELSE 0 END AS acctx 
				UNION ALL								   
			   SELECT CASE WHEN ISNULL(@DefaultCreditorClass,'') NOT IN ('01' ,'02' ,'03' ,'04' ,'05' ,'06' ,'07' ,'08' ,'09' ,'10' ,'11' ,'12' ,'13' ,'14' ,'15' ) 
						AND ISNULL(@DefaultCreditorClass,'') NOT IN ('01' ,'02' ,'03' ,'04' ,'05' ,'06' ,'07' ,'08' ,'09' ,'10' ,'11' ,'12' ,'13' ,'14' ,'15' ) 
						THEN -1048576 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN @DelinquencyDate > DATEADD(day, -365, { fn curdate() }) AND 
						((@UseCustomerOriginalCreditor = 1 AND ISNULL(@DefaultCreditorClass,'') = '02') OR (@UseCustomerOriginalCreditor = 0 AND ISNULL(@DefaultCreditorClass,'') = '02'))
						THEN -16384 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN ISDATE(@ContractDate) = 0 AND ISNULL(@DefaultCreditorClass,'') IN ('01','03','05','06','07','08','09','10','11','12','13','14','15') 											
									  THEN -32768 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN @IsChargeOffData = 1 AND @ContractDate IS NULL THEN -16 ELSE 0 END AS acctx 
						-- we need the customer account number
				UNION ALL
			   SELECT CASE WHEN @ConsumerAccountNumber IS NULL THEN -32 ELSE 0 END AS acctx 
						-- we have to have a charge off record
				UNION ALL
			   SELECT CASE WHEN @IsChargeOffData = 1 AND @HasChargeOffRecord IS NULL THEN -64 ELSE 0 END AS acctx 
						-- we have to have a charge off amount  
				UNION ALL
			   SELECT CASE WHEN @IsChargeOffData = 1 AND ISNULL(@ChargeOffAmount, 0) = 0 THEN -128 ELSE 0 END AS acctx 
						-- we have to have a secondary agency identifier for mortgage industry mortgage portfolio chargeoffs
				UNION ALL
			   SELECT CASE WHEN @PortfolioType = 'M' AND ISNULL(@SecondaryAgencyIdenitifier,'') NOT IN ('00','01','02') THEN -256 ELSE 0 END AS acctx 
						-- we have to have a secondary account number for mortgage industry mortgage portfolio chargeoffs
				UNION ALL
			   SELECT CASE WHEN @PortfolioType = 'M' AND ISNULL(@SecondaryAccountNumber,'') = '' AND ISNULL(@SecondaryAgencyIdenitifier,'') IN ('01','02') 
						THEN -512 ELSE 0 END AS acctx 
				UNION ALL
			   SELECT CASE WHEN ISNULL(@OriginalLoan,0) <= 0 THEN -2097152 ELSE 0 END AS acctx) x
	

GO

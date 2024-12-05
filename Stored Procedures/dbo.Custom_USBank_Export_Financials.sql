SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Updates
--Changed to Net instead of Gross remit on 7/12/2018  BGM.

DECLARE @BeginDate datetime
DECLARE @EndDate datetime
DECLARE @Customer varchar(8000)
DECLARE @invoice varchar(8000)
SET @BeginDate = '20070201'
SET @EndDate = '20070206'
--SET @Customer = '0000837|0000839|'
SET @invoice = '10136|10140|'

EXEC [getToyotaFinancials] @BeginDate, @EndDate,  @invoice

*/


--ALTER  the procedure.
CREATE      PROCEDURE [dbo].[Custom_USBank_Export_Financials]
@BeginDate datetime,
@EndDate datetime,
--@Customer varchar(8000)
@invoice varchar(8000)
AS
-- Create an in-memory temp table.
CREATE TABLE #USBank_TempUploadFinancials
(
TransDate datetime,
TransTime VARCHAR(4),
Account VARCHAR(20),
TransCode VARCHAR(2),
TransAmt money,
FeeAmt money,
InterestFlag varchar(1),
DirectedFlag VARCHAR(1),
TransDesc VARCHAR(30),
NetPmtAmt money,
CommPerValue int,
CommPct varchar(4), 
Internal_External_Flag VARCHAR(1),
DPS_ID varchar(4),
Recoverer_Code VARCHAR(8),
Loan_Code VARCHAR(4)
) ON [PRIMARY]
DECLARE @batchDate varchar(50)
DECLARE @FieldCode varchar(50)
DECLARE @batchTime VARCHAR(20) 
DECLARE @Customers VARCHAR(50)
SET @EndDate = CAST(CONVERT(varchar(10),@EndDate,20) + ' 23:59:59.000' as datetime)
-- Remove the "/" from the date portion of the datetime value, 
SET @batchDate = REPLACE(CONVERT(char, GetDate(), 111), '/', '')
-- Remove the ":" from the time portion of the datetime value, 
-- and return the first 4 chars HHMM.
SET @batchTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''), 4)
INSERT INTO #USBank_TempUploadFinancials
(
TransDate,
TransTime,
Account,
TransCode,
TransAmt,
FeeAmt,
InterestFlag,
DirectedFlag,
TransDesc,
NetPmtAmt,
CommPerValue,
CommPct, 
Internal_External_Flag,
DPS_ID,
Recoverer_Code,
Loan_Code 
)
-- Changed by BGM on 09/06/2018 Use Transaction date instead of current date
-- payment date
SELECT REPLACE(CONVERT(char, ph.Entered, 111), '/', ''),
--SELECT CASE WHEN ph.batchtype in ('PU','PA') THEN REPLACE(CONVERT(char, GetDate(), 111), '/', '') ELSE (SELECT datepaid FROM payhistory WHERE uid = ph.reverseofuid) END,
       '0000',
       m.account,
     --  CASE
	    --WHEN ph.batchtype IN ('PU','PA') THEN '52'
     --       WHEN ph.batchtype IN ('PUR','PAR') THEN '59'
     --  END 
       '52' AS TransCode,
       transamt = 
           CASE            
                WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid),2)
                WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid) * -1,2)
	   END,       
       nettransamt = 
           CASE            
                WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalFee](ph.uid),2)
                WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalFee](ph.uid) * -1,2)
	   END,       
       InterestFlag = 'N',
       DirectedFlag = '',     
       transdesc = 'Payment - collection agency',
  --         CASE
		--WHEN ph.batchtype IN ('PU','PA') THEN 'Payment - SIM'
  --              WHEN ph.batchtype IN ('PUR','PAR') THEN 'Payment Reversal-NSF SIM '
	 --  END,
/*
	NetPmtAmt = ABS([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid)) 
	            - ABS([dbo].[Custom_CalculatePaymentTotalFee](ph.uid)),
*/     
       NetPmtAmt = 
           CASE 

               WHEN ph.batchType IN ('PU', 'PA') THEN Round(ABS([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid)),2)
                                                    - Round(ABS([dbo].[Custom_CalculatePaymentTotalFee](ph.uid)),2)
               WHEN ph.batchtype IN ('PUR','PAR') THEN ABS(Round(ABS([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid)),2)
                                                    - Round(ABS([dbo].[Custom_CalculatePaymentTotalFee](ph.uid)),2)) * -1

                --WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid),2)
                --WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid) * -1,2)
           END, 
       CommPerValue = fsd.Fee1,
       CommPct = '0000',
       'X',
       c.CustomText1 AS DPS_ID,
       c.CustomText1 AS Recoverer_ID,
	   (SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code      

--select ph.*
FROM  master m WITH (NOLOCK)
INNER JOIN PayHistory ph WITH (NOLOCK)ON ph.number = m.number
INNER JOIN customer c WITH(NOLOCK)on c.customer = m.customer 
INNER JOIN FeeScheduleDetails fsd WITH (NOLOCK) ON c.FeeSchedule = fsd.Code
WHERE ph.invoice in (select string from dbo.CustomStringToSet(@invoice,'|') ) and
      ph.matched <> 'Y' and 
      ph.batchtype NOT IN('PC','PCR','DA','DAR') and 
      ph.paid1 <> 0
	   
UPDATE #USBank_TempUploadFinancials
	SET CommPerValue = CAST(ROUND(FeeAmt / TransAmt * 1000,0) * 10 as int)
	WHERE(TransAmt <> 0)

Select REPLACE(CONVERT(char, TransDate, 111), '/', '') as BatchDate, TransDate, 
       TransTime, Account, TransCode, 
       FeeAmt, InterestFlag, DirectedFlag, TransDesc,       
       Internal_External_Flag, DPS_ID,
       Recoverer_Code, Loan_Code, 
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(5),((SELECT COUNT(Account)
        FROM #USBank_TempUploadFinancials))),5, 0) as TransCount,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(TransAmt)
        FROM #USBank_TempUploadFinancials))),10, 1) as GrossTransAmt,

       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(NetPmtAmt)
        FROM #USBank_TempUploadFinancials))),10, 1) as GrossNetAmt,

       --[dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(TransAmt)
       -- FROM #USBank_TempUploadFinancials))),10, 1) as GrossNetAmt,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),TransAmt),10, 1) as TransAmt,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),NetPmtAmt), 10, 1) as NetPmtAmt, 
       CONVERT(varchar(4),ABS(CommPerValue)) as CommPercValue,
       --[dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(4),ABS(0)),4,0) as CommPercValue,
       ' ' as NotUsed
from #USBank_TempUploadFinancials
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*

exec [Custom_Citizens_Export_Financials] 23301

*/


--ALTER  the procedure.
CREATE      PROCEDURE [dbo].[Custom_Citizens_Export_Financials]
@invoice varchar(8000)
AS
-- Create an in-memory temp table.
CREATE TABLE #Citizens_TempUploadFinancials
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
---- Remove the "/" from the date portion of the datetime value, 
SET @batchDate = REPLACE(CONVERT(char, GetDate(), 111), '/', '')
-- Remove the ":" from the time portion of the datetime value, 
-- and return the first 4 chars HHMM.
SET @batchTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''), 4)
INSERT INTO #Citizens_TempUploadFinancials
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
       '0000',
       m.account,
       CASE
	    WHEN ph.batchtype IN ('PU') THEN '50'
            WHEN ph.batchtype IN ('PUR') THEN '59'
       END  AS TransCode,
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
       InterestFlag = 'Y',
       DirectedFlag = '',     
       transdesc = 
           CASE
		WHEN ph.batchtype IN ('PU','PA') THEN 'PAYMENT - SIM'
                WHEN ph.batchtype IN ('PUR','PAR') THEN 'NSF RECEIVED - SIM'
	   END,
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
	   (SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code      

--select ph.*
FROM  master m WITH (NOLOCK)
INNER JOIN PayHistory ph WITH (NOLOCK)ON ph.number = m.number
INNER JOIN customer c WITH(NOLOCK)on c.customer = m.customer 
INNER JOIN FeeScheduleDetails fsd WITH (NOLOCK) ON c.FeeSchedule = fsd.Code
WHERE ph.invoice in (select string from dbo.CustomStringToSet(@invoice,'|') ) AND
      ph.batchtype NOT IN('PC','PCR','DA','DAR') and 
      ph.paid1 <> 0
      
--UNION

--Report back commission only
--SELECT REPLACE(CONVERT(char, ph.Entered, 111), '/', ''),
--       '0000',
--       m.account,
--       '49' AS TransCode,
--       transamt = 
--           CASE            
--                WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalFee](ph.uid),2)
--                WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalFee](ph.uid) * -1,2)
--	   END,       
--       nettransamt = 
--           CASE            
--                WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalFee](ph.uid),2)
--                WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalFee](ph.uid) * -1,2)
--	   END,       
--       InterestFlag = 'Y',
--       DirectedFlag = '',     
--       transdesc = 
--           CASE
--		WHEN ph.batchtype IN ('PU','PA') THEN 'PAYMENT - SIM'
--                WHEN ph.batchtype IN ('PUR','PAR') THEN 'NSF RECEIVED - SIM'
--	   END,
--/*
--	NetPmtAmt = ABS([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid)) 
--	            - ABS([dbo].[Custom_CalculatePaymentTotalFee](ph.uid)),
--*/     
--       NetPmtAmt = 
--           CASE 

--               WHEN ph.batchType IN ('PU', 'PA') THEN Round(ABS([dbo].[Custom_CalculatePaymentTotalFee](ph.uid)),2)
--               WHEN ph.batchtype IN ('PUR','PAR') THEN ABS(Round(ABS([dbo].[Custom_CalculatePaymentTotalFee](ph.uid)),2)) * -1

--                --WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid),2)
--                --WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid) * -1,2)
--           END, 
--       CommPerValue = fsd.Fee1,
--       CommPct = '0000',
--       'X',
--       c.CustomText1 AS DPS_ID,
--       c.CustomText1 AS Recoverer_ID,
--	   (SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code      

--select ph.*
--FROM  master m WITH (NOLOCK)
--INNER JOIN PayHistory ph WITH (NOLOCK)ON ph.number = m.number
--INNER JOIN customer c WITH(NOLOCK)on c.customer = m.customer 
--INNER JOIN FeeScheduleDetails fsd WITH (NOLOCK) ON c.FeeSchedule = fsd.Code
--WHERE ph.invoice in (select string from dbo.CustomStringToSet(@invoice,'|') ) AND
--      ph.batchtype NOT IN('PC','PCR','DA','DAR') and 
--      ph.paid1 <> 0
	   
UPDATE #Citizens_TempUploadFinancials
	SET CommPerValue = CASE WHEN transcode <> '49' then CAST(ROUND(FeeAmt / TransAmt * 1000,0) * 10 as int) ELSE 0000 END
	WHERE(TransAmt <> 0)

Select REPLACE(CONVERT(char, TransDate, 111), '/', '') as BatchDate, TransDate, 
       TransTime, Account, TransCode, [dbo].[Custom_ConvertNumberToIBMSigned](TransAmt, 10, 1),
       [dbo].[Custom_ConvertNumberToIBMSigned](FeeAmt, 10, 1), InterestFlag, DirectedFlag, TransDesc,       
       Internal_External_Flag, DPS_ID,
       Recoverer_Code, Loan_Code, 
       CASE WHEN recoverer_code = '3803' THEN '3274'
			ELSE '3264' END AS Bank_ID,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(5),((SELECT COUNT(Account)
			FROM #Citizens_TempUploadFinancials))),5, 0) as TransCount,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(TransAmt)
			FROM #Citizens_TempUploadFinancials))),10, 1) as GrossTransAmt,

       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(NetPmtAmt)
			FROM #Citizens_TempUploadFinancials))),10, 1) as GrossNetAmt,

       --[dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(TransAmt)
       -- FROM #Citizens_TempUploadFinancials))),10, 1) as GrossNetAmt,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),TransAmt),10, 1) as TransAmt,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),NetPmtAmt), 10, 1) as NetPmtAmt, 
       CONVERT(varchar(4),ABS(CommPerValue)) as CommPercValue,
       --[dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(4),ABS(0)),4,0) as CommPercValue,
       ' ' as NotUsed
from #Citizens_TempUploadFinancials
GO

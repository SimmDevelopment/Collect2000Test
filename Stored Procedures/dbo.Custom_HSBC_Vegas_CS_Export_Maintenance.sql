SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO






--ALTER  the procedure.
CREATE      PROCEDURE [dbo].[Custom_HSBC_Vegas_CS_Export_Maintenance]
@BeginDate datetime,
@EndDate datetime,
@customer varchar(5000),
@invoice varchar(8000)

AS
BEGIN
	CREATE TABLE #HsbcReturns(number int)
	
	
	CREATE TABLE #HSBCVegas_TempUploadFinancials
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
	Agency_Code varchar(4),
	MIO_Parent VARCHAR(8)) ON [PRIMARY]

		
	-- Create an in-memory temp table.
	CREATE TABLE #HSBC_TempUploadMaintenance
	(OrderByFlag int,
	TransDate VARCHAR(10),
	TransTime VARCHAR(4),
	Account VARCHAR(20),
	TransCode VARCHAR(2),
	FieldCode VARCHAR(6),
	NewValue VARCHAR(40),
	Internal_External_Flag VARCHAR(1),
	Agency_Code varchar(4),
	MIO_Parent VARCHAR(8)) ON [PRIMARY]
	DECLARE @runDate datetime
	DECLARE @batchDate varchar(50)
	DECLARE @FieldCode varchar(50)
	DECLARE @batchTime VARCHAR(20) 

	SET @runDate = getdate()
	
	SET @EndDate = CAST(CONVERT(varchar(10),@EndDate,20) + ' 23:59:59.000' as datetime)
	-- Remove the "/" from the date portion of the datetime value, 
	SET @batchDate = REPLACE(CONVERT(char, GetDate(), 111), '/', '')
	-- Remove the ":" from the time portion of the datetime value, 
	-- and return the first 4 chars HHMM.
	SET @batchTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''), 4)
	-- Set the address change
	DECLARE @addressChanges varchar(50)
	SET @addresschanges = 'MASAD1|MASAD2|MASCTY|MASSTC|MASZIP'
	-- Address Change
	
	INSERT INTO #HSBCVegas_TempUploadFinancials
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
Agency_Code,
MIO_Parent)

-- Changed by KAR on 08/07/2006 Want to use the file creation date instead of the 
-- payment date
--SELECT REPLACE(CONVERT(char, ph.Entered, 111), '/', ''),
SELECT CASE WHEN ph.batchtype in ('PU','PA') THEN REPLACE(CONVERT(char, GetDate(), 111), '/', '') ELSE (SELECT datepaid FROM payhistory WHERE uid = ph.reverseofuid) END as TransDate,
       '0000'as TransTime,
       m.account,
       CASE
	    WHEN ph.batchtype IN ('PU','PA') THEN '54'
            WHEN ph.batchtype IN ('PUR','PAR') THEN '55'
       END AS TransCode,
       TransAmt = 
           CASE            
                WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid),2)
                WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid) * -1,2)
	   END,       
       FeeAmt = 
           CASE            
                WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalFee](ph.uid),2)
                WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalFee](ph.uid) * -1,2)
	   END,       
       InterestFlag = 'N',
       DirectedFlag = '',     
       TransDesc = 
           CASE
		WHEN ph.batchtype IN ('PU','PA') THEN 'Payment - SIMM'
                WHEN ph.batchtype IN ('PUR','PAR') THEN 'Payment Reversal - SIMM'
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
/*
                WHEN ph.batchtype IN ('PU','PA') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid),2)
                WHEN ph.batchtype IN ('PUR','PAR') THEN Round([dbo].[Custom_CalculatePaymentTotalPaid](ph.uid) * -1,2)
*/           END, 
       CommPerValue = 0,
       CommPct = (select fd.fee1 from customer c with (nolock)  inner join feescheduledetails fd with (nolock) on c.feeschedule = fd.code where customer = m.customer),
       ' ' as Internal_External_Flag,
       c.customtext1 AS Agency_Code,
		c.customtext2 AS MIO_Parent   

FROM  master m WITH (NOLOCK)
INNER JOIN PayHistory ph WITH (NOLOCK)ON ph.number = m.number
INNER JOIN customer c WITH(NOLOCK)on c.customer = m.customer 
WHERE ph.invoice in (select string from dbo.CustomStringToSet(@invoice,'|') ) and
      ph.matched <> 'Y' and 
      ph.batchtype NOT IN('PC','PCR','DA','DAR') and 
      ph.paid1 <> 0
	   
UPDATE #HSBCVegas_TempUploadFinancials
	SET CommPerValue = CAST(ROUND(FeeAmt / TransAmt * 1000,0) * 10 as int)
	WHERE(TransAmt <> 0)

	Select REPLACE(CONVERT(char, TransDate, 111), '/', '') as BatchDate, TransDate, 
       TransTime, Account, TransCode, 
       FeeAmt, InterestFlag, DirectedFlag, TransDesc,       
       Internal_External_Flag, Agency_Code,
       MIO_Parent, 
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(5),((SELECT COUNT(Account)
        FROM #HSBCVegas_TempUploadFinancials))),5, 0) as TransCount,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(TransAmt)
        FROM #HSBCVegas_TempUploadFinancials))),10, 1) as GrossTransAmt,

       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(NetPmtAmt)
        FROM #HSBCVegas_TempUploadFinancials))),10, 1) as GrossNetAmt,
/*
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),((SELECT SUM(TransAmt)
        FROM #HSBCVegas_TempUploadFinancials))),10, 1) as GrossNetAmt,
*/       
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),TransAmt),10, 1) as TransAmt,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(10),NetPmtAmt), 10, 1) as NetPmtAmt, 
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(4),ABS(CommPerValue)),4,0) as CommPercValue,
       --[dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(4),ABS(0)),4,0) as CommPercValue,
       ' ' as NotUsed
from #HSBCVegas_TempUploadFinancials
	
	
	
	
	INSERT INTO #HSBC_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	Agency_Code,
	MIO_Parent)
	SELECT 
	2,
	@batchDate,
	@batchTime,
	m.account,
	'MT',       	
	CASE d.SEQ
		WHEN 0 THEN	
			CASE csts.string
				WHEN 'MASAD1' THEN 'MASAD1'
				WHEN 'MASAD2' THEN 'MASAD2'
				WHEN 'MASCTY' THEN 'MASCTY'
				WHEN 'MASSTC' THEN 'MASSTC'
				WHEN 'MASZIP' THEN 'MASZIP'
			END
		ELSE
			CASE csts.string
				WHEN 'MASAD1' THEN 'C01AD1'
				WHEN 'MASAD2' THEN 'C01AD2'
				WHEN 'MASCTY' THEN 'C01CTY'
				WHEN 'MASSTC' THEN 'C01STC'
				WHEN 'MASZIP' THEN 'C01ZIP'
			END
		END AS Field_Code,
	CASE csts.string
		WHEN 'MASAD1' THEN LEFT(ah.NewStreet1,40)
		WHEN 'MASAD2' THEN LEFT(ah.NewStreet2,40)
		WHEN 'MASCTY' THEN LEFT(ah.NewCity,40)
		WHEN 'MASSTC' THEN ah.NewState
		WHEN 'MASZIP' THEN [dbo].[StripNonDigits](ah.NewZipCode)
	END as address,
	' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM dbo.CustomStringToSet(@addresschanges,'|') csts,
	AddressHistory ah WITH (NOLOCK) 
	INNER JOIN DEBTORS D WITH (NOLOCK)
	ON ah.debtorid = d.debtorid
	INNER JOIN Master m WITH (NOLOCK)
	ON d.Number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	WHERE ah.DateChanged BETWEEN @BeginDate and @EndDate AND
	m.customer in (select string from dbo.CustomStringToSet(@customer,'|'))
	
	-- Phone Change
	INSERT INTO #HSBC_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	Agency_Code,
	MIO_Parent)
	SELECT 2,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	CASE d.seq
		WHEN 0 THEN        	 
			CASE ph.PhoneType
				WHEN 1 THEN 'MASHPH'
				WHEN 2 THEN 'MASOPH'
			END 
		ELSE
			CASE ph.PhoneType
				WHEN 1 THEN 'C01HPH'
				WHEN 2 THEN 'C01OPH'
			END                    
	END AS Field_Code,
	[dbo].[StripNonDigits](ph.NewNumber),
	' ',
	c.customtext1 AS Agency_Code,       
	c.customtext2 AS MIO_Parent
	FROM PhoneHistory ph WITH (NOLOCK)
	INNER JOIN Debtors d WITH (NOLOCK) ON d.DebtorID = ph.DebtorID and d.seq = 0
	INNER JOIN Master  m WITH (NOLOCK)
	ON d.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	where ph.DateChanged BETWEEN @BeginDate and @EndDate AND
	m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND ph.Phonetype IN(1,2)
	
	-- Return Accounts From Dana Greene Find accoutns in a Closed Status that the Qlevel is not @ 999.
	INSERT INTO #HSBCReturns(number)
	SELECT m.number
	FROM master m WITH(NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON m.customer=c.customer
	INNER JOIN status s WITH(NOLOCK)
	ON s.code = m.status
	WHERE m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND
	m.status IN('B07','B11','B13','BKY','FRD','PIF','SIF','RCL', 'DSP', 'DEC', 'CAD') AND
	m.Qlevel NOT IN('999')
	
	
/*
	-- We need to update master to be returned and create a note
	UPDATE master
	SET Qlevel = '999',returned = @runDate,
	closed = CASE WHEN closed IS NULL THEN @runDate ELSE closed END
	WHERE number IN(SELECT number from #HSBCReturns)

	-- Insert a Note Showing the return of the account.
	INSERT INTO Notes(number,created,user0,action,result,comment)
	SELECT t.number,@runDate,'EXG','+++++','+++++', 'Account was returned to HSBC during the Maintenance Export process.'
	FROM #HSBCReturns t 

*/
	INSERT INTO #HSBC_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	Agency_Code,
	MIO_Parent)
	SELECT 1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	'MASSTS',
	CASE m.Status
		WHEN 'B07' THEN '03A'
		WHEN 'B11' THEN '03A'
		WHEN 'B13' THEN '03A'
		WHEN 'BKY' THEN '03A'
		WHEN 'FRD' THEN '03C'
		WHEN 'RCL' THEN '03J'	--RECALLED BY CLIENT
		WHEN 'DSP' THEN '03E'
		WHEN 'DEC' THEN '03B'
		WHEN 'CAD' THEN '03D'
	END AS NewValue,
	' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	WHERE m.number IN(SELECT number FROM #HSBCReturns)


	-- This is PIF and SIF processing only as thery require 
        -- a different set of business rules for maintenance processing.
	INSERT INTO #HSBC_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	Agency_Code,
	MIO_Parent)
	SELECT 1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	'MASSTS',
	CASE m.Status
		WHEN 'PIF' THEN '03H'		
		WHEN 'SIF' THEN '03G'
	END AS NewValue,
	' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer 
	WHERE (m.number IN(SELECT number FROM #HSBCReturns)) and
          (m.Status in ('PIF', 'SIF')) --and (datediff(d, m.LastPaid, (GetDate())) >= 30)
	

	INSERT INTO #HSBC_TempUploadMaintenance
			(OrderByFlag,
			TransDate,
			TransTime,
			Account,
			TransCode,
			FieldCode,
			NewValue,
			Internal_External_Flag,
			Agency_Code,
			MIO_Parent)

			SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'01    ',
			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and convert(varchar(100), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL')

UNION

--Get first 40 characters Line 2
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'02    ',
			isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
		' ',
		c.customtext1 AS Agency_Code,
		c.customtext2 AS MIO_Parent	
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 40

UNION

--Get first 40 characters Line 3
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'03    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 80

UNION

--Get first 40 characters Line 4
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'04    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 120

UNION

--Get first 40 characters Line 5
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'05    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 160

UNION

--Get first 40 characters Line 6
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'06    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 200

UNION

--Get first 40 characters Line 7
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'07    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 240

UNION

--Get first 40 characters Line 8
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'08    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 280
UNION

--Get first 40 characters Line 9
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'09    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 320

UNION

--Get first 40 characters Line 10
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case when result = 'BK' then 'BA'
				when [action] = 'TE' and result = 'WN' then 'BD'
				when [action] = 'TE' and result = 'DK' then 'BE'
				when [action] = 'TE' and result = 'LM' then 'BM'
				when [action] = 'TE' and result = 'NA' then 'BN'
				when [action] = 'TE' and result = 'PP' then 'BP'
				when [action] = 'TE' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'TE' and result = 'LB' then 'BZ'
				when [action] = 'DT' and result = 'TT' then 'CP'
				when [action] in ('NB', 'TO') then 'CR'
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'WN' then 'PD'
				when [action] = 'TR' and result = 'TT' then 'HE'
				when [action] = 'TR' and result = 'LM' then 'HL'
				when [action] = 'TR' and result in ('AM', 'LR', 'LV') then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				when [action] = 'TR' and result = 'PP' then 'HP'
				when [action] = 'TR' and result = 'CY' then 'HS'
				when [action] = 'DT' and result = 'LV' then 'LM'
				when [action] = 'DIAL' and result = 'WN' then 'BD'
				when [action] = 'DIAL' and result = 'DK' then 'BE'
				when [action] = 'DIAL' and result = 'LM' then 'BM'
				when [action] = 'DIAL' and result = 'NA' then 'BN'
				when [action] = 'DIAL' and result = 'PP' then 'BP'
				when [action] = 'DIAL' and result in ('AM', 'LR', 'LV') then 'BV'
				when [action] = 'DIAL' and result = 'LB' then 'BZ'
				
				else '90'				
				 end,        	 
			'10    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL') and len(convert(varchar(1000), n.comment)) > 360

UNION

--These are the TU/BKY/DEC scrub comments
--Get first 40 characters Line 1
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'01    ',
			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and convert(varchar(40), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')

UNION

--Get first 40 characters Line 2
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'02    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 40

UNION

--Get first 40 characters Line 3
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'03    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 80

UNION

--Get first 40 characters Line 4
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'04    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 120

UNION

--Get first 40 characters Line 5
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'05    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 160

UNION

--Get first 40 characters Line 6
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'06    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 200

UNION

--Get first 40 characters Line 7
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'07    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 240

UNION

--Get first 40 characters Line 8
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'08    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 280

UNION

--Get first 40 characters Line 9
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'09    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 320

UNION

--Get first 40 characters Line 10
SELECT distinct
			1,
			@batchDate,
			@batchTime,
			m.account,
			'90',        	 
			'10    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), ''),
			' ',
	c.customtext1 AS Agency_Code,
	c.customtext2 AS MIO_Parent
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 360


/*	
-- SOFT RECALLS HOLD
	INSERT INTO #HSBC_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	Agency_Code,
	MIO_Parent)
	SELECT 
	1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',        	 
	'MASSTS',
	'A3H',
	'X',
	c.customtext1 AS Agency_Code,       
	c.customtext1 AS MIO_Parent
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer 
	WHERE m.customer = @customer AND
	Qlevel NOT IN('998','999') AND 
	DateDiff(DAY,m.received,getdate()) BETWEEN 25 and 30
	-- Find accounts that have payments or active promises, pdcs within the last 30 days.
	AND m.number IN(SELECT ph.number FROM payhistory ph WITH(NOLOCK)
					WHERE ph.number = m.number AND DateDiff(DAY,ph.entered,getdate()) BETWEEN 0 AND 30 AND
					ph.batchtype IN('PU')
					UNION 
					SELECT p.number FROM PDC p WITH(NOLOCK)
					WHERE p.number = m.number AND p.active = 1 AND DateDiff(DAY,p.entered,getdate()) BETWEEN 0 AND 30
					UNION 
					SELECT p.AcctId FROM Promises p WITH(NOLOCK)
					WHERE p.AcctId = m.number AND p.Active = 1 AND 
					DateDiff(DAY,p.entered,getdate()) BETWEEN 0 AND 30)
	*/

	/*
	--acknowledge new placements
	INSERT INTO #HSBC_TempUploadMaintenance
			(OrderByFlag,
			TransDate,
			TransTime,
			Account,
			TransCode,
			FieldCode,
			NewValue,
			Internal_External_Flag,
			Agency_Code,
			MIO_Parent)
			SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			'AP',        	 
			'MASSTS',
			'Account Placement Received',
			'X',
			c.customtext1 AS Agency_Code,       
			c.customtext1 AS MIO_Parent
	FROM Master m WITH(NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where m.Received between @BeginDate and @EndDate and 
	      m.Customer = @customer
	*/
	-- Return all records...
	SELECT * FROM #HSBC_TempUploadMaintenance
	WHERE NewValue IS NOT NULL AND RTRIM(LTRIM(NewValue)) != ''
	ORDER BY Account, OrderByFlag , FieldCode

END
GO

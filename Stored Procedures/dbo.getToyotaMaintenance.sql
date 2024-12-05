SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO






--ALTER  the procedure.
CREATE      PROCEDURE [dbo].[getToyotaMaintenance]
@BeginDate datetime,
@EndDate datetime,
@customer varchar(5000)
AS
BEGIN
	CREATE TABLE #ToyotaReturns(number int)
	
	-- Create an in-memory temp table.
	CREATE TABLE #Toyota_TempUploadMaintenance
	(OrderByFlag int,
	TransDate VARCHAR(10),
	TransTime VARCHAR(4),
	Account VARCHAR(20),
	TransCode VARCHAR(2),
	FieldCode VARCHAR(6),
	NewValue VARCHAR(40),
	Internal_External_Flag VARCHAR(1),
	DPS_ID varchar(4),
	Recoverer_Code VARCHAR(8),
	Loan_Code VARCHAR(4)) ON [PRIMARY]
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
	INSERT INTO #Toyota_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	DPS_ID,
	Recoverer_Code,
	Loan_Code)
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
				WHEN 'MASAD1' THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'AD1'
				WHEN 'MASAD2' THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'AD2'
				WHEN 'MASCTY' THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'CTY'
				WHEN 'MASSTC' THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'STC'
				WHEN 'MASZIP' THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'ZIP'
			END
		END AS Field_Code,
	CASE csts.string
		WHEN 'MASAD1' THEN LEFT(ah.NewStreet1,40)
		WHEN 'MASAD2' THEN LEFT(ah.NewStreet2,40)
		WHEN 'MASCTY' THEN LEFT(ah.NewCity,40)
		WHEN 'MASSTC' THEN ah.NewState
		WHEN 'MASZIP' THEN [dbo].[StripNonDigits](ah.NewZipCode)
	END as address,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	c.customtext2 AS Loan_Code
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
	INSERT INTO #Toyota_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	DPS_ID,
	Recoverer_Code,
	Loan_Code)
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
				WHEN 1 THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'HPH'
				WHEN 2 THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'OPH'
			END                    
	END AS Field_Code,
	[dbo].[StripNonDigits](ph.NewNumber),
	'X',
	c.customtext1 AS DPS_ID,       
	c.customtext1 AS Recoverer_ID,
	c.customtext2 AS Loan_Code
	FROM PhoneHistory ph WITH (NOLOCK)
	INNER JOIN Debtors d WITH (NOLOCK) ON d.DebtorID = ph.DebtorID and d.seq = 0
	INNER JOIN Master  m WITH (NOLOCK)
	ON d.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	where ph.DateChanged BETWEEN @BeginDate and @EndDate AND
	m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND ph.Phonetype IN(1,2)
	
	-- Return Accounts From Dana Greene Find accoutns in a Closed Status that the Qlevel is not @ 999.
	INSERT INTO #ToyotaReturns(number)
	SELECT m.number
	FROM master m WITH(NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON m.customer=c.customer
	INNER JOIN status s WITH(NOLOCK)
	ON s.code = m.status
	WHERE m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND
	m.status IN('AEX','ATY','B07','B11','B13','BKY','FRD','PIF','SIF','RCL', 'DSP', 'RFP', 'STL') AND
	m.Qlevel NOT IN('999')
	
	-- We need to update master to be returned and create a note
/*	UPDATE master
	SET Qlevel = '999',returned = @runDate,
	closed = CASE WHEN closed IS NULL THEN @runDate ELSE closed END
	WHERE number IN(SELECT number from #ToyotaReturns)
*/
	-- Insert a Note Showing the return of the account.
	INSERT INTO Notes(number,created,user0,action,result,comment)
	SELECT t.number,@runDate,'EXG','+++++','+++++','Account was in a Toyota Maintenance Export file.'--'Account was returned to Toyota during the Maintenance Export process.'
	FROM #ToyotaReturns t 


	INSERT INTO #Toyota_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	DPS_ID,
	Recoverer_Code,
	Loan_Code)
	SELECT 1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	'MASSTS',
	CASE m.Status
		WHEN 'AEX' THEN 'A3W'
	    	WHEN 'ATY' THEN 'ARL'
		WHEN 'B07' THEN 'AR7'
		WHEN 'B11' THEN 'AR1'
		WHEN 'B13' THEN 'AR3'
		WHEN 'BKY' THEN 'AR7'
		WHEN 'FRD' THEN 'A3F'
		WHEN 'RCL' THEN 'A3R'	--RECALLED BY CLIENT
		WHEN 'DSP' THEN 'ARD'
		WHEN 'RFP' THEN 'A3U'
		WHEN 'STL' THEN 'A3S'
	END AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	c.customtext2 AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	WHERE m.number IN(SELECT number FROM #ToyotaReturns)


	-- This is PIF and SIF processing only as thery require 
        -- a different set of business rules for maintenance processing.
	INSERT INTO #Toyota_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	DPS_ID,
	Recoverer_Code,
	Loan_Code)
	SELECT 1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	'MASSTS',
	CASE m.Status
		WHEN 'PIF' THEN 'ARY'		
		WHEN 'SIF' THEN 'ARX'
	END AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	c.customtext2 AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer 
	WHERE (m.number IN(SELECT number FROM #ToyotaReturns)) and
          (m.Status in ('PIF', 'SIF')) and 
              (datediff(d, m.LastPaid, (GetDate())) >= 30)
	
	-- SOFT RECALLS HOLD
	INSERT INTO #Toyota_TempUploadMaintenance
	(OrderByFlag,
	TransDate,
	TransTime,
	Account,
	TransCode,
	FieldCode,
	NewValue,
	Internal_External_Flag,
	DPS_ID,
	Recoverer_Code,
	Loan_Code)
	SELECT 
	1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',        	 
	'MASSTS',
	'A3H',
	'X',
	c.customtext1 AS DPS_ID,       
	c.customtext1 AS Recoverer_ID,
	c.customtext2 AS Loan_Code
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
	
	/*
	--acknowledge new placements
	INSERT INTO #Toyota_TempUploadMaintenance
			(OrderByFlag,
			TransDate,
			TransTime,
			Account,
			TransCode,
			FieldCode,
			NewValue,
			Internal_External_Flag,
			DPS_ID,
			Recoverer_Code,
			Loan_Code)
			SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			'AP',        	 
			'MASSTS',
			'Account Placement Received',
			'X',
			c.customtext1 AS DPS_ID,       
			c.customtext1 AS Recoverer_ID,
			c.customtext2 AS Loan_Code
	FROM Master m WITH(NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where m.Received between @BeginDate and @EndDate and 
	      m.Customer = @customer
	*/
	-- Return all records...
	SELECT * FROM #Toyota_TempUploadMaintenance
	WHERE NewValue IS NOT NULL AND RTRIM(LTRIM(NewValue)) != ''
	ORDER BY Account, OrderByFlag , FieldCode

END
GO

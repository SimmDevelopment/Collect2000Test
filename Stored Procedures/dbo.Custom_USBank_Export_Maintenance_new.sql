SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--ALTER  the procedure.

--exec Custom_USBank_Export_Maintenance '20110630', '20110701', '0001132'
--updated for new US Bank export maintenance
--Per US bank, turned off setting an account as returned on our side.  
--We will wait for them to recall the account and only report that it was closed on our end.
--Changes:
-- 07/18/2019 BGM Changed Fruad code from FDR to VFD

CREATE      PROCEDURE [dbo].[Custom_USBank_Export_Maintenance_new]
@BeginDate datetime,
@EndDate datetime,
@customer varchar(5000)
AS
BEGIN
	CREATE TABLE #USBANKReturns(number int)
	
	-- Create an in-memory temp table.
	CREATE TABLE #USBANK_TempUploadMaintenance
	(OrderByFlag int,
	TransDate VARCHAR(100),
	TransTime VARCHAR(100),
	Account VARCHAR(100),
	TransCode VARCHAR(100),
	FieldCode VARCHAR(100),
	NewValue VARCHAR(100),
	Internal_External_Flag VARCHAR(1),
	DPS_ID varchar(100),
	Recoverer_Code VARCHAR(100),
	Loan_Code VARCHAR(100)) ON [PRIMARY]
	DECLARE @runDate datetime
	DECLARE @batchDate varchar(100)
	DECLARE @FieldCode varchar(100)
	DECLARE @batchTime VARCHAR(100) 

	SET @runDate = GETDATE()
	
	SET @beginDate = CAST(dbo.F_START_OF_DAY(@beginDate) AS DATETIME)
	
	SET @EndDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))
	-- Remove the "/" from the date portion of the datetime value, 
	SET @batchDate = REPLACE(CONVERT(char, GetDate(), 111), '/', '')
	-- Remove the ":" from the time portion of the datetime value, 
	-- and return the first 4 chars HHMM.
	SET @batchTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''), 4)
	-- Set the address change
	DECLARE @addressChanges varchar(50)
	SET @addresschanges = 'MASAD1|MASAD2|MASCTY|MASSTC|MASZIP'
	-- Address Change
	INSERT INTO #USBANK_TempUploadMaintenance
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
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM dbo.CustomStringToSet(@addresschanges,'|') csts,
	AddressHistory ah WITH (NOLOCK) 
	INNER JOIN DEBTORS D WITH (NOLOCK)
	ON ah.debtorid = d.debtorid AND d.seq = 0
	INNER JOIN Master m WITH (NOLOCK)
	ON d.Number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	WHERE ah.DateChanged BETWEEN @BeginDate and @EndDate AND
	m.customer in (select string from dbo.CustomStringToSet(@customer,'|'))
	
	-- Phone Change
	INSERT INTO #USBANK_TempUploadMaintenance
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
			CASE ph.PhoneTypeID
				WHEN 1 THEN 'MASHPH'
				WHEN 2 THEN 'MASOPH'
				
			END 
		ELSE
			CASE ph.PhoneTypeID
				WHEN 1 THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'HPH'
				WHEN 2 THEN 'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'OPH'
			END                    
	END AS Field_Code,
	[dbo].[StripNonDigits](ph.PhoneNumber),
	'X',
	c.customtext1 AS DPS_ID,       
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM Phones_Master  ph WITH (NOLOCK)
	INNER JOIN Debtors d WITH (NOLOCK) ON d.DebtorID = ph.DebtorID and d.seq = 0
	INNER JOIN Master  m WITH (NOLOCK)
	ON d.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	where ph.DateAdded BETWEEN @BeginDate and @EndDate AND ph.PhoneStatusID = 2 AND
	m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND ph.PhoneTypeID IN(1,2)
	
	-- Return Accounts From Dana Greene Find accoutns in a Closed Status that the Qlevel is not @ 999.
	INSERT INTO #USBANKReturns(number)
	SELECT m.number
	FROM master m WITH(NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON m.customer=c.customer
	INNER JOIN status s WITH(NOLOCK)
	ON s.code = m.status
	WHERE m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND
	m.status IN('AEX','ATY','B07','B11','B13','BKY','FRD','PIF','SIF', 'RFP', 'DEC', 'CCS', 'CCR', 'CND', 'CAD', 'DIP', 'RSK', 'MIL', 'OOS') AND 
	m.closed between @BeginDate and @EndDate AND (qlevel NOT IN ('999') OR returned = dbo.date(GETDATE()))
	
	-- We need to update master to be returned and create a note
		--Not required they will recall a closed account.
	--UPDATE master
	--SET Qlevel = '999',returned = @runDate,
	--closed = CASE WHEN closed IS NULL THEN @runDate ELSE closed END
	--WHERE number IN(SELECT number from #USBANKReturns) AND status IN ('AEX', 'ATY', 'B07', 'B11', 'B13', 'BKY', 'DEC', 'FRD', 'CND', 'CAD', 'FRD', 'DIP', 'RSK', 'MIL')

	---- Insert a Note Showing the return of the account.
	--INSERT INTO Notes(number,created,user0,action,result,comment)
	--SELECT t.number,@runDate,'EXG','+++++','+++++','Account was in a US Bank Maintenance Export file.'--'Account was returned to Toyota during the Maintenance Export process.'
	--FROM #USBANKReturns t WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON t.number = m.number
	--WHERE m.status IN ('AEX', 'ATY', 'B07', 'B11', 'B13', 'BKY', 'DEC', 'FRD', 'CND', 'CAD', 'FRD', 'DIP', 'RSK', 'MIL')


	INSERT INTO #USBANK_TempUploadMaintenance
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
	CASE 
		WHEN m.customer <> '0001749' AND m.STATUS = 'AEX' THEN 'CEE'
		WHEN m.STATUS = 'ATY' THEN 'CEE'
		WHEN m.STATUS = 'B07' THEN 'PBK'
		WHEN m.STATUS = 'B11' THEN 'PBK'
		WHEN m.STATUS = 'B13' THEN 'PBK'
		WHEN m.STATUS = 'BKY' THEN 'PBK'
		WHEN m.STATUS = 'FRD' THEN 'VFD'	
		WHEN m.STATUS = 'RFP' THEN 'CEE'
		WHEN m.STATUS = 'DEC' THEN 'RDC'
		WHEN m.STATUS = 'CCR' THEN 'CEE'
		WHEN m.STATUS = 'CCS' THEN 'CCS'
		WHEN m.STATUS = 'CND' THEN 'CCD'
		WHEN m.STATUS = 'CAD' THEN 'CCD'
		WHEN m.STATUS = 'DIP' THEN 'JAL'
		WHEN m.STATUS = 'RSK' THEN 'LIT'
		WHEN m.STATUS = 'MIL' THEN 'MIL'
		WHEN m.STATUS = 'OOS' THEN 'OOS'
		WHEN m.customer = '0001749' AND m.STATUS = 'AEX' THEN 'DEE'
	END AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	WHERE m.number IN(SELECT number FROM #USBANKreturns)


--send up bankruptcy case and chapter

INSERT INTO #USBANK_TempUploadMaintenance
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
	CASE d.seq
		WHEN 0 THEN        	 
			'MASBNR'
		ELSE
			'C' + [dbo].[Custom_ConvertNumberToIBMSigned](CAST(d.SEQ as varchar(2)),2,0) + 'BNR'
				
			                   
	END AS Field_Code,
	
	b.CaseNumber AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number 
	INNER JOIN bankruptcy b WITH (NOLOCK) ON d.debtorid = b.debtorid
	WHERE m.number IN(SELECT number FROM #USBANKreturns) AND m.status IN ('BKY', 'B07', 'B11', 'B13')

--Insert code for claim Filed
INSERT INTO #USBANK_TempUploadMaintenance
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
	'PC',
	'01    ',
	'PROOF OF CLAIMS - DECEASED' AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer 
	WHERE (m.Status in ('CLM') OR (SELECT TOP 1 oldstatus FROM StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND OldStatus = 'CLM' AND DateChanged BETWEEN @BeginDate and @EndDate) = 'CLM') 
	AND m.userdate2 BETWEEN @BeginDate and @EndDate and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) 



	-- This is PIF and SIF processing only as thery require 
        -- a different set of business rules for maintenance processing.
	INSERT INTO #USBANK_TempUploadMaintenance
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
		WHEN 'PIF' THEN 'PIF'		
		WHEN 'SIF' THEN 'SIF'
	END AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer 
	WHERE (m.number IN(SELECT number FROM #USBANKReturns)) and
          (m.Status in ('PIF', 'SIF'))
          
          INSERT INTO #USBANK_TempUploadMaintenance
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

--			SELECT 
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			case 				
--				when [action] = 'BNKO' then 'QB'
--				when [action] = 'DECD' then 'QD'
--				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
--				end,        	 
--			'01    ',
--			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and convert(varchar(100), n.comment) <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('BNKO', 'DECD', 'RTN')

--UNION
          
          
--          SELECT 
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			case 				
--				when [action] = 'BNKO' then 'QB'
--				when [action] = 'DECD' then 'QD'
--				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
--				end,        	 
--			'02    ',
--			isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('BNKO', 'DECD', 'RTN')

--UNION

--SELECT 
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			case 				
--				when [action] = 'BNKO' then 'QB'
--				when [action] = 'DECD' then 'QD'
--				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
--				end,        	 
--			'03    ',
--			isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('BNKO', 'DECD', 'RTN')

--UNION
 --         	INSERT INTO #USBANK_TempUploadMaintenance
	--		(OrderByFlag,
	--TransDate,
	--TransTime,
	--Account,
	--TransCode,
	--FieldCode,
	--NewValue,
	--Internal_External_Flag,
	--DPS_ID,
	--Recoverer_Code,
	--Loan_Code)

			SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'				
				 end,        	 
			'01    ',
			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and convert(varchar(100), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 2
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
								
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'				
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'				
				 end,        	 
			'02    ',
			isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
		'X',
		c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 3
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'03    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 4
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'04    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 5
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'	
				 end,        	 
			'05    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 6
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'06    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 7
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'07    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 8
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'08    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')
UNION

--Get first 40 characters Line 9
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'09    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 10
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'10    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION


--Get first 40 characters Line 11
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'				
				 end,        	 
			'11    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 400, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 400, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 12
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
								
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'				
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'				
				 end,        	 
			'12    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 440, 40), ''),
		'X',
		c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 440, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 13
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'13    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 480, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 480, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 14
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'14    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 520, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 520, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 15
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'	
				 end,        	 
			'15    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 560, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 560, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 16
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'16    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 600, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 600, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 17
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'17    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 640, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 640, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 18
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'18    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 680, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 680, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')
UNION

--Get first 40 characters Line 19
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'19    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 720, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 720, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 20
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'20    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 760, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 760, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 21
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'				
				 end,        	 
			'21    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 800, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 800, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 22
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
								
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'				
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'				
				 end,        	 
			'22    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 840, 40), ''),
		'X',
		c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 840, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 23
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'23    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 880, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 880, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 24
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'24    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 920, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 920, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 25
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'	
				 end,        	 
			'25    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 960, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 960, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 26
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'26    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1000, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 100, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 27
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'27    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1040, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1040, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 28
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'28    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1080, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1080, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')
UNION

--Get first 40 characters Line 29
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'29    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1120, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 30
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'30    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1160, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 31
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'				
				 end,        	 
			'31    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1200, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 32
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
								
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'				
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'				
				 end,        	 
			'32    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1240, 40), ''),
		'X',
		c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 33
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'33    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1280, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 34
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'34    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1320, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 35
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'	
				 end,        	 
			'35    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1360, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 36
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'		
				 end,        	 
			'26    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1400, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 140, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 37
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'37    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1440, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1440, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 38
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'38    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1480, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1480, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')
UNION

--Get first 40 characters Line 39
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'39    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1520, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1520, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

--Get first 40 characters Line 40
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				when [action] = 'TE' and result = 'TT' then 'RW'
				when [action] = 'TE' and result = 'PP' then 'WP'
				
				when [action] = 'TR' and result = 'LB' then 'HB'
				when [action] = 'TR' and result = 'TT' then 'RP'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
				WHEN [action] = 'TR' AND result = 'HU' THEN 'HU'
				WHEN [action] = 'TR' AND result = 'PP' THEN 'PP'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
				
				when [action] = 'DT' and result = '3P' then 'I3'
				when [action] = 'DT' and result = 'TT' then 'IR'
				WHEN [action] = 'DT' AND result = 'HU' THEN 'IB'
				WHEN [action] = 'DT' AND result = 'PP' THEN 'IP'
				WHEN [action] = 'DT' AND result NOT IN ('3P', 'TT', 'HU', 'PP') THEN 'IB'
				
				when [action] = 'TO' and result = 'LB' then 'O3'
				when [action] = 'TO' and result = 'TT' then 'O7'
				when [action] = 'TO' and result = 'LM' then 'O5'
				when [action] = 'TO' and result = 'NA' then 'O2'
				WHEN [action] = 'TO' AND result = 'HU' THEN 'O4'
				WHEN [action] = 'TO' AND result = 'PP' THEN 'O8'
								
				WHEN [action] NOT IN ('TR', 'TE', 'DIAL') AND result = 'PP' THEN 'PS'
				
				else '90'
				 end,        	 
			'40    ',
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1560, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1560, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TC', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co') AND user0 NOT IN ('EXG')

UNION

-------------


--These are the TU/BKY/DEC scrub comments
--Get first 40 characters Line 1
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,      	 
			'01    ',
			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and convert(varchar(40), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')

UNION

--Get first 40 characters Line 2
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,       	 
			'02    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 40

UNION

--Get first 40 characters Line 3
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,        	 
			'03    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 80

UNION

--Get first 40 characters Line 4
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,        	 
			'04    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 120

UNION

--Get first 40 characters Line 5
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,        	 
			'05    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 160

UNION

--Get first 40 characters Line 6
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,        	 
			'06    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 200

UNION

--Get first 40 characters Line 7
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,        	 
			'07    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 240

UNION

--Get first 40 characters Line 8
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,        	 
			'08    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 280

UNION

--Get first 40 characters Line 9
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,        	 
			'09    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 320

UNION

--Get first 40 characters Line 10
SELECT distinct
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] = 'BNKO' then 'QB'
				when [action] = 'DECD' then 'QD'
				when [action] = 'RTN' AND user0 = 'SCRA' then 'QS'
				ELSE '90' end,        	 
			'10    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.loantypecode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('LINK','TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 360

    INSERT INTO notes
            ( number ,
              ctl ,
              created ,
              user0 ,
              action ,
              result ,
              comment
            )
    SELECT m.number, 'CTL', GETDATE(), 'EXG', '+++++', 'PCS', 'PC Code Sent in Maintenance File'
    FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer 
	WHERE (m.Status in ('CLM') OR (SELECT TOP 1 oldstatus FROM StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND OldStatus = 'CLM' AND DateChanged BETWEEN @BeginDate and @EndDate) = 'CLM') 
	AND m.userdate2 BETWEEN @BeginDate and @EndDate and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|'))
          

	-- Return all records...
	SELECT * FROM #USBANK_TempUploadMaintenance
	WHERE NewValue IS NOT NULL AND RTRIM(LTRIM(NewValue)) != ''
	ORDER BY Account, OrderByFlag , FieldCode

END
GO

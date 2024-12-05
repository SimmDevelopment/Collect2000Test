SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--ALTER  the procedure.

--exec Custom_Citizens_Export_Maintenance '20190328', '20190329', '0001132'

CREATE      PROCEDURE [dbo].[Custom_Citizens_Export_Maintenance]
	@BeginDate datetime,
	@EndDate datetime,
	@customer varchar(5000)
AS
BEGIN
--Declare Cursor Variables
	DECLARE @recoverID VARCHAR(50)
    DECLARE cur CURSOR
    FOR
--load the cursor with the alpha codes from the customer table
	SELECT DISTINCT CustomText1
		FROM      customer WITH ( NOLOCK )
		WHERE     customer IN ( SELECT    string FROM dbo.CustomStringToSet(@customer, '|') )

    OPEN cur

--get the information from the cursor and into the variables
    FETCH FROM cur INTO @recoverID
    WHILE @@fetch_status = 0 
        BEGIN            
			IF EXISTS ( SELECT  *
						FROM    tempdb.sys.tables
						WHERE   name LIKE '#CitizensReturns%' ) 
					DROP TABLE #CitizensReturns
			IF EXISTS ( SELECT  *
						FROM    tempdb.sys.tables
						WHERE   name LIKE '#Citizens_TempUploadMaintenance%' ) 
					DROP TABLE #Citizens_TempUploadMaintenance

-- Create an in-memory temp table.
	CREATE TABLE #CitizensReturns(number int)
	
-- Create an in-memory temp table.
	CREATE TABLE #Citizens_TempUploadMaintenance
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

	SET @runDate = getdate()
	
	SET @BeginDate = dbo.F_START_OF_DAY(@BeginDate)
	SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))
	-- Remove the "/" from the date portion of the datetime value, 
	SET @batchDate = REPLACE(CONVERT(char, GetDate(), 111), '/', '')
	-- Remove the ":" from the time portion of the datetime value, 
	-- and return the first 4 chars HHMM.
	SET @batchTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''), 4)
	-- Set the address change
	DECLARE @addressChanges varchar(50)
	SET @addresschanges = 'MASAD1|MASAD2|MASCTY|MASSTC|MASZIP'
	-- Address Change
	
	INSERT INTO #Citizens_TempUploadMaintenance
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
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
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
	AND c.CustomText1 = @recoverID
	
	-- Phone Change
	INSERT INTO #Citizens_TempUploadMaintenance
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
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM Phones_Master  ph WITH (NOLOCK)
	INNER JOIN Debtors d WITH (NOLOCK) ON d.DebtorID = ph.DebtorID and d.seq = 0
	INNER JOIN Master  m WITH (NOLOCK)
	ON d.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	where ph.DateAdded BETWEEN @BeginDate and @EndDate AND ph.PhoneStatusID = 2 AND
	m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND ph.PhoneTypeID IN(1,2)
	AND c.CustomText1 = @recoverID
	
	-- Return Accounts in a Closed Status that the Qlevel is not @ 999.
	INSERT INTO #CitizensReturns(number)
	SELECT m.number
	FROM master m WITH(NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON m.customer=c.customer
	INNER JOIN status s WITH(NOLOCK)
	ON s.code = m.status
	WHERE m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND
	m.status IN('AEX','ATY','B07','B11','B13','BKY','FRD','PIF','SIF','RCL', 'RFP', 'STL', 'DEC', 'CCR', 'CND', 'CAD', 'DIP') AND 
	(qlevel NOT IN ('999') OR returned = dbo.date(GETDATE()))
	AND c.CustomText1 = @recoverID
	
	-- We need to update master to be returned and create a note
/*	UPDATE master
	SET Qlevel = '999',returned = @runDate,
	closed = CASE WHEN closed IS NULL THEN @runDate ELSE closed END
	WHERE number IN(SELECT number from #CitizensReturns)

	-- Insert a Note Showing the return of the account.
	INSERT INTO Notes(number,created,user0,action,result,comment)
	SELECT t.number,@runDate,'EXG','+++++','+++++','Account was in a US Bank Maintenance Export file.'--'Account was returned to Toyota during the Maintenance Export process.'
	FROM #CitizensReturns t 
*/

	INSERT INTO #Citizens_TempUploadMaintenance
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
	CASE WHEN m.customer IN ('0001076', '0001077', '0001078', '0001079') 
		THEN CASE 
			WHEN m.STATUS = 'AEX' THEN '612'
			--WHEN m.STATUS = 'ATY' THEN 'CEE'
			WHEN m.STATUS = 'B07' THEN '614'
			WHEN m.STATUS = 'B11' THEN '614'
			WHEN m.STATUS = 'B13' THEN '614'
			WHEN m.STATUS = 'BKY' THEN '614'
			--WHEN m.STATUS = 'FRD' THEN 'FDR'
			--WHEN m.STATUS = 'RCL' THEN 'A3R'	--RECALLED BY CLIENT
			--WHEN m.STATUS = 'RFP' THEN 'CEE'
			WHEN m.STATUS = 'DEC' THEN '615'
			--WHEN m.STATUS = 'CCR' THEN 'CEE'
			--WHEN m.STATUS = 'CCS' THEN 'CCS'
			WHEN m.STATUS = 'CND' THEN '61C'
			WHEN m.STATUS = 'CAD' THEN '61C'
			--WHEN m.STATUS = 'DIP' THEN 'JAL'
			--WHEN m.STATUS = 'RSK' THEN 'LIT'
			WHEN m.STATUS = 'MIL' THEN '61S'
			WHEN m.STATUS = 'OOS' THEN '61L'
			END 
		ELSE 
			CASE
			WHEN m.STATUS = 'AEX' THEN '424'
			--WHEN m.STATUS = 'ATY' THEN 'CEE'
			WHEN m.STATUS = 'B07' THEN '426'
			WHEN m.STATUS = 'B11' THEN '426'
			WHEN m.STATUS = 'B13' THEN '426'
			WHEN m.STATUS = 'BKY' THEN '426'
			--WHEN m.STATUS = 'FRD' THEN 'FDR'
			--WHEN m.STATUS = 'RCL' THEN 'A3R'	--RECALLED BY CLIENT
			--WHEN m.STATUS = 'RFP' THEN 'CEE'
			WHEN m.STATUS = 'DEC' THEN '427'
			--WHEN m.STATUS = 'CCR' THEN 'CEE'
			--WHEN m.STATUS = 'CCS' THEN 'CCS'
			WHEN m.STATUS = 'CND' THEN '429'
			WHEN m.STATUS = 'CAD' THEN '429'
			--WHEN m.STATUS = 'DIP' THEN 'JAL'
			--WHEN m.STATUS = 'RSK' THEN 'LIT'
			WHEN m.STATUS = 'MIL' THEN '425'
			WHEN m.STATUS = 'OOS' THEN '44L'
			END 		
		END	AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	WHERE m.number IN(SELECT number FROM #CitizensReturns)



--send up bankruptcy case number
INSERT INTO #Citizens_TempUploadMaintenance
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
	'LNNLCN' AS Field_Code,
	b.CaseNumber AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN bankruptcy b WITH (NOLOCK) ON d.debtorid = b.debtorid
	WHERE m.number IN(SELECT number FROM #CitizensReturns) AND m.status IN ('BKY', 'B07', 'B11', 'B13')
	AND (CaseNumber IS NOT NULL OR casenumber <> '')
	
--send up bankruptcy court date
INSERT INTO #Citizens_TempUploadMaintenance
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
	'LNNBFL' AS Field_Code,
	b.DateFiled AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN bankruptcy b WITH (NOLOCK) ON d.debtorid = b.debtorid
	WHERE m.number IN(SELECT number FROM #CitizensReturns) AND m.status IN ('BKY', 'B07', 'B11', 'B13')
	AND (DateFiled IS NOT NULL OR DateFiled <> '') AND (CaseNumber IS NOT NULL OR casenumber <> '')
	
--Get bky chapter number
INSERT INTO #Citizens_TempUploadMaintenance
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
	'LNNCHP' AS Field_Code,
	b.Chapter AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN bankruptcy b WITH (NOLOCK) ON d.debtorid = b.debtorid
	WHERE m.number IN(SELECT number FROM #CitizensReturns) AND m.status IN ('BKY', 'B07', 'B11', 'B13')
	AND (CaseNumber IS NOT NULL OR casenumber <> '')
	
--BKY DISCHARGE DATE
INSERT INTO #Citizens_TempUploadMaintenance
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
	'LNNDCD' AS Field_Code,
	b.DischargeDate AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN bankruptcy b WITH (NOLOCK) ON d.debtorid = b.debtorid
	WHERE m.number IN(SELECT number FROM #CitizensReturns) AND m.status IN ('BKY', 'B07', 'B11', 'B13')
	AND (DischargeDate IS NOT NULL OR DischargeDate <> '') 	AND (CaseNumber IS NOT NULL OR casenumber <> '')

--Get bky DISMISSAL DATE
INSERT INTO #Citizens_TempUploadMaintenance
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
	'LNNBDD' AS Field_Code,
	b.DismissalDate AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN bankruptcy b WITH (NOLOCK) ON d.debtorid = b.debtorid
	WHERE m.number IN(SELECT number FROM #CitizensReturns) AND m.status IN ('BKY', 'B07', 'B11', 'B13')
	AND (CaseNumber IS NOT NULL OR casenumber <> '') AND (DismissalDate IS NOT NULL OR DismissalDate <> '')

	-- This is PIF and SIF processing only as thery require 
        -- a different set of business rules for maintenance processing.
	INSERT INTO #Citizens_TempUploadMaintenance
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
	CASE WHEN m.customer IN ('0001076', '0001077', '0001078', '0001079') 
		THEN
			CASE m.Status
				WHEN 'PIF' THEN '616'		
				WHEN 'SIF' THEN '613'
			END
	ELSE 
		CASE m.Status
				WHEN 'PIF' THEN '428'		
				WHEN 'SIF' THEN '425'
			END
	END AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer 
	WHERE (m.number IN(SELECT number FROM #CitizensReturns)) and
          (m.Status in ('PIF', 'SIF'))
          
          	INSERT INTO #Citizens_TempUploadMaintenance
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
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'				
				 end,        	 
			'01    ',
			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and convert(varchar(100), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'TC', 'DIAL', '+++++', 'co')
	AND c.CustomText1 = @recoverID
	
UNION ALL

--Get first 40 characters Line 2
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'					
				 end,        	 
			'02    ',
			isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
		'X',
		c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
AND c.CustomText1 = @recoverID

UNION ALL

--Get first 40 characters Line 3
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'		
				 end,        	 
			'03    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
AND c.CustomText1 = @recoverID

UNION ALL

--Get first 40 characters Line 4
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'		
				 end,        	 
			'04    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
AND c.CustomText1 = @recoverID

UNION ALL

--Get first 40 characters Line 5
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'	
				 end,        	 
			'05    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
AND c.CustomText1 = @recoverID

UNION ALL

--Get first 40 characters Line 6
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'		
				 end,        	 
			'06    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
AND c.CustomText1 = @recoverID

UNION ALL

--Get first 40 characters Line 7
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'	
				 end,        	 
			'07    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
AND c.CustomText1 = @recoverID

UNION ALL

--Get first 40 characters Line 8
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'	
				 end,        	 
			'08    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
	AND c.CustomText1 = @recoverID
	
UNION ALL

--Get first 40 characters Line 9
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'	
				 end,        	 
			'09    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
AND c.CustomText1 = @recoverID

UNION ALL

--Get first 40 characters Line 10
SELECT 
			1,
			REPLACE(CONVERT(char, n.created, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
			m.account,
			case 				
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('LV', 'LM') then '93'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) then '91'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result IN ('DC', 'LN', 'NH', 'NI', 'DK', 'TW') then '92'
				when result IN ('SK', 'S1', 'S2', 'S3', 'S4') then '98'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and result = 'PP' then '95'
				when [action] IN ('TR', 'TO', 'TE', 'TI', 'TC', 'DIAL') and 
					(result NOT IN (SELECT CODE FROM result WITH (NOLOCK) WHERE contacted = 1) OR 
						result NOT IN ('LV', 'LM', 'DC', 'LN', 'NH', 'NI', 'DK', 'TW', 'pp', 'SK', 'S1', 'S2', 'S3', 'S4')) then '94'
				when [action] = 'DT' then '97'
				else '90'	
				 end,        	 
			'10    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', '+++++', 'co')
AND c.CustomText1 = @recoverID

UNION ALL
--Sent letters
SELECT 
			1,
			REPLACE(CONVERT(char, lr.DateProcessed, 111), '/', ''),
			LEFT(REPLACE(CONVERT(CHAR, lr.DateProcessed, 108), ':', ''), 4),
			m.account,
			'96',        	 
			'01    ',
			'Sent Letter',
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
	FROM LetterRequest lr inner join Master m WITH(NOLOCK) on lr.AccountID = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where lr.DateProcessed between @BeginDate and @EndDate AND
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|'))
	      AND c.CustomText1 = @recoverID

--UNION

----These are the TU/BKY/DEC scrub comments
----Get first 40 characters Line 1
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'01    ',
--			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and convert(varchar(40), n.comment) <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')

--UNION

----Get first 40 characters Line 2
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'02    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 40

--UNION

----Get first 40 characters Line 3
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'03    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 80

--UNION

----Get first 40 characters Line 4
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'04    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 120

--UNION

----Get first 40 characters Line 5
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'05    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 160

--UNION

----Get first 40 characters Line 6
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'06    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 200

--UNION

----Get first 40 characters Line 7
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'07    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 240

--UNION

----Get first 40 characters Line 8
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'08    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 280

--UNION

----Get first 40 characters Line 9
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'09    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 320

--UNION

----Get first 40 characters Line 10
--SELECT distinct
--			1,
--			REPLACE(CONVERT(char, n.created, 111), '/', ''),
--			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4),
--			m.account,
--			'90',        	 
--			'10    ',
--			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), ''),
--			'X',
--	c.customtext1 AS DPS_ID,
--	c.customtext1 AS Recoverer_ID,
--	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'A.0.MIOCode') AS Loan_Code
--	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
--	INNER JOIN customer c WITH(NOLOCK)
--	on c.customer = m.customer
--	where dbo.date(n.created) between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
--	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial') and user0 not in ('exg', 'exchng', 'exchange')
--			and len(convert(varchar(1000), n.comment)) > 360

          
          

		-- Return all records...
		SELECT *, CASE WHEN recoverer_code = '3803' THEN '3274'
				ELSE '3264' END AS Bank_ID FROM #Citizens_TempUploadMaintenance
		WHERE NewValue IS NOT NULL AND RTRIM(LTRIM(NewValue)) != ''
		ORDER BY Account, OrderByFlag , FieldCode

		FETCH FROM cur INTO @recoverID
	
    END
        DROP TABLE #CitizensReturns
        DROP TABLE #Citizens_TempUploadMaintenance
        
--close and free up all the resources.
        CLOSE cur
        DEALLOCATE cur

END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--ALTER  the procedure.

--exec Custom_Suntrust_BBT_Export_Maintenance '20201101', '20201130', '0001117'

CREATE      PROCEDURE [dbo].[Custom_Suntrust_BBT_Export_Maintenance]
@BeginDate datetime,
@EndDate datetime,
@customer varchar(5000)
AS
BEGIN

SET @begindate = dbo.F_START_OF_DAY(@begindate)
SET @endDate = DATEADD(ss, -3, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))


CREATE TABLE #BBTReturns(number int)
	
	-- Create an in-memory temp table.
	CREATE TABLE #BBT_TempUploadMaintenance
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
	MIO_Code VARCHAR(100)) ON [PRIMARY]
	DECLARE @runDate datetime
	DECLARE @batchDate varchar(100)
	DECLARE @FieldCode varchar(100)
	DECLARE @batchTime VARCHAR(100) 

	SET @runDate = getdate()
	
	--SET @EndDate = CAST(CONVERT(varchar(10),@EndDate,20) + ' 23:59:59.000' as datetime)
	-- Remove the "/" from the date portion of the datetime value, 
	SET @batchDate = REPLACE(CONVERT(char, GetDate(), 111), '/', '')
	-- Remove the ":" from the time portion of the datetime value, 
	-- and return the first 4 chars HHMM.
	SET @batchTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''), 4)
	-- Set the address change
	DECLARE @addressChanges varchar(50)
	SET @addresschanges = 'MASAD1|MASAD2|MASCTY|MASSTC|MASZIP'
	-- Address Change
	INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)
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
	'BBT1' AS MIO_Code
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
	INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)
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
	'BBT1' AS MIO_Code
	FROM PhoneHistory ph WITH (NOLOCK)
	INNER JOIN Debtors d WITH (NOLOCK) ON d.DebtorID = ph.DebtorID and d.seq = 0
	INNER JOIN Master  m WITH (NOLOCK) ON d.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	where m.customer IN (select string from dbo.CustomStringToSet(@customer,'|'))
		AND ph.DateChanged BETWEEN @BeginDate and @EndDate AND ph.Phonetype IN(1,2) AND ph.NewNumber <> ''
	
UNION ALL

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
	'BBT1' AS MIO_Code
	FROM dbo.Phones_Master ph WITH (NOLOCK)
	INNER JOIN Debtors d WITH (NOLOCK) ON d.DebtorID = ph.DebtorID and d.seq = 0
	INNER JOIN Master  m WITH (NOLOCK) ON d.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	where m.customer IN (select string from dbo.CustomStringToSet(@customer,'|'))
		AND ph.DateAdded BETWEEN @BeginDate and @EndDate AND ph.PhoneTypeID IN(1,2) AND PhoneStatusID = 2 AND LoginName NOT IN ('', 'sync')
	
	--Find accounts in a Closed Status that the Qlevel is not @ 999 or account was returned today
	INSERT INTO #BBTReturns(number)
	SELECT m.number
	FROM master m WITH(NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON m.customer=c.customer
	INNER JOIN status s WITH(NOLOCK)
	ON s.code = m.status
	WHERE m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND
	m.status IN('AEX','ATY','B07','B11','B13','BKY','FRD','PIF','SIF','RCL', 'RSK', 'DEC', 'CCR') AND 
	(qlevel NOT IN ('999') OR returned = dbo.date(GETDATE()))
	
--	-- We need to update master to be returned and create a note
--/*	UPDATE master
--	SET Qlevel = '999',returned = @runDate,
--	closed = CASE WHEN closed IS NULL THEN @runDate ELSE closed END
--	WHERE number IN(SELECT number from #BBTReturns)

--	-- Insert a Note Showing the return of the account.
--	INSERT INTO Notes(number,created,user0,action,result,comment)
--	SELECT t.number,@runDate,'EXG','+++++','+++++','Account was in a US Bank Maintenance Export file.'--'Account was returned to Toyota during the Maintenance Export process.'
--	FROM #BBTReturns t 
--*/

	INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)
	SELECT 1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	'MASSTS',
	CASE m.Status
		WHEN 'AEX' THEN '470'
	    WHEN 'ATY' THEN '470'
		WHEN 'B07' THEN '777'
		WHEN 'B11' THEN '777'
		WHEN 'B13' THEN '777'
		WHEN 'BKY' THEN '777'
		WHEN 'FRD' THEN '060'
		WHEN 'RCL' THEN '470'	--RECALLED BY CLIENT
		WHEN 'RSK' THEN '472'
		WHEN 'DEC' THEN '040'
		WHEN 'CCR' THEN '470'
	END AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	WHERE m.number IN(SELECT number FROM #BBTReturns)


----send up bankruptcy case and chapter
/*
INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)
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
	'BBT1' AS MIO_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number 
	INNER JOIN bankruptcy b WITH (NOLOCK) ON d.debtorid = b.debtorid
	WHERE m.number IN(SELECT number FROM #BBTReturns) AND m.status IN ('BKY', 'B07', 'B11', 'B13')

*/



	-- This is PIF and SIF processing only as thery require 
        -- a different set of business rules for maintenance processing.
	INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)
	SELECT 1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	'MASSTS',
	CASE m.Status
		WHEN 'PIF' THEN '059'		
		WHEN 'SIF' THEN '058'
	END AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer 
	WHERE (m.number IN(SELECT number FROM #BBTReturns)) and
          (m.Status in ('PIF', 'SIF'))
          
    -- Insert Judgement dates      
    INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)
	SELECT 1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	'MASJDT',
	CONVERT(VARCHAR(8), JudgementDate, 112) AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK) ON c.customer = m.customer 
	INNER JOIN dbo.CourtCases cc WITH (NOLOCK) ON m.number = cc.AccountID
	WHERE m.Status in ('JDG') AND m.Customer IN (select string from dbo.CustomStringToSet(@customer,'|'))
	AND (SELECT TOP 1 NewStatus FROM dbo.StatusHistory sh WITH (NOLOCK)  WHERE AccountID = m.number ORDER BY DateChanged DESC) = 'JDG'	

	
	          	INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)

			SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			'DR',        	 
			'01    ',
			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and convert(varchar(100), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('MR') AND result IN ('DR')


	          	INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)

			SELECT DISTINCT
			1,
			@batchDate,
			@batchTime,
			m.account,
			'94',        	 
			'01    ',
			'JDG GRANTED: ' + CONVERT(VARCHAR(8), cc.JudgementRecordedDate, 112),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	INNER JOIN dbo.CourtCases cc WITH (NOLOCK) ON m.number = cc.AccountID
	where m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) 
	      AND m.Status in ('JDG') AND m.Customer IN (select string from dbo.CustomStringToSet(@customer,'|'))
AND (SELECT TOP 1 NewStatus FROM dbo.StatusHistory sh WITH (NOLOCK)  WHERE AccountID = m.number
AND DateChanged BETWEEN @begindate AND @enddate ORDER BY DateChanged DESC) = 'JDG'	
AND (JudgementRecordedDate IS NOT NULL AND JudgementRecordedDate <> '')

UNION ALL

SELECT DISTINCT
			1,
			@batchDate,
			@batchTime,
			m.account,
			'94',        	 
			'01    ',
			'JDG CASE: ' + cc.CaseNumber,
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	INNER JOIN dbo.CourtCases cc WITH (NOLOCK) ON m.number = cc.AccountID
	where m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) 
	      AND m.Status in ('JDG') AND m.Customer IN (select string from dbo.CustomStringToSet(@customer,'|'))
AND (SELECT TOP 1 NewStatus FROM dbo.StatusHistory sh WITH (NOLOCK)  WHERE AccountID = m.number 
AND DateChanged BETWEEN @begindate AND @enddate ORDER BY DateChanged DESC) = 'JDG'	
AND (cc.CaseNumber IS NOT NULL AND cc.CaseNumber <> '')

UNION ALL 

SELECT DISTINCT
			1,
			@batchDate,
			@batchTime,
			m.account,
			'94',        	 
			'01    ',
			'JDG EXPIRE DATE: ' + CONVERT(VARCHAR(8), cc.StatuteDeadline, 112),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	INNER JOIN dbo.CourtCases cc WITH (NOLOCK) ON m.number = cc.AccountID
	where m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) 
	      AND m.Status in ('JDG') AND m.Customer IN (select string from dbo.CustomStringToSet(@customer,'|'))
AND (SELECT TOP 1 NewStatus FROM dbo.StatusHistory sh WITH (NOLOCK)  WHERE AccountID = m.number 
AND DateChanged BETWEEN @begindate AND @enddate ORDER BY DateChanged DESC) = 'JDG'	
AND	(cc.StatuteDeadline IS NOT NULL AND cc.StatuteDeadline <> '')

	--Insert Media Request     
          
          	INSERT INTO #BBT_TempUploadMaintenance
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
	MIO_Code)

			SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'				
				 end,        	 
			'01    ',
			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and convert(varchar(100), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN')

UNION

--Get first 40 characters Line 2
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'				
				 end,        	 
			'02    ',
			isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
		'X',
		c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 40

UNION

--Get first 40 characters Line 3
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'		
				 end,        	 
			'03    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 80

UNION

--Get first 40 characters Line 4
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'		
				 end,        	 
			'04    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 120

UNION

--Get first 40 characters Line 5
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'	
				 end,        	 
			'05    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 160

UNION

--Get first 40 characters Line 6
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'		
				 end,        	 
			'06    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 200

UNION

--Get first 40 characters Line 7
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'
				 end,        	 
			'07    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 240

UNION

--Get first 40 characters Line 8
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'
				 end,        	 
			'08    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 280
UNION

--Get first 40 characters Line 9
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'
				 end,        	 
			'09    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 320

UNION

--Get first 40 characters Line 10
SELECT 
			1,
			@batchDate,
			@batchTime,
			m.account,
			case 				
				when [action] = 'TE' and result = 'LM' then 'WL'
				when [action] = 'TE' and result = 'NA' then 'WN'
				when [action] = 'TE' and result = 'LB' then 'WN'
				
				when [action] = 'TR' and result = 'LB' then 'HN'
				when [action] = 'TR' and result = 'TT' then 'HT'
				when [action] = 'TR' and result = 'LM' then 'HM'
				when [action] = 'TR' and result = 'NA' then 'HN'
								
				when [action] = 'DIAL' and result = 'LM' then 'HM'
				when [action] = 'DIAL' and result = 'NA' then 'HN'
								
				WHEN result = 'PP' THEN 'PP'
				
				else '90'
				 end,        	 
			'10    ',
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), ''),
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] in ('TR', 'TO', 'TE', 'DT', 'TI', 'DIAL', 'ITT', 'TC', 'TN') and len(convert(varchar(1000), n.comment)) > 360

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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and convert(varchar(40), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')

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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
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
			'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	'BBT1' AS MIO_Code
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where n.created between @BeginDate and @EndDate and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('TR', 'TO', 'TE', 'DT', 'TI', 'desk', 'mnual', 'phone', 'addr', '+++++', 'prom', 'dial', 'name', 'MR') and user0 not in ('exg', 'exchng', 'exchange')
			and len(convert(varchar(1000), n.comment)) > 360

          
          

	-- Return all records...
	SELECT * FROM #BBT_TempUploadMaintenance
	WHERE NewValue IS NOT NULL AND RTRIM(LTRIM(NewValue)) != ''
	ORDER BY Account, OrderByFlag , FieldCode

END
GO

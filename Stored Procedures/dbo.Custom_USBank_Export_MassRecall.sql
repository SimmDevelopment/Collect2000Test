SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--ALTER  the procedure.
create      PROCEDURE [dbo].[Custom_USBank_Export_MassRecall]
@closedate DATETIME,
@customer varchar(5000)

AS
BEGIN
	CREATE TABLE #USBANKReturns(number int)
	
	-- Create an in-memory temp table.
	CREATE TABLE #USBANK_TempUploadMaintenance
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
	SELECT 1,
	@batchDate,
	@batchTime,
	m.account,
	'MT',
	'MASSTS',
	CASE m.Status
		WHEN 'AEX' THEN 'CS2'
	    	WHEN 'ATY' THEN 'CS2'
		WHEN 'B07' THEN 'NBK'
		WHEN 'B11' THEN 'NBK'
		WHEN 'B13' THEN 'NBK'
		WHEN 'BKY' THEN 'NBK'
		WHEN 'FRD' THEN 'CS2'
		WHEN 'RCL' THEN 'A3R'	--RECALLED BY CLIENT
		WHEN 'RFP' THEN 'CS2'
		WHEN 'DEC' THEN 'DEC'
		WHEN 'CCR' THEN 'CS2'
	END AS NewValue,
	'X',
	c.customtext1 AS DPS_ID,
	c.customtext1 AS Recoverer_ID,
	(SELECT thedata FROM miscextra WITH (NOLOCK) WHERE number = m.number AND title = 'loantypecode') AS Loan_Code
	FROM Master m WITH (NOLOCK)
	INNER JOIN customer c WITH(NOLOCK)
	ON c.customer = m.customer
	WHERE m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) 
			AND m.status = 'CCR' AND m.closed = @closedate

        
          

	-- Return all records...
	SELECT * FROM #USBANK_TempUploadMaintenance
	WHERE NewValue IS NOT NULL AND RTRIM(LTRIM(NewValue)) != ''
	ORDER BY Account, OrderByFlag , FieldCode

END
GO

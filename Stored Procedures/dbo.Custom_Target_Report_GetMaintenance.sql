SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Create the procedure.
CREATE PROCEDURE [dbo].[Custom_Target_Report_GetMaintenance]
@BeginDate datetime,
@EndDate datetime
AS

-- Create an in-memory temp table.
CREATE TABLE #Toyota_TempUploadMaintenance
(
OrderByFlag int,
TransDate VARCHAR(10),
TransTime VARCHAR(4),
Account VARCHAR(20),
FieldCode VARCHAR(6),
NewValue VARCHAR(40)
) ON [PRIMARY]

DECLARE @batchDate varchar(50)
DECLARE @FieldCode varchar(50)
DECLARE @batchTime VARCHAR(20) 

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
(
OrderByFlag,
TransDate,
TransTime,
Account,
FieldCode,
NewValue
)

SELECT 2,
	@batchDate,
	@batchTime,
	m.account,     	
	case d.SEQ
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
	END as address
FROM dbo.StringToSet(@addresschanges,'|') csts,
	AddressHistory ah WITH (NOLOCK) JOIN DEBTORS D WITH (NOLOCK) 
	ON (ah.debtorid = d.debtorid) JOIN Master m WITH (NOLOCK)
	ON (d.Number = m.number)
WHERE ah.DateChanged between @BeginDate and @EndDate and
      (m.customer = '0000856')


-- Phone Change
INSERT INTO #Toyota_TempUploadMaintenance
(
OrderByFlag,
TransDate,
TransTime,
Account,
FieldCode,
NewValue
)
SELECT 2,
       @batchDate,
       @batchTime,
       m.account,
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
       [dbo].[StripNonDigits](ph.NewNumber)
FROM PhoneHistory ph WITH (NOLOCK) join 
     Debtors d WITH (NOLOCK) 
ON (d.DebtorID = ph.DebtorID)
Join Master  m WITH (NOLOCK)
ON (d.number = m.number)
where (ph.DateChanged between @BeginDate and @EndDate) and
      m.customer = '0000856' and
      (d.Seq = 0 or (d.Seq > 0 and ph.Phonetype = 2))


-- Status Change
INSERT INTO #Toyota_TempUploadMaintenance
(
OrderByFlag,
TransDate,
TransTime,
Account,
FieldCode,
NewValue
)
SELECT 1,
       @batchDate,
       @batchTime,
       m.account,
       'MASSTS',
       CASE s.NewStatus
       		WHEN 'AEX' THEN '490'
         	WHEN 'SIF' THEN '491'
       END AS NewValue
FROM StatusHistory s WITH (NOLOCK)  join Master  m WITH (NOLOCK)
ON s.accountid = m.number
where (s.DateChanged between @BeginDate and @EndDate) and
      m.customer = '0000856' and
      s.NewStatus in ('AEX', 'SIF')

--Insert 491 account into SIF Table
Insert into customtargetsif(account, createddate)
select account,  @batchDate
from #Toyota_TempUploadMaintenance
where NewValue = '491'

SELECT * FROM #Toyota_TempUploadMaintenance order by Account, OrderByFlag , FieldCode

DROP TABLE #Toyota_TempUploadMaintenance
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20070101'
set @endDate='20070131'
set @customer='0000833|'
exec Custom_Simms_JCAP @startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE     PROCEDURE [dbo].[Custom_Simms_JCAP_MN]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)
AS
BEGIN
--Some init stuff
declare @addyDate datetime

set @endDate = @endDate + 1

-- Header Record

SELECT
	getdate() AS [Date]

--Master Update Record
DECLARE @tmpjcap TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[number] [int] NOT NULL,
	[LDtype] VARCHAR(4) NOT NULL,
	[LDDate] DATETIME NULL
)

INSERT INTO @tmpjcap (number, LDtype, LDDate)
	SELECT DISTINCT m.number, 'AGC', created from notes n WITH (NOLOCK)
	JOIN master m with (nolock)
	ON m.Number = n.number
	WHERE n.created BETWEEN @startDate AND @endDate
	AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1)
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

insert into @tmpjcap (number, LDtype, LDDate)
	SELECT DISTINCT AccountID, 'LTS', DateProcessed from LetterRequest lr WITH (NOLOCK)
	JOIN master m with (nolock)
	ON m.Number = lr.AccountID
	WHERE lr.DateProcessed BETWEEN @startDate AND @endDate
	AND (ErrorDescription IS NULL OR ErrorDescription = '')
	AND jobname <> 'Global'
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

INSERT INTO @tmpjcap(number, LDtype, LDDate)
	SELECT DISTINCT AccountID, 'MT', p.DateChanged
	from PhoneHistory p
	JOIN master m with (nolock)
	ON m.Number = p.AccountId
	WHERE p.DateChanged BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	
INSERT INTO @tmpjcap(number, LDtype, LDDate)
	SELECT DISTINCT pm.number, 'MTA', pm.DateAdded
	from phones_master pm
	JOIN master m with (nolock)
	ON m.Number = pm.Number
	WHERE pm.DateAdded BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

INSERT INTO @tmpjcap(number, LDtype, LDDate)
	SELECT DISTINCT m.number, 'MB', m.closed
	FROM master m with (nolock) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number
	INNER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE m.closed between @startDate AND @endDate AND 
m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND m.returned is null AND m.status IN ('B07', 'B11', 'B13', 'BKY')

INSERT INTO @tmpjcap (number, LDtype, LDDate)
	SELECT DISTINCT AccountID, 'MG', a.DateChanged
	from AddressHistory a
	JOIN master m with (nolock) ON m.Number=a.AccountId
	INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
	WHERE a.DateChanged BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	
INSERT INTO @tmpjcap (number, LDtype, LDDate)
	SELECT DISTINCT m.number, 'RML', n.created
	from master m with (nolock) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
	INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
	WHERE n.created BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	AND n.action = '+++++' AND n.result = '+++++' AND n.comment LIKE 'Mail return Set on%'
	AND m.mr = 'Y'

--Get LD Table
SELECT DISTINCT
    	m.number,
	m.id2		AS [BFrame],
	'5555' AS [RemoteID],
	m.received  AS [PlacedDate],
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'PORTFOLIO')		 AS [Portfolio],
	'LD'		AS [RecordType],
	m.account	AS [Account],
	CASE WHEN LDtype IN ('AGC', 'LTS', 'RML', 'STA') THEN CONVERT(VARCHAR(8), LDDate, 112)  ELSE '' END AS [LedgerDate],
	CASE WHEN LDtype IN ('AGC', 'LTS', 'RML', 'STA') THEN REPLACE(CONVERT(VARCHAR(5), LDDate, 114), ':', '')  ELSE '' END AS [LedgerTime],
	LDtype		AS [ActionCode],
	CASE WHEN LDtype = 'LTS' THEN 'AGYLTR'
	  ELSE '' END AS [ActionSubCode],
	
	'' AS [Comment]
	
FROM @tmpjcap t
JOIN master m with (nolock) ON m.number = t.number
WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND LDtype IN ('LTS', 'AGC', 'RML')

--Get MT Table
SELECT DISTINCT
    m.number,
	m.id2		AS [BFrame],
	'5555' AS [RemoteID],
	m.received  AS [PlacedDate],
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'PORTFOLIO')		 AS [Portfolio],
	'MT'		AS [RecordType],
	m.account	AS [Account],
	CASE WHEN p.oldnumber IS NOT NULL AND p.newnumber = '' THEN p.oldnumber
		WHEN p.oldnumber IS NOT NULL AND p.newnumber IS NOT NULL THEN p.NewNumber END AS [TelephoneNumber],
	CASE WHEN p.oldnumber IS NOT NULL AND p.newnumber = '' THEN 'N'
		WHEN p.oldnumber IS NOT NULL AND p.newnumber IS NOT NULL THEN 'Y' ELSE '' END AS [Status],
	CASE p.phonetype when 1 THEN 'H'
			WHEN 2 THEN 'W'
			WHEN 47 THEN 'A'
			WHEN 48 THEN 'A'
				 ELSE 'O' END AS [PhoneType]
FROM @tmpjcap t
JOIN master m with (nolock) ON m.number = t.number
LEFT JOIN PhoneHistory p with (nolock) ON p.AccountID = m.number
WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND p.DateChanged BETWEEN @startDate AND @endDate
AND LDtype IN ('MT')

UNION ALL

--Get MTA Table (MT telephones added.)
SELECT DISTINCT
    m.number,
	m.id2		AS [BFrame],
	'5555' AS [RemoteID],
	m.received  AS [PlacedDate],
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'PORTFOLIO')		 AS [Portfolio],
	'MT'		AS [RecordType],
	m.account	AS [Account],
	pm.PhoneNumber AS [TelephoneNumber],
	CASE WHEN pm.PhoneStatusID = 1 THEN 'N'
		WHEN pm.PhoneStatusID = 2 THEN 'Y' ELSE '' END AS [Status],
	CASE pm.PhoneTypeID when 1 THEN 'H'
			WHEN 2 THEN 'W'
			WHEN 47 THEN 'A'
			WHEN 48 THEN 'A'
				 ELSE 'O' END AS [PhoneType]
FROM @tmpjcap t
JOIN master m with (nolock) ON m.number = t.number
LEFT JOIN Phones_Master pm with (nolock) ON pm.Number = m.number
WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND pm.DateAdded BETWEEN @startDate AND @endDate
AND LDtype IN ('MTA')

--Get MB Table
SELECT DISTINCT
		m.id2		 AS [BFrame],
		'5555' AS [RemoteID],
		m.received   AS [PlacedDate],
		(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'PORTFOLIO')		 AS [Portfolio],
		'MB'		 AS [RecordType],
		m.account	 AS [Account],
		getdate()	 AS [Date],
		b.CaseNumber AS [CaseID],
		b.Chapter	AS [Chapter],
		dbo.GetLastName(da.Name) AS [AttyLastName],
		dbo.GetMiddleName(da.Name) AS [AttyMidName],
		dbo.GetFirstName(da.name) AS [AttyFirstName],
		da.Addr1 AS [AttyAddr1],
		da.Addr2 AS [AttyAddr2],
		da.City AS [AttyCity],
		da.State AS [AttyState],
		da.Zipcode AS [AttyZip],
		b.CourtDivision AS [Court],
		b.DateFiled AS [DateFiled],
		CASE WHEN b.DismissalDate < '19250101' THEN '' ELSE b.DismissalDate end AS [DateDismiss],
		'' AS [Misc1],
		'' AS [Misc2],
		'' AS [Misc3],
		'' AS [PayStartDate],
		'' AS [PayEndDate],
		'' AS [AmtToPay],
		'' AS [POCFileDate],
		'' AS [POCConfirmDate],
		CASE WHEN d.isBusiness = 1 THEN 'B' ELSE 'S' END AS [ECOA]
FROM @tmpjcap t
JOIN master m with (nolock) ON m.number = t.number
INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number
INNER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE m.closed between @startDate AND @endDate AND 
m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND m.returned is null AND m.status IN ('B07', 'B11', 'B13', 'BKY')
AND t.LDType IN ('MB')

--Get MG Table
SELECT DISTINCT
    	m.number,
	m.id2		AS [BFrame],
	'5555'	AS [RemoteID],
	m.received  AS [PlacedDate],
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'PORTFOLIO') AS [Portfolio],
	'MG'		AS [RecordType],
	m.account	AS [Account],
	a.DateChanged AS [DateChanged],
	
	d.Lastname  AS [LName],
	d.Firstname + CASE WHEN d.middleName = '' THEN '' ELSE ', ' + SUBSTRING(d.middleName, 1, 1) end AS [FName],
	d.Street1 AS [Address1],
	d.Street2 AS [Address2],
	d.City	AS [City],
	d.State AS [State],
	d.Zipcode AS [Zipcode],
	'' AS [Country]
	
FROM @tmpjcap t
JOIN master m with (nolock) ON m.number=t.number
LEFT JOIN AddressHistory a with (nolock) ON a.AccountID=m.number
RIGHT JOIN Debtors d with (nolock) ON d.number=m.number 
WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND a.DateChanged BETWEEN @startDate AND @endDate
AND d.seq = 0 AND t.LDType IN ('MG')

END


GO

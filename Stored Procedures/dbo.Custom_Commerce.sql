SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Jeff Mixon
-- ALTER  date:	12/29/2007
-- Description:	Commerce(TSYS) Export
-- =============================================
/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20060101'
set @endDate='20060301'
set @customer='0000805|'
exec Custom_Commerce @startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE PROCEDURE [dbo].[Custom_Commerce]
	 @startDate datetime,
	 @endDate datetime,
	 @customer varchar(8000)
AS
BEGIN
	--This needs to happen for things which were changed TODAY to return
	set @endDate=@endDate+1

	DECLARE @tmpcom TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[number] [int] NOT NULL,
	[uType] [varchar] (5) NULL)

	--Address has been changed
	INSERT INTO @tmpcom (number,uType)
	SELECT DISTINCT AccountID,'AD' from AddressHistory a with (nolock)
	JOIN master m with (nolock)
	ON m.Number=a.AccountId
	WHERE a.DateChanged BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	--Phone number has been changed
	INSERT INTO @tmpcom (number,uType)
	SELECT DISTINCT AccountID,'PH' from PhoneHistory p with (nolock)
	JOIN master m with (nolock)
	ON m.Number=p.AccountId
	WHERE p.DateChanged BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	--Payment has been made
	INSERT INTO @tmpcom (number,uType)
	SELECT DISTINCT number, 'PY' from master with (nolock)
	WHERE clidlp BETWEEN @startDate AND @endDate
	AND customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	--Note Created
	INSERT INTO @tmpcom (number,uType)
	SELECT DISTINCT n.number, 'NO' from Notes n with (nolock)
	JOIN master m with (nolock)
	ON m.number=n.number
	WHERE n.created BETWEEN @startDate AND @endDate
	AND customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	--Action Performed
	INSERT INTO @tmpcom (number,uType)
	SELECT DISTINCT pdc.number, 'AX' from pdc with (nolock)
--	JOIN master m with (nolock)
--	ON m.number=pdc.number
	WHERE pdc.entered BETWEEN @startDate AND @endDate
	AND customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


	--If number is in @tmpcom at all, we'll need a 500 record
	--
	--500 RECORD
	SELECT DISTINCT
	'500' AS [RecordID],
	m.account AS [Account],
	isnull((select top 1 TheData from MiscExtra where Title = 'CommerceVendorID' and number = m.number),'SIMMS')
	 AS [Vendor],
	'' AS [RecallFlag],
	x.TheData AS [Product]--Product?

	FROM @tmpcom t
	JOIN master m with (nolock)
	ON t.number=m.number
	LEFT OUTER JOIN MiscExtra x with (nolock) ON t.number=x.number AND x.Title = 'CommerceProductID'
	WHERE t.uType is not null
	

	--510 RECORD
	SELECT DISTINCT
	'510' AS [RecordID],
	m.account AS [Account],
	x.TheData AS [RelType],
	d.FirstName AS [FName],
	d.Lastname AS [LName],
	m.Street1 AS [Street1],
	m.Street2 AS [Street2],
	m.City AS [City],
	m.State AS [State],
	m.Zipcode AS [Zipcode],
	--No TaxID
	m.SSN AS [SSN],
	m.homephone AS [HomePhone],
	m.workphone AS [WorkPhone],
	--No other phone
	--No email
	d.jobname AS [Employer],
	--Lang, DL
	d.jobAddr1 AS [JobAddress1],
	d.JobAddr2 AS [JobAddress2],
	m.DOB as [DOB],
	d.fax AS [Fax]

	FROM @tmpcom t
	JOIN master m with (nolock)
	ON t.number=m.number
	JOIN debtors d with (nolock)
	ON d.number=m.number
	LEFT OUTER JOIN MiscExtra x with (nolock)
	ON t.number=x.number
	WHERE t.uType is not null
	AND x.Title = 'CommerceRelationshipID'

	--520 RECORD
	SELECT
	'520' AS [RecordID],
	m.account AS [Account],
	n.Created AS [Date],
	n.Created AS [Time],
	n.user0 AS [User],
	n.comment AS [Text]

	FROM @tmpcom t
	JOIN notes n with (nolock)
	ON t.number=n.number
	JOIN master m with (nolock)
	ON n.number=m.number
	WHERE t.uType = 'NO'

	--530 RECORD
	SELECT TOP 1
	'530' AS [RecordID],
	m.account AS [Account],
	'TH' AS [ActionCode],
	'PTP' AS [ResultCode],
	pdc.entered AS [Date],
	--time
	'VEN' AS [Collector]

	FROM @tmpcom t
	JOIN master m with (nolock)
	ON m.number=t.number
	JOIN pdc with (nolock)
	ON pdc.number=m.number
	WHERE  t.uType = 'AX'

	--590 RECORD
--	SELECT DISTINCT
--	'590' AS [RecordID],
--	m.account AS [Account],
--	m.status AS [Status]
--	FROM @tmpcom t
--	JOIN master m with (nolock)
--	ON t.number=m.number
--	WHERE t.uType is not null

END

GO

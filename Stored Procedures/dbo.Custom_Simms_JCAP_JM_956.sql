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
CREATE     PROCEDURE [dbo].[Custom_Simms_JCAP_JM_956]
	
AS
BEGIN
--Some init stuff
declare @addyDate datetime


-- Header Record

SELECT dbo.date(getdate()) AS [Date]

--Master Update Record
DECLARE @tmpjcap TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[number] [int] NOT NULL
)

INSERT INTO @tmpjcap (number)
	SELECT DISTINCT AccountID from AddressHistory a
	JOIN master m with (nolock)
	ON m.Number=a.AccountId
	WHERE a.DateChanged BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6)
	AND m.customer = '0001032'

insert into @tmpjcap (number)
	SELECT DISTINCT AccountID from PhoneHistory p
	JOIN master m with (nolock)
	ON m.Number=p.AccountId
	WHERE p.DateChanged BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6)
	AND m.customer = '0001032'

select @addyDate = (select top 1 a.datechanged
FROM addresshistory a
JOIN master m with (nolock)	
ON m.number=a.accountid
WHERE m.customer = '0001032'
ORDER BY a.datechanged DESC)

SELECT DISTINCT
    	m.number,
	m.id2		AS [BFrame],
	case when m.customer = '0001020' then '0824'
				when m.customer = '0001026' then '0898'
				when m.customer = '0001032' then '0956'
		end		AS [RemoteID],
	m.received  AS [PlacedDate],
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Portfolioid')		 AS [Portfolio],
	'MG'		AS [RecordType],
	m.account	AS [Account],
	CASE WHEN @addyDate BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6) then @addyDate ELSE '' END AS [DateChanged],
	m.ssn		AS [SSN],
	d.Lastname  AS [LName],
	d.Firstname AS [FName],
	CASE WHEN a.DateChanged BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6) then m.Street1 ELSE '' END AS [Address1],
	CASE WHEN a.DateChanged BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6) then m.Street2 ELSE '' END AS [Address2],
	CASE WHEN a.DateChanged BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6) then m.City ELSE '' END	AS [City],
	CASE WHEN a.DateChanged BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6) then m.State ELSE '' END AS [State],
	CASE WHEN a.DateChanged BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6) then m.Zipcode ELSE '' END AS [Zipcode],
	'' AS [Country],
	CASE WHEN p.DateChanged BETWEEN dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6) then m.homephone ELSE '' END AS [Homephone]
	
FROM @tmpjcap t
JOIN master m with (nolock) ON m.number=t.number
LEFT JOIN AddressHistory a with (nolock) ON a.AccountID=m.number
LEFT JOIN PhoneHistory p with (nolock) ON p.AccountID=m.number
RIGHT JOIN Debtors d with (nolock) ON d.number=m.number 
WHERE m.customer = '0001032'
AND d.seq = 0


-- TAILER RECORD

	SELECT COUNT(distinct t.number) AS [NumRecs]
		FROM @tmpjcap t
		JOIN master m with (nolock) ON m.number=t.number
		LEFT JOIN AddressHistory a with (nolock) ON a.AccountID=m.number
		LEFT JOIN PhoneHistory p with (nolock) ON p.AccountID=m.number
		WHERE m.customer = '0001032'

END
GO

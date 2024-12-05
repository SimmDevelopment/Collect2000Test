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
exec Custom_Simms_JCAP_Closure @startDate=@startDate,@endDate=@endDate,@customer=@customer

*/
CREATE     PROCEDURE [dbo].[Custom_Simms_JCAP_Closure]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)
AS
BEGIN
	--Header
	SELECT getdate() AS [Date]
	--Recall Record
	SELECT DISTINCT
		m.id2		 AS [BFrame],
		case when m.customer = '0000833' then '0861'
	     		else '0721'
		end		AS [RemoteID],
		m.received   AS [PlacedDate],
		(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Portfolioid')		 AS [Portfolio],
		'RT'		 AS [RecordType],
		m.account	 AS [Account],
		getdate()	 AS [Date],
		m.name		 AS [Name],
		m.current0	 AS [Balance],
		m.paid  	AS [TotalPaid],
		m.clialp	 AS [LastPaid],
		m.closed	 AS [StatusDate],
		m.status	 AS [Status]

FROM master m with (nolock)
--JOIN PayHistory p with (nolock) ON p.number=m.number
WHERE --m.closed between @startDate AND @endDate AND 
m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND m.returned is null 
AND m.closed < (getdate()-15)
AND m.status in ('SIF')

UNION 


	SELECT DISTINCT
		m.id2		 AS [BFrame],
		case when m.customer = '0000833' then '0861'
	     		else '0721'
		end		AS [RemoteID],
		m.received   AS [PlacedDate],
		(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Portfolioid')		 AS [Portfolio],
		'RT'		 AS [RecordType],
		m.account	 AS [Account],
		getdate()	 AS [Date],
		m.name		 AS [Name],
		m.current0	 AS [Balance],
		m.paid  	AS [TotalPaid],
		m.clialp	 AS [LastPaid],
		m.closed	 AS [StatusDate],
		m.status	 AS [Status]

FROM master m with (nolock)
--JOIN PayHistory p with (nolock) ON p.number=m.number
WHERE m.closed between @startDate AND @endDate
AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND m.returned is null 
--AND m.closed < (getdate()-15)
AND m.status not in ('SIF')


	--Tailer
	SELECT COUNT(distinct m.number) AS [NumRecs]
	FROM master m with (nolock)
--	JOIN PayHistory p with (nolock) ON p.number=m.number
	WHERE (m.number in (select m.number FROM master m with (nolock) WHERE m.closed between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND m.returned is null AND m.status not in ('SIF'))
	or m.number in (select m.number FROM master m with(nolock) where m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND m.returned is null AND m.closed < (getdate()-15) AND m.status in ('SIF')))

END


GO

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
CREATE     PROCEDURE [dbo].[Custom_Simms_JCAP_Closure_JM_956]
	
AS
BEGIN
	--Header
	SELECT dbo.date(getdate()) AS [Date]
	--Recall Record
	SELECT DISTINCT
		m.id2		 AS [BFrame],
		case when m.customer = '0001020' then '0824'
				when m.customer = '0001026' then '0898'
				when m.customer = '0001032' then '0956'
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
m.customer = '0001032'
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
		case m.status
			when 'BK7' THEN 'BKRT07'
			WHEN 'B11' THEN 'BKRT11'
			WHEN 'B13' THEN 'BKRT13'
			WHEN 'CAD' THEN 'CCOMM'
			WHEN 'DEC' THEN 'DDU'
			WHEN 'DSP' THEN 'DISP'
			When 'BKY' then 'BKRT07'
			ELSE STATUS 
				END	 AS [Status]

FROM master m with (nolock)
--JOIN PayHistory p with (nolock) ON p.number=m.number
WHERE m.closed between dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6)
AND m.customer = '0001032'
AND m.returned is null 
--AND m.closed < (getdate()-15)
AND m.status not in ('SIF')


	--Tailer
	SELECT COUNT(distinct m.number) AS [NumRecs]
	FROM master m with (nolock)
--	JOIN PayHistory p with (nolock) ON p.number=m.number
	WHERE (m.number in (select m.number FROM master m with (nolock) WHERE m.closed between dbo.F_START_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND dbo.F_END_OF_WEEK(dateadd(dd, -1, getdate()), 6) AND m.customer = '0001032' AND m.returned is null AND m.status not in ('SIF'))
	or m.number in (select m.number FROM master m with(nolock) where m.customer = '0001032' AND m.returned is null AND m.closed < (getdate()-15) AND m.status in ('SIF')))

END
GO

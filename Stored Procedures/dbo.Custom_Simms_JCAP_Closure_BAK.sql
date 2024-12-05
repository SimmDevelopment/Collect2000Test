SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20060101'
set @endDate='20061130'
set @customer='0000001|0000002|0000003|0000004|0000000|'
exec Custom_Simms_JCAP_Closure @startDate=@startDate,@endDate=@endDate,@customer=@customer

*/
CREATE  PROCEDURE [dbo].[Custom_Simms_JCAP_Closure_BAK]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)
AS
BEGIN
	--Header
	SELECT getdate() AS [Date]
	--Recall Record
	SELECT DISTINCT
		''			 AS [BFrame],
		'0861'		 AS [RemoteID],
		m.received   AS [PlacedDate],
		''			 AS [Portfolio],
		'RT'		 AS [RecordType],
		m.account	 AS [Account],
		getdate()	 AS [Date],
		m.name		 AS [Name],
		m.current0	 AS [Balance],
		p.totalpaid  AS [TotalPaid],
		m.clialp	 AS [LastPaid],
		getdate()	 AS [StatusDate],
		''			 AS [Status]

FROM master m with (nolock)
JOIN PayHistory p with (nolock)
ON p.number=m.number
WHERE m.received between @startDate AND @endDate
AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

	--Tailer
	SELECT COUNT(distinct m.number) AS [NumRecs]
	FROM master m with (nolock)
	JOIN PayHistory p with (nolock)
	ON p.number=m.number
	WHERE m.received between @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

END
GO

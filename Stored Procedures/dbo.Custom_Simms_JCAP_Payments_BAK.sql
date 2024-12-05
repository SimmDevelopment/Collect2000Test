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
exec Custom_Simms_JCAP_Payments @startDate=@startDate,@endDate=@endDate,@customer=@customer

*/
CREATE     PROCEDURE [dbo].[Custom_Simms_JCAP_Payments_BAK]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)
AS
BEGIN

  --Header info
	SELECT getdate() AS [Date]

  --Payment info

	SELECT DISTINCT
		''			 AS [BFrame],
		'0861'		 AS [RemoteID],
		m.received   AS [PlacedDate],
		''			 AS [Portfolio],
		'PY'		 AS [RecordType],
		m.account	 AS [Account],
		--Fill 18
		'SIM'		 AS [ServiceID],
		m.name		 AS [Name],
		p.datepaid   AS [Datepaid],
		'A' AS [PayTo],
		CASE WHEN p.paymethod like '%CHECK%' then '1'
			WHEN p.paymethod like '%DEBIT%' then '3'
			WHEN p.paymethod like '%CASH%' then '3'
			else '4' END AS [PaymentType],
		CASE WHEN p.batchtype IN ('PU', 'PA') then 'PY'
		     WHEN p.batchtype IN ('PUR', 'PAR') then 'RC'
		END AS [MiscPayment],
		CASE WHEN p.batchtype IN ('PUR','PAR') then (-1*p.totalpaid)
		     ELSE p.totalpaid END AS [TotalPaid],
		p.fee1 AS [Commission],
		getdate() AS [Date]

--select * from PayHistory ORDER BY batchtype
--select top 10 paytype,* from PayHistory with (nolock) where paytype != ''

FROM PayHistory p with (nolock)
JOIN Master m with (nolock)
ON m.Number=p.Number
WHERE p.datepaid between @startDate AND @endDate
AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND p.batchtype not in ('DA','DAR','PC','PCR')


-- TAILER RECORD

	SELECT 
		
		SUM(p.totalpaid) AS [AmountPayments],									
		COUNT(distinct m.number) AS [NumRecs]
		

	FROM PayHistory p with (nolock)
	JOIN Master m with (nolock)
	ON m.Number=p.Number
	WHERE p.datepaid between @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	AND p.batchtype not in ('DA','DAR','PC','PCR')


END



GO

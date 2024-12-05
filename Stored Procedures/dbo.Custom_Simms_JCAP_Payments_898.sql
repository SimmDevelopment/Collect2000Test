SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)
declare @invoice varchar(8000)
set @invoice = '10169|'
set @startDate='20070101'
set @endDate='20070131'
set @customer='0000833|'
exec Custom_Simms_JCAP_Payments @invoice
--@startDate=@startDate,@endDate=@endDate,@customer=@customer

*/
CREATE     PROCEDURE [dbo].[Custom_Simms_JCAP_Payments_898]
	
--	@startDate datetime,
--	@endDate datetime,
--	@customer varchar(8000)
AS
BEGIN

  --Header info
	SELECT dbo.date(getdate()) AS [Date]

  --Payment info

	SELECT DISTINCT
		p.UID,
		m.id2		 AS [BFrame],
		case when m.customer = '0001020' then '0824'
				when m.customer = '0001026' then '0898'
				when m.customer = '0001032' then '0956'
		end		AS [RemoteID],
		m.received   AS [PlacedDate],
		(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Portfolioid')		 AS [Portfolio],
		'PY'		 AS [RecordType],
		m.account	 AS [Account],
		case when p.batchtype in ('pur', 'par') then convert(varchar(10), p.datepaid, 112)
		else '' end as batchdate,
		'SIM'		 AS [ServiceID],
		m.name		 AS [Name],
		case when p.batchtype in ('pur', 'par') then (select datepaid from payhistory with (nolock) where uid = p.reverseofuid)
		else p.datepaid end   AS [Datepaid],
		'A' AS [PayTo],
		CASE WHEN p.paymethod like '%CHECK%' then '1'
			WHEN p.paymethod like '%DEBIT%' then '3'
			WHEN p.paymethod like '%CASH%' then '3'
			else '4' END AS [PaymentType],
		CASE WHEN p.batchtype IN ('PU', 'PA') then 'PY'
		     WHEN p.batchtype IN ('PUR', 'PAR') then 'RC'
		END AS [MiscPayment],
		case when p.batchtype in ('PUR','PAR') then (dbo.Custom_CalculatePaymentTotalPaid (p.uid)*-1) else dbo.Custom_CalculatePaymentTotalPaid (p.uid) end AS [TotalPaid],
		case when p.batchtype in ('PAR','PUR') then (p.fee1*-1) else p.fee1 end AS [Commission],
		getdate() AS [Date]

FROM PayHistory p with (nolock)
JOIN Master m with (nolock) ON m.Number=p.Number
LEFT JOIN PayHistory r with (nolock) ON p.UID=r.ReverseOfUID
WHERE --p.datepaid between @startDate AND @endDate AND 
--r.UID IS NULL AND 
--m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND 
p.batchtype not in ('DA','DAR','PC','PCR') and 
p.invoiced = dbo.date(getdate()) and p.invoice is not null and p.customer = '0001026'

-- TAILER RECORD

	SELECT
		SUM(case when p.batchtype in ('PUR','PAR') then (dbo.Custom_CalculatePaymentTotalPaid (p.uid)*-1) else dbo.Custom_CalculatePaymentTotalPaid (p.uid) end) AS [AmountPayments],									
		COUNT(*) AS [NumRecs]
		
FROM PayHistory p with (nolock)
JOIN Master m with (nolock) ON m.Number=p.Number
LEFT JOIN PayHistory r with (nolock) ON p.UID=r.ReverseOfUID
WHERE --p.datepaid between @startDate AND @endDate AND 
r.UID IS NULL AND 
--m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND 
p.batchtype not in ('DA','DAR','PC','PCR') and
p.invoiced = dbo.date(getdate()) and p.invoice is not null and p.customer = '0001026'

END
GO

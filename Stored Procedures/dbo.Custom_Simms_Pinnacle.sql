SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----Pinnacle
/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20070101'
set @endDate='20070131'
set @customer='0000831|0000895|'
exec Custom_Simms_Pinnacle @startDate=@startDate,@endDate=@endDate,@customer=@customer

*/
CREATE  PROCEDURE [dbo].[Custom_Simms_Pinnacle]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)
AS
BEGIN

SELECT @endDate = @endDate + 1

SELECT
	p.uid AS [UID],
	 CASE when p.batchtype in ('PU', 'PA') then '1000'
		 when p.batchtype in ('PAR', 'PUR') then '1003'
		 else '' END AS [TransactionType],
	p.datepaid AS [TransactionDate],
	dbo.Custom_CalculatePaymentTotalPaid (p.uid) AS [TotalPaid],
	p.paid1 AS [TotalPrin],
	p.paid2 AS [TotalInt],
	p.paid8 AS [TotalCourt],
	p.paid5 AS [TotalAttorney],
	CASE WHEN p.batchtype in ('PUR','PAR') THEN p.paid4 ELSE 0 END AS [TotalNSF],
	p.paid3 AS [TotalFee],
	(p.paid7 + p.paid9 + p.paid10) AS [TotalOther],
	'0' AS [TotalRetained]

FROM PayHistory p with (nolock)
JOIN master m with (nolock)
ON m.number=p.number
WHERE p.batchtype IN ('PU', 'PA', 'PAR', 'PUR')
AND p.datepaid BETWEEN @startDate AND @endDate
AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
END
GO

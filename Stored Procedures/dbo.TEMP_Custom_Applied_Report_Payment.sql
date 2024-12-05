SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20070101'
set @endDate='20070125'
set @customer='0000905|'
exec Custom_Simms_First_PAY @startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE          PROCEDURE [dbo].[TEMP_Custom_Applied_Report_Payment]
	 @startDate datetime,
	 @endDate datetime

AS
BEGIN
	


SELECT DISTINCT --Header Record
	--RecordCode
	--Filler
	getdate() AS [Date],
	--Type=1
	--SourceCode=1
	m.customer,
	'PRE005' AS [AgencyCode],
	case
		when m.customer='0000555' then 'SIMM Associates Inc.'
		else ''
	end AS [AgencyName],
	--Rec1
	(select count(*) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number WHERE p.entered between @startDate AND @endDate AND p.batchtype IN ('PU', 'PA') AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec1],
	(select SUM(dbo.Custom_ReversePaymentSign(dbo.Custom_CalculatePaymentTotalPaid (p.uid), p.batchtype)) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number WHERE p.entered between @startDate AND @endDate AND p.batchtype IN ('PU', 'PA') AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalPay],
	--Rec2
	'0' AS [NumRec2],--(select count(*) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec2],
	'0' AS [TotalCost],--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer )/*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalCost],
	--Rec3
	(SELECT COUNT(*) 
		FROM PayHistory p with (nolock) 
		JOIN master m2 with (nolock) ON m2.Number = p.Number 
		WHERE p.entered between @startDate AND @endDate 
			AND m2.customer = m.customer
			AND p.batchtype IN ('PUR', 'PAR')) AS [NumRec3],
	(SELECT SUM(dbo.Custom_ReversePaymentSign(p.totalpaid, p.batchtype)) 
		FROM PayHistory p with (nolock) 
		JOIN master m2 with (nolock) ON m2.Number = p.Number 
		WHERE p.entered between @startDate AND @endDate 
			AND m2.customer = m.customer
			AND p.batchtype IN ('PUR', 'PAR')) AS [TotalAdj],
	--Rec4
	'0' AS [NumRec4], --(select count(*) FROM notes n with (nolock) JOIN master m2 with (nolock) ON m2.Number=n.number WHERE n.created between @startDate AND @endDate AND m2.customer=m.customer /*IN (select string from dbo.CustomStringToSet(@customer, '|'))*/ AND EXISTS
						--( SELECT ID from Users with (nolock)
						--	Where LoginName=n.user0
						--)) AS [NumRec4],
	--Rec5
--	(
--		select count(distinct m2.number) 
--		FROM @tmpcms_count t 
--		JOIN master m2 with (nolock) ON m2.Number=t.Number 
--		left JOIN CourtCases c with (nolock) ON m2.Number=c.AccountID 
--		left JOIN Courts ct with (nolock) ON c.CourtID=ct.CourtID
--		where m2.customer=m.customer 
--	)
	'0' AS [NumRec5],
	--Filler
	'05584' AS [BankID]
	--Fills
FROM master m with (nolock)
JOIN PayHistory p with (nolock)
ON p.Number=m.Number
where m.customer = '0000555' and m.customer is not null
AND p.batchtype IN ('PU', 'PA', 'PUR', 'PAR')  

SELECT --Payment Record
	'1' AS [RecordCode],
	p.datepaid,
	case when p.batchtype in ('PU', 'PA') then '1' ELSE '3' END as 'paymenttype',
	'1' as 'sourcecode',
	case when p.batchtype in ('PU', 'PA') then 'PAYMENT THROUGH PRE005' ELSE 'PAYMENT REV THROUGH PRE005' END as 'reference',
	p.AdjInvoicedPaid as amountpaid,
	0 paid1,
	0 paid3,
	0 paid2,
	0 paid10,
	p.AdjInvoicedFee fee,
	'N' as DueAgency,--Find fee due agency
    '   ' batchtype,
	NULL id1,
	m.account
FROM Custom_PaymentsView p 
JOIN Master m with (nolock)
ON m.Number=p.Number
WHERE p.entered between @startDate AND @endDate
AND p.batchtype IN ('PUR')
AND m.customer = '0000555'

END










GO

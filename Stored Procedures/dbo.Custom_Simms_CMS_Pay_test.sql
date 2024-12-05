SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)
declare @invoice varchar(8000)
set @invoice = '10177|'
set @startDate='20070205'
set @endDate='20070211'
set @customer='0000633|'
exec Custom_Simms_CMS_PAY @invoice
--@startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE       PROCEDURE [dbo].[Custom_Simms_CMS_Pay_test]
	@invoice varchar(8000)
--	 @startDate datetime,
--	 @endDate datetime,
--	 @customer varchar(8000)

AS
BEGIN
--	set @endDate=@endDate+1
--Declare @theCustomers Table (
--				[ID] [int] IDENTITY(1,1) NOT NULL,
--				Customer varchar(7)
--			)
--			
--			Insert into @theCustomers(customer)
--			Select string from dbo.CustomStringToSet(@customer,'|')

SELECT DISTINCT --Header Record
	--RecordCode
	--Filler
	getdate() AS [Date],
	--Type=1
	--SourceCode=1
	m.customer,
	case 
		when m.customer='0000511' then 'AL0125'
		when m.customer='0000627' then 'AL0204'
		when m.customer='0000591' then 'AL0171'
		when m.customer='0000619' then 'AL0200'
		when m.customer='0000633' then 'AL0217'
		when m.customer='0000676' then 'AL0283'
		when m.customer='0000644' then 'AL0225'
		when m.customer='0000677' then 'AL0284'
		when m.customer='0000896' then 'AL0349'
		when m.customer='0000905' then ''
		else ''
	end AS [AgencyCode],
	case
		when m.customer='0000511' then 'SIMM Associates Inc.'
		when m.customer='0000627' then 'SIMM Associates Inc.'
		when m.customer='0000591' then 'SIMM Associates Inc.'
		when m.customer='0000619' then 'SIMM Associates Inc.'
		when m.customer='0000633' then 'SIMM Associates Inc.'
		when m.customer='0000676' then 'SIMM Associates Inc.'
		when m.customer='0000644' then 'SIMM Associates Inc.'
		when m.customer='0000677' then 'SIMM Associates Inc.'
		when m.customer='0000896' then 'SIMM Associates Inc.'
		when m.customer='0000905' then 'SIMM Associates Inc.'
		else ''
	end AS [AgencyName],
	--Rec1
	  (select count(*) 
		FROM (select string as invoices from dbo.CustomStringToSet(@invoice, '|')) i
			inner join payhistory p with (nolock) on p.invoice = i.invoices
			inner JOIN  master m with (nolock) ON m.Number=p.Number
			where 	p.batchtype IN ('PU', 'PA', 'PUR', 'PAR') 
			and 	p.matched = 'N' 
			and 	(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) <> 0) AS [NumRec1],

	  (select sum(case when p.batchtype in ('PAR','PUR') then (dbo.Custom_CalculatePaymentTotalPaid (p.uid)*-1) 
		else (dbo.Custom_CalculatePaymentTotalPaid (p.uid)) end) 
		FROM (select string as invoices from dbo.CustomStringToSet(@invoice, '|')) i
			inner join payhistory p with (nolock) on p.invoice = i.invoices
			inner JOIN  master m with (nolock) ON m.Number=p.Number
			where 	p.batchtype IN ('PU', 'PA', 'PUR', 'PAR') 
			and 	p.matched = 'N' 
			and 	(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) <> 0)  AS [TotalPay],

	--Rec2
	'0' AS [NumRec2],--(select count(*) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec2],
	'0' AS [TotalCost],--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer )/*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalCost],
	--Rec3
	'0' AS [NumRec3],
	--(select count(*) FROM PayHistory p with (nolock) JOIN master m with (nolock) ON m.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))) AS [NumRec3],
	--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m with (nolock) ON m.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))) AS [TotalAdj],
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
	case
		when m.customer='0000511' then '05242'
		when m.customer='0000627' then '05242'
		when m.customer='0000591' then '06070'
		when m.customer='0000619' then '06070'
		when m.customer='0000633' then '06070'
		when m.customer='0000676' then '06070'
		when m.customer='0000644' then '06488'
		when m.customer='0000677' then '06488'
		when m.customer='0000896' then '06112'
		when m.customer='0000905' then ''
	end AS [BankID]
	--Fills
FROM 	(select string as invoices from dbo.CustomStringToSet(@invoice, '|')) i
	inner join payhistory p with (nolock) on p.invoice = i.invoices
	inner JOIN  master m with (nolock) ON m.Number=p.Number

where 	p.batchtype IN ('PU', 'PA', 'PUR', 'PAR') 
and 	p.matched = 'N' 
and 	(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) <> 0

SELECT --Payment Record
	'1' AS [RecordCode],
	p.datepaid,
	case when p.batchtype in ('PU', 'PA') then '1' ELSE '3' END as 'paymenttype',
	'1' as 'sourcecode',
	case	when p.batchtype in ('PU', 'PA') and p.customer = '0000511' then 'PAYMENT THROUGH AL0125' 
		when p.batchtype in ('PU', 'PA') and p.customer = '0000627' then 'PAYMENT THROUGH AL0204' 
		when p.batchtype in ('PU', 'PA') and p.customer = '0000591' then 'PAYMENT THROUGH AL0171' 
		when p.batchtype in ('PU', 'PA') and p.customer = '0000619' then 'PAYMENT THROUGH AL0200' 
		when p.batchtype in ('PU', 'PA') and p.customer = '0000633' then 'PAYMENT THROUGH AL0217' 
		when p.batchtype in ('PU', 'PA') and p.customer = '0000676' then 'PAYMENT THROUGH AL0283' 
		when p.batchtype in ('PU', 'PA') and p.customer = '0000644' then 'PAYMENT THROUGH AL0225' 
		when p.batchtype in ('PU', 'PA') and p.customer = '0000677' then 'PAYMENT THROUGH AL0284' 
		when p.batchtype in ('PU', 'PA') and p.customer = '0000896' then 'PAYMENT THROUGH AL0349' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000511' then 'PAYMENT REV THROUGH AL0125' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000627' then 'PAYMENT REV THROUGH AL0204' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000591' then 'PAYMENT REV THROUGH AL0171' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000619' then 'PAYMENT REV THROUGH AL0200' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000633' then 'PAYMENT REV THROUGH AL0217' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000676' then 'PAYMENT REV THROUGH AL0283' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000644' then 'PAYMENT REV THROUGH AL0225' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000677' then 'PAYMENT REV THROUGH AL0284' 
		when p.batchtype in ('PUR','PAR') and p.customer = '0000896' then 'PAYMENT REV THROUGH AL0349'		 
	END as 'reference',
	case when p.batchtype in ('PUR','PAR') then '-' else '0' end as [sign],
	dbo.Custom_CalculatePaymentTotalPaid (p.uid )as amountpaid,
	case when p.batchtype in ('PUR','PAR') and p.paid1 <> 0 then '-' else '0' end as [sign1],
	p.paid1 as [paid1],
	case when p.batchtype in ('PUR','PAR') and p.paid3 <> 0 then '-' else '0' end as [sign2],
	p.paid3 as [paid3],
	case when p.batchtype in ('PUR','PAR') and p.paid2 <> 0 then '-' else '0' end as [sign3],
	p.paid2 as [paid2],
	'00000000.00' as [paid10],--p.paid10,
	case when p.batchtype in ('PUR','PAR') and p.fee6 <> 0 then '-' else '0' end as [sign4],
	p.fee6 as [fee6],
	'Y' as fee,--Find fee due agency
	p.batchtype,
	m.id2 as [id1],
	m.account
FROM 	(select string as invoices from dbo.CustomStringToSet(@invoice, '|')) i
	inner join payhistory p with (nolock) on p.invoice = i.invoices
	inner JOIN  master m with (nolock) ON m.Number=p.Number

where 	p.batchtype IN ('PU', 'PA', 'PUR', 'PAR') 
and 	p.matched = 'N' 
and 	(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) <> 0
ORDER BY M.NUMBER





END






GO

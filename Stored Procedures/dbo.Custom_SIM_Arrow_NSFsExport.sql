SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
[dbo].[Custom_NCC_Arrow_PaymentsExport]
'10049'
*/
CREATE procedure [dbo].[Custom_SIM_Arrow_NSFsExport]

@invoice varchar(80)
--@startDate datetime,
--@endDate datetime
as
begin

-- DECLARE @lastFileDateTime datetime
-- SELECT @lastFileDateTime = dbo.Custom_GetLastFileDate(3,@customer)





SELECT
	m.id2 as account,
	Convert(varchar(10),ph.datepaid,101)  as payment_date,
	[dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10) as payment_amount,
	[dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.fee1,ph.fee2,ph.fee3,ph.fee4,ph.fee5,ph.fee6,ph.fee7,ph.fee8,ph.fee9,ph.fee10) as agency_fee,
	[dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.fee1,ph.fee2,ph.fee3,ph.fee4,ph.fee5,ph.fee6,ph.fee7,ph.fee8,ph.fee9,ph.fee10)/[dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10)*100 as percent_rate,
	substring(m.name,0,charindex(',',m.name,0))as debtor_last_name,
	substring(m.name,charindex(',',m.name,0)+2,len(m.name)-charindex(',',m.name,0)) as debtor_first_name,
	'NSF' as payment_type
	
FROM
	payhistory ph with (nolock) join master m on ph.number = m.number
	left outer join debtors d on d.number = ph.number and d.seq = 0

--	join fact f on f.customerid = ph.customer
--	join customcustgroups c on c.id = f.customgroupid
	--join customer c on c.customer = m.customer
	
WHERE   ph.batchtype in ('PUR') and

ph.invoice = @invoice
and ph.customer in (select customerid from fact (nolock) where customgroupid = 97)


--	ph.entered >= @startDate and ph.entered <= @endDate 
--    and  m.Customer in (Select String From [dbo].[StringToSet](@customer, '|')) 
	--and c.name = 'Arrow'
--GROUP BY me.thedata,ph.datepaid,ph.totalpaid,ph.fee1,ph.fee2,ph.paid1,ph.paid2,m.name,ph.paymethod, ph.invoiceflags
end
GO

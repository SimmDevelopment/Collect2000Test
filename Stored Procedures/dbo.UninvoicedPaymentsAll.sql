SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UninvoicedPaymentsAll] 
	@SysYr int = 2999, 
	@SysMo int = 12
AS
	Select m.number, m.name, ph.uid, ph.matched, p.customer as [Parent], p.name as [Parent Name], c.customer, c.name, c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, TotalPaid = CASE ph.batchtype WHEN 'PC' THEN ph.totalpaid WHEN 'PCR' THEN -ph.totalpaid END, ph.invoiceflags, 
		InvoiceAmt = CASE ph.batchtype
			WHEN 'PC' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PCR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
		END,
		FeeAmt = CASE ph.batchtype
			WHEN 'PC' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PCR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END,
		RemitAmt = CASE ph.batchtype
			WHEN 'PC' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PCR' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END
	From (((Customer c inner join Customer p on Isnull(c.custgroup,c.customer) = p.customer) 
		inner join payhistory ph on ph.customer = c.customer)
		inner join master m on ph.number = m.number)
	where ph.batchtype in ('PC','PCR') 
		and ((ph.systemyear = @SysYr and ph.systemmonth <= @SysMo) or (ph.systemyear < @SysYr)) 
		and ph.Invoiced is null
	union
	Select m.number, m.name, ph.uid, ph.matched, p.customer as [Parent], p.name as [Parent Name], c.customer, c.name, c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, TotalPaid = CASE ph.batchtype WHEN 'PU' THEN ph.totalpaid WHEN 'PA' THEN ph.totalpaid WHEN 'PUR' THEN -ph.totalpaid WHEN 'PAR' THEN -ph.totalpaid END, ph.invoiceflags, 
		InvoiceAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PUR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PAR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
		END,
		FeeAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PUR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PAR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END,
		RemitAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PUR' THEN - (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PAR' THEN - (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END
	From (((Customer c inner join Customer p on Isnull(c.custgroup,c.customer) = p.customer) 
		inner join payhistory ph on ph.customer = c.customer)
		inner join master m on ph.number = m.number)
	where ph.batchtype in ('PU','PA','PUR','PAR') and SubString(p.invoicemethod, 1,1) = '1'
		and ((ph.systemyear = @SysYr and ph.systemmonth <= @SysMo) or (ph.systemyear < @SysYr)) 
		and ph.Invoiced is null
	union
	Select m.number, m.name, ph.uid, ph.matched, p.customer as [Parent], p.name as [Parent Name], c.customer, c.name, c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, TotalPaid = CASE ph.batchtype WHEN 'PU' THEN ph.totalpaid WHEN 'PA' THEN ph.totalpaid WHEN 'PUR' THEN -ph.totalpaid WHEN 'PAR' THEN -ph.totalpaid END, ph.invoiceflags, 
		InvoiceAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PUR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PAR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
		END,
		FeeAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PUR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PAR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END,
		RemitAmt = CASE ph.batchtype
			WHEN 'PU' THEN dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10)
			WHEN 'PUR' THEN -dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10)
			WHEN 'PA' THEN dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10)
			WHEN 'PAR' THEN -dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10)
		END
	From (((Customer c inner join Customer p on Isnull(c.custgroup,c.customer) = p.customer) 
		inner join payhistory ph on ph.customer = c.customer)
		inner join master m on ph.number = m.number)
	where ph.batchtype in ('PU','PA','PUR','PAR') and SubString(p.invoicemethod, 1,1) = '2'
		and ((ph.systemyear = @SysYr and ph.systemmonth <= @SysMo) or (ph.systemyear < @SysYr)) 
		and ph.Invoiced is null
	union
	Select m.number, m.name, ph.uid, ph.matched, p.customer as [Parent], p.name as [Parent Name], c.customer, c.name, c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, TotalPaid = CASE ph.batchtype WHEN 'PC' THEN ph.totalpaid WHEN 'PCR' THEN -ph.totalpaid END, ph.invoiceflags, 
		InvoiceAmt = CASE ph.batchtype
			WHEN 'PC' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PCR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
		END,
		FeeAmt = CASE ph.batchtype
			WHEN 'PC' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PCR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END,
		RemitAmt = CASE ph.batchtype
			WHEN 'PC' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PCR' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END
	From (((Customer c inner join Customer p on Isnull(c.custgroup,c.customer) = p.customer) 
		inner join payhistory ph on ph.customer = c.customer)
		inner join master m on ph.number = m.number)
	where ph.batchtype in ('PC','PCR') 
		and ((ph.systemyear = @SysYr and ph.systemmonth <= @SysMo) or (ph.systemyear < @SysYr)) 
		and ph.Invoiced is not null and ph.Invoiced >= dateadd( m, 1, convert(datetime, cast(@SysYr as varchar) + '-' + cast((@SysMo) as varchar) + '-1'))
	union
	Select m.number, m.name, ph.uid, ph.matched, p.customer as [Parent], p.name as [Parent Name], c.customer, c.name, c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, TotalPaid = CASE ph.batchtype WHEN 'PU' THEN ph.totalpaid WHEN 'PA' THEN ph.totalpaid WHEN 'PUR' THEN -ph.totalpaid WHEN 'PAR' THEN -ph.totalpaid END, ph.invoiceflags, 
		InvoiceAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PUR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PAR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
		END,
		FeeAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PUR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PAR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END,
		RemitAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PUR' THEN - (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PAR' THEN - (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END
	From (((Customer c inner join Customer p on Isnull(c.custgroup,c.customer) = p.customer) 
		inner join payhistory ph on ph.customer = c.customer)
		inner join master m on ph.number = m.number)
	where ph.batchtype in ('PU','PA','PUR','PAR') and SubString(p.invoicemethod, 1,1) = '1'
		and ((ph.systemyear = @SysYr and ph.systemmonth <= @SysMo) or (ph.systemyear < @SysYr)) 
		and ph.Invoiced is not null and ph.Invoiced >= dateadd( m, 1, convert(datetime, cast(@SysYr as varchar) + '-' + cast((@SysMo) as varchar) + '-1'))
	union
	Select m.number, m.name, ph.uid, ph.matched, p.customer as [Parent], p.name as [Parent Name], c.customer, c.name, c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, TotalPaid = CASE ph.batchtype WHEN 'PU' THEN ph.totalpaid WHEN 'PA' THEN ph.totalpaid WHEN 'PUR' THEN -ph.totalpaid WHEN 'PAR' THEN -ph.totalpaid END, ph.invoiceflags, 
		InvoiceAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PUR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN 'PAR' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
		END,
		FeeAmt = CASE ph.batchtype
			WHEN 'PU' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PA' THEN (dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PUR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN 'PAR' THEN -(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
		END,
		RemitAmt = CASE ph.batchtype
			WHEN 'PU' THEN dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10)
			WHEN 'PUR' THEN -dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10)
			WHEN 'PA' THEN dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10)
			WHEN 'PAR' THEN -dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10)
		END
	From (((Customer c inner join Customer p on Isnull(c.custgroup,c.customer) = p.customer) 
		inner join payhistory ph on ph.customer = c.customer)
		inner join master m on ph.number = m.number)
	where ph.batchtype in ('PU','PA','PUR','PAR') and SubString(p.invoicemethod, 1,1) = '2'
		and ((ph.systemyear = @SysYr and ph.systemmonth <= @SysMo) or (ph.systemyear < @SysYr)) 
		and ph.Invoiced is not null and ph.Invoiced >= dateadd( m, 1, convert(datetime, cast(@SysYr as varchar) + '-' + cast((@SysMo) as varchar) + '-1'))
	order by Parent, c.customer, ph.datepaid

GO

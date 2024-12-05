SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PendingRemittanceReport] 
	@SysYr int = 2999, 
	@SysMo int = 12
AS
	DECLARE @MaxDate datetime
	SELECT @MaxDate = CAST('2599-12-31' as datetime)

	SELECT m.number, m.name AS [Debtor Name], ph.uid, ph.matched, p.customer AS [Parent], p.name AS [Parent Name], c.customer, c.name AS [Customer Name], c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, ph.invoiceflags, c.invoicetype,
		TotalPaid = 
		CASE 
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				ph.totalpaid 
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-ph.totalpaid 
			ELSE  0
		END, 
		
		InvoiceAmt = 
		CASE
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		FeeAmt = 
		CASE
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			ELSE  0
		END,
		PaidUs = 
		CASE
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		PaidCust = 
		CASE
			WHEN ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		DueUs = 
		CASE SUBSTRING(ISNULL(p.invoicemethod, '1'), 1,1)
			WHEN '1' THEN
				CASE
					WHEN ph.batchtype = 'PC' THEN 
						(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					WHEN ph.batchtype = 'PCR' THEN 
						-(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					ELSE  0
				END
			ELSE
				CASE
					WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
						(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
						-(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					ELSE  0
				END
		END,
		DueCust = 
		CASE 
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' THEN 
				CASE SUBSTRING(ISNULL(p.invoicemethod, '1'), 1,1)
					WHEN '1' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					ELSE (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
				END
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' THEN 
				CASE SUBSTRING(ISNULL(p.invoicemethod, '1'), 1,1)
					WHEN '1' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					ELSE -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
				END
			ELSE  0
		END,
		PURAmt = 0,
--		CASE
--			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' THEN 
--				
--				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
--			ELSE  0
--		END,
		PCRAmt = 0
--		CASE
--			WHEN ph.batchtype = 'PCR' THEN 
--				-(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
--			ELSE  0
--		END
	FROM ((((Customer c INNER JOIN Customer p ON ISNULL(c.custgroup,c.customer) = p.customer) 
		INNER JOIN payhistory ph ON ph.customer = c.customer)
		INNER JOIN master m ON ph.number = m.number)
		LEFT OUTER JOIN payhistory r ON r.uid = ph.reverseofuid)
	WHERE ph.batchtype in ('PU','PA','PC','PUR','PAR','PCR')
		AND ((ph.systemyear = @SysYr AND ph.systemmonth <= @SysMo) OR (ph.systemyear < @SysYr)) 
		AND ISNULL(ph.Invoiced, @MaxDate) >= DATEADD( m, 1, CONVERT(datetime, CAST(@SysYr AS varchar) + '-' + CAST((@SysMo) AS varchar) + '-1'))
		AND ISNULL(ph.matched, 'N') <> 'Y'
		AND ISNULL(r.invoiced, @MaxDate) >= DATEADD( m, 1, CONVERT(datetime, CAST(@SysYr AS varchar) + '-' + CAST((@SysMo) AS varchar) + '-1'))
	UNION
	SELECT m.number, m.name AS [Debtor Name], ph.uid, ph.matched, p.customer AS [Parent], p.name AS [Parent Name], c.customer, c.name AS [Customer Name], c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, ph.invoiceflags, c.invoicetype,
		TotalPaid = 
		CASE 
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				ph.totalpaid 
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-ph.totalpaid 
			ELSE  0
		END, 
		InvoiceAmt = 
		CASE
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		FeeAmt = 
		CASE
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			ELSE  0
		END,
		PaidUs = 
		CASE
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		PaidCust = 
		CASE
			WHEN ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		DueUs = 
		CASE SUBSTRING(ISNULL(p.invoicemethod, '1'), 1,1)
			WHEN '1' THEN
				CASE
					WHEN ph.batchtype = 'PC' THEN 
						(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					WHEN ph.batchtype = 'PCR' THEN 
						-(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					ELSE  0
				END
			ELSE
				CASE
					WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
						(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
						-(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					ELSE  0
				END
		END,
		DueCust = 
		CASE 
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' THEN 
				CASE SUBSTRING(ISNULL(p.invoicemethod, '1'), 1,1)
					WHEN '1' THEN (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					ELSE (dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
				END
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' THEN 
				CASE SUBSTRING(ISNULL(p.invoicemethod, '1'), 1,1)
					WHEN '1' THEN -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
					ELSE -(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
				END
			ELSE  0
		END,
		PURAmt = 0,
		PCRAmt = 0
	FROM ((((Customer c INNER JOIN Customer p ON ISNULL(c.custgroup,c.customer) = p.customer) 
		INNER JOIN payhistory ph ON ph.customer = c.customer)
		INNER JOIN master m ON ph.number = m.number)
		LEFT OUTER JOIN payhistory r ON ph.uid = r.reverseofuid)
	WHERE ph.batchtype in ('PU','PA','PC')
		AND ((ph.systemyear = @SysYr AND ph.systemmonth <= @SysMo) OR (ph.systemyear < @SysYr)) 
		AND ((r.systemyear = @SysYr AND r.systemmonth > @SysMo) OR (r.systemyear > @SysYr)) 
		AND ph.Invoiced IS NULL 
		AND r.Invoiced IS NULL
		AND ph.matched = 'Y'
		AND r.matched = 'Y'
	UNION
	SELECT m.number, m.name AS [Debtor Name], ph.uid, ph.matched, p.customer AS [Parent], p.name AS [Parent Name], c.customer, c.name AS [Customer Name], c.invoicemethod, ph.systemmonth, 
		ph.systemyear, ph.invoiced, ph.batchtype, ph.datepaid, ph.paymethod, ph.invoiceflags, c.invoicetype,
		TotalPaid = 
		CASE 
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				ph.totalpaid 
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-ph.totalpaid 
			ELSE  0
		END, 
		InvoiceAmt = 
		CASE 
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		FeeAmt = 
		CASE 
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' OR ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' OR ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			ELSE  0
		END,
		PaidUs = 
		CASE
			WHEN ph.batchtype = 'PU' OR ph.batchtype = 'PA' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		PaidCust = 
		CASE
			WHEN ph.batchtype = 'PC' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			WHEN ph.batchtype = 'PCR' THEN 
				-(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10))
			ELSE  0
		END,
		DueUs = 
		CASE
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			ELSE  0
		END,
		DueCust = 
		CASE ph.batchtype
			WHEN 'PCR' THEN 
				(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			ELSE  0
		END,
		PURAmt = 
		CASE
			WHEN ph.batchtype = 'PUR' OR ph.batchtype = 'PAR' THEN 
				(dbo.InvoiceAmountTotal( ph.invoiceflags, ph.paid1,ph.paid2, ph.paid3, ph.paid4, ph.paid5, ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) - dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			ELSE  0
		END,
		PCRAmt = 
		CASE ph.batchtype
			WHEN 'PCR' THEN 
				(dbo.InvoiceAmountTotal (ph.invoiceflags, ph.fee1, ph.fee2, ph.fee3, ph.fee4, ph.fee5, ph.fee6, ph.fee7, ph.fee8, ph.fee9, ph.fee10))
			ELSE  0
		END
	FROM ((((Customer c INNER JOIN Customer p ON ISNULL(c.custgroup,c.customer) = p.customer) 
		INNER JOIN payhistory ph ON ph.customer = c.customer)
		INNER JOIN master m ON ph.number = m.number)
		LEFT OUTER JOIN payhistory r ON r.uid = ph.reverseofuid)
	WHERE ph.batchtype in ('PUR','PAR','PCR')
		AND ((ph.systemyear = @SysYr AND ph.systemmonth <= @SysMo) OR (ph.systemyear < @SysYr)) 
		AND ISNULL( ph.Invoiced, @MaxDate)>= DATEADD( m, 1, CONVERT(datetime, CAST(@SysYr AS varchar) + '-' + CAST((@SysMo) AS varchar) + '-1'))
		AND ISNULL(ph.matched, 'N') <> 'Y'
		AND ISNULL(r.invoiced, @MaxDate) <= DATEADD( m, 1, CONVERT(datetime, CAST(@SysYr AS varchar) + '-' + CAST((@SysMo) AS varchar) + '-1'))
	ORDER BY c.customer, m.number, ph.datepaid

GO

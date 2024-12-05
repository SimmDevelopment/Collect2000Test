SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
[dbo].[sp_Custom_SIMMDiscoverExcelInvoice]
'2007-03-13',
'2007-03-20',
'10001|10002',
0,
0,
0,
1
*/
CREATE PROCEDURE [dbo].[sp_Custom_SIMMDiscoverExcelInvoice]
@dateBegin datetime,
@dateEnd datetime,
@invoiceList varchar(8000),
@useDateEntered bit,
@useDateInvoiced bit,
@useDatePaid bit,
@useInvoiceNumbers bit
AS
BEGIN


	DECLARE @runDate datetime
	SET @dateEnd = CAST(CONVERT(varchar(10),@dateEnd,20) + ' 23:59:59.000' as datetime)	
	SET @runDate = getdate()
	SET @invoiceList = ISNULL(@invoiceList,'')
	CREATE TABLE #Payments(uid int,agencycode varchar(7),batchtype varchar(5))
	
	CREATE TABLE #PaymentCounts(agencycode varchar(7),PUCount int, PURCount int,PACount int,PARCount int, PCCount int,PCRCount int)
	
	INSERT INTO #Payments
	(uid,agencycode,batchtype)
	SELECT ph.uid,d.agencycode,ph.batchtype 
	FROM payhistory ph WITH(NOLOCK)
	INNER JOIN Discover_CustomerMapping d WITH(NOLOCK)
	ON d.customer = ph.customer
	WHERE ((@useInvoiceNumbers = 1 AND @InvoiceList IS NOT NULL AND CAST(ph.invoice as varchar(20)) IN(SELECT string FROM [dbo].[StringToSet](@invoiceList,'|'))) 
	 OR (@useDateEntered = 1 AND ph.entered BETWEEN @dateBegin AND @dateEnd)
	 OR (@useDatePaid = 1 AND ph.datepaid BETWEEN @dateBegin AND @dateEnd)
	 OR (@useDateInvoiced = 1 AND ph.invoiced BETWEEN @dateBegin AND @dateEnd))
	 AND ph.matched = 'N' AND ph.batchtype IN('PU','PUR','PA','PAR','PC','PCR') AND ph.customer = d.customer
	
	INSERT INTO #PaymentCounts
	(agencycode,PUCount, PURCount,PACount,PARCount,PCCount,PCRCount)
	SELECT DISTINCT d.agencycode,
	-- Find All PUs
	/*(SELECT COUNT(*) FROM payhistory ph WITH(NOLOCK)
	 WHERE ((@useInvoiceNumbers = 1 AND @InvoiceList IS NOT NULL AND CAST(ph.invoice as varchar(20)) IN(SELECT string FROM [dbo].[StringToSet](@invoiceList,'|'))) 
	 OR (@useDateEntered = 1 AND ph.entered BETWEEN @dateBegin AND @dateEnd)
	 OR (@useDatePaid = 1 AND ph.datepaid BETWEEN @dateBegin AND @dateEnd)
	 OR (@useDateInvoiced = 1 AND ph.invoiced BETWEEN @dateBegin AND @dateEnd))
	 AND ph.matched = 'N' AND ph.batchtype = 'PU' AND ph.customer = d.customer),*/
	(SELECT COUNT(*) FROM #Payments p WHERE p.agencycode = d.agencycode and p.batchtype = 'PU'),
	-- Find All PURs
	(SELECT COUNT(*) FROM #Payments p WHERE p.agencycode = d.agencycode and p.batchtype = 'PUR'),
	-- Find All PAs
	(SELECT COUNT(*) FROM #Payments p WHERE p.agencycode = d.agencycode and p.batchtype = 'PA'),
	-- Find All PARs	
	(SELECT COUNT(*) FROM #Payments p WHERE p.agencycode = d.agencycode and p.batchtype = 'PAR'),
	-- Find All PCs	
	(SELECT COUNT(*) FROM #Payments p WHERE p.agencycode = d.agencycode and p.batchtype = 'PC'),
	-- Find All PCRs	
	(SELECT COUNT(*) FROM #Payments p WHERE p.agencycode = d.agencycode and p.batchtype = 'PCR')	   	
    FROM Discover_CustomerMapping d
	
	SELECT * FROM #PaymentCounts
	
	SELECT m.number, m.customer, d.agencycode,m.account, m.name,
	convert(varchar(10),ph.datepaid,1) as datepaid,m.current0,
	ph.batchtype,
	CASE 
		WHEN ph.batchtype IN('PU','PA') THEN '51'
		WHEN ph.batchtype IN('PUR','PAR') THEN '56'
		WHEN ph.batchtype IN('PC') THEN '50'
		WHEN ph.batchtype IN('PCR') THEN '59'
	END as code,
	CASE 
		WHEN ph.batchtype IN('PU','PA') THEN [dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10)
		WHEN ph.batchtype IN('PUR','PAR') THEN [dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10)
		WHEN ph.batchtype IN('PC') THEN  0
		WHEN ph.batchtype IN('PCR') THEN  0
	END as paidAgency,
	CASE 
		WHEN ph.batchtype IN('PU','PA') THEN 0
		WHEN ph.batchtype IN('PUR','PAR') THEN 0
		WHEN ph.batchtype IN('PC') THEN  [dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10)
		WHEN ph.batchtype IN('PCR') THEN [dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10)
	END as paidClient,
	CASE 
		WHEN ph.batchtype IN('PU','PA') THEN [dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.fee1,ph.fee2,ph.fee3,ph.fee4,ph.fee5,ph.fee6,ph.fee7,ph.fee8,ph.fee9,ph.fee10)
		WHEN ph.batchtype IN('PUR','PAR') THEN ([dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10) 
			- [dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.fee1,ph.fee2,ph.fee3,ph.fee4,ph.fee5,ph.fee6,ph.fee7,ph.fee8,ph.fee9,ph.fee10))
		WHEN ph.batchtype IN('PC') THEN  [dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.fee1,ph.fee2,ph.fee3,ph.fee4,ph.fee5,ph.fee6,ph.fee7,ph.fee8,ph.fee9,ph.fee10)
		WHEN ph.batchtype IN('PCR') THEN  [dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.fee1,ph.fee2,ph.fee3,ph.fee4,ph.fee5,ph.fee6,ph.fee7,ph.fee8,ph.fee9,ph.fee10) 
	END as dueAgency,	
	CASE 
		WHEN ph.batchtype IN('PU','PA') THEN 
		[dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10)
		WHEN ph.batchtype IN('PUR','PAR') THEN 0
		WHEN ph.batchtype IN('PC') THEN  0
		WHEN ph.batchtype IN('PCR') THEN  0
	END as dueClient
	FROM payhistory ph WITH(NOLOCK)
	INNER JOIN master m WITH(NOLOCK)
	ON m.number = ph.number
	INNER JOIN Discover_CustomerMapping d
	ON d.customer = m.customer 
	WHERE ph.UID IN(SELECT UID FROM #Payments)
	ORDER BY d.agencycode,ph.datepaid,m.account
END

GO

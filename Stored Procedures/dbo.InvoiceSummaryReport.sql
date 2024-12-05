SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[InvoiceSummaryReport]
	@OrderByCustomer BIT ,
    @OnlyCustomersWithInvoice BIT ,
    @FromDate VARCHAR (25) ,
    @ToDate VARCHAR (25) ,
    @SysMonth VARCHAR (2) ,
    @SysYear VARCHAR (4) 
    
AS 
	IF @OnlyCustomersWithInvoice = 1   
	BEGIN --1 
		IF @OrderByCustomer = 1  --2
				BEGIN --4
				IF @FromDate = '' AND @ToDate = '' 
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
					FROM    dbo.InvoiceSummary  INNER JOIN dbo.Customer ON
					dbo.InvoiceSummary.customer = dbo.Customer.customer
					WHERE dbo.InvoiceSummary.Symonth = @SysMonth AND dbo.InvoiceSummary.Syyear = @SysYear
					ORDER BY InvoiceSummary.Customer, InvoiceSummary.Invoice ASC
				ELSE IF @ToDate = ''  -- Specific Date
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
					FROM    dbo.InvoiceSummary  INNER JOIN dbo.Customer ON
					dbo.InvoiceSummary.customer = dbo.Customer.customer
					WHERE dbo.InvoiceSummary.Tdate = CONVERT(DATETIME,@FromDate)
					ORDER BY InvoiceSummary.Customer, InvoiceSummary.Invoice ASC
				ELSE
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
					FROM    dbo.InvoiceSummary  INNER JOIN dbo.Customer ON
					dbo.InvoiceSummary.customer = dbo.Customer.customer
					WHERE dbo.InvoiceSummary.Tdate BETWEEN @FromDate AND  @ToDate
					ORDER BY InvoiceSummary.Customer, InvoiceSummary.Invoice ASC
				END --4
		ELSE --2 -- don't order by customer
				BEGIN --5
				IF @FromDate = '' AND @ToDate = '' 
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
					FROM dbo.InvoiceSummary  INNER JOIN dbo.Customer 
						ON dbo.InvoiceSummary.customer = dbo.Customer.customer
					WHERE dbo.InvoiceSummary.Symonth = @SysMonth AND dbo.InvoiceSummary.Syyear = @SysYear
					ORDER BY Customer.Name, InvoiceSummary.Invoice ASC
				ELSE IF @ToDate = ''   -- Specific Date
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
					FROM    dbo.InvoiceSummary  INNER JOIN dbo.Customer ON
					dbo.InvoiceSummary.customer = dbo.Customer.customer
					WHERE dbo.InvoiceSummary.Tdate = CONVERT(DATETIME,@FromDate)
					ORDER BY Customer.Name, InvoiceSummary.Invoice ASC
				ELSE
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
					FROM    dbo.InvoiceSummary  INNER JOIN dbo.Customer ON
					dbo.InvoiceSummary.customer = dbo.Customer.customer
					WHERE dbo.InvoiceSummary.Tdate BETWEEN @FromDate AND  @ToDate
					ORDER BY Customer.Name, InvoiceSummary.Invoice ASC
				END --5
	END --1
	ELSE --1   All Customers 
	BEGIN --3
		IF @OrderByCustomer = 1   --6
				BEGIN  --7 
				IF @FromDate = '' AND @ToDate = ''  
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
						FROM dbo.InvoiceSummary INNER JOIN dbo.Customer ON
						dbo.InvoiceSummary.customer = dbo.Customer.customer
						WHERE dbo.InvoiceSummary.Symonth = @SysMonth AND dbo.InvoiceSummary.Syyear = @SysYear
					UNION
					SELECT Customer.customer, Customer.Name, NULL AS Invoice, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
						FROM dbo.Customer
						WHERE customer.customer NOT IN (SELECT Customer.customer 
														FROM dbo.InvoiceSummary INNER JOIN dbo.Customer 
															ON dbo.InvoiceSummary.customer = dbo.Customer.customer
														WHERE dbo.InvoiceSummary.Symonth = @SysMonth AND dbo.InvoiceSummary.Syyear = @SysYear)
					ORDER BY Customer.Customer, Invoice ASC
				ELSE IF @ToDate =''  -- Specific Date
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
						FROM    dbo.InvoiceSummary INNER JOIN dbo.Customer ON
						dbo.InvoiceSummary.customer = dbo.Customer.customer
						WHERE dbo.InvoiceSummary.Tdate = CONVERT(DATETIME,@FromDate)
					UNION
					SELECT Customer.customer, Customer.Name, NULL AS Invoice, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
						FROM dbo.Customer
						WHERE customer.customer NOT IN (SELECT Customer.customer
														FROM dbo.InvoiceSummary INNER JOIN dbo.Customer 
															ON dbo.InvoiceSummary.customer = dbo.Customer.customer
														WHERE dbo.InvoiceSummary.Tdate = CONVERT(DATETIME,@FromDate))
					ORDER BY customer.Customer, Invoice ASC
				ELSE
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
						FROM    dbo.InvoiceSummary INNER JOIN dbo.Customer ON
						dbo.InvoiceSummary.customer = dbo.Customer.customer
						WHERE dbo.InvoiceSummary.Tdate BETWEEN @FromDate AND  @ToDate
					UNION
					SELECT Customer.customer, Customer.Name, NULL AS Invoice, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
						FROM dbo.Customer 
						WHERE customer.customer NOT IN (SELECT Customer.customer
														FROM dbo.InvoiceSummary INNER JOIN dbo.Customer
															ON dbo.InvoiceSummary.customer = dbo.Customer.customer
														WHERE dbo.InvoiceSummary.Tdate BETWEEN @FromDate AND  @ToDate)
					ORDER BY customer.Customer, Invoice ASC
				END --7
		ELSE --6 -- don't order by customer
				BEGIN --8
				IF @FromDate = '' AND @ToDate = '' 
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
						FROM dbo.InvoiceSummary INNER JOIN dbo.Customer ON
						dbo.InvoiceSummary.customer = dbo.Customer.customer
						WHERE dbo.InvoiceSummary.Symonth = @SysMonth AND dbo.InvoiceSummary.Syyear = @SysYear
					UNION
					SELECT Customer.customer, Customer.Name, NULL AS Invoice, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
						FROM dbo.Customer
						WHERE customer.customer NOT IN (SELECT Customer.customer 
														FROM dbo.InvoiceSummary INNER JOIN dbo.Customer 
															ON dbo.InvoiceSummary.customer = dbo.Customer.customer
														WHERE dbo.InvoiceSummary.Symonth = @SysMonth AND dbo.InvoiceSummary.Syyear = @SysYear)
					ORDER BY Customer.Name, Invoice ASC
				ELSE IF @ToDate = '' 
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
						FROM    dbo.InvoiceSummary INNER JOIN dbo.Customer ON
						dbo.InvoiceSummary.customer = dbo.Customer.customer
						WHERE dbo.InvoiceSummary.Tdate = CONVERT(DATETIME,@FromDate)
					UNION
					SELECT Customer.customer, Customer.Name, NULL AS Invoice, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
						FROM dbo.Customer
						WHERE customer.customer NOT IN (SELECT Customer.customer
														FROM dbo.InvoiceSummary INNER JOIN dbo.Customer 
															ON dbo.InvoiceSummary.customer = dbo.Customer.customer
														WHERE dbo.InvoiceSummary.Tdate = CONVERT(DATETIME,@FromDate))
					ORDER BY Customer.Name, Invoice ASC
				ELSE
					SELECT Customer.customer, Customer.Name, InvoiceSummary.Invoice, InvoiceSummary.AmountA, InvoiceSummary.AmountB, InvoiceSummary.AmountC, InvoiceSummary.AmountD, InvoiceSummary.AmountE, InvoiceSummary.AmountF 
						FROM    dbo.InvoiceSummary INNER JOIN dbo.Customer ON
						dbo.InvoiceSummary.customer = dbo.Customer.customer
						WHERE dbo.InvoiceSummary.Tdate BETWEEN @FromDate AND  @ToDate
					UNION
					SELECT Customer.customer, Customer.Name, NULL AS Invoice, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
						FROM dbo.Customer 
						WHERE customer.customer NOT IN (SELECT Customer.customer
														FROM dbo.InvoiceSummary INNER JOIN dbo.Customer
															ON dbo.InvoiceSummary.customer = dbo.Customer.customer
														WHERE dbo.InvoiceSummary.Tdate BETWEEN @FromDate AND  @ToDate)
					ORDER BY Customer.Name, Invoice ASC
				END --8
	END -- 3


SET ANSI_NULLS ON
GO

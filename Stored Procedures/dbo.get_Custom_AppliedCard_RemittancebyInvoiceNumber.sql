SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE     PROCEDURE [dbo].[get_Custom_AppliedCard_RemittancebyInvoiceNumber]
@Invoice_List           VARCHAR(1000),
@Batch_Type             VARCHAR(1000)
AS

SET NOCOUNT ON

-- Create the temp tables - temp tables are created in the SQL Server tempdb
DECLARE  @Temp_Data_Payments TABLE
(
number int,
datepaid datetime,
BatchType varchar(10),
PaymentDate datetime,
Customer varchar(10),
Matched varchar(1),
Invoice varchar(10),
Invoiced Datetime,
NetPaidAmount money,
Status varchar(10),
Qlevel varchar(10),
Current0 money,
Account varchar(100),
InvoiceFlags varchar(10),
PID int,
REVERSEPID int
)

-- Create the temp tables - temp tables are created in the SQL Server tempdb
DECLARE  @Temp_Data_Reversals TABLE
(
number int,
datepaid datetime,
BatchType varchar(10),
PaymentDate datetime,
Customer varchar(10),
Matched varchar(1),
Invoice varchar(10),
Invoiced Datetime,
NetPaidAmount money,
Status varchar(10),
Qlevel varchar(10),
Current0 money,
Account varchar(100),
InvoiceFlags varchar(10),
PID int,
REVERSEPID int
)


INSERT INTO @Temp_Data_Payments
SELECT A.number, A.datepaid, A.Batchtype,A.entered as PaymentDate, A.Customer, A.Matched, 
       A.Invoice, A.Invoiced,  
		case Len(rtrim(ltrim(batchtype))) 
			WHEN 2 THEN [dbo].[DetermineInvoicedAmount](A.invoiceflags,A.paid1,A.paid2,A.paid3,A.paid4,A.paid5,A.paid6,A.paid7,A.paid8,A.Paid9,A.paid10)
			ELSE   [dbo].[DetermineInvoicedAmount](A.invoiceflags,A.paid1,A.paid2,A.paid3,A.paid4,A.paid5,A.paid6,A.paid7,A.paid8,A.Paid9,A.paid10) *-1 
		end as NetPaidAmount,
       B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID, 0 as REVERSEPID 
FROM dbo.CustomStringToSet(@Invoice_List, '|') csts,
     payhistory A with (nolock), 
     Master B with (nolock)
WHERE (matched = 'N') and 
      (INVOICE = csts.String) and 
      ([dbo].[DetermineInvoicedAmount](A.invoiceflags,A.paid1,A.paid2,A.paid3,A.paid4,A.paid5,A.paid6,A.paid7,A.paid8,A.Paid9,A.paid10)) <> 0 and 
      (A.Number = B.Number) AND 
      batchtype in (SELECT STS.String FROM StringToSet(@Batch_Type, '|') STS WHERE STS.idPos = '1')


INSERT INTO @Temp_Data_Reversals
SELECT A.number, A.datepaid, A.Batchtype,A.entered as PaymentDate, A.Customer, A.Matched, 
       A.Invoice, A.Invoiced,  
		case Len(rtrim(ltrim(batchtype))) 
			WHEN 2 THEN [dbo].[DetermineInvoicedAmount](A.invoiceflags,A.paid1,A.paid2,A.paid3,A.paid4,A.paid5,A.paid6,A.paid7,A.paid8,A.Paid9,A.paid10)
			ELSE   [dbo].[DetermineInvoicedAmount](A.invoiceflags,A.paid1,A.paid2,A.paid3,A.paid4,A.paid5,A.paid6,A.paid7,A.paid8,A.Paid9,A.paid10) *-1 
		end as NetPaidAmount,
       B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID,A.ReverseOfUid as REVERSEPID 
FROM dbo.CustomStringToSet(@Invoice_List, '|') csts,
     payhistory A with (nolock), 
     Master B with (nolock)
WHERE (matched = 'N') and 
      (INVOICE = csts.String) and 
      ([dbo].[DetermineInvoicedAmount](A.invoiceflags,A.paid1,A.paid2,A.paid3,A.paid4,A.paid5,A.paid6,A.paid7,A.paid8,A.Paid9,A.paid10)) <> 0 and 
      (A.Number = B.Number) AND 
      batchtype in (SELECT STS.String FROM StringToSet(@Batch_Type, '|') STS WHERE STS.idPos = '2')



-- Retreive the appropriate data.
select * from @temp_data_payments dp
where dp.number not in(select Number 
                       from @temp_data_Reversals dr
                       where dr.number = dp.number and
                             abs(dr.netpaidamount) = abs(dp.netpaidamount) and
                             dr.Customer = dp.customer and
                             dr.account = dp.account AND 
			dp.PID = dr.REVERSEPID
                       )
UNION
select * from @temp_data_Reversals dr
where dr.number not in(select Number 
                       from @temp_data_Payments dp
                       where dr.number = dp.number and
                             abs(dr.netpaidamount) = abs(dp.netpaidamount) and
                             dp.Customer = dr.customer and 
                             dp.account = dr.account   AND 
			dp.PID = dr.REVERSEPID
                       )


SET NOCOUNT OFF
RETURN

-- GO

/************
--DEPRECATED
************/
-- INSERT INTO #Temp_Data_Payments
-- SELECT A.number, A.datepaid, A.Batchtype,A.entered as PaymentDate, A.Customer, A.Matched, 
--        A.Invoice, A.Invoiced,  case Len(rtrim(ltrim(batchtype)))WHEN 2 THEN ((A.paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+ (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+ (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) ))  else (((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+  (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+  (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) )) * -1) end as NetPaidAmount, 
--        B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID 
-- FROM payhistory A with (nolock), 
--      Master B with (nolock)
-- WHERE (matched = 'N') and 
--       (INVOICE in (@Invoice_List)) and 
--       (A.Paid1+A.Paid2+A.Paid3+A.Paid4+A.Paid5+A.Paid6+A.Paid7+A.Paid8+A.Paid9+A.Paid10) <> 0 and 
--       (A.Number = B.Number) AND 
--       (b.Current1 > 0.00 ) and 
--       (batchtype in ('PU','PUR'))


-- INSERT INTO #Temp_Data_Payments
-- SELECT A.number, A.datepaid,A.BatchType, A.entered as PaymentDate, A.Customer, A.matched, 
--        A.invoice, A.Invoiced,   case Len(rtrim(ltrim(batchtype)))WHEN 2 THEN ((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+  (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+  (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+  (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) ))   else (((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+    (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+    (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* 
--        convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+   (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) )) * -1) end as NetPaidAmount,   B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID  
-- FROM payhistory A with (nolock),
--      Master B with (nolock)
-- WHERE (A.matched = 'N') and 
--       (A.INVOICED between @Invoice_Begin_Date and @Invoice_End_Date) and 
--       (A.customer in (@Customer_list)) and 
--       (A.Paid1+A.Paid2+A.Paid3+A.Paid4+A.Paid5+A.Paid6+A.Paid7+A.Paid8+A.Paid9+A.Paid10)  <> 0 and 
--       (A.number = B.Number) AND 
--       (b.Current1 > 0.00) and 
--       batchtype in (SELECT STS.String FROM StringToSet(@Batch_Type, '|') STS WHERE STS.idPos = '1')


-- INSERT INTO #Temp_Data_Reversals
-- SELECT A.number, A.datepaid,A.BatchType, A.entered as PaymentDate, A.Customer, A.matched, 
--        A.invoice, A.Invoiced,   case Len(rtrim(ltrim(batchtype)))WHEN 2 THEN ((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+  (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+  (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+  (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) ))   else (((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+    (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+    (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* 
--        convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+   (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) )) * -1) end as NetPaidAmount,   B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID  
-- FROM payhistory A with (nolock),
--      Master B with (nolock)
-- WHERE (A.matched = 'N') and 
--       (A.INVOICED between @Invoice_Begin_Date and @Invoice_End_Date) AND
--       (A.customer in (@Customer_List)) and 
--       (A.Paid1+A.Paid2+A.Paid3+A.Paid4+A.Paid5+A.Paid6+A.Paid7+A.Paid8+A.Paid9+A.Paid10)  <> 0 and 
--       (A.number = B.Number) AND 
--       (b.Current1 > 0.00) and 
--       batchtype in (SELECT STS.String FROM StringToSet(@Batch_Type, '|') STS WHERE STS.idPos = '2')

-- -- Create the temp tables - temp tables are created in the SQL Server tempdb
-- CREATE TABLE #Temp_Data_Payments
-- (
-- number int,
-- datepaid datetime,
-- BatchType varchar(10),
-- PaymentDate datetime,
-- Customer varchar(10),
-- Matched varchar(1),
-- Invoice varchar(10),
-- Invoiced Datetime,
-- NetPaidAmount money,
-- Status varchar(10),
-- Qlevel varchar(10),
-- Current0 money,
-- Account varchar(100),
-- InvoiceFlags varchar(10),
-- PID int
-- )
-- 
-- -- Create the temp tables - temp tables are created in the SQL Server tempdb
-- CREATE TABLE #Temp_Data_Reversals
-- (
-- number int,
-- datepaid datetime,
-- BatchType varchar(10),
-- PaymentDate datetime,
-- Customer varchar(10),
-- Matched varchar(1),
-- Invoice varchar(10),
-- Invoiced Datetime,
-- NetPaidAmount money,
-- Status varchar(10),
-- Qlevel varchar(10),
-- Current0 money,
-- Account varchar(100),
-- InvoiceFlags varchar(10),
-- PID int
-- )


-- INSERT INTO @Temp_Data_Payments
-- SELECT A.number, A.datepaid, A.Batchtype,A.entered as PaymentDate, A.Customer, A.Matched, 
--        A.Invoice, A.Invoiced,  case Len(rtrim(ltrim(batchtype)))WHEN 2 THEN ((A.paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+ (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+ (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) ))  else (((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+  (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+  (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) )) * -1) end as NetPaidAmount, 
--        B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID 
-- FROM dbo.CustomStringToSet(@Invoice_List, '|') csts,
--      payhistory A with (nolock), 
--      Master B with (nolock)
-- WHERE (matched = 'N') and 
--       (INVOICE = csts.String) and 
--       (A.Paid1+A.Paid2+A.Paid3+A.Paid4+A.Paid5+A.Paid6+A.Paid7+A.Paid8+A.Paid9+A.Paid10) <> 0 and 
--       (A.Number = B.Number) AND 
--       (b.Current1 > 0.00 ) and 
--       batchtype in (SELECT STS.String FROM StringToSet(@Batch_Type, '|') STS WHERE STS.idPos = '1')
-- 
-- 
-- INSERT INTO @Temp_Data_Reversals
-- SELECT A.number, A.datepaid, A.Batchtype,A.entered as PaymentDate, A.Customer, A.Matched, 
--        A.Invoice, A.Invoiced,  case Len(rtrim(ltrim(batchtype)))WHEN 2 THEN ((A.paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+ (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+ (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) ))  else (((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+  (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+  (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) )) * -1) end as NetPaidAmount, 
--        B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID 
-- FROM dbo.CustomStringToSet(@Invoice_List, '|') csts,
--      payhistory A with (nolock), 
--      Master B with (nolock)
-- WHERE (matched = 'N') and 
--       (INVOICE = csts.String) and 
--       (A.Paid1+A.Paid2+A.Paid3+A.Paid4+A.Paid5+A.Paid6+A.Paid7+A.Paid8+A.Paid9+A.Paid10) <> 0 and 
--       (A.Number = B.Number) AND 
--       (b.Current1 > 0.00 ) and 
--       batchtype in (SELECT STS.String FROM StringToSet(@Batch_Type, '|') STS WHERE STS.idPos = '2')







GO

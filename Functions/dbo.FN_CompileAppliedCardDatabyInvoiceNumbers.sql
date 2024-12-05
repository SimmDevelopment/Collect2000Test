SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO


CREATE  FUNCTION [dbo].[FN_CompileAppliedCardDatabyInvoiceNumbers](@Invoice_List VARCHAR(1000), @Batch_Type VARCHAR(1000))
RETURNS @Data 
TABLE
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
PID int
)
AS 

BEGIN
-- Create the in-memory temp tables
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
PID int
)
-- Create the in-memory temp tables
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
PID int
)

-- Compile the payments
INSERT INTO @Temp_Data_Payments
SELECT A.number, A.datepaid, A.Batchtype,A.entered as PaymentDate, A.Customer, A.Matched, 
       A.Invoice, A.Invoiced,  case Len(rtrim(ltrim(batchtype)))WHEN 2 THEN ((A.paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+ (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+ (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) ))  else (((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+  (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+  (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) )) * -1) end as NetPaidAmount, 
       B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID 
FROM dbo.CustomStringToSet(@Invoice_List, '|') csts,
     payhistory A with (nolock), 
     Master B with (nolock)
WHERE (matched = 'N') and 
      (INVOICE = csts.String) and 
      (A.Paid1+A.Paid2+A.Paid3+A.Paid4+A.Paid5+A.Paid6+A.Paid7+A.Paid8+A.Paid9+A.Paid10) <> 0 and 
      (A.Number = B.Number) AND 
      (b.Current1 > 0.00 ) and 
      batchtype in (SELECT STS.String FROM StringToSet(@Batch_Type, '|') STS WHERE STS.idPos = '1')

--Compile the reversals
INSERT INTO @Temp_Data_Reversals
SELECT A.number, A.datepaid, A.Batchtype,A.entered as PaymentDate, A.Customer, A.Matched, 
       A.Invoice, A.Invoiced,  case Len(rtrim(ltrim(batchtype)))WHEN 2 THEN ((A.paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+ (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+ (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) ))  else (((A.Paid1)* convert(tinyint,substring(invoiceflags,1,1) )+(A.Paid2)* convert(tinyint,substring(invoiceflags,2,1) )+  (A.Paid3)* convert(tinyint,substring(invoiceflags,3,1) )+(A.Paid4)* convert(tinyint,substring(invoiceflags,4,1) )+(A.Paid5)* convert(tinyint,substring(invoiceflags,5,1) )+  (A.Paid6)* convert(tinyint,substring(invoiceflags,6,1) )+ (A.Paid7)* convert(tinyint,substring(invoiceflags,7,1) )+(A.Paid8)* convert(tinyint,substring(invoiceflags,8,1) )+ (A.Paid9)* convert(tinyint,substring(invoiceflags,9,1) )+(A.Paid10)* convert(tinyint,substring(invoiceflags,10,1) )) * -1) end as NetPaidAmount, 
       B.Status, B.Qlevel, B.Current0, B.Account, A.InvoiceFlags, A.UID as PID 
FROM dbo.CustomStringToSet(@Invoice_List, '|') csts,
     payhistory A with (nolock), 
     Master B with (nolock)
WHERE (matched = 'N') and 
      (INVOICE = csts.String) and 
      (A.Paid1+A.Paid2+A.Paid3+A.Paid4+A.Paid5+A.Paid6+A.Paid7+A.Paid8+A.Paid9+A.Paid10) <> 0 and 
      (A.Number = B.Number) AND 
      (b.Current1 > 0.00 ) and 
      batchtype in (SELECT STS.String FROM StringToSet(@Batch_Type, '|') STS WHERE STS.idPos = '2')

-- Push the data into the return table.
INSERT @Data
select * from @temp_data_payments dp
where dp.number not in(select Number 
                       from @temp_data_Reversals dr
                       where dr.number = dp.number and
                             abs(dr.netpaidamount) = abs(dp.netpaidamount) and
                             dr.Customer = dp.customer and
                             dr.account = dp.account
                       )
-- Push the data into the return table.
INSERT @Data
select * from @temp_data_Reversals dr
where dr.number not in(select Number 
                       from @temp_data_Payments dp
                       where dr.number = dp.number and
                             abs(dr.netpaidamount) = abs(dp.netpaidamount) and
                             dp.Customer = dr.customer and 
                             dp.account = dr.account
                       )

-- Return to the caller.
RETURN
END

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[TempUpdateOI]
	@InvNum int
AS

Declare @InvDate datetime
Declare @Amount money
Declare @SysMonth tinyInt
Declare @SysYear smallint
Declare @Cust varchar(7)
Declare @Err int

Select @InvDate =  TDate, @SysYear=SyYear, @SysMonth=SyMonth, @Amount=AmountD, @Cust=Customer
From InvoiceSummary Where Invoice=@InvNum

if @@Rowcount = 0
	Return 1

Insert Into OpenItem(Invoice, TDate, SyYear, SyMonth, Customer, Amount, Retired)
Values (@InvNum, @InvDate, @SysYear, @SysMonth, @Cust, @Amount, 0)

set @Err = @@Error
IF @Err <> 0
	Return 2

Insert Into OpenItemTransactions (Amount, Invoice, TransDate, TransType, Comment)
Values (@Amount, @InvNum, @InvDate, 1, 'Opening Balance')

set @Err = @@Error
IF @Err <> 0
	Return 3
GO

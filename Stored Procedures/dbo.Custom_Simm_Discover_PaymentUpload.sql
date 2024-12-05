SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
[dbo].[Custom_Simm_Discover_PaymentUpload]
'0000000|0000001',
'2001-01-01',
'2007-12-01',
'10001|10002', 
'', 
'PC'

[dbo].[Custom_Simm_Discover_PaymentUpload]
'0000000|0000001',
'2001-01-01',
'2007-12-01',
'10001|10002', 
'Invoice', 
'PU'
*/

CREATE PROCEDURE [dbo].[Custom_Simm_Discover_PaymentUpload]
@Customer varchar(8000),
@DateBegin datetime,
@DateEnd datetime,
@Invoice varchar(8000),
@Criteria varchar(9),
@PayMethod varchar(2)
AS
-- Variable declaration.
DECLARE @runDate datetime
SET @runDate=getdate()
SET @DateBegin = @DateBegin + '00:00:00.000'
SET @DateEnd = @DateEnd + '23:59:59.000'


BEGIN
 If @Criteria = 'Invoice' 
 Begin
	Select Replace(Convert(varchar(10), @runDate, 101), '/', '') as date, m.account as accountNumber, 
    [dbo].[DetermineInvoicedAmount](ph.invoiceflags, ph.paid1, ph.paid2, ph.paid3, ph.paid4, ph.paid5,
	ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) *100 as balance, m.name,
	case when charindex(',',m.name,1)> 0 then rtrim(ltrim(left(m.name,charindex(',',m.name,1)-1))) else m.name end as lastName,
	case  when charindex(',',m.name,1)> 0 then rtrim(ltrim(SUBSTRING(m.name,charindex(',',m.name,1)+1,len(m.name)-charindex(',',m.name,1))))
    else '' end as firstName

	From master m with (nolock)
	inner join payhistory ph with (nolock)
	on m.number = ph.number 
	inner join debtors d with (nolock)
	on m.number = d.number
	where m.customer in (SELECT string from [dbo].[StringToSet](@Customer, '|'))
	and ph.invoice IN(SELECT string from [dbo].[StringToSet](@Invoice, '|')) 
    and ph.batchtype = @PayMethod 
 End 

 Else
 Begin 
	Select Replace(Convert(varchar(10), @runDate, 101), '/', '') as date, m.account as accountNumber, 
    [dbo].[DetermineInvoicedAmount](ph.invoiceflags, ph.paid1, ph.paid2, ph.paid3, ph.paid4, ph.paid5,
	ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) as balance, m.name,
	case when charindex(',',m.name,1)> 0 then rtrim(ltrim(left(m.name,charindex(',',m.name,1)-1))) else m.name end as lastName,
	case  when charindex(',',m.name,1)> 0 then rtrim(ltrim(SUBSTRING(m.name,charindex(',',m.name,1)+1,len(m.name)-charindex(',',m.name,1))))
    else '' end as firstName

	From master m with (nolock)
	inner join payhistory ph with (nolock)
	on m.number = ph.number
	inner join debtors d with (nolock)
	on m.number = d.number
	where m.customer in (SELECT string from [dbo].[StringToSet](@Customer, '|'))
	and ph.invoiced between @DateBegin and @DateEnd
	and ph.batchtype = @PayMethod
 End 

END
GO

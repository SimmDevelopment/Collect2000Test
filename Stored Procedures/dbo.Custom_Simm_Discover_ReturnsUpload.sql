SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
exec [Custom_Simm_Discover_ReturnsUpload]
'0000711|0000785|0000926|0000955|0000998|0000999'
*/

CREATE PROCEDURE [dbo].[Custom_Simm_Discover_ReturnsUpload]
@Customer varchar(8000)
AS
-- Variable declaration.
DECLARE @runDate datetime
SET @runDate=getdate()


BEGIN

Create Table #Info (accountNumber varchar(30), number int, customer varchar(7), closedDate datetime, qlevel varchar(3), 
                         qdate varchar(8), returnedDate datetime, status varchar(5), agencyCode varchar(5))

Insert into #Info (accountNumber, number, customer, closedDate, qlevel, qdate, returnedDate, status, agencyCode)
Select m.account, m.number, m.customer, m.closed, m.qlevel, m.qdate, m.returned, m.status, '' as agencyCode
	From master m with (nolock)
	Where m.customer in (SELECT string from [dbo].[StringToSet](@Customer, '|')) and qlevel = '998'
	and ((status in ('PIF', 'SIF') and datediff(day,ISNULL(LastPaid, GETDATE()),getdate())>20) OR (status IN('AEX'))) 

	update master 
	set qlevel = '999', qdate = dbo.makeqdate(@runDate), returned = dbo.date(@rundate)
	where number in (select number from #info)

	Insert into notes (number, created, user0, action, result, comment)
	select number, @rundate, 'Discover', '+++++', '+++++', 'Account returned to Customer.'
	from #Info

	Select i.accountNumber, i.customer, i.closedDate, dbo.date(getdate()) as returnedDate, case i.status when 'PIF' then 'P' when 'SIF' then 'S' when 'AEX' then 'X' end as closeCode, d.agencyCode
	from #Info i Inner join discover_customerMapping d with (nolock) on i.customer = d.customer


/*

	
	Create Table #Info (accountNumber varchar(30), number int, customer varchar(7), closedDate datetime, qlevel varchar(3), 
                         qdate varchar(8), returnedDate datetime, status varchar(5), agencyCode varchar(5))

	Insert into #Info (accountNumber, number, customer, closedDate, qlevel, qdate, returnedDate, status, agencyCode)
	Select m.account, m.number, m.customer, m.closed, m.qlevel, m.qdate, m.returned, m.status, ''--d.agencyCode 
	From master m with (nolock)
--	Inner join discover_customerMapping d with (nolock)
--	on m.customer = d.customer
	Where m.customer in (SELECT string from [dbo].[StringToSet](@Customer, '|'))
	and m.status in ('PIF', 'SIF', 'AEX') and m.qlevel = '998' 
    --and ((datediff(day, m.closed, @runDate) > 30) or ((status in ('AEX')) and datediff(day, m.closed, @runDate)>30)

--	update master 
--	set qlevel = '999', qdate = @runDate, returned = i.returned
--	where number in (select number from #info)

--	Insert into notes (number, created, user0, action, result, comment)
--	select number, @rundate, 'Discover', '+++++', '+++++', 'Account returned to Customer.'
--	from #Info

	Select i.accountNumber, i.number, i.customer, i.closedDate, i.qlevel, i.qdate, i.returnedDate, i.status, i.agencyCode from #Info i
	
-- If @Criteria = 'Invoice' 
-- Begin
--	Select Replace(Convert(varchar(10), @runDate, 101), '/', '') as date, m.account, 
--    [dbo].[DetermineInvoicedAmount](ph.invoiceflags, ph.paid1, ph.paid2, ph.paid3, ph.paid4, ph.paid5,
--	ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) as totalpaid, m.name
--
--	From master m with (nolock)
--	inner join payhistory ph with (nolock)
--	on m.number = ph.number
--	where m.customer in (SELECT string from [dbo].[StringToSet](@Customer, '|'))
--	and ph.invoice IN(SELECT string from [dbo].[StringToSet](@Invoice, '|')) 
--    and ph.batchtype = @PayMethod 
-- End 
--
-- Else
-- Begin 
--	Select Replace(Convert(varchar(10), @runDate, 101),'/', '') as date, m.account, 
--    [dbo].[DetermineInvoicedAmount](ph.invoiceflags, ph.paid1, ph.paid2, ph.paid3, ph.paid4, ph.paid5,
--	ph.paid6, ph.paid7, ph.paid8, ph.paid9, ph.paid10) as totalpaid, m.name
--
--	From master m with (nolock)
--	inner join payhistory ph with (nolock)
--	on m.number = ph.number
--	where m.customer in (SELECT string from [dbo].[StringToSet](@Customer, '|'))
--	and ph.invoiced between @DateBegin and @DateEnd
--	and ph.batchtype = @PayMethod
-- End 
*/

END
GO

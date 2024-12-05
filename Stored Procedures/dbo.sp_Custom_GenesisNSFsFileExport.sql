SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




/*

DECLARE @customer varchar(8000)
DECLARE @invoiceBegin datetime
DECLARE @invoiceEnd datetime
DECLARE @invoice varchar(8000)
SET @invoiceBegin = '20070205'
SET @invoiceEnd = '20070211'
SET @customer = '0000858|0000901|0000919|0000920|'
SET @invoice = '10321|10320|10319|10318|'
EXEC [sp_Custom_GenesisNSFsFileExport] @invoice
--@customer, @invoiceBegin, @invoiceEnd

*/

CREATE      PROCEDURE [dbo].[sp_Custom_GenesisNSFsFileExport]
@invoice varchar(8000)
--@customer varchar(8000),
--@invoiceBegin datetime,
--@invoiceEnd datetime
AS
BEGIN
	DECLARE @runDate as datetime
	SET @runDate = getdate()
	
	--SET @invoiceEnd = CAST(CONVERT(varchar(10),@invoiceEnd,20) + ' 23:59:59.000' as datetime)	
	
	SELECT 
	CONVERT(varchar(8),@runDate,112) as fileDate,
	m.account as account,
	case 	when m.customer = '0000901' then '2SIM01-SIR'
		when m.customer = '0000919' then '3SIM01-CGL'
		when m.customer = '0000920' then '3SIM02-CHV'
		when m.customer = '0000933' then '2SIM02-MCB'
		when m.customer = '0000934' then '2SIM03-MCB'
		when m.customer = '0000977' then '3SIM05-GEC'
		when m.customer = '0000978' then '3SIM04-GEC'
		when m.customer = '0000994' then '3SIM07-GEC'
		when m.customer = '0000995' and m.originalcreditor = 'MONTEREY COUNTY BANK' then '3SIM08-MCB'
		when m.customer = '0000995' and m.originalcreditor = 'WebBank' then '3SIM08-WBK'
	end  as placementId,
	m.current0 as currentBalance,
	CONVERT(varchar(8),ph.datepaid,112) as payDate,
	-1*[dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10) as totalPaid,
	(select substring(f.name,1,5) from customer c join feeschedules f on f.code = c.feeschedule where c.customer = m.customer) as commRate,
	([dbo].[DetermineInvoicedAmount](ph.invoiceflags,ph.paid1,ph.paid2,ph.paid3,ph.paid4,ph.paid5,ph.paid6,ph.paid7,ph.paid8,ph.paid9,ph.paid10) * (select (cast(substring(f.name,1,2) as int) * .01) from customer c join feeschedules f on f.code = c.feeschedule where c.customer = m.customer)) as totalFees,
	'NSF' as note
	FROM master m WITH(NOLOCK)
	INNER JOIN payhistory ph WITH(NOLOCK)
	ON ph.number = m.number
	WHERE --ph.invoiced BETWEEN @invoiceBegin AND @invoiceEnd AND
	batchtype IN('PUR') and matched = 'N' AND
	--m.customer IN(SELECT string FROM dbo.CustomStringToSet(@customer, '|')) and
	ph.invoice in (SELECT string FROM dbo.CustomStringToSet(@invoice, '|'))	
	ORDER BY ph.datepaid	
END
GO

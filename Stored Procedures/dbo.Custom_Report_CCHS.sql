SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
declare @Invoice varchar(8000)
declare @customer varchar(8000)
set @customer='0000527|'
set @Invoice= '10326|10324|'
exec custom_report_CCHS @Invoice, @customer

*/

CREATE   PROCEDURE [dbo].[Custom_Report_CCHS]
	@invoice varchar(8000),
	@customer varchar(8000)
AS
BEGIN

	SELECT
		m.Account AS Account,
		m.Name AS Name,
		CASE WHEN p.batchtype in ('PUR','PCR','PAR') then (dbo.Custom_CalculatePaymentTotalPaid (p.uid)*-1) else dbo.Custom_CalculatePaymentTotalPaid (p.uid) end AS Amount,
		p.datepaid AS Date,
		m.current1 AS Balance
		,p.matched
	FROM master m WITH (NOLOCK)
	JOIN payhistory p WITH (NOLOCK)
	ON p.number=m.number
	WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))	
	AND p.batchtype not in ('DA','DAR','PC','PCR')

END

GO

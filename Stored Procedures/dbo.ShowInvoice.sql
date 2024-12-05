SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ShowInvoice] 
@Inv int
AS
select 'invoicesummary' as _invoicesummary, * from invoicesummary where invoice = @Inv
select 'openitem' as _openitem, * from openitem where invoice = @Inv
select 'openitemtransactions' as _openitemtransactions, * from openitemtransactions where invoice = @Inv
select 'bankentries' as _bankentries, * from bankentries where invoice = @Inv
--select 'ServiceInvoiceTaxItems' as _ServiceInvoiceTaxItems, * from ServiceInvoiceTaxItems S, TaxAuthority T where S.invoiceid = @Inv and S.TaxAuthorityId = T.Id
select 'payhistory' as _payhistory, * from payhistory where invoice = @Inv
--select 'payhistoryCharges' as _payhistoryCharges, * from payhistorycharges where payhistoryid in (select uid from payhistory where invoice = @Inv)
--select 'payhistoryTaxItems' as _payhistoryTaxItems, * from payhistoryTaxItems where payhistoryid in (select uid from payhistory where invoice = @Inv)
select 'legal_ledger' as _legal_ledger, * from legal_ledger where invoice = @Inv
--select 'ContraTransactionLog' as From_ContraTransactionLog, * from ContraTransactionLog where frominvoice = @Inv
--select 'ContraTransactionLog' as To_ContraTransactionLog, * from ContraTransactionLog where toinvoice = @Inv
GO

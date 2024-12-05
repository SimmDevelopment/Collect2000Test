SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ShowAccount]
@AcctNumber int
 AS

select 'master' as _master,  * from master where number = @AcctNumber
select 'debtors' as _debtors,  * from debtors where number = @AcctNumber order by seq
select 'payhistory' as _payhistory,  * from payhistory where number = @AcctNumber order by uid
--select 'payhistoryCharges' as _payhistoryCharges, * from payhistorycharges where Accountid = @AcctNumber
select 'legal_ledger' as _legal_ledger, * from legal_ledger where payhistoryid in (select uid from payhistory where number = @AcctNumber)
select 'notes' as _notes,  * from notes where number = @AcctNumber order by created
--select 'payhistoryTaxItems' as _payhistoryTaxItems, * from payhistoryTaxItems where Accountid = @AcctNumber

select 'bankruptcy' as _bankruptcy,  * from bankruptcy where accountid = @AcctNumber
select 'debtorattorneys' as _debtorattorneys,  * from debtorattorneys where accountid = @AcctNumber
select 'restrictions' as _restrictions,  * from restrictions where number = @AcctNumber
GO

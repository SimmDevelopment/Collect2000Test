SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_Uninvoice]
@invoiceId int

AS
DELETE FROM AIM_LedgerInvoiceSummary WHERE LedgerInvoiceId = @invoiceId
DELETE FROM AIM_LedgerInvoice WHERE LedgerInvoiceId = @invoiceId
DELETE FROM AIM_LedgerInvoiceGroup WHERE LedgerInvoiceId = @invoiceId
DELETE FROM AIM_LedgerInvoiceType WHERE LedgerInvoiceId = @invoiceId
DELETE FROM AIM_LedgerInvoicePortfolio WHERE LedgerInvoiceId = @invoiceId
UPDATE AIM_Ledger SET ToInvoiceId = null WHERE ToInvoiceId = @invoiceId
UPDATE AIM_Ledger SET FromInvoiceId = null WHERE FromInvoiceId = @invoiceId



GO

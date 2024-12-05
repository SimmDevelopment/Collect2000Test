SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_InsertInvoiceSummary]
@invoiceId int,
@groupId int,
@credit money,
@debit money,
@net money,
@gross money

AS

BEGIN
INSERT INTO AIM_LedgerInvoiceSummary
(LedgerInvoiceId,GroupId,SumCredit,SumDebit,Net,Gross,Outstanding)
VALUES
(@invoiceId,@groupId,@credit,@debit,@net,@gross,1)

--SELECT @@identity

END


GO

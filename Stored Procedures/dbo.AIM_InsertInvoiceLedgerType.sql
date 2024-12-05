SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_InsertInvoiceLedgerType]
@invoiceId int,
@ledgertypeId int

AS

DECLARE @containedData bit
DECLARE @count int
SET @containedData = 0
SET @count = 0

SELECT @count = count(*) FROM AIM_Ledger WHERE LedgerTypeId = @ledgertypeId AND (ToInvoiceId = @invoiceId OR FromInvoiceId = @invoiceId)

IF(@count > 0)
	SET @containedData = 1


INSERT INTO AIM_LedgerInvoiceType
(LedgerInvoiceID,LedgerTypeId,ContainedEntries)
VALUES
(@invoiceId,@ledgertypeId,@containedData)

GO

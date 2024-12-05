SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_InsertInvoicePortfolio]
@invoiceId int,
@portfolioId int

AS

DECLARE @containedData bit
DECLARE @count int
SET @containedData = 0
SET @count = 0

SELECT @count = count(*) FROM AIM_Ledger WHERE PortfolioId = @portfolioId AND (ToInvoiceId = @invoiceId OR FromInvoiceId = @invoiceId)

IF(@count > 0)
	SET @containedData = 1


INSERT INTO AIM_LedgerInvoicePortfolio
(LedgerInvoiceID,PortfolioID,ContainedData)
VALUES
(@invoiceId,@portfolioId,@containedData)


GO

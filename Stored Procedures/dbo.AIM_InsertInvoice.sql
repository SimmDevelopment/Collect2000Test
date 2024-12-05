SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_InsertInvoice]
@portfolioId int,
@hasBuyers bit,
@hasSellers bit,
@hasInvestors bit,
@hasManagement bit,
@invoiceDate datetime

AS

BEGIN
INSERT INTO AIM_LedgerInvoice
(PortfolioId,Buyers,Sellers,Investors,Management,InvoiceDate)
VALUES
(@portfolioId,@hasBuyers,@hasSellers,@hasInvestors,@hasManagement,@invoiceDate)


SELECT @@identity 

END

GO

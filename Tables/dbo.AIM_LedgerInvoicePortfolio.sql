CREATE TABLE [dbo].[AIM_LedgerInvoicePortfolio]
(
[LedgerInvoicePortfolioId] [int] NOT NULL IDENTITY(1, 1),
[LedgerInvoiceId] [int] NULL,
[PortfolioId] [int] NULL,
[ContainedData] [bit] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for whether the invoice contained data for this portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoicePortfolio', 'COLUMN', N'ContainedData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated ledger invoice id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoicePortfolio', 'COLUMN', N'LedgerInvoiceId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoicePortfolio', 'COLUMN', N'LedgerInvoicePortfolioId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated portfolio for the invoice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoicePortfolio', 'COLUMN', N'PortfolioId'
GO

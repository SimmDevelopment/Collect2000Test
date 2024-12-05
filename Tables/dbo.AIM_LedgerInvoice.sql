CREATE TABLE [dbo].[AIM_LedgerInvoice]
(
[LedgerInvoiceID] [int] NOT NULL IDENTITY(1, 1),
[PortfolioId] [int] NULL,
[Buyers] [bit] NULL,
[Sellers] [bit] NULL,
[Investors] [bit] NULL,
[InvoiceDate] [datetime] NULL,
[management] [bit] NULL,
[Invoiced] [datetime] NULL CONSTRAINT [DF__AIM_Ledge__Invoi__3E38A332] DEFAULT (getdate())
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'flag if the invoice has buyers associated', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoice', 'COLUMN', N'Buyers'
GO
EXEC sp_addextendedproperty N'MS_Description', N'flag if the invoice has investors associated', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoice', 'COLUMN', N'Investors'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date the invoice was created', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoice', 'COLUMN', N'Invoiced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date of the invoiced', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoice', 'COLUMN', N'InvoiceDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoice', 'COLUMN', N'LedgerInvoiceID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'flag if the invoice has management associated', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoice', 'COLUMN', N'management'
GO
EXEC sp_addextendedproperty N'MS_Description', N'associated portfolio for this invoice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoice', 'COLUMN', N'PortfolioId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'flag if the invoice has sellers associated', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoice', 'COLUMN', N'Sellers'
GO

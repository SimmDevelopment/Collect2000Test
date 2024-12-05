CREATE TABLE [dbo].[AIM_LedgerInvoiceType]
(
[LedgerInvoiceTypeId] [int] NOT NULL IDENTITY(1, 1),
[LedgerInvoiceId] [int] NULL,
[LedgerTypeId] [int] NULL,
[ContainedEntries] [bit] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for whether the invoice contained date for this ledger type', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceType', 'COLUMN', N'ContainedEntries'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated ledger invoice id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceType', 'COLUMN', N'LedgerInvoiceId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceType', 'COLUMN', N'LedgerInvoiceTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated ledger type of this inovice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceType', 'COLUMN', N'LedgerTypeId'
GO

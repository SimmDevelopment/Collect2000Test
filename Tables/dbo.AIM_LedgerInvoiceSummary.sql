CREATE TABLE [dbo].[AIM_LedgerInvoiceSummary]
(
[LedgerInvoiceSummaryId] [int] NOT NULL IDENTITY(1, 1),
[LedgerInvoiceId] [int] NULL,
[GroupId] [int] NULL,
[SumCredit] [money] NULL,
[SumDebit] [money] NULL,
[Net] [money] NULL,
[Gross] [money] NULL,
[Outstanding] [bit] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The gross value of the invoice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceSummary', 'COLUMN', N'Gross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated group id for this invoice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceSummary', 'COLUMN', N'GroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the ledger invoice id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceSummary', 'COLUMN', N'LedgerInvoiceId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceSummary', 'COLUMN', N'LedgerInvoiceSummaryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The net value of the invoice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceSummary', 'COLUMN', N'Net'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount outstanding of the invoice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceSummary', 'COLUMN', N'Outstanding'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total sum of credits on the invoice for the group', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceSummary', 'COLUMN', N'SumCredit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total sum of debits on the invoice for the group', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceSummary', 'COLUMN', N'SumDebit'
GO

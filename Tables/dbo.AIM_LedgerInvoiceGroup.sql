CREATE TABLE [dbo].[AIM_LedgerInvoiceGroup]
(
[LedgerInvoiceGroupID] [int] NOT NULL IDENTITY(1, 1),
[LedgerInvoiceID] [int] NULL,
[GroupID] [int] NULL,
[GroupTypeID] [int] NULL,
[ContainedData] [bit] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for whether the invoice contained data for this group', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceGroup', 'COLUMN', N'ContainedData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated group for the invoice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceGroup', 'COLUMN', N'GroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the type of group for the associated group of the invoice', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceGroup', 'COLUMN', N'GroupTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceGroup', 'COLUMN', N'LedgerInvoiceGroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated ledger invoice id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerInvoiceGroup', 'COLUMN', N'LedgerInvoiceID'
GO

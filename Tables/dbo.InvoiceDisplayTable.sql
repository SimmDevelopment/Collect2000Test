CREATE TABLE [dbo].[InvoiceDisplayTable]
(
[InvoiceNumber] [int] NULL,
[InvDate] [datetime] NULL,
[CustomerCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileNumber] [int] NULL,
[DebtorName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentBal] [money] NULL,
[CustAccount] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatePaid] [datetime] NULL,
[AmountPaid] [money] NULL,
[AmountFee] [money] NULL,
[BatchType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceNumber] ON [dbo].[InvoiceDisplayTable] ([InvoiceNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'AmountFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'AmountPaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'BatchType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'CurrentBal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'CustAccount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'CustomerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'DatePaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'DebtorName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'FileNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'InvDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'InvoiceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDisplayTable', 'COLUMN', N'UID'
GO

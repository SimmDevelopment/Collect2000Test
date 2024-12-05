CREATE TABLE [dbo].[InvoiceWork]
(
[number] [int] NULL,
[seq] [int] NULL,
[matched] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[batchtype] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sortdata] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paytype] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymethod] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[systemmonth] [smallint] NULL,
[systemyear] [smallint] NULL,
[entered] [datetime] NULL,
[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoiced] [datetime] NULL,
[InvoiceSort] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoicePayType] [real] NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[datepaid] [datetime] NULL,
[totalpaid] [money] NULL,
[paid1] [money] NULL,
[paid2] [money] NULL,
[paid3] [money] NULL,
[paid4] [money] NULL,
[paid5] [money] NULL,
[paid6] [money] NULL,
[paid7] [money] NULL,
[paid8] [money] NULL,
[paid9] [money] NULL,
[paid10] [money] NULL,
[fee1] [money] NULL,
[fee2] [money] NULL,
[fee3] [money] NULL,
[fee4] [money] NULL,
[fee5] [money] NULL,
[fee6] [money] NULL,
[fee7] [money] NULL,
[fee8] [money] NULL,
[fee9] [money] NULL,
[fee10] [money] NULL,
[tota] [money] NULL,
[totb] [money] NULL,
[totc] [money] NULL,
[totd] [money] NULL,
[tote] [money] NULL,
[totf] [money] NULL,
[UID] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Invoicework2] ON [dbo].[InvoiceWork] ([customer], [InvoiceSort], [sortdata]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Invoicework3] ON [dbo].[InvoiceWork] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Invoicework1] ON [dbo].[InvoiceWork] ([number], [batchtype], [totalpaid], [invoiced]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Invoicework4] ON [dbo].[InvoiceWork] ([seq]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'batchtype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'datepaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'fee9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'invoiced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'InvoicePayType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'InvoiceSort'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'InvoiceType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'matched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paid9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paymethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'paytype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'sortdata'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'systemmonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'systemyear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'tota'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'totalpaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'totb'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'totc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'totd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'tote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'totf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceWork', 'COLUMN', N'UID'
GO

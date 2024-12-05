CREATE TABLE [dbo].[Legal_LedgerInvoiceSummary]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Created] [datetime] NOT NULL CONSTRAINT [DF__Legal_Led__Creat__4742EA7F] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The DateTime stamp Invoice was created', 'SCHEMA', N'dbo', 'TABLE', N'Legal_LedgerInvoiceSummary', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The entity creating the invoice', 'SCHEMA', N'dbo', 'TABLE', N'Legal_LedgerInvoiceSummary', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Invoice ID', 'SCHEMA', N'dbo', 'TABLE', N'Legal_LedgerInvoiceSummary', 'COLUMN', N'ID'
GO

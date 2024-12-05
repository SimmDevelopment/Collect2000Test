CREATE TABLE [dbo].[OpenItemTransactions]
(
[Amount] [money] NULL,
[Invoice] [int] NULL,
[TransDate] [datetime] NULL,
[TransType] [smallint] NULL,
[Comment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OpenItemTransactions] ADD CONSTRAINT [PK_OpenItemTransactions] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_OpenItemTransactions_Invoice] ON [dbo].[OpenItemTransactions] ([Invoice]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Amount of Transaction', 'SCHEMA', N'dbo', 'TABLE', N'OpenItemTransactions', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Comment from Payhistory', 'SCHEMA', N'dbo', 'TABLE', N'OpenItemTransactions', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice from payhistory', 'SCHEMA', N'dbo', 'TABLE', N'OpenItemTransactions', 'COLUMN', N'Invoice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction Date', 'SCHEMA', N'dbo', 'TABLE', N'OpenItemTransactions', 'COLUMN', N'TransDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction Type', 'SCHEMA', N'dbo', 'TABLE', N'OpenItemTransactions', 'COLUMN', N'TransType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Field', 'SCHEMA', N'dbo', 'TABLE', N'OpenItemTransactions', 'COLUMN', N'UID'
GO

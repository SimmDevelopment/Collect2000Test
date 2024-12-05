CREATE TABLE [dbo].[HCFAItemTrx]
(
[item_id] [int] NULL,
[trx_uid] [int] NOT NULL IDENTITY(1, 1),
[trx_dte] [datetime] NULL,
[trx_desc] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[trx_amt] [money] NULL,
[timestamp] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HCFAItemTrx] ADD CONSTRAINT [PK_HCFAItemTrx] PRIMARY KEY NONCLUSTERED ([trx_uid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IKF_HCFAItemTrx] ON [dbo].[HCFAItemTrx] ([item_id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItemTrx', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItemTrx', 'COLUMN', N'item_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItemTrx', 'COLUMN', N'timestamp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItemTrx', 'COLUMN', N'trx_amt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItemTrx', 'COLUMN', N'trx_desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItemTrx', 'COLUMN', N'trx_dte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'HCFAItemTrx', 'COLUMN', N'trx_uid'
GO

CREATE TABLE [dbo].[OpenItem]
(
[Invoice] [int] NOT NULL,
[Tdate] [datetime] NULL,
[Tcode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Syyear] [int] NULL,
[SyMonth] [int] NULL,
[customer] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[Comment] [char] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Itype] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Retired] [bit] NULL CONSTRAINT [DF_OpenItem_Retired] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OpenItem] ADD CONSTRAINT [PK_OpenItem] PRIMARY KEY NONCLUSTERED ([Invoice]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_OpenItem_Customer] ON [dbo].[OpenItem] ([customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_OpenItem_Retired] ON [dbo].[OpenItem] ([Retired]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_OpenItem_Tdate] ON [dbo].[OpenItem] ([Tdate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of Invoice', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Comment from Payhistory', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer from Payhistory', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice Number from Payhistory', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'Invoice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item Type', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'Itype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retired or Active', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'Retired'
GO
EXEC sp_addextendedproperty N'MS_Description', N'System Month from payhistory', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'SyMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'System Year from payhistory', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'Syyear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction Code', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'Tcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction Date', 'SCHEMA', N'dbo', 'TABLE', N'OpenItem', 'COLUMN', N'Tdate'
GO

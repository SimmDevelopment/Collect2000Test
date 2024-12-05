CREATE TABLE [dbo].[CustomerInventoryStat]
(
[Received] [datetime] NULL,
[NumberPlaced] [money] NOT NULL CONSTRAINT [DF__CustomerI__Numbe__2D8BA36F] DEFAULT (0),
[DollarsPlaced] [money] NOT NULL CONSTRAINT [DF__CustomerI__Dolla__2E7FC7A8] DEFAULT (0),
[NumberOpen] [money] NOT NULL CONSTRAINT [DF__CustomerI__Numbe__2F73EBE1] DEFAULT (0),
[DollarsOpen] [money] NOT NULL CONSTRAINT [DF__CustomerI__Dolla__3068101A] DEFAULT (0),
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table used to build Customer Inventory Report', 'SCHEMA', N'dbo', 'TABLE', N'CustomerInventoryStat', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code receiving account placement', 'SCHEMA', N'dbo', 'TABLE', N'CustomerInventoryStat', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollars placed for open accounts', 'SCHEMA', N'dbo', 'TABLE', N'CustomerInventoryStat', 'COLUMN', N'DollarsOpen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total dollars placed', 'SCHEMA', N'dbo', 'TABLE', N'CustomerInventoryStat', 'COLUMN', N'DollarsPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total accounts in an open status type and qlevel', 'SCHEMA', N'dbo', 'TABLE', N'CustomerInventoryStat', 'COLUMN', N'NumberOpen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total number of accounts placed', 'SCHEMA', N'dbo', 'TABLE', N'CustomerInventoryStat', 'COLUMN', N'NumberPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime accounts placed or received', 'SCHEMA', N'dbo', 'TABLE', N'CustomerInventoryStat', 'COLUMN', N'Received'
GO

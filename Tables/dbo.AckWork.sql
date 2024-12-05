CREATE TABLE [dbo].[AckWork]
(
[number] [int] NOT NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[homephone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workphone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received] [datetime] NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original] [money] NULL,
[current0] [money] NULL,
[clidlc] [datetime] NULL,
[clidlp] [datetime] NULL,
[DESK1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customername] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerContact] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Acknowledgement Work Table NOT USED', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'account'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'clidlc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'clidlp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'company'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'current0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'CustomerContact'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'Customername'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'DESK1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'homephone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'original'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'other'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'received'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'workphone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AckWork', 'COLUMN', N'Zipcode'
GO

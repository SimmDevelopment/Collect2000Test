CREATE TABLE [dbo].[PDCTemp]
(
[PDCID] [int] NULL,
[AcctID] [int] NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[CheckNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepositDate] [datetime] NULL,
[OnHold] [bit] NULL,
[Approved] [bit] NULL,
[Printed] [bit] NULL,
[PDCType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Surcharge] [money] NOT NULL CONSTRAINT [DF__PDCTemp__Surchar__010AD557] DEFAULT (0)
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'AcctID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Post date Amount', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that approved the PDC', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'Approved'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check Number  ', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'CheckNo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer from the Master table', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date to Deposit amount', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'DepositDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Account assigned ', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name from Master', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field to determine if deposit is on hold or not', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'OnHold'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID from PDC Table', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'PDCID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of Post Date', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'PDCType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field used to determine whether the account has been printed', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'Printed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status of Post Date', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surcharge amount', 'SCHEMA', N'dbo', 'TABLE', N'PDCTemp', 'COLUMN', N'Surcharge'
GO

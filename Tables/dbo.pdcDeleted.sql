CREATE TABLE [dbo].[pdcDeleted]
(
[number] [int] NULL,
[ctl] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[entered] [datetime] NULL,
[onhold] [datetime] NULL,
[processed1] [datetime] NULL,
[processedflag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[deposit] [datetime] NULL,
[amount] [money] NULL,
[checknbr] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [int] NULL,
[nitd] [datetime] NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill1] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill2] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill3] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill4] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill5] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PDC_Type] [tinyint] NULL,
[Surcharge] [money] NULL,
[LtrCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Printed] [bit] NULL,
[PromiseMode] [tinyint] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UID] [int] NOT NULL IDENTITY(1, 1),
[DeletedDate] [datetime] NULL,
[Account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'Account'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of the transaction', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that approved the PDC', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'ApprovedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The check number', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'checknbr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer field from master', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date item Deleted', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'DeletedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date time field for Date deposited', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'deposit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk account assigned to', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entered date from master', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter ID from Letters', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'LtrCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Onhold filed from master', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'onhold'
GO
EXEC sp_addextendedproperty N'MS_Description', N'typs of PDC ', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'PDC_Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field to show whether this has been printed or not', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'Printed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Single Payment,2 - Monthly Payments,3 - Bi-Weekly Payments,4 - Twice a Month, 5 - Weekly, 6 - Settlement, 7 - MultipartSettlement, 8 - PayOff, 9 - Every28Days, 10 - EndOfMonth,  11 - BiMonthly, 12 - LastFriday, 99 - Multiple ', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'PromiseMode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Qlevel Account was in a time PDC deleted', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'Qlevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number from Debtor', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'SEQ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of Surcharge for PDC', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'Surcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for each record', 'SCHEMA', N'dbo', 'TABLE', N'pdcDeleted', 'COLUMN', N'UID'
GO

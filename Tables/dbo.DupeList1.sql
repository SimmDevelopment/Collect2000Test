CREATE TABLE [dbo].[DupeList1]
(
[Desk] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [int] NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Received] [datetime] NULL,
[Original] [money] NULL,
[Current0] [money] NULL,
[status] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[returned] [datetime] NULL,
[closed] [datetime] NULL,
[ssn] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'Account'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'closed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'Current0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'Original'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'Received'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'returned'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'ssn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DupeList1', 'COLUMN', N'status'
GO

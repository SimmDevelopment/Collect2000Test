CREATE TABLE [dbo].[NSFPaymentTemp]
(
[totalpaid] [money] NULL CONSTRAINT [DF__NSFPaymen__total__7A42A041] DEFAULT (0),
[Comment] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[desk] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalFee] [money] NULL CONSTRAINT [DF__NSFPaymen__Total__7B36C47A] DEFAULT (0),
[DatePaid] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Comment on Account', 'SCHEMA', N'dbo', 'TABLE', N'NSFPaymentTemp', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer from Payhistory', 'SCHEMA', N'dbo', 'TABLE', N'NSFPaymentTemp', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DatePaid from Payhistory', 'SCHEMA', N'dbo', 'TABLE', N'NSFPaymentTemp', 'COLUMN', N'DatePaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name from Master', 'SCHEMA', N'dbo', 'TABLE', N'NSFPaymentTemp', 'COLUMN', N'DebtorName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk from Master', 'SCHEMA', N'dbo', 'TABLE', N'NSFPaymentTemp', 'COLUMN', N'desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'NSFPaymentTemp', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Fee Amount', 'SCHEMA', N'dbo', 'TABLE', N'NSFPaymentTemp', 'COLUMN', N'TotalFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Amount Paid', 'SCHEMA', N'dbo', 'TABLE', N'NSFPaymentTemp', 'COLUMN', N'totalpaid'
GO

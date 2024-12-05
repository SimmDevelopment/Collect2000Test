CREATE TABLE [dbo].[AgedARTMP]
(
[Customer] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Invoice_Number] [int] NULL,
[Invoice_Date] [datetime] NULL,
[Amount] [money] NULL,
[Total_Paid] [money] NULL,
[Balance] [money] NULL,
[Bucket1] [money] NULL,
[Bucket2] [money] NULL,
[Bucket3] [money] NULL,
[Bucket4] [money] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Balance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Bucket1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Bucket2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Bucket3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Bucket4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Invoice_Date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Invoice_Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgedARTMP', 'COLUMN', N'Total_Paid'
GO

CREATE TABLE [dbo].[CreditHistory]
(
[number] [int] NULL,
[TransactionDate] [datetime] NULL,
[TransactionCode] [int] NULL,
[TransactionBalance] [money] NULL,
[TransactionMessage] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'CreditHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'CreditHistory', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'CreditHistory', 'COLUMN', N'TransactionBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'CreditHistory', 'COLUMN', N'TransactionCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'CreditHistory', 'COLUMN', N'TransactionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'CreditHistory', 'COLUMN', N'TransactionMessage'
GO

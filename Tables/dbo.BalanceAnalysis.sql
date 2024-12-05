CREATE TABLE [dbo].[BalanceAnalysis]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalPCT] [money] NULL,
[DollarsPct] [money] NULL,
[TotalPlaced] [int] NULL,
[DollarsPlaced] [money] NULL,
[AvgPlaced] [money] NULL,
[LR] [money] NULL,
[HR] [money] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'AvgPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'CustomerName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'DollarsPct'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'DollarsPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'HR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'LR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'TotalPCT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'BalanceAnalysis', 'COLUMN', N'TotalPlaced'
GO

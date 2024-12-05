CREATE TABLE [dbo].[DeskDistributionDetail]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DeskDistributionId] [int] NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LowLimit] [money] NULL,
[HighLimit] [money] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Detail table used by Desk Distibutor to allocate accounts across inventory desks', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistributionDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Code', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistributionDetail', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent DeskDistribution ID', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistributionDetail', 'COLUMN', N'DeskDistributionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum allowance', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistributionDetail', 'COLUMN', N'HighLimit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistributionDetail', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum allowance', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistributionDetail', 'COLUMN', N'LowLimit'
GO

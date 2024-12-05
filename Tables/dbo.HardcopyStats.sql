CREATE TABLE [dbo].[HardcopyStats]
(
[SystemMonth] [smallint] NULL,
[SystemYear] [smallint] NULL,
[Branch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessedCount] [int] NULL,
[ProcessedDate] [datetime] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table that tracks purchased credit reports by branch', 'SCHEMA', N'dbo', 'TABLE', N'HardcopyStats', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branchcode', 'SCHEMA', N'dbo', 'TABLE', N'HardcopyStats', 'COLUMN', N'Branch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of reports processed', 'SCHEMA', N'dbo', 'TABLE', N'HardcopyStats', 'COLUMN', N'ProcessedCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp of activity', 'SCHEMA', N'dbo', 'TABLE', N'HardcopyStats', 'COLUMN', N'ProcessedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Billing month', 'SCHEMA', N'dbo', 'TABLE', N'HardcopyStats', 'COLUMN', N'SystemMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Billing year', 'SCHEMA', N'dbo', 'TABLE', N'HardcopyStats', 'COLUMN', N'SystemYear'
GO

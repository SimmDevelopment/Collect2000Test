CREATE TABLE [dbo].[AgencyBatchCollections]
(
[BatchUID] [int] NOT NULL,
[AgcyCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SysMonth] [tinyint] NOT NULL,
[SysYear] [smallint] NOT NULL,
[AmtCollected] [money] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatchCollections', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatchCollections', 'COLUMN', N'AgcyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatchCollections', 'COLUMN', N'AmtCollected'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatchCollections', 'COLUMN', N'BatchUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatchCollections', 'COLUMN', N'SysMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatchCollections', 'COLUMN', N'SysYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatchCollections', 'COLUMN', N'UID'
GO

CREATE TABLE [dbo].[AgencyBatches]
(
[GUID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BatchDate] [datetime] NOT NULL,
[SysMonth] [tinyint] NULL,
[SysYear] [smallint] NULL,
[AgencyCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Tier] [tinyint] NOT NULL,
[ItemsPlaced] [int] NULL,
[AmtPlaced] [money] NOT NULL,
[AmtCollected] [money] NULL,
[ItemsActive] [int] NULL,
[DollarsActive] [money] NULL,
[Filename] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Acknowledged] [bit] NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'Acknowledged'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'AgencyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'AmtCollected'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'AmtPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'BatchDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'DollarsActive'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'Filename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'GUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'ItemsActive'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'ItemsPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'SysMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'SysYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'Tier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyBatches', 'COLUMN', N'UID'
GO

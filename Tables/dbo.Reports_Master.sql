CREATE TABLE [dbo].[Reports_Master]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Path] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportFileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__Reports_M__Activ__07727E2D] DEFAULT ((1)),
[ReportImage] [varbinary] (max) NOT NULL,
[System] [bit] NOT NULL CONSTRAINT [DF__Reports_M__Syste__0866A266] DEFAULT ((0)),
[ReportKey] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_Master] ADD CONSTRAINT [PK_Reports_Master] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_Master] ADD CONSTRAINT [IX_Reports_Master_NamePath] UNIQUE NONCLUSTERED ([Name], [Path]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_Master] ADD CONSTRAINT [IX_Reports_Master_ReportKey] UNIQUE NONCLUSTERED ([ReportKey]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'A bit flag to indicate if the report is active. Inactive reports do not normally get displayed to user.', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A user defined description of the report', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Friendly name of the report that the end user may modify', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The treepath location that the report will be shown at in Reporting Console', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'Path'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'Path'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The file name the report was last updated from.', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'ReportFileName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'ReportFileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The actual report contents stored as binary', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'ReportImage'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'ReportImage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A unique symbolic ID or GUID of the report, updates by DBUpdate will respect this key', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'ReportKey'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'ReportKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A bit flag to indicate if the report is system. System reports may not be altered by Reporting Console, but can be updated by dbupdate.', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'COLUMN', N'System'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Enforce Name and Path to be unique pair', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'CONSTRAINT', N'IX_Reports_Master_NamePath'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Enforce ReportKey to be unique', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Master', 'CONSTRAINT', N'IX_Reports_Master_ReportKey'
GO

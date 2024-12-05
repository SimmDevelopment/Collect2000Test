CREATE TABLE [dbo].[PVGPlugins]
(
[key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[desc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ach] [bit] NOT NULL,
[cc] [bit] NOT NULL,
[pdraft] [bit] NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_PVGPlugins] ON [dbo].[PVGPlugins] ([key]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'PVGPlugins', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PVGPlugins', 'COLUMN', N'ach'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PVGPlugins', 'COLUMN', N'cc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'What''s displayed in the permissions', 'SCHEMA', N'dbo', 'TABLE', N'PVGPlugins', 'COLUMN', N'desc'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PVGPlugins', 'COLUMN', N'desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Key passed to PVG to retrieve plugin', 'SCHEMA', N'dbo', 'TABLE', N'PVGPlugins', 'COLUMN', N'key'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'PVGPlugins', 'COLUMN', N'key'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PVGPlugins', 'COLUMN', N'pdraft'
GO

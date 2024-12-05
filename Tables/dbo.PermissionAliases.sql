CREATE TABLE [dbo].[PermissionAliases]
(
[ModuleName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PermissionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewModuleName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewPermissionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermissionAliases] ADD CONSTRAINT [PK__PermissionAliase__05071A1B] PRIMARY KEY CLUSTERED ([ModuleName], [PermissionName]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'PermissionAliases', 'COLUMN', N'ModuleName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PermissionAliases', 'COLUMN', N'NewModuleName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PermissionAliases', 'COLUMN', N'NewPermissionName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'PermissionAliases', 'COLUMN', N'PermissionName'
GO

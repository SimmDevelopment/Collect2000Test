CREATE TABLE [dbo].[Permissions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ModuleName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PermissionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PolicyTemplate] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserPermission] [bit] NOT NULL CONSTRAINT [def_Permissions_UserPermission] DEFAULT (1),
[CustomerPermission] [bit] NOT NULL CONSTRAINT [def_Permissions_CustomerPermission] DEFAULT (0),
[DeskPermission] [bit] NOT NULL CONSTRAINT [DF_Permissions_DeskPermission] DEFAULT (0),
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObsoleteDescription] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [pk_Permissions] PRIMARY KEY NONCLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_Permissions_ModuleName_PermissionName] ON [dbo].[Permissions] ([ModuleName], [PermissionName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', 'COLUMN', N'CustomerPermission'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', 'COLUMN', N'DeskPermission'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', 'COLUMN', N'ModuleName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', 'COLUMN', N'ObsoleteDescription'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', 'COLUMN', N'PermissionName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', 'COLUMN', N'PolicyTemplate'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Permissions', 'COLUMN', N'UserPermission'
GO

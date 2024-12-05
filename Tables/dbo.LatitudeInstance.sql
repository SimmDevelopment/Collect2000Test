CREATE TABLE [dbo].[LatitudeInstance]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LatitudeInstance_Description] DEFAULT ('Latitude'),
[DataSource] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LatitudeInstance_DataSource] DEFAULT ('(Local)'),
[InitialCatalog] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LatitudeInstance_InitialCatalog] DEFAULT ('Collect2000'),
[UserID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSPI] [bit] NOT NULL CONSTRAINT [DF__Instances__SSPI__7C8480AE] DEFAULT (0),
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LatitudeInstance_Code] DEFAULT ('master'),
[Active] [bit] NOT NULL CONSTRAINT [DF_LatitudeInstance_Active] DEFAULT (0),
[RFU] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeInstance] ADD CONSTRAINT [chk_LoginInformation] CHECK (([SSPI]=(1) OR [UserID] IS NOT NULL AND [Password] IS NOT NULL))
GO
ALTER TABLE [dbo].[LatitudeInstance] ADD CONSTRAINT [PK__LatitudeInstance__20C1E124] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeInstance] ADD CONSTRAINT [UQ__LatitudeInstance__21B6055D] UNIQUE NONCLUSTERED ([Description]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines an instance of a Latitude database', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Should this instance be used', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A unique code assigned to this LatitudeInstance', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Database logon info', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'DataSource'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of database', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Database logon info', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'InitialCatalog'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Encrypted database logon info', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'Password'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reserved for future use.', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'RFU'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Database logon info', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'SSPI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Unique Identity', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Encrypted database logon info', 'SCHEMA', N'dbo', 'TABLE', N'LatitudeInstance', 'COLUMN', N'UserID'
GO

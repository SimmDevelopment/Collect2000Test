CREATE TABLE [dbo].[AIM_AppSetting]
(
[Key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_AppSetting] ADD CONSTRAINT [PK_AppSetting] PRIMARY KEY CLUSTERED ([Key]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AppSetting', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AppSetting', 'COLUMN', N'Key'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AppSetting', 'COLUMN', N'Key'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AppSetting', 'COLUMN', N'Value'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Data', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AppSetting', 'COLUMN', N'Value'
GO

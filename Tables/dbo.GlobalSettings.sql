CREATE TABLE [dbo].[GlobalSettings]
(
[GlobalSettingsID] [int] NOT NULL IDENTITY(1, 1),
[NameSpace] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SettingName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettingType] [tinyint] NOT NULL,
[BitValue] [bit] NULL,
[DateValue1] [datetime] NULL,
[DateValue2] [datetime] NULL,
[FloatValue1] [float] NULL,
[FloatValue2] [float] NULL,
[IntValue1] [int] NULL,
[IntValue2] [int] NULL,
[StringValue] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GlobalSettings] ADD CONSTRAINT [PK_GlobalSettings] PRIMARY KEY CLUSTERED ([GlobalSettingsID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'GlobalSettings', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'GlobalSettings', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'GlobalSettings', 'COLUMN', N'NameSpace'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'GlobalSettings', 'COLUMN', N'SettingName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'GlobalSettings', 'COLUMN', N'SettingType'
GO

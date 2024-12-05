CREATE TABLE [dbo].[PVGDebtorProfiles]
(
[key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[desc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ordering] [tinyint] NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_PVGDebtorProfiles] ON [dbo].[PVGDebtorProfiles] ([key]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'PVGDebtorProfiles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'What''s displayed in the permissions', 'SCHEMA', N'dbo', 'TABLE', N'PVGDebtorProfiles', 'COLUMN', N'desc'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PVGDebtorProfiles', 'COLUMN', N'desc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Key used to indicate debtor profile data set to PVG', 'SCHEMA', N'dbo', 'TABLE', N'PVGDebtorProfiles', 'COLUMN', N'key'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'PVGDebtorProfiles', 'COLUMN', N'key'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The default should be zero, other values should be one', 'SCHEMA', N'dbo', 'TABLE', N'PVGDebtorProfiles', 'COLUMN', N'ordering'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'PVGDebtorProfiles', 'COLUMN', N'ordering'
GO

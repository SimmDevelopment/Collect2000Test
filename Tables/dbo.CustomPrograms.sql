CREATE TABLE [dbo].[CustomPrograms]
(
[ProgName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomPrograms] ADD CONSTRAINT [PK_CustomPrograms] PRIMARY KEY NONCLUSTERED ([ProgName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table logs all applications that log onto the Latitude database by latest version and is also used to alert the user if they are running an older version of that program', 'SCHEMA', N'dbo', 'TABLE', N'CustomPrograms', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The program name which can either be the name of the executable file or a friendly name as specified by the application', 'SCHEMA', N'dbo', 'TABLE', N'CustomPrograms', 'COLUMN', N'ProgName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The latest version number of the application, usually 3 or 4 part', 'SCHEMA', N'dbo', 'TABLE', N'CustomPrograms', 'COLUMN', N'Version'
GO

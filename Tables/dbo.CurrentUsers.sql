CREATE TABLE [dbo].[CurrentUsers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProgName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TimeOn] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CurrentUsers] ADD CONSTRAINT [PK_CurrentUsers] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Populated with each user when user is signed into Latitude', 'SCHEMA', N'dbo', 'TABLE', N'CurrentUsers', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'CurrentUsers', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Program component logged into', 'SCHEMA', N'dbo', 'TABLE', N'CurrentUsers', 'COLUMN', N'ProgName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time Stamp of Logon', 'SCHEMA', N'dbo', 'TABLE', N'CurrentUsers', 'COLUMN', N'TimeOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'CurrentUsers', 'COLUMN', N'UserName'
GO

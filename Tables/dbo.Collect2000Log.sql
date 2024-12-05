CREATE TABLE [dbo].[Collect2000Log]
(
[TheUser] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogWhen] [datetime] NOT NULL,
[LogMessage] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogWhenServer] [datetime] NULL CONSTRAINT [def_Collect2000Log_LogWhenServer] DEFAULT (getdate()),
[LogWhenUTC] [datetime] NULL CONSTRAINT [def_Collect2000Log_LogWhenUTC] DEFAULT (getutcdate())
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Audits User logon and logoff of Latitude', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Log', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code describing action ', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Log', 'COLUMN', N'LogCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of action taken', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Log', 'COLUMN', N'LogMessage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time of action performed', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Log', 'COLUMN', N'LogWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude component accessed', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Log', 'COLUMN', N'ProgramName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User logon', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Log', 'COLUMN', N'TheUser'
GO

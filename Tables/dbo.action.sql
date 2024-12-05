CREATE TABLE [dbo].[action]
(
[code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WasAttempt] [bit] NULL,
[WasWorked] [bit] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Action taken on account.  These codes allow you to catagorize transaction notes by defined action code.', 'SCHEMA', N'dbo', 'TABLE', N'action', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'action', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique action code', 'SCHEMA', N'dbo', 'TABLE', N'action', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'action', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Detailed description of action', 'SCHEMA', N'dbo', 'TABLE', N'action', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'action', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catagorizes action as an attempt to work account', 'SCHEMA', N'dbo', 'TABLE', N'action', 'COLUMN', N'WasAttempt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catagorizes action as worked account', 'SCHEMA', N'dbo', 'TABLE', N'action', 'COLUMN', N'WasWorked'
GO

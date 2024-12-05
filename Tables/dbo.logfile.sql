CREATE TABLE [dbo].[logfile]
(
[program] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[logdate] [datetime] NULL,
[logmsg] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [logdate1] ON [dbo].[logfile] ([logdate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'logfile', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'logfile', 'COLUMN', N'logdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'logfile', 'COLUMN', N'logmsg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'logfile', 'COLUMN', N'program'
GO

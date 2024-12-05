CREATE TABLE [dbo].[AdminLogFile]
(
[LogCategory] [int] NULL,
[LogDate] [datetime] NULL,
[who] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogStatus] [int] NULL,
[LogMessage] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AdminLogFile] ON [dbo].[AdminLogFile] ([LogCategory], [LogDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AdminLogFile', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AdminLogFile', 'COLUMN', N'LogCategory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AdminLogFile', 'COLUMN', N'LogDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AdminLogFile', 'COLUMN', N'LogMessage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AdminLogFile', 'COLUMN', N'LogStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AdminLogFile', 'COLUMN', N'Program'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AdminLogFile', 'COLUMN', N'who'
GO

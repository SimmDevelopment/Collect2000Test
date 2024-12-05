CREATE TABLE [dbo].[AIM_LogMessage]
(
[LogMessageId] [int] NOT NULL,
[LogMessage] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Policy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_LogMessage] ADD CONSTRAINT [PK_LogMessage] PRIMARY KEY CLUSTERED ([LogMessageId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LogMessage', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LogMessage', 'COLUMN', N'LogMessage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LogMessage', 'COLUMN', N'LogMessageId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LogMessage', 'COLUMN', N'LogMessageId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Continue', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LogMessage', 'COLUMN', N'Policy'
GO

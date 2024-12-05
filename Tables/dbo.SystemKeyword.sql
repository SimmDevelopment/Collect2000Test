CREATE TABLE [dbo].[SystemKeyword]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[KeywordCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemKeyword] ADD CONSTRAINT [PK_SystemKeyword] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'List of available keywords. This table is for reference only. ', 'SCHEMA', N'dbo', 'TABLE', N'SystemKeyword', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'SystemKeyword', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'A description of the value that is used to replace this keyword in systemnotetemplate notes.', 'SCHEMA', N'dbo', 'TABLE', N'SystemKeyword', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A keyword (include $[]''s) to use in a systemnotetemplate that will be replaced by an actual value when the DUS creates notes on the account.', 'SCHEMA', N'dbo', 'TABLE', N'SystemKeyword', 'COLUMN', N'KeywordCode'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'SystemKeyword', 'COLUMN', N'KeywordCode'
GO

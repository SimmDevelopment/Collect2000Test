CREATE TABLE [dbo].[DBUpdateLog]
(
[DateRun] [datetime] NULL,
[UpdateVersion] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromVersion] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCount] [int] NULL,
[LogFile] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DBUpdateLog', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DBUpdateLog', 'COLUMN', N'DateRun'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DBUpdateLog', 'COLUMN', N'ErrorCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DBUpdateLog', 'COLUMN', N'FromVersion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DBUpdateLog', 'COLUMN', N'LogFile'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DBUpdateLog', 'COLUMN', N'UpdateVersion'
GO

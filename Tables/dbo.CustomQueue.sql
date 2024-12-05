CREATE TABLE [dbo].[CustomQueue]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Schedule] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QueueName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TheSql] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromptForFU] [bit] NULL,
[Conditions] [image] NULL,
[Order] [image] NULL,
[MaxAccounts] [int] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used by the Custom Queue Manager to define and schedule Custom account queues.', 'SCHEMA', N'dbo', 'TABLE', N'CustomQueue', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Included account conditions from condition builder', 'SCHEMA', N'dbo', 'TABLE', N'CustomQueue', 'COLUMN', N'Conditions'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'CustomQueue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum number of accounts allowed in queue', 'SCHEMA', N'dbo', 'TABLE', N'CustomQueue', 'COLUMN', N'MaxAccounts'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of CustomQueue', 'SCHEMA', N'dbo', 'TABLE', N'CustomQueue', 'COLUMN', N'QueueName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Daily Schedule Flags (Sun,Mon,Tue,Wed,Thu,Fri,Sat,Null) ie. 12345670', 'SCHEMA', N'dbo', 'TABLE', N'CustomQueue', 'COLUMN', N'Schedule'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Generated SQL to build queue of accounts', 'SCHEMA', N'dbo', 'TABLE', N'CustomQueue', 'COLUMN', N'TheSql'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Schedule title of Custom Queue', 'SCHEMA', N'dbo', 'TABLE', N'CustomQueue', 'COLUMN', N'Title'
GO

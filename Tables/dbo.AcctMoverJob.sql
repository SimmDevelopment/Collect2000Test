CREATE TABLE [dbo].[AcctMoverJob]
(
[JobID] [int] NOT NULL IDENTITY(1, 1),
[DateCreated] [datetime] NOT NULL,
[DateCompleted] [datetime] NULL,
[NumberMoved] [int] NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobDefXML] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateUndone] [datetime] NULL,
[UndoneBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AcctMoverJob] ADD CONSTRAINT [PK_AcctMoverJob] PRIMARY KEY CLUSTERED ([JobID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retains Historical Job Criteria and Logs execution of the Account Mover application', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date move completed', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', 'COLUMN', N'DateCompleted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date move was defined and executed', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account move was Undone or Reversed', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', 'COLUMN', N'DateUndone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'XML data that records the selection criteria and all options configured to Move the respective accounts', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', 'COLUMN', N'JobDefXML'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity of the Job or Move that was executed', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', 'COLUMN', N'JobID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Accounts moved', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', 'COLUMN', N'NumberMoved'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latutude UserName of the responsible Manager', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', 'COLUMN', N'UndoneBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude UserName of the Collector or Manager', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob', 'COLUMN', N'UserName'
GO

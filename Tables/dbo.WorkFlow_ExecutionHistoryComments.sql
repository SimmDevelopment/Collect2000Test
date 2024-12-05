CREATE TABLE [dbo].[WorkFlow_ExecutionHistoryComments]
(
[HistoryID] [uniqueidentifier] NOT NULL,
[AccountID] [int] NOT NULL,
[Comment] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_ExecutionHistoryComments] ADD CONSTRAINT [pk_WorkFlow_ExecutionHistoryComments] PRIMARY KEY CLUSTERED ([HistoryID], [AccountID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WorkFlow_ExecutionHistoryComments_AccountID] ON [dbo].[WorkFlow_ExecutionHistoryComments] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_ExecutionHistoryComments] ADD CONSTRAINT [fk_WorkFlow_ExecutionHistory_ExecutionHistoryComments] FOREIGN KEY ([HistoryID]) REFERENCES [dbo].[WorkFlow_ExecutionHistory] ([ID]) ON DELETE CASCADE
GO

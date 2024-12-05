CREATE TABLE [dbo].[WorkFlow_ExecutionHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_ExecutionHistory__ID] DEFAULT (newsequentialid()),
[ExecID] [uniqueidentifier] NOT NULL,
[AccountID] [int] NOT NULL,
[ActivityID] [uniqueidentifier] NOT NULL,
[Entered] [datetime] NOT NULL,
[Evaluated] [datetime] NOT NULL CONSTRAINT [DF__WorkFlow_ExecutionHistory__Evaluated] DEFAULT (getdate()),
[NextActivityID] [uniqueidentifier] NOT NULL,
[UndoState] [uniqueidentifier] NULL,
[Undone] [bit] NOT NULL CONSTRAINT [DF__WorkFlow_ExecutionHistory__Undone] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_ExecutionHistory] ADD CONSTRAINT [pk_WorkFlow_ExecutionHistory] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Workflow_ExecutionHistory_AccountID] ON [dbo].[WorkFlow_ExecutionHistory] ([AccountID]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO

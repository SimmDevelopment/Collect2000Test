CREATE TABLE [dbo].[WorkFlow_ExecutionVariables]
(
[ID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF__WorkFlow_ExecutionVariables__ID] DEFAULT (newsequentialid()),
[ExecID] [uniqueidentifier] NOT NULL,
[ActivityID] [uniqueidentifier] NULL,
[AccountID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Variable] [sql_variant] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_ExecutionVariables] ADD CONSTRAINT [pk_WorkFlow_ExecutionVariables_ID] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_WorkFlow_ExecutionVariables_ExecID_ActivityID_AccountID_Name] ON [dbo].[WorkFlow_ExecutionVariables] ([ExecID], [ActivityID], [AccountID], [Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_ExecutionVariables] ADD CONSTRAINT [fk_WorkFlow_Activities_ID] FOREIGN KEY ([ActivityID]) REFERENCES [dbo].[WorkFlow_Activities] ([ID])
GO
ALTER TABLE [dbo].[WorkFlow_ExecutionVariables] ADD CONSTRAINT [fk_WorkFlow_Execution_ID] FOREIGN KEY ([ExecID]) REFERENCES [dbo].[WorkFlow_Execution] ([ID]) ON DELETE CASCADE
GO

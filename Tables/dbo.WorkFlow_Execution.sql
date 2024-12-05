CREATE TABLE [dbo].[WorkFlow_Execution]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_Execution__ID] DEFAULT (newsequentialid()),
[AccountID] [int] NOT NULL,
[ActivityID] [uniqueidentifier] NOT NULL,
[EnteredDate] [datetime] NOT NULL CONSTRAINT [DF__WorkFlow_Execution__EnteredDate] DEFAULT (getdate()),
[NextEvaluateDate] [datetime] NOT NULL CONSTRAINT [DF__WorkFlow_Execution__NextEvaluateDate] DEFAULT (getdate()),
[LastEvaluated] [datetime] NOT NULL CONSTRAINT [DF__WorkFlow_Execution__LastEvaluated] DEFAULT (getdate()),
[Priority] [tinyint] NOT NULL CONSTRAINT [DF__WorkFlow_Execution__Priority] DEFAULT ((100)),
[LastEvaluatedWithPriority] [datetime] NOT NULL CONSTRAINT [DF__WorkFlow_Execution__LastEvaluatedWithPriority] DEFAULT (getdate()),
[PauseCount] [int] NOT NULL CONSTRAINT [DF__WorkFlow_Execution__PauseCount] DEFAULT ((0)),
[ChildExecID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_Execution] WITH NOCHECK ADD CONSTRAINT [chk_WorkFlow_Execution_PauseCount] CHECK (([PauseCount]>=(0)))
GO
ALTER TABLE [dbo].[WorkFlow_Execution] ADD CONSTRAINT [pk_WorkFlow_Execution] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WorkFlow_Execution_AccountID_ActivityID] ON [dbo].[WorkFlow_Execution] ([AccountID]) INCLUDE ([ActivityID]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WorkFlow_Execution_ActivityID] ON [dbo].[WorkFlow_Execution] ([ActivityID]) INCLUDE ([NextEvaluateDate], [PauseCount]) WITH (FILLFACTOR=80, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WorkFlow_Execution_NextActivities] ON [dbo].[WorkFlow_Execution] ([ChildExecID]) INCLUDE ([Priority], [LastEvaluatedWithPriority]) WITH (FILLFACTOR=70, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WorkFlow_Execution_ActivityStats] ON [dbo].[WorkFlow_Execution] ([EnteredDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_Execution] ADD CONSTRAINT [fk_WorkFlow_Execution_ActivityID_WorkFlow_Activities_ID] FOREIGN KEY ([ActivityID]) REFERENCES [dbo].[WorkFlow_Activities] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkFlow_Execution] ADD CONSTRAINT [fk_WorkFlow_Execution_ChildExecID_WorkFlow_Execution_ID] FOREIGN KEY ([ChildExecID]) REFERENCES [dbo].[WorkFlow_Execution] ([ID])
GO

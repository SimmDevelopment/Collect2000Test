CREATE TABLE [dbo].[WorkFlow_Counters]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_Counters__ID] DEFAULT (newsequentialid()),
[AccountID] [int] NOT NULL,
[WorkFlowID] [uniqueidentifier] NULL,
[ExecID] [uniqueidentifier] NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_Counters] ADD CONSTRAINT [pk_WorkFlow_Counters] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_WorkFlow_Counters_AccountID_ExecID_Name] ON [dbo].[WorkFlow_Counters] ([AccountID], [WorkFlowID], [ExecID], [Name]) ON [PRIMARY]
GO

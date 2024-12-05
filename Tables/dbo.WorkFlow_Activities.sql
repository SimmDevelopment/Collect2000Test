CREATE TABLE [dbo].[WorkFlow_Activities]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_Activities__ID] DEFAULT (newsequentialid()),
[WorkFlowID] [uniqueidentifier] NOT NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivityXML] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastEvaluated] [datetime] NULL,
[NextEvaluateDate] [datetime] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__WorkFlow_Activities__Active] DEFAULT ((1)),
[RedirectActivityID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_Activities__RedirectActivityID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[Version] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_Activities] ADD CONSTRAINT [pk_WorkFlow_Activities] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_Activities] ADD CONSTRAINT [fk_WorkFlow_Activities_WorkFlowID_WorkFlows_ID] FOREIGN KEY ([WorkFlowID]) REFERENCES [dbo].[WorkFlows] ([ID])
GO

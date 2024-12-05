CREATE TABLE [dbo].[WorkFlow_EventConfiguration]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_EventConfiguration__ID] DEFAULT (newsequentialid()),
[Class] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventID] [uniqueidentifier] NOT NULL,
[WorkFlowID] [uniqueidentifier] NULL,
[InitialPriority] [tinyint] NOT NULL CONSTRAINT [DF__WorkFlow___Initi__046A5DA2] DEFAULT (100),
[ActionType] [bit] NULL,
[WorkFlowDelay] [bigint] NOT NULL CONSTRAINT [DF__WorkFlow___WorkF__055E81DB] DEFAULT (0),
[Reentrance] [tinyint] NOT NULL CONSTRAINT [DF__WorkFlow___Reent__0652A614] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_EventConfiguration] ADD CONSTRAINT [chk_WorkFlow_EventConfiguration] CHECK ((NOT ([Class] IS NOT NULL AND [Customer] IS NOT NULL)))
GO
ALTER TABLE [dbo].[WorkFlow_EventConfiguration] ADD CONSTRAINT [pk_WorkFlow_EventConfiguration] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_EventConfiguration] ADD CONSTRAINT [uq_WorkFlow_EventConfiguration_Class_Customer_EventID] UNIQUE NONCLUSTERED ([Class], [Customer], [EventID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_EventConfiguration] WITH NOCHECK ADD CONSTRAINT [fk_WorkFlow_EventConfiguration_Customer_Customer_Customer] FOREIGN KEY ([Customer]) REFERENCES [dbo].[Customer] ([customer]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkFlow_EventConfiguration] ADD CONSTRAINT [fk_WorkFlow_EventConfiguration_EventID_WorkFlow_Events_ID] FOREIGN KEY ([EventID]) REFERENCES [dbo].[WorkFlow_Events] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkFlow_EventConfiguration] ADD CONSTRAINT [fk_WorkFlow_EventConfiguration_WorkFlowID_WorkFlows_ID] FOREIGN KEY ([WorkFlowID]) REFERENCES [dbo].[WorkFlows] ([ID]) ON DELETE CASCADE
GO

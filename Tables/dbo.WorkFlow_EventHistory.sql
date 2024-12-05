CREATE TABLE [dbo].[WorkFlow_EventHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_EventHistory__ID] DEFAULT (newsequentialid()),
[EventID] [uniqueidentifier] NOT NULL,
[EventName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountID] [int] NOT NULL,
[Occurred] [datetime] NOT NULL CONSTRAINT [DF__WorkFlow___Occur__2D6C7335] DEFAULT (getdate()),
[EventVariable] [sql_variant] NULL,
[WorkFlowID] [uniqueidentifier] NULL,
[ActionType] [bit] NULL,
[Reentrance] [tinyint] NOT NULL CONSTRAINT [DF__WorkFlow___Reent__2E60976E] DEFAULT (0),
[WorkFlowDelay] [bigint] NOT NULL CONSTRAINT [DF__WorkFlow___WorkF__2F54BBA7] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_EventHistory] ADD CONSTRAINT [pk_WorkFlow_EventHistory] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WorkFlow_EventHistory] ON [dbo].[WorkFlow_EventHistory] ([AccountID]) INCLUDE ([EventID], [Occurred]) WITH (FILLFACTOR=70, PAD_INDEX=ON) ON [PRIMARY]
GO

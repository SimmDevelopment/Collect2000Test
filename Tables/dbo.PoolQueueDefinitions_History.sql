CREATE TABLE [dbo].[PoolQueueDefinitions_History]
(
[UID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF__PoolQueueDe__UID__265C5597] DEFAULT (newid()),
[ID] [int] NOT NULL,
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Conditions] [image] NOT NULL,
[QueueAhead] [int] NOT NULL,
[Version] [binary] (8) NOT NULL,
[Order] [image] NULL,
[StartDate] [datetime] NOT NULL CONSTRAINT [DF__PoolQueue__Start__275079D0] DEFAULT (getdate()),
[EndDate] [datetime] NULL,
[ChangedBy] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PoolQueueDefinitions_History] ADD CONSTRAINT [pk_PoolQueueDefinitions_History] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PoolQueueDefinitions_History] ON [dbo].[PoolQueueDefinitions_History] ([ID], [Version] DESC) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SupportQueueItems]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[QueueCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountID] [int] NOT NULL,
[DateAdded] [datetime] NOT NULL,
[DateDue] [datetime] NULL,
[LastAccessed] [datetime] NOT NULL CONSTRAINT [DF_SupportQueueItems_LastAccessed] DEFAULT (getdate()),
[ShouldQueue] [bit] NOT NULL CONSTRAINT [DF_SupportQueueItems_ShouldQueue] DEFAULT (1),
[UserName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QueueType] [tinyint] NOT NULL CONSTRAINT [DF_SupportQueueItems_QueueType] DEFAULT (0),
[Comment] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SupportQueueItems] ADD CONSTRAINT [PK_SupportQueueItems] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SpecialQueueItems_AccountID] ON [dbo].[SupportQueueItems] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SupportQueueItems_LastAccessed] ON [dbo].[SupportQueueItems] ([LastAccessed]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SpecialQueueItems_QueueCode] ON [dbo].[SupportQueueItems] ([QueueCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

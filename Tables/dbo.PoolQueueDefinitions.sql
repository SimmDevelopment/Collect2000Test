CREATE TABLE [dbo].[PoolQueueDefinitions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Conditions] [image] NOT NULL,
[QueueAhead] [int] NOT NULL CONSTRAINT [DF__PoolQueue__Queue__3F5D0D8B] DEFAULT (50),
[Version] [timestamp] NOT NULL,
[Order] [image] NULL,
[ChangedBy] [int] NOT NULL CONSTRAINT [DF__PoolQueue__Chang__405131C4] DEFAULT (0),
[LastModified] [datetime] NOT NULL CONSTRAINT [DF__PoolQueue__LastM__414555FD] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PoolQueueDefinitions] ADD CONSTRAINT [PK__PoolQueueDefinit__1571C0B7] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_PoolQueueDefinitions_Name] ON [dbo].[PoolQueueDefinitions] ([Name]) ON [PRIMARY]
GO

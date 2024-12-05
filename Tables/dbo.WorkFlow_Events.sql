CREATE TABLE [dbo].[WorkFlow_Events]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_Events__ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SystemEvent] [bit] NOT NULL,
[Conditions] [image] NULL,
[MinimumDays] [int] NOT NULL CONSTRAINT [DF__WorkFlow_Events__MinimumDays] DEFAULT ((0)),
[MaximumDays] [int] NOT NULL CONSTRAINT [DF__WorkFlow_Events__MaximumDays] DEFAULT ((2147483647)),
[ReoccurDays] [int] NULL,
[LastEvaluated] [datetime] NULL CONSTRAINT [DF__WorkFlow_Events__LastEvaluated] DEFAULT (getdate()),
[NextEvaluateDelay] [bigint] NOT NULL CONSTRAINT [DF__WorkFlow_Events__NextEvaluateDelay] DEFAULT ((1440)),
[NextEvaluateDate] [datetime] NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF__WorkFlow_Events__Enabled] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_Events] ADD CONSTRAINT [pk_WorkFlow_Events] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_Events] ADD CONSTRAINT [uq_WorkFlow_Events_Name] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'WorkFlow_Events', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'WorkFlow_Events', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'WorkFlow_Events', 'COLUMN', N'Name'
GO

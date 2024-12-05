CREATE TABLE [dbo].[WorkForm_QueueProviders]
(
[UID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkForm_Qu__UID__639A6E01] DEFAULT (newid()),
[Order] [int] NOT NULL,
[Name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF__WorkForm___Enabl__648E923A] DEFAULT (1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkForm_QueueProviders] ADD CONSTRAINT [PK__WorkForm_QueuePr__1FEF4F2A] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkForm_QueueProviders] ADD CONSTRAINT [UQ__WorkForm_QueuePr__1EFB2AF1] UNIQUE NONCLUSTERED ([Order]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'WorkForm_QueueProviders', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'WorkForm_QueueProviders', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'WorkForm_QueueProviders', 'COLUMN', N'UID'
GO

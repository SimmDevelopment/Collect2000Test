CREATE TABLE [dbo].[WorkFlow_ActivityVersionHistory]
(
[WorkFlow_ActivityVersionHistoryID] [bigint] NOT NULL IDENTITY(1, 1),
[ID] [uniqueidentifier] NOT NULL,
[WorkFlowID] [uniqueidentifier] NOT NULL,
[Version] [int] NOT NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivityXML] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_ActivityVersionHistory] ADD CONSTRAINT [pk_WorkFlow_ActivityVersionHistory] PRIMARY KEY CLUSTERED ([WorkFlow_ActivityVersionHistoryID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_WorkFlow_ActivityVersionHistory] ON [dbo].[WorkFlow_ActivityVersionHistory] ([WorkFlowID], [Version], [ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_ActivityVersionHistory] ADD CONSTRAINT [fk_WorkFlow_ActivityVersionHistory_WorkFlow_VersionHistory] FOREIGN KEY ([WorkFlowID], [Version]) REFERENCES [dbo].[WorkFlow_VersionHistory] ([ID], [Version])
GO

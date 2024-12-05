CREATE TABLE [dbo].[WorkFlow_ForkRelationships]
(
[ParentID] [uniqueidentifier] NOT NULL,
[ChildID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_ForkRelationships] ADD CONSTRAINT [pk_WorkFlow_ForkRelationships] PRIMARY KEY CLUSTERED ([ParentID], [ChildID]) ON [PRIMARY]
GO

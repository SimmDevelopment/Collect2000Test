CREATE TABLE [dbo].[PoolQueueAssignments]
(
[UserID] [int] NULL,
[DefinitionID] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [pk_PoolQueueAssignments_UserID] ON [dbo].[PoolQueueAssignments] ([UserID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PoolQueueAssignments] ADD CONSTRAINT [FK__PoolQueue__Defin__1A3675D4] FOREIGN KEY ([DefinitionID]) REFERENCES [dbo].[PoolQueueDefinitions] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PoolQueueAssignments] ADD CONSTRAINT [FK__PoolQueue__UserI__1942519B] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID]) ON DELETE CASCADE
GO

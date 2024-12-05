CREATE TABLE [dbo].[PoolQueueAssignments_WorkHistory]
(
[UID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF__PoolQueueAs__UID__48E677C5] DEFAULT (newid()),
[DefinitionID] [int] NOT NULL,
[Version] [binary] (8) NOT NULL,
[UserID] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[Accounts] [int] NOT NULL,
[Worked] [int] NOT NULL,
[Contacted] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PoolQueueAssignments_WorkHistory] ADD CONSTRAINT [pk_PoolQueueAssignments_WorkHistory] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PoolQueueAssignments_WorkHistory_DefinitionID_Version] ON [dbo].[PoolQueueAssignments_WorkHistory] ([DefinitionID], [Version] DESC) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PoolQueueAssignments_WorkHistory_UserID] ON [dbo].[PoolQueueAssignments_WorkHistory] ([UserID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

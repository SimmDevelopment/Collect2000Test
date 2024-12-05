CREATE TABLE [dbo].[PoolQueueAssignments_History]
(
[UID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF__PoolQueueAs__UID__700044E6] DEFAULT (newid()),
[UserID] [int] NULL,
[DefinitionID] [int] NOT NULL,
[Version] [binary] (8) NOT NULL,
[ChangedBy] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PoolQueueAssignments_History] ADD CONSTRAINT [pk_PoolQueueAssignments_History] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PoolQueueAssignments_History_DefinitionID_Version] ON [dbo].[PoolQueueAssignments_History] ([DefinitionID], [Version]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

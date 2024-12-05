CREATE TABLE [dbo].[PoolQueueAssignments_WorkHistoryAccounts]
(
[UID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF__PoolQueueAs__UID__73D0D5CA] DEFAULT (newid()),
[HistoryID] [uniqueidentifier] NOT NULL,
[AccountID] [int] NOT NULL,
[StartDate] [datetime] NOT NULL CONSTRAINT [DF__PoolQueue__Start__74C4FA03] DEFAULT (getdate()),
[EndDate] [datetime] NULL,
[Worked] [bit] NOT NULL CONSTRAINT [DF__PoolQueue__Worke__75B91E3C] DEFAULT (0),
[Contacted] [bit] NOT NULL CONSTRAINT [DF__PoolQueue__Conta__76AD4275] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PoolQueueAssignments_WorkHistoryAccounts] ADD CONSTRAINT [pk_PoolQueueAssignments_WorkHistoryAccounts] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PoolQueueAssignments_WorkHistoryAccounts_Update] ON [dbo].[PoolQueueAssignments_WorkHistoryAccounts] ([HistoryID], [AccountID], [EndDate], [StartDate] DESC) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

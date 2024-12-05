CREATE TABLE [dbo].[AcctMoverJob_Items]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[JobID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[OldDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AcctMoverJob_Items] ADD CONSTRAINT [PK_AcctMoverJob_Items] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AcctMoverJob_Items_JobID] ON [dbo].[AcctMoverJob_Items] ([JobID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_AcctMoverJob_Items_JobID_AccountID] ON [dbo].[AcctMoverJob_Items] ([JobID], [AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AcctMoverJob_Items] ADD CONSTRAINT [FK_AcctMoverJob_Items_AcctMoverJob] FOREIGN KEY ([JobID]) REFERENCES [dbo].[AcctMoverJob] ([JobID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retains Desk History for Accounts Moved ', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob_Items', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob_Items', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity of Account Transaction', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob_Items', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'JobID responsible for action on account', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob_Items', 'COLUMN', N'JobID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Assignment after move', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob_Items', 'COLUMN', N'NewDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Assignment before Move', 'SCHEMA', N'dbo', 'TABLE', N'AcctMoverJob_Items', 'COLUMN', N'OldDesk'
GO

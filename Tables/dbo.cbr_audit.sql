CREATE TABLE [dbo].[cbr_audit]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[accountID] [int] NULL,
[debtorID] [int] NULL,
[dateCreated] [datetime] NULL,
[user] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_audit] ADD CONSTRAINT [PK_cbr_audit] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_audit_accountID] ON [dbo].[cbr_audit] ([accountID]) INCLUDE ([dateCreated]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'lists all transactions and changes made by the system and users to the reported account.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_audit', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber ID.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_audit', 'COLUMN', N'accountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of transaction', 'SCHEMA', N'dbo', 'TABLE', N'cbr_audit', 'COLUMN', N'comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date audit action performed and recorded.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_audit', 'COLUMN', N'dateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Debtor Identity for primary or co-debtor.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_audit', 'COLUMN', N'debtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity for audit transaction.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_audit', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon applying transaction', 'SCHEMA', N'dbo', 'TABLE', N'cbr_audit', 'COLUMN', N'user'
GO

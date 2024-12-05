CREATE TABLE [dbo].[EmailHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[DateChanged] [datetime] NOT NULL,
[UserChanged] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransmittedDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailHistory] ADD CONSTRAINT [PK_EmailHistory] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EmailHistory_AccountID] ON [dbo].[EmailHistory] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EmailHistory_DebtorID] ON [dbo].[EmailHistory] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction history for Debtor E-Mail address changes', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTime stamp of change', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', 'COLUMN', N'DateChanged'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Primary Key', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New/Current E-mail address', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', 'COLUMN', N'NewEmail'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Previous E-mail address', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', 'COLUMN', N'OldEmail'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTime stamp of recorded change', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', 'COLUMN', N'TransmittedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'EmailHistory', 'COLUMN', N'UserChanged'
GO

CREATE TABLE [dbo].[BankEntries]
(
[BankCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnteredDate] [datetime] NOT NULL,
[PrintedDate] [datetime] NULL,
[CutomerCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NOT NULL,
[Memo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrivateMemo] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckNumber] [int] NULL,
[Reconciled] [bit] NULL,
[Printed] [bit] NULL,
[UID] [int] NOT NULL IDENTITY(1, 1),
[GLEntryType] [int] NULL,
[BankEntrySubType] [int] NULL,
[UserID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Invoice] [int] NULL,
[CurrencyISO3] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_BankEntries_CurrencyISO3] DEFAULT ('USD'),
[CheckType] [tinyint] NOT NULL CONSTRAINT [DF__BankEntries__CheckType] DEFAULT ((0)),
[Hold] [bit] NOT NULL CONSTRAINT [DF__BankEntries__Hold] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BankEntries] ADD CONSTRAINT [PK_BankEntries] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Trust account transactions', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Amount of Transaction', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal Bank Code', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'BankCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number of check', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'CheckNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currency indicator', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'CurrencyISO3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude Customer code', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'CutomerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of transaction', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Timestamp of transaction', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'EnteredDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID of General Ledger Transaction Type', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'GLEntryType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice number transaction applies to', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'Invoice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Public memo for Check ', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'Memo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check has been printed indicator', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'Printed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Check was Printed', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'PrintedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal memo for accounting', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'PrivateMemo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction has been reconciled indicator', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'Reconciled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity of transaction', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon applying transaction', 'SCHEMA', N'dbo', 'TABLE', N'BankEntries', 'COLUMN', N'UserID'
GO

CREATE TABLE [dbo].[AddressHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[DateChanged] [datetime] NOT NULL,
[UserChanged] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldZipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewZipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransmittedDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AddressHistory] ADD CONSTRAINT [PK_AddressHistory] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AddressHistory_AccountID] ON [dbo].[AddressHistory] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AddressHistory_DebtorID] ON [dbo].[AddressHistory] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction record which retains address changes for the Debtor', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date change was executed', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'DateChanged'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor ID', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identity of transaction', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current City', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'NewCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current State', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'NewState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Street1', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'NewStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Street2', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'NewStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Zip Code', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'NewZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Previous City', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'OldCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Previous State', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'OldState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Previous Street1 Address', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'OldStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Previous Street2 Address', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'OldStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Previous Zip Code', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'OldZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date TimeStamp of Change', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'TransmittedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon ID that executed the change', 'SCHEMA', N'dbo', 'TABLE', N'AddressHistory', 'COLUMN', N'UserChanged'
GO

CREATE TABLE [dbo].[LegalLedgerType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDebit] [bit] NOT NULL CONSTRAINT [DF__LegalLedg__IsDeb__51015EE3] DEFAULT ((1)),
[Invoiceable] [bit] NOT NULL CONSTRAINT [DF__LegalLedg__Invoi__51F5831C] DEFAULT ((1))
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'A unique code to use for the ledger type, this will map on the import of transaction codes in AIM', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description of the ledger type', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique id of the ledger type, this will be stamped in Legal_Ledger', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to indicate if the ledger type is invoiceable or not', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'Invoiceable'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'Invoiceable'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to indicate if the ledger type is a debit or credit', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'IsDebit'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'LegalLedgerType', 'COLUMN', N'IsDebit'
GO

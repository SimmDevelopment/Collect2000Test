CREATE TABLE [dbo].[DebtorBankInfo]
(
[AcctID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[ABANumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountAddress1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountAddress2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountState] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountZipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountVerified] [bit] NULL,
[LastCheckNumber] [int] NULL,
[BankName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankState] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankZipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [def_DebtorBankInfo_AccountType] DEFAULT ('C'),
[BankID] [int] NOT NULL IDENTITY(1, 1),
[PaymentVendorTokenId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DebtorBankInfo] ADD CONSTRAINT [PK_DebtorBankInfo] PRIMARY KEY CLUSTERED ([AcctID], [DebtorID], [BankID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DebtorBankInfo] ADD CONSTRAINT [uq_DebtorBankInfo] UNIQUE NONCLUSTERED ([BankID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DebtorBankInfo] ADD CONSTRAINT [FK_DebtorBankInfo_PaymentVendorToken] FOREIGN KEY ([PaymentVendorTokenId]) REFERENCES [dbo].[PaymentVendorToken] ([Id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Banking account information for Debtors that have previously set up payment arrangements', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'ABA Routing number of Bank', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'ABANumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account holder address line 1', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountAddress1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account holder address line 2', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountAddress2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account holder city ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Checking account holder name', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Checking Account Number of Debtor/CoDebtor - Paying party', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account holder state', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of Account - (checking, savings, debit)', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Verification of funds completed', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountVerified'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account holder zipcode', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AccountZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FileNumber - Master.Number', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'AcctID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank branch Address', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'BankAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank branch City', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'BankCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Identity Key  ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'BankID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of Bank issuing account', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'BankName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'bank branch phone ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'BankPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank branch State', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'BankState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank branch zipcode', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'BankZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID of Debtor - Debtors.DebtorID', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last checknumber processed by bank', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'LastCheckNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK into PaymentVendorToken table. Once the payment information has been authorized via the Latitude Payment Vendor Gateway, then a PaymentVendorToken record is created to be used for all future transactions for this bank information.', 'SCHEMA', N'dbo', 'TABLE', N'DebtorBankInfo', 'COLUMN', N'PaymentVendorTokenId'
GO

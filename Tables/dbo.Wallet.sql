CREATE TABLE [dbo].[Wallet]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ModeStatus] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Wallet_ModeStatus] DEFAULT ('Listable'),
[LastOperation] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Wallet_LastOperation] DEFAULT ('New'),
[Type] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PaymentVendorTokenId] [int] NOT NULL,
[DebtorId] [int] NULL,
[SearchKey] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstitutionCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountType] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayorName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CCExpiration] [datetime] NULL,
[AllowedWhenEarly] [datetime] NULL,
[AllowedWhenLate] [datetime] NULL,
[DisplayName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL,
[CreatedWhen] [datetimeoffset] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedWhen] [datetimeoffset] NOT NULL,
[UpdatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Wallet] ADD CONSTRAINT [pk_Wallet] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_Wallet_Debtors] ON [dbo].[Wallet] ([DebtorId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_Wallet_PaymentVendorToken] ON [dbo].[Wallet] ([PaymentVendorTokenId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Wallet] ADD CONSTRAINT [fk_Wallet_Debtors] FOREIGN KEY ([DebtorId]) REFERENCES [dbo].[Debtors] ([DebtorID]) ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Wallet] ADD CONSTRAINT [fk_Wallet_PaymentVendorToken] FOREIGN KEY ([PaymentVendorTokenId]) REFERENCES [dbo].[PaymentVendorToken] ([Id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Display friendly front-end table for PaymentVendor tokens, user selectable payment instruments', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account number, masked', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'AccountNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'for ACH - Checking or Savings', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'AccountType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Optional early-side date range', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'AllowedWhenEarly'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Optional late-side date range', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'AllowedWhenLate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Expiration Date (for CC only)', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'CCExpiration'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Created by user login name', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When created', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reference to the Debtor', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'DebtorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'optional display name', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'DisplayName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'optional display order', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'DisplayOrder'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'for CC - the CC type, for ACH - the bank ABA number', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'InstitutionCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Simply the last payment operation result against this instrument, enum codes TBA', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'LastOperation'
GO
EXEC sp_addextendedproperty N'MS_Description', N'How this instrument is to be treated or searched, enum codes TBA', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'ModeStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reference to the PVG Token', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'PaymentVendorTokenId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name on Credit Card or Bank Account', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'PayorName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Optional search key for search-only lookups', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'SearchKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ACH or CC', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Updated by user login name', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'UpdatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When updated (what ?)', 'SCHEMA', N'dbo', 'TABLE', N'Wallet', 'COLUMN', N'UpdatedWhen'
GO

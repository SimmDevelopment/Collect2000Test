CREATE TABLE [dbo].[bank]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ABA] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckStockName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartCheckNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyISO3] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_bank_CurrencyISO3] DEFAULT ('USD'),
[PermitDepositToGeneral] [bit] NULL CONSTRAINT [def_bank_PermitDepositToGeneral] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bank] ADD CONSTRAINT [PK_bank] PRIMARY KEY NONCLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [bank1] ON [dbo].[bank] ([code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank account used by the collection agency to retain deposits directly from debtors or sent to the customer, then forwarded to the agency.  This account is also used to receive fees for the agency paid by the customer and to return customer debt collected by the agency.  Trust accounts may be used by one or multiple clients', 'SCHEMA', N'dbo', 'TABLE', N'bank', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'ABA Routing number of Bank', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'ABA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Trust account name used by Agency', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'AcctName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency''s checking account number for the Trust Account', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'AcctNum'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of check stock used for Bank', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'CheckStockName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank City', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal Bank Code', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currency indicator', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'CurrencyISO3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal Unique identity of Bank ', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of Bank', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Allows money collected and split between linked accounts having different banks to initially deposit to the General Trust. This will affect linked account selection in the Arrangements Wizard, as only accounts that may deposit to the same trust or general trust can be included in the same payment arrangement. ', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'PermitDepositToGeneral'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Phone', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Starting check number used by the invoicing application to print checks', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'StartCheckNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank State', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'bank', 'COLUMN', N'Zipcode'
GO

CREATE TABLE [dbo].[cbr_configuration]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Class] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [int] NULL,
[enabled] [bit] NOT NULL,
[portfolioType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[accountType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[minBalance] [money] NOT NULL,
[waitDays] [int] NOT NULL,
[creditorClass] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[originalCreditor] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[useAccountOriginalCreditor] [bit] NOT NULL,
[useCustomerOriginalCreditor] [bit] NOT NULL,
[principalOnly] [bit] NOT NULL,
[includeCodebtors] [bit] NOT NULL,
[deleteReturns] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_configuration] ADD CONSTRAINT [ck_cbr_configuration_ClassCustomerID] CHECK (([Class] IS NULL OR [CustomerID] IS NULL))
GO
ALTER TABLE [dbo].[cbr_configuration] ADD CONSTRAINT [pk_cbr_configuration] PRIMARY KEY NONCLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_configuration] ADD CONSTRAINT [uq_cbr_configuration_ClassCustomerID] UNIQUE NONCLUSTERED ([Class], [CustomerID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secondary configuration table for credit reporting used to define default and specific settings for all classes of business, customers and statuses.  Referenced by the view cbr_effectiveconfiguration.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account Type to be configured:                                          48 - Collection Agency/Attorney 77 - Returned Check 0C - Factoring Company Account/Debt Purchaser ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'accountType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Class of business as defined in the COB table .', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'Class'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'Class'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains a code indicating a general type of business for the Original Creditor Name. Values available: 01 Retail 02 Medical/Health Care 03 Oil Company 04 Government 05 Personal Services 06 Insurance 07 Educational 08 Banking 09 Rental/Leasing 10 Utilities 11 Cable/Cellular 12 Financial 13 Credit Union 14 Automotive 15 Check Guarantee', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'creditorClass'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key of Customer.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'CustomerID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'CustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set, returned accounts will be reported to the Bureau with a DA - Delete status.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'deleteReturns'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Switch that enables or disables credit reporting for the customer of business class.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'enabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity of row.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set, responsible Co-debtors may be reported.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'includeCodebtors'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum (original) balance to report.  Accounts with an original balance that does not reach this amount will not be reported. ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'minBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the company or agent who originally opened the account for the consumer as noted on the account, customer or CBR reporting console configuration.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'originalCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set, report only principal amounts.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'principalOnly'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If checked, the original creditor noted in the Customer Properties - Credit Bureaus tab will be sent as the creditor name. If no original creditor is assigned, the customer/client name will be sent as the creditor name.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'useAccountOriginalCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set, the original creditor noted in the Customer Properties - Credit Bureaus tab will be sent as the creditor name. If no original creditor is assigned, the customer/client name will be sent as the creditor name. ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'useCustomerOriginalCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days to wait after receiving the account (system receive date) before reporting to the credit bureau. ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_configuration', 'COLUMN', N'waitDays'
GO

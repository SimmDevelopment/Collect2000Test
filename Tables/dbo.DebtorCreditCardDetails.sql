CREATE TABLE [dbo].[DebtorCreditCardDetails]
(
[DebtorCreditCardID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[Amount] [money] NOT NULL,
[Settlement] [bit] NOT NULL,
[ProjectedCurrent] [money] NOT NULL,
[ProjectedRemaining] [money] NOT NULL,
[Surcharge] [money] NOT NULL,
[ProjectedFee] [money] NULL,
[ProjectedCollectorFee] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DebtorCreditCardDetails] ADD CONSTRAINT [pk_DebtorCreditCardDetails] PRIMARY KEY NONCLUSTERED ([DebtorCreditCardID], [AccountID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_DebtorCreditCardDetails_AccountID] ON [dbo].[DebtorCreditCardDetails] ([AccountID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Detail for creditcard payents that may be one to one or many to one depending on the respective spread algorythm which may split one payment across linked accounts.', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total or portion of amount when split', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'DebtorCreditCardID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected fee based on collector fee schedule.  Defaults to projected fee when collector feeschedule not defined', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'ProjectedCollectorFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected current balance before transaction is applied', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'ProjectedCurrent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected fee based on feeschedule when not overriden', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'ProjectedFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected remaining balance after transaction is applied', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'ProjectedRemaining'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit flag indicating arrangement is settlement', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'Settlement'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction surcharge amount or portion if split', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCardDetails', 'COLUMN', N'Surcharge'
GO

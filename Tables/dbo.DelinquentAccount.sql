CREATE TABLE [dbo].[DelinquentAccount]
(
[DelinquentAccountID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DaysPastDue] [int] NULL,
[CycleID] [int] NULL,
[RecurringBillingAmount] [money] NULL,
[BillingFrequency] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DueDate] [datetime] NULL,
[OnHold] [bit] NOT NULL CONSTRAINT [DF_DelinquentAccount_OnHold] DEFAULT ((0)),
[ContractCancelReason] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractCancelEffectiveDate] [datetime] NULL,
[Entered] [datetime] NOT NULL CONSTRAINT [DF_DelinquentAccount_Entered] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DelinquentAccount] ADD CONSTRAINT [PK_DelinquentAccount] PRIMARY KEY CLUSTERED ([DelinquentAccountID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DelinquentAccount] ADD CONSTRAINT [FK_DelinquentAccount_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'master.number', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Frequency of Recurring Billing Amount, Can be in terms of Monthly, Quarterly, Semi-Annually and Annually', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'BillingFrequency'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If populated, the date the account was cancelled', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'ContractCancelEffectiveDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If populated, the reason why the account was cancelled', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'ContractCancelReason'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cycle Code, the day the account cycles for billing purposes', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'CycleID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Number of Days Past Due', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'DaysPastDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity field', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'DelinquentAccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The current Due Date of payment', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'DueDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and Time record was populated', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'Entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether or not the account should be on hold', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'OnHold'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The reoccuring billing amount if applicable, e.g. monthly mortgage payment, monthly auto payment or annual service amount', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccount', 'COLUMN', N'RecurringBillingAmount'
GO

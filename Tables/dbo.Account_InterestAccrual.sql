CREATE TABLE [dbo].[Account_InterestAccrual]
(
[UID] [bigint] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[Date] [datetime] NOT NULL,
[InterestRate] [money] NOT NULL,
[LastInterest] [datetime] NOT NULL,
[Balance] [money] NOT NULL,
[InterestBuckets] [smallint] NOT NULL,
[InterestBearingAmount] [money] NOT NULL,
[PreviousInterest] [money] NOT NULL,
[Accrued] [money] NOT NULL,
[NewInterest] AS ([PreviousInterest]+[Accrued])
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account_InterestAccrual] ADD CONSTRAINT [pk_Account_InterestAccrual] PRIMARY KEY NONCLUSTERED ([UID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table was intended to serve as a historical record of interest accrual. It is not currently in use.', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The file number of the account (master.number)', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of interest calculated based on the interest rate, interest bearing amount and number of days since interest last calculated', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'Accrued'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The current total balance of the account (master.current0)', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'Balance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of the interest accrual ({ fn CURDATE() })', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'Date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total interest bearing balance calculated by adding up the current balance fields for each corresponding interest accruing bucket', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'InterestBearingAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The bitmask of the money buckets that accrue interest (COALESCE(master.InterestBuckets, customer.InterestBuckets, 1))', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'InterestBuckets'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The interest rate on the account (master.InterestRate)', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'InterestRate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that interest was last calculated/accrued on the account (master.LastInterest)', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'LastInterest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of accrued interest after adding calculated new interest', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'NewInterest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of accrued interest prior to adding calculating new interest (master.current2)', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'PreviousInterest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IDENTITY', 'SCHEMA', N'dbo', 'TABLE', N'Account_InterestAccrual', 'COLUMN', N'UID'
GO

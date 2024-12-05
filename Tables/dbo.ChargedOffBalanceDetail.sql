CREATE TABLE [dbo].[ChargedOffBalanceDetail]
(
[ChargedOffBalanceDetailId] [int] NOT NULL IDENTITY(1, 1),
[AccountId] [int] NOT NULL,
[ChargedOffAmount] [money] NULL,
[Interest] [money] NULL,
[Fees] [money] NULL,
[Payments] [money] NULL,
[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_ChargedOffBalanceDetail_LastModifiedDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChargedOffBalanceDetail] ADD CONSTRAINT [PK_ChargedOffBalanceDetails] PRIMARY KEY CLUSTERED ([ChargedOffBalanceDetailId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChargedOffBalanceDetail] ADD CONSTRAINT [FK_ChargedOffBalanceDetail_master_AccountId] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relates to Master.Number (Also a candidate key)', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffBalanceDetail', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Charged Off Amount', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffBalanceDetail', 'COLUMN', N'ChargedOffAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total non-interest fees and charges post-charge off, excluding fees incurred while in Latitude', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffBalanceDetail', 'COLUMN', N'Fees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Interest accrued post charge off, excluding fees incurred while in Latitude', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffBalanceDetail', 'COLUMN', N'Interest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Payments collected post charge-off, excluding payments in Latitude', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffBalanceDetail', 'COLUMN', N'Payments'
GO

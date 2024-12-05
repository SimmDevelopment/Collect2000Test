CREATE TABLE [dbo].[DelinquentAccountBalanceBucketHistory]
(
[DelinquentAccountBalanceBucketHistoryID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[BucketID] [int] NULL,
[Amount] [money] NOT NULL CONSTRAINT [DF_DelinquentAccountBalanceBucketHistory_Amount] DEFAULT ((0)),
[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DelinquentAccountBalanceBucketHistory] ADD CONSTRAINT [PK_DelinquentAccountBalanceBucketHistory] PRIMARY KEY CLUSTERED ([DelinquentAccountBalanceBucketHistoryID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DelinquentAccountBalanceBucketHistory] ADD CONSTRAINT [FK_DelinquentAccountBalanceBucketHistory_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'master.number', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucketHistory', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount contained in the bucket', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucketHistory', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The delinquency bucket for the Account. 0 = Current, 1 = 1 - [timeframe, typically 30], 2 = [timeframe+1] - [2*timeframe], etc.   NULL represents values that do not roll', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucketHistory', 'COLUMN', N'BucketID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Past Date for the Record', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucketHistory', 'COLUMN', N'Date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity for table', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucketHistory', 'COLUMN', N'DelinquentAccountBalanceBucketHistoryID'
GO

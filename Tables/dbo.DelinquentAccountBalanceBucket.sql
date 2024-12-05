CREATE TABLE [dbo].[DelinquentAccountBalanceBucket]
(
[DelinquentAccountBalanceBucketID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[BucketID] [int] NULL,
[Amount] [money] NOT NULL CONSTRAINT [DF_DelinquentAccountBalanceBucket_Amount] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DelinquentAccountBalanceBucket] ADD CONSTRAINT [PK_DelinquentAccountBalanceBucket] PRIMARY KEY CLUSTERED ([DelinquentAccountBalanceBucketID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DelinquentAccountBalanceBucket] ADD CONSTRAINT [FK_DelinquentAccountBalanceBucket_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'master.number', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucket', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount contained in the bucket', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucket', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The delinquency bucket for the Account. 0 = Current, 1 = 1 - [timeframe, typically 30], 2 = [timeframe+1] - [2*timeframe], etc.   NULL represents values that do not roll', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucket', 'COLUMN', N'BucketID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity for table', 'SCHEMA', N'dbo', 'TABLE', N'DelinquentAccountBalanceBucket', 'COLUMN', N'DelinquentAccountBalanceBucketID'
GO

CREATE TABLE [dbo].[PaymentVendorSeriesBookmark]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PaymentType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UsageCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CheckPointValue] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RFU] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastSyncTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorSeriesBookmark] ADD CONSTRAINT [PK_PaymentVendorSeriesBookmark] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorSeriesBookmark_VendorCode] ON [dbo].[PaymentVendorSeriesBookmark] ([VendorCode], [UsageCode], [PaymentType]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorSeriesBookmark] ADD CONSTRAINT [uq_PaymentVendorSeriesBookmark_VendorCode_Etc] UNIQUE NONCLUSTERED ([VendorCode], [UsageCode], [PaymentType]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains a checkpoint bookmark value from the payment vendor to hold the placement of the last global synchronization operation', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesBookmark', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check point value to be used in the next PVG Series Sync call', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesBookmark', 'COLUMN', N'CheckPointValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesBookmark', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last time the series records were synced (or created)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesBookmark', 'COLUMN', N'LastSyncTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PVG Payment type - either CC or ACH or (null)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesBookmark', 'COLUMN', N'PaymentType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reserved for Future Use', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesBookmark', 'COLUMN', N'RFU'
GO
EXEC sp_addextendedproperty N'MS_Description', N'What type of bookmark this is', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesBookmark', 'COLUMN', N'UsageCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Which vendor this series sync bookmark is for', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesBookmark', 'COLUMN', N'VendorCode'
GO

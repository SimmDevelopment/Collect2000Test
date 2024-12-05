CREATE TABLE [dbo].[PaymentVendorBatch]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[VendorCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PayMethodCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HoldProcessingUntil] [datetime] NOT NULL CONSTRAINT [DF__PaymentVe__HoldP__03C1E8DA] DEFAULT (getdate()),
[VendorBatchNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Closed] [datetime] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__PaymentVe__Creat__04B60D13] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorBatch] ADD CONSTRAINT [PK_PaymentVendorBatch] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents a batch at the payment vendor. Used to match payment vendor batches with Latitude batches, whenever possible.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime that this vendor batch was closed. Once closed, payments will no longer be associated with it.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', 'COLUMN', N'Closed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When was this record inserted?', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Some batches will need to be held in a batch state until a certain time period has passed. When is it ok to process this batch. Defaults to the current datetime.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', 'COLUMN', N'HoldProcessingUntil'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identity value.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'What type of payment device is this batch for? CC, ACH, etc.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', 'COLUMN', N'PayMethodCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The actual batch number that the vendor assigns to the batch.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', 'COLUMN', N'VendorBatchNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The payment vendor code.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorBatch', 'COLUMN', N'VendorCode'
GO

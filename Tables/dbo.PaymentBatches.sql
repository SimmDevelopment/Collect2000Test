CREATE TABLE [dbo].[PaymentBatches]
(
[BatchNumber] [int] NOT NULL,
[BatchType] [tinyint] NULL,
[CreatedDate] [datetime] NOT NULL,
[LastAmmended] [datetime] NULL,
[ItemCount] [int] NULL,
[SysMonth] [tinyint] NOT NULL,
[SysYear] [smallint] NOT NULL,
[ProcessedDate] [datetime] NULL,
[ProcessedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_PaymentBatches_CreatedBy] DEFAULT (suser_sname()),
[CreatedByApplication] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_PaymentBatches_CreatedByApplication] DEFAULT ('Unknown'),
[Description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpectedCount] [int] NULL,
[ExpectedAmount] [money] NULL,
[datetimeentered] [datetime] NULL,
[UseBatchSysDate] [bit] NULL,
[PaymentVendorBatchId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentBatches] ADD CONSTRAINT [PK_PaymentBatches] PRIMARY KEY NONCLUSTERED ([BatchNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentBatches] ON [dbo].[PaymentBatches] ([CreatedDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentBatches_ProcessedDate] ON [dbo].[PaymentBatches] ([ProcessedDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentBatches_1] ON [dbo].[PaymentBatches] ([SysYear], [SysMonth]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentBatches] ADD CONSTRAINT [FK_PaymentBatches_PaymentVendorBatch] FOREIGN KEY ([PaymentVendorBatchId]) REFERENCES [dbo].[PaymentVendorBatch] ([Id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for each record', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'BatchNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of Payhistory Batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'BatchType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that created the batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Global Library that created batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'CreatedByApplication'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Created  ', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'CreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of Batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Amount expected to be processed by batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'ExpectedAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Items expected to process', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'ExpectedCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Items in Batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'ItemCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Last Updated', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'LastAmmended'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK into the PaymentVendorBatch table. Valuable to associate a Latitude batch with a vendors batch on an invoice.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'PaymentVendorBatchId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Name the processed Batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'ProcessedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Batch Processed', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'ProcessedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'System Month for Batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'SysMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'System Year for Batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'SysYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to determine if the Batch shoud use the Batch System Date', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatches', 'COLUMN', N'UseBatchSysDate'
GO

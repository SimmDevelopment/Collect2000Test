CREATE TABLE [dbo].[PayhistoryAudit]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[FieldName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldOldValue] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldNewValue] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PaymentBatchId] [int] NULL,
[PaymentBatchItemsId] [int] NULL,
[PayhistoryId] [int] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__Payhistor__Creat__3E33DF28] DEFAULT (getdate()),
[CreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Payhistor__Creat__3F280361] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayhistoryAudit] ADD CONSTRAINT [PK_PayhistoryAudit] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_PayhistoryAudit] ON [dbo].[PayhistoryAudit] ([PaymentBatchId], [PaymentBatchItemsId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Item changed', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that Changed the data', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field name that was changed', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'FieldName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New data value', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'FieldNewValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old data value', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'FieldOldValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payhistory UID', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'PayhistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payhistory Batchid', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'PaymentBatchId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payhistory Batchitemsid', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'PaymentBatchItemsId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for each record', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryAudit', 'COLUMN', N'UID'
GO

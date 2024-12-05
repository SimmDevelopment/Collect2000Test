CREATE TABLE [dbo].[PaymentBatchItems]
(
[BatchNumber] [int] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1),
[FileNum] [int] NULL,
[DatePaid] [datetime] NULL CONSTRAINT [DF_PaymentBatchItems_DatePaid] DEFAULT (getdate()),
[Entered] [datetime] NULL CONSTRAINT [DF_PaymentBatchItems_Entered] DEFAULT (getdate()),
[PmtType] [tinyint] NULL,
[Paid0] [money] NULL,
[Paid1] [money] NULL,
[Paid2] [money] NULL,
[Paid3] [money] NULL,
[Paid4] [money] NULL,
[Paid5] [money] NULL,
[Paid6] [money] NULL,
[Paid7] [money] NULL,
[Paid8] [money] NULL,
[Paid9] [money] NULL,
[Paid10] [money] NULL,
[Fee0] [money] NULL,
[Fee1] [money] NULL,
[Fee2] [money] NULL,
[Fee3] [money] NULL,
[Fee4] [money] NULL,
[Fee5] [money] NULL,
[Fee6] [money] NULL,
[Fee7] [money] NULL,
[Fee8] [money] NULL,
[Fee9] [money] NULL,
[Fee10] [money] NULL,
[InvoiceFlags] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvKeyCode] [tinyint] NULL,
[OverPaidAmt] [money] NULL,
[ForwardeeFee] [money] NULL,
[IsPIF] [bit] NULL,
[IsSettlement] [bit] NULL,
[Comment] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayMethod] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReverseOfUID] [int] NULL CONSTRAINT [DF_PaymentBatchItems_ReverseOfUID] DEFAULT (0),
[Surcharge] [money] NULL,
[Tax] [money] NOT NULL CONSTRAINT [DF__PaymentBatc__Tax__365CE7DF] DEFAULT (0),
[CollectorFee] [money] NULL,
[PAIdentifier] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AIMAgencyId] [int] NULL,
[AIMDueAgency] [money] NULL,
[AIMAgencyFee] [money] NULL,
[CheckNUmber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeSched] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollectorFeeSched] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCorrection] [bit] NOT NULL CONSTRAINT [DF__PaymentBa__IsCor__5888AE08] DEFAULT (0),
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PaymentBat__Desk__597CD241] DEFAULT (0),
[IsFreeDemand] [bit] NOT NULL CONSTRAINT [DF__PaymentBa__IsFre__5A70F67A] DEFAULT (0),
[Created] [datetime] NOT NULL CONSTRAINT [DF__PaymentBa__Creat__5B651AB3] DEFAULT (getdate()),
[CreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PaymentBa__Creat__5C593EEC] DEFAULT (suser_sname()),
[datetimeentered] [datetime] NULL,
[CurrencyISO3] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PaymentBatchItems_CurrencyISO3] DEFAULT ('USD'),
[AIMBatchId] [int] NULL,
[AIMSendingID] [int] NULL,
[SubBatchType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostDateUID] [int] NULL,
[PaymentLinkUID] [int] NULL,
[DebtorId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentBatchItems] ADD CONSTRAINT [PK_PaymentBatchItems] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentBatchItems] ON [dbo].[PaymentBatchItems] ([BatchNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentBatchItems_Entered] ON [dbo].[PaymentBatchItems] ([Entered]) INCLUDE ([OverPaidAmt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentBatchItems_FileNum] ON [dbo].[PaymentBatchItems] ([FileNum]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentBatchItems_ReverseOfUid] ON [dbo].[PaymentBatchItems] ([ReverseOfUID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aim Agency Fee form Aim Agency table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'AIMAgencyFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aim Agency ID from Aim Agency table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'AIMAgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aim Batch ID ', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'AIMBatchId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aim due Agency from Aim agency table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'AIMDueAgency'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aim Agency Sending ID from Aim Agency table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'AIMSendingID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'BatchID from Payment Batches', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'BatchNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check Number if check payment type', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'CheckNUmber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'collector fee from fee schedule', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'CollectorFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'collecor fee schedule from fee schedule table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'CollectorFeeSched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'comment for pahyistory item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date item created', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that created payhistory item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currency type', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'CurrencyISO3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Item Paid', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'DatePaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DebtorID for payment from Debtors table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'DebtorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk account assigned to', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date item entered', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee 0 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee1 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee 10 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee2 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee3 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee4 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee 5 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee 6 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee 7 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'fee 8 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee8'
GO
EXEC sp_addextendedproperty N'MS_Description', N' fee 9 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Fee9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee Schedule id from Fee schedule table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'FeeSched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'FileNum'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee to Forward from fee schedule', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'ForwardeeFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'invoice flags for customer from payhistory', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'InvoiceFlags'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field to show if this item is a correction', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'IsCorrection'
GO
EXEC sp_addextendedproperty N'MS_Description', N'is Paid in full flag', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'IsPIF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'is settlement amount flag', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'IsSettlement'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Over Payment Amount', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'OverPaidAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 0  item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 1  item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 10 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Paid 2 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 3 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 4 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 5 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 6 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 7 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 8 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'paid 9 item', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Paid9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for each record', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'PAIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'payment method ACH, Credit', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'PayMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'batch type from payhistory:

PU = 1, PC =2, DA =3, PA =4, PUR = 5, PCR = 6, DAR = 7, PAR = 8
', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'PmtType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Post date UID if item from promises ', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'PostDateUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'reverseof uid for batch reversals', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'ReverseOfUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Batch type from payhistory', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'SubBatchType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surcharge amount', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Surcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Tax amount', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'Tax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for each record', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchItems', 'COLUMN', N'UID'
GO

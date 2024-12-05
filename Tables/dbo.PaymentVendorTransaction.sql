CREATE TABLE [dbo].[PaymentVendorTransaction]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PDCId] [int] NULL,
[DebtorCreditCardId] [int] NULL,
[PaymentVendorTokenId] [int] NULL,
[Amount] [money] NOT NULL CONSTRAINT [DF__PaymentVe__Amoun__13F850A3] DEFAULT ((0)),
[AuthDate] [smalldatetime] NOT NULL CONSTRAINT [DF__PaymentVe__AuthD__14EC74DC] DEFAULT (getdate()),
[AuthErrCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PaymentVe__AuthE__15E09915] DEFAULT ('0'),
[AuthErrDesc] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorBatchNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VendorReferenceNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsSurcharge] [bit] NOT NULL CONSTRAINT [DF__PaymentVe__IsSur__16D4BD4E] DEFAULT ((0)),
[Created] [datetime] NOT NULL CONSTRAINT [DF__PaymentVe__Creat__17C8E187] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PaymentLinkUID] [int] NULL,
[AuthorizationCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstitutionReferenceNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtraReferenceNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduledPaymentId] [int] NULL,
[PaymentVendorSeriesPaymentId] [int] NULL,
[BounceErrCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BounceErrDesc] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorTransaction] ADD CONSTRAINT [CHK_PaymentVendorTransaction_Type] CHECK (((1)=((case  when [PDCId] IS NOT NULL then (1) else (0) end+case  when [DebtorCreditCardId] IS NOT NULL then (1) else (0) end)+case  when [ScheduledPaymentId] IS NOT NULL then (1) else (0) end)))
GO
ALTER TABLE [dbo].[PaymentVendorTransaction] ADD CONSTRAINT [PK_PaymentVendorTransaction] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorTransaction_DebtorCreditCards] ON [dbo].[PaymentVendorTransaction] ([DebtorCreditCardId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorTransaction_PaymentLinkUID] ON [dbo].[PaymentVendorTransaction] ([PaymentLinkUID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorTransaction_PDC] ON [dbo].[PaymentVendorTransaction] ([PDCId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorTransaction_ScheduledPayment] ON [dbo].[PaymentVendorTransaction] ([ScheduledPaymentId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorTransaction_VendorReferenceNumber] ON [dbo].[PaymentVendorTransaction] ([VendorReferenceNumber]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorTransaction] ADD CONSTRAINT [FK_PaymentVendorTransaction_PaymentVendorSeriesPayment] FOREIGN KEY ([PaymentVendorSeriesPaymentId]) REFERENCES [dbo].[PaymentVendorSeriesPayment] ([Id])
GO
ALTER TABLE [dbo].[PaymentVendorTransaction] ADD CONSTRAINT [FK_PaymentVendorTransaction_PaymentVendorToken] FOREIGN KEY ([PaymentVendorTokenId]) REFERENCES [dbo].[PaymentVendorToken] ([Id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents a transaction attempt using the Latitude Payment Vendor Gateway.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total amount of the transaction.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime that the payment vendor reports that this transaction was authorized. If vendor does not suppor then this is simply set to the current datetime when record is inserted.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'AuthDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A code value assigned to this transaction if there was an decline. Zero indicates a successful transaction.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'AuthErrCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A textual description of the AuthErrCode.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'AuthErrDesc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Authorization code for successful transaction (Approval Code) returned from the account holders institution/bank.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'AuthorizationCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A code value assigned to this transaction if there was Return/Bounce AFTER the fact. Null indicates no bounce has been applied.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'BounceErrCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A textual description of the BounceErrCode.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'BounceErrDesc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When was this record inserted?', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nullable value that is the uid from the debtorcreditcards table if this Transaction represents a CC.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'DebtorCreditCardId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Miscelaneous extra reference information. The meaning is dependent on the vendor.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'ExtraReferenceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identity value.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value is the unique reference number assigned to this transaction by the account holder''s institution/bank.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'InstitutionReferenceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value of 1 indicates that this transaction was only for a surcharge, and that the principal amount was handled by a separate transaction (Usually immediately preceeding this transaction).', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'IsSurcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Virtual Key to link all the related payment items together.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'PaymentLinkUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'optional FK to the PaymentVendorSeriesPayment table for the series payment record that represents this payment(s).', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'PaymentVendorSeriesPaymentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the PaymentVendorToken table for the Token that was used in the transaction request to the Latitude Payment Vendor Gateway.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'PaymentVendorTokenId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nullable value that is the uid from the pdc table if this Transaction represents a PDC.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'PDCId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nullable value that is the uid from the scheduledpayment table if this Transaction represents a nPMT.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'ScheduledPaymentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the payment vendors batch number. Not all vendors support this, however the vendor module should fake a value in that case.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'VendorBatchNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This value is the unique reference number assigned to this transaction by the payment vendor.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorTransaction', 'COLUMN', N'VendorReferenceNumber'
GO

CREATE TABLE [dbo].[PaymentVendorSeriesPayment]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PaymentVendorSeriesId] [int] NOT NULL,
[PDCId] [int] NULL,
[DebtorCreditCardId] [int] NULL,
[Amount] [money] NOT NULL,
[SurchargeAmount] [money] NULL,
[ExecuteDate] [datetime] NOT NULL,
[Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PaymentVendorSeriesPayment__Status] DEFAULT ('Scheduled'),
[PaymentLinkUID] [int] NULL,
[PaymentIdentifier] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorSeriesPayment] ADD CONSTRAINT [CHK_PaymentVendorSeriesPayment_Type] CHECK (([PDCId] IS NOT NULL AND [DebtorCreditCardId] IS NULL OR [PDCId] IS NULL AND [DebtorCreditCardId] IS NOT NULL))
GO
ALTER TABLE [dbo].[PaymentVendorSeriesPayment] ADD CONSTRAINT [PK_PaymentVendorSeriesPayment] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorSeriesPayment_DebtorCreditCardId] ON [dbo].[PaymentVendorSeriesPayment] ([DebtorCreditCardId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorSeriesPayment_PaymentLinkUID] ON [dbo].[PaymentVendorSeriesPayment] ([PaymentLinkUID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorSeriesPayment_PaymentVendorSeriesId] ON [dbo].[PaymentVendorSeriesPayment] ([PaymentVendorSeriesId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorSeriesPayment_PDCId] ON [dbo].[PaymentVendorSeriesPayment] ([PDCId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorSeriesPayment] ADD CONSTRAINT [FK_PaymentVendorSeriesPayment_PaymentVendorSeries] FOREIGN KEY ([PaymentVendorSeriesId]) REFERENCES [dbo].[PaymentVendorSeries] ([Id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents a payment of a vendor managed series using the Latitude Payment Vendor Gateway.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The principal amount of this payment', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nullable value that is the uid from the debtorcreditcards table if this Transaction represents a CC.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'DebtorCreditCardId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When the payment is scheduled to process', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'ExecuteDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifiers returned from Payment Vendor Gateway to identify each payment of a series.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'PaymentIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Virtual Key to link all the related payment items together.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'PaymentLinkUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'reference to the parent record in PaymentVendorSeries', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'PaymentVendorSeriesId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nullable value that is the uid from the pdc table if this Transaction represents a PDC.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'PDCId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status of this vendor series - Scheduled, Cancelled, Completed - if Completed, there should be at least one record in PaymentVendorTransaction', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surcharge amount of this payment ONLY if there will be (or is) a separate transaction record, otherwise surcharge is combined with principal, and THIS field will be null', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeriesPayment', 'COLUMN', N'SurchargeAmount'
GO

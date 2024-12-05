CREATE TABLE [dbo].[PaymentVendorSeries]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ArrangementId] [int] NULL,
[AccountId] [int] NOT NULL,
[PaymentType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PaymentVendorTokenId] [int] NULL,
[SeriesIdentifier] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PaymentVendorSeries__Status] DEFAULT ('Active'),
[SeparateSurcharge] [bit] NOT NULL,
[ExternalCreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalCreatedDate] [datetime] NOT NULL,
[OriginalPaymentCount] [int] NOT NULL,
[OriginalTotalAmount] [money] NOT NULL,
[OriginalFirstPaymentDate] [datetime] NOT NULL,
[OriginalLastPaymentDate] [datetime] NOT NULL,
[SeriesSource] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastSyncTime] [datetime] NOT NULL,
[WhenCreated] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorSeries] ADD CONSTRAINT [PK_PaymentVendorSeries] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorSeries_AccountId] ON [dbo].[PaymentVendorSeries] ([AccountId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorSeries_ArrangementId] ON [dbo].[PaymentVendorSeries] ([ArrangementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorSeries_PaymentVendorTokenId] ON [dbo].[PaymentVendorSeries] ([PaymentVendorTokenId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorSeries] ADD CONSTRAINT [FK_PaymentVendorSeries_ArrangementId] FOREIGN KEY ([ArrangementId]) REFERENCES [dbo].[Arrangements] ([ID])
GO
ALTER TABLE [dbo].[PaymentVendorSeries] ADD CONSTRAINT [FK_PaymentVendorSeries_Master] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[master] ([number])
GO
ALTER TABLE [dbo].[PaymentVendorSeries] ADD CONSTRAINT [FK_PaymentVendorSeries_PaymentVendorToken] FOREIGN KEY ([PaymentVendorTokenId]) REFERENCES [dbo].[PaymentVendorToken] ([Id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents an arrangement *series* as created or managed by a payment vendor, linked to a Latitude Arrangement', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reference to the master account which owns this series', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of Parent Arrangement (it IS possible for a series to not have a parent arrangement if it was cancelled before we got to it)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'ArrangementId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If this series was created externally, then some string which indicates by whom (or null if we don''t know)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'ExternalCreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When this series was created (not the record, but the series)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'ExternalCreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last time the series records were synced (or created)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'LastSyncTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the first payment date of the series when it was first created', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'OriginalFirstPaymentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the last payment date of the series when it was first created', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'OriginalLastPaymentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the number of payments the series had when first created', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'OriginalPaymentCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the total principal amount of payments the series had when first created', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'OriginalTotalAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PVG Payment type of series - either CC or ACH', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'PaymentType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'optional reference to the token used to create this arrangement, if not externally created', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'PaymentVendorTokenId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether or not this series has surcharges in separate buckets', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'SeparateSurcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifier returned from Payment Vendor Gateway upon vendor series registration. Used when synchronizing or manipulating a series request to Latitude Payment Vendor Gateway.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'SeriesIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'a value indicating the name of the service used to create the series, or NULL to indicate Latitude did', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'SeriesSource'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status of this vendor series - Pending, Active, Complete, Incomplete, Cancelled, Error, FirstDecline', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the series records were created (or when the series was created)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorSeries', 'COLUMN', N'WhenCreated'
GO

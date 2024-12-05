CREATE TABLE [dbo].[PaymentVendorActivities]
(
[Ordering] [bigint] NOT NULL IDENTITY(1, 1),
[EventTie] [uniqueidentifier] NOT NULL CONSTRAINT [DF_PaymentVendorActivities_EventTie] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[HostName] [char] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PaymentVendorActivities_HostName] DEFAULT ('UNKNOWN'),
[LoginName] [char] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PaymentVendorActivities_LoginName] DEFAULT (' '),
[ActionCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResultCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[When] [datetime] NOT NULL CONSTRAINT [DF_PaymentVendorActivities_When] DEFAULT (getutcdate()),
[WhenLocal] [datetime] NOT NULL CONSTRAINT [DF_PaymentVendorActivities_WhenLocal] DEFAULT (getdate()),
[Flags] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkFileNumber] [int] NULL,
[LinkTblType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PaymentVendorActivities_LinkTblType] DEFAULT (' '),
[LinkUID] [int] NULL,
[LinkPLUID] [int] NULL,
[LinkTokenID] [int] NULL,
[LinkSeriesIdentifier] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkPaymentIdentifier] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkVendorReferenceNumber] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkOtherKey1] [int] NULL,
[LinkOtherKey2] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorActivities] ADD CONSTRAINT [PK_PaymentVendorActivities] PRIMARY KEY CLUSTERED ([Ordering]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorActivities_ActionCode] ON [dbo].[PaymentVendorActivities] ([ActionCode], [LinkFileNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorActivities_FileNumber] ON [dbo].[PaymentVendorActivities] ([LinkFileNumber], [ActionCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorActivities_3rd] ON [dbo].[PaymentVendorActivities] ([LinkPaymentIdentifier]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorActivities_2nd] ON [dbo].[PaymentVendorActivities] ([LinkUID], [LinkTblType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorActivities_VenRef] ON [dbo].[PaymentVendorActivities] ([LinkVendorReferenceNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PaymentVendorActivities_When] ON [dbo].[PaymentVendorActivities] ([When]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Traces a particular operation of the Latitude payment system, most pointedly, interactions with Payment Vendor Gateway', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'action code for the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'ActionCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Any textual details relevant to the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'identifier which ties a group of related records together', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'EventTie'
GO
EXEC sp_addextendedproperty N'MS_Description', N'relevant flags for the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'Flags'
GO
EXEC sp_addextendedproperty N'MS_Description', N'computer from which the operation was run', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'HostName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the ID of a latitude account associated with the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkFileNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'context specific key or ID associated with the event (int)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkOtherKey1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'context specific key or ID associated with the event (text)', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkOtherKey2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'external paymentID associated with the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkPaymentIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PaymentLinkUID associated with the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkPLUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'external seriesID associated with the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkSeriesIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether the LinkUID refers to the PDC, DebtorCreditCards or ScheduledPayment table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkTblType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PaymentVendorTokenID associated with the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkTokenID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UID of the associated record in a payment table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'vendor reference number associated with the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LinkVendorReferenceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'assigned latitude login by which the operation was run', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'LoginName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'primary key and order in which the record was inserted', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'Ordering'
GO
EXEC sp_addextendedproperty N'MS_Description', N'payment type associated with the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'PaymentType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'result code for the event', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'ResultCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the event occurred in UTC', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'When'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when the event occurred in local time', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorActivities', 'COLUMN', N'WhenLocal'
GO

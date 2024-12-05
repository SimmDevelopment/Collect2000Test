CREATE TABLE [dbo].[Attunely_ScheduledPayments]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScheduledPaymentKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountCents] [int] NOT NULL,
[PromiseMadeTime] [datetime2] NOT NULL,
[PaymentDeadlineTime] [datetime2] NOT NULL,
[PaymentMethod_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_ScheduledPayments] ADD CONSTRAINT [PK_Attunely_ScheduledPayments] PRIMARY KEY CLUSTERED ([AccountKey], [ScheduledPaymentKey]) ON [PRIMARY]
GO

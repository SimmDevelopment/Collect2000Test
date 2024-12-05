CREATE TABLE [dbo].[FirstDataUploadPaymentsHistory]
(
[Number] [int] NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PID] [int] NOT NULL,
[FileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDate] [datetime] NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeAmount] [money] NOT NULL CONSTRAINT [DF__FirstData__FeeAm__398F259C] DEFAULT (0),
[NetTotal] [money] NOT NULL,
[PaymentAmount] [money] NOT NULL CONSTRAINT [DF__FirstData__Payme__3A8349D5] DEFAULT (0),
[PaymentDate] [datetime] NOT NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QLevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Current0] [money] NOT NULL,
[InvoiceNumber] [int] NOT NULL,
[BatchType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecordCode] [tinyint] NULL,
[AgencyCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankID] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceDate] [datetime] NOT NULL,
[InvoiceFlags] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceStartDate] [datetime] NOT NULL,
[InvoiceEndDate] [datetime] NOT NULL,
[InvoiceType] [tinyint] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FirstDataUploadPaymentsHistory] ADD CONSTRAINT [PK_FirstDataUploadPaymentsHistory] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndFileName] ON [dbo].[FirstDataUploadPaymentsHistory] ([FileName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndInvoiceNumber] ON [dbo].[FirstDataUploadPaymentsHistory] ([InvoiceNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndNumber] ON [dbo].[FirstDataUploadPaymentsHistory] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndRunDate] ON [dbo].[FirstDataUploadPaymentsHistory] ([RunDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

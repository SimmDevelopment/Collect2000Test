CREATE TABLE [dbo].[AIM_PaymentAudit]
(
[PaymentAuditId] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NULL,
[PaymentAmount] [money] NULL,
[FeeAmount] [money] NULL,
[IsFeeOnly] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchFileHistoryId] [int] NULL,
[ReceivingAgencyId] [int] NULL,
[CreditingAgencyId] [int] NULL,
[BatchType] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubBatchType] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processed] [bit] NULL,
[ThrewException] [bit] NULL,
[DateTimeEntered] [datetime] NULL,
[PaymentIdentifier] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO

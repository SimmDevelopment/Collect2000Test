CREATE TABLE [dbo].[CbrReportDetail]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ReportId] [int] NULL,
[AccountId] [int] NULL,
[Balance] [money] NULL,
[Status] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActivityType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecialComment] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CbrClass] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Received] [datetime] NULL,
[Original1] [money] NULL,
[Current1] [money] NULL,
[DelinquencyDate] [datetime] NULL,
[Clidlc] [datetime] NULL,
[Returned] [datetime] NULL,
[LastPaid] [datetime] NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MR] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current0] [money] NULL,
[ActualPaymentAmount] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CbrReportDetail] ADD CONSTRAINT [PK_CbrReportDetail] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

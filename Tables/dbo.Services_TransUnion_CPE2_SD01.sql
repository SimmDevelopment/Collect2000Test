CREATE TABLE [dbo].[Services_TransUnion_CPE2_SD01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SummaryType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HighCredit] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditLimit] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Balance] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountPastDue] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MonthlyPayment] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PercentOfCreditAvailable] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_SD01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_SD01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

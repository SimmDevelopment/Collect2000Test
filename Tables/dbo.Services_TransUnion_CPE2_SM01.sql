CREATE TABLE [dbo].[Services_TransUnion_CPE2_SM01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreaditSummaryReportingPeriod] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfPublicRecords] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfCollections] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfNegativeTrades] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TradesWithAnyHistoricalNegative] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccurranceOfHistoricalNegatives] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfTrades] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfRevolvingAndCheckCreditTrades] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfInstallmentTrades] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfMortgageTrades] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfOpenTradeAccounts] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfInquiries] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_SM01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_SM01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

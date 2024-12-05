CREATE TABLE [dbo].[Services_TransUnion_CPE2_IN01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauMarket] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauSubMarket] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberName] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanAmount] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfInquiry] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_IN01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_IN01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

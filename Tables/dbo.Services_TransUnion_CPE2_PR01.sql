CREATE TABLE [dbo].[Services_TransUnion_CPE2_PR01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PublicRecordType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocketNumber] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plainitff] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateFiled] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatePaid] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assets] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LiabiltiesAmount] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountDesignator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtLocationCity] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtLocationState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_PR01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_PR01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

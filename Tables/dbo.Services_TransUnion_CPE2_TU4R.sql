CREATE TABLE [dbo].[Services_TransUnion_CPE2_TU4R]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VersionSwitch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LanguageIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserReferenceNumber] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauMarket] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauSubmarket] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionTime] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_TU4R] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_TU4R] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Services_TransUnion_CPE2_YI01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IDQualifier] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfYearsCovered] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RangeOfYearsIssuedFrom] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RangeOfYearsIssuedTo] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SignOfAgeObtainedFrom] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgeObtainiedFrom] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SignOfAgeObtainedTo] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgeObtainedTo] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuanceYearStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_YI01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_YI01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

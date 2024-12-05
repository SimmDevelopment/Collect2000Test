CREATE TABLE [dbo].[Services_TransUnion_CPE2_DC01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityLastResidency] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateLastResidency] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCodeLastResidency] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityLocationOfPayments] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateLocationOfPayments] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCodeLocationOfPayments] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfBirthOfDeceased] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfDeath] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeceasedInformationFileSearched] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_DC01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_DC01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

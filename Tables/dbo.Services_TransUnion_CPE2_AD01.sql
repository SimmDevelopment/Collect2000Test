CREATE TABLE [dbo].[Services_TransUnion_CPE2_AD01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressQualifier] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Predirectional] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetName] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postdirectional] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApartmentUnitNumber] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateReported] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_AD01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_AD01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

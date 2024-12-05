CREATE TABLE [dbo].[Services_TransUnion_CPE2_AM01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputAddressIndex] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileAddressIndex] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseNumberMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreDirectionalMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetNameMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetTypeMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityNameMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateCodeMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCodeMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApartmentNumberMatch] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_AM01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_AM01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

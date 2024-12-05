CREATE TABLE [dbo].[Services_CT_Address]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[RecordType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddrSegIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryStreetID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreDirection] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostDirection] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetSuffix] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NonStandardAddress] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler01] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CensusGeoCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GeoStateCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GeoCountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstReportedDate] [datetime] NULL,
[LastUpdatedDate] [datetime] NULL,
[OriginationCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberTimesReported] [int] NULL,
[Filler02] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_CT_Address] ADD CONSTRAINT [PK_Services_CT_Address] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

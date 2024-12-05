CREATE TABLE [dbo].[Services_TransUnion_CPE2_GC01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GEOStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSA-MDCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CensusTractCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CensusTractSuffix] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BlockCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Latitude] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Longitude] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_GC01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_GC01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

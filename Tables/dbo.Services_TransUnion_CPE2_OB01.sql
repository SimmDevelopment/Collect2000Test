CREATE TABLE [dbo].[Services_TransUnion_CPE2_OB01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauAddress] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauCityStateZip] [varchar] (29) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauTelephoneNumber] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_OB01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_OB01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

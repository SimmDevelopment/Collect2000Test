CREATE TABLE [dbo].[Services_SurePlacement_Assessment]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[Parcel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerName] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnAddress] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnCity] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnState] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnZipcode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SaleDate] [datetime] NULL,
[SalePrice] [money] NULL,
[SellerName] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssmtValue] [money] NULL,
[AssmtTotalValue] [money] NULL,
[AssmtMarketValue] [money] NULL,
[ShortLegalDesc] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SquareFootage] [int] NULL,
[NumRooms] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConstructionType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssessmentType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_Assessment] ADD CONSTRAINT [PK_Services_SurePlacement_Assessment] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Services_SurePlacement_Deed]
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
[LoanAmt] [money] NULL,
[LenderName] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeedCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeedSeqNum] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_Deed] ADD CONSTRAINT [PK_Services_SurePlacement_Deed] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO

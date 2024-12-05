CREATE TABLE [dbo].[Portfolio]
(
[PortfolioId] [int] NOT NULL IDENTITY(1, 1),
[SellerBuyerId] [int] NULL,
[PortfolioType] [int] NULL,
[PortfolioName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionDate] [datetime] NULL,
[WarrantyExpiration] [datetime] NULL,
[StatmentMediaCost] [money] NULL,
[ApplicationCost] [money] NULL,
[PurchasePrice] [money] NULL,
[SalesPrice] [money] NULL,
[Misc1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Misc2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Misc3] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Misc4] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO

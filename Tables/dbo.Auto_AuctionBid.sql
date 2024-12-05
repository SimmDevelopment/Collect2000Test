CREATE TABLE [dbo].[Auto_AuctionBid]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[BidderCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BidAmount] [money] NULL,
[AcceptBid] [bit] NULL,
[BidDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auto_AuctionBid] ADD CONSTRAINT [PK_Auto_AuctionBid] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

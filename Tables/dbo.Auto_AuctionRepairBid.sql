CREATE TABLE [dbo].[Auto_AuctionRepairBid]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[RepairCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepairEstimate] [money] NULL,
[AcceptEstimate] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auto_AuctionRepairBid] ADD CONSTRAINT [PK__Auto_AuctionRepairBid] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Auto_AuctionRepairBid] ON [dbo].[Auto_AuctionRepairBid] ([AccountID]) ON [PRIMARY]
GO

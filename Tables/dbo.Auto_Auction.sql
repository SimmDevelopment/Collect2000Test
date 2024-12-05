CREATE TABLE [dbo].[Auto_Auction]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[BidCloseDate] [datetime] NULL,
[CollateralAppraiserCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerPONumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCollateralAvailableforSale] [datetime] NULL,
[DateAppraisalReceived] [datetime] NULL,
[InspectionDate] [datetime] NULL,
[DateofLettertoLienHolder1] [datetime] NULL,
[DateofLettertoLienHolder2] [datetime] NULL,
[DateRepairsCompleted] [datetime] NULL,
[DateRepairsOrdered] [datetime] NULL,
[DateRepairsApproved] [datetime] NULL,
[TitleOrderedDate] [datetime] NULL,
[TitleSenttoAuction] [datetime] NULL,
[DatePaymentReceivedforCollatoral] [datetime] NULL,
[TitleReceivedDate] [datetime] NULL,
[DateCollateralSold] [datetime] NULL,
[DateAppraisalVerified] [datetime] NULL,
[DateNoticeSenttoGuarantor] [datetime] NULL,
[DateNoticeSenttoMaker] [datetime] NULL,
[DateNoticeSenttoOther] [datetime] NULL,
[RepairDescription] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralRepairsNeeded] [bit] NULL,
[SellAsIsorRepaired] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralSalePrice] [money] NULL,
[CollateralStockNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepairedValue] [money] NULL,
[RepairComments] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuctionExpense] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auto_Auction] ADD CONSTRAINT [PK_Auto_Auction] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

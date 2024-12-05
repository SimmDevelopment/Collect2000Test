SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAutoAuction]
@client_id int,
@file_number int,
@BidCloseDate [datetime],
@CollateralAppraiserCode [varchar](5),
@BuyerPONumber [varchar](10),
@DateCollateralAvailableforSale [datetime],
@DateAppraisalReceived [datetime],
@InspectionDate [datetime],
@DateofLettertoLienHolder1 [datetime],
@DateofLettertoLienHolder2 [datetime],
@DateRepairsCompleted  [datetime],
@DateRepairsOrdered  [datetime],
@DateRepairsApproved [datetime], 
@TitleOrderedDate  [datetime],
@TitleSenttoAuction  [datetime],
@DatePaymentReceivedforCollatoral  [datetime],
@TitleReceivedDate  [datetime],
@DateCollateralSold  [datetime],
@DateAppraisalVerified  [datetime],
@DateNoticeSenttoGuarantor [datetime],
@DateNoticeSenttoMaker  [datetime],
@DateNoticeSenttoOther [datetime],
@RepairDescription [varchar](300),
@CollateralRepairsNeeded [char](1),
@SellAsIsorRepaired [char](1),
@CollateralSalePrice [money],
@CollateralStockNumber [varchar](20),
@RepairedValue [money],
@RepairComments [varchar](300),
@Location [varchar] (100),
@AuctionExpense [money]
AS 
BEGIN

	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @client_id
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @receivernumber

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END

	IF NOT EXISTS(SELECT * FROM [dbo].[Auto_Auction]  (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN
		INSERT INTO [dbo].[Auto_Auction](
		[AccountID],
		[BidCloseDate],
		[CollateralAppraiserCode],
		[BuyerPONumber],
		[DateCollateralAvailableforSale],
		[DateAppraisalReceived],
		[InspectionDate],
		[DateofLettertoLienHolder1],
		[DateofLettertoLienHolder2],
		[DateRepairsCompleted],
		[DateRepairsOrdered],
		[DateRepairsApproved],
		[TitleOrderedDate],
		[TitleSenttoAuction],
		[DatePaymentReceivedforCollatoral],
		[TitleReceivedDate],
		[DateCollateralSold],
		[DateAppraisalVerified],
		[DateNoticeSenttoGuarantor],
		[DateNoticeSenttoMaker],
		[DateNoticeSenttoOther],
		[RepairDescription],
		[CollateralRepairsNeeded],
		[SellAsIsorRepaired],
		[CollateralSalePrice],
		[CollateralStockNumber],
		[RepairedValue],
		[RepairComments],
		[Location],
		[AuctionExpense])
		
		SELECT 
		@receiverNumber,--[AccountID] [int] NOT NULL,
		@BidCloseDate,--[BidCloseDate] [datetime] NULL,
		@CollateralAppraiserCode,--[CollateralAppraiserCode] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@BuyerPONumber,--[BuyerPONumber] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@DateCollateralAvailableforSale,--[DateCollateralAvailableforSale] [datetime] NULL,
		@DateAppraisalReceived,--[DateAppraisalReceived] [datetime] NULL,
		@InspectionDate,--[InspectionDate] [datetime] NULL,
		@DateofLettertoLienHolder1,--[DateofLettertoLienHolder1] [datetime] NULL,
		@DateofLettertoLienHolder2,--[DateofLettertoLienHolder2] [datetime] NULL,
		@DateRepairsCompleted,--[DateRepairsCompleted] [datetime] NULL,
		@DateRepairsOrdered,--[DateRepairsOrdered] [datetime] NULL,
		@DateRepairsApproved,--[DateRepairsApproved] [datetime] NULL,
		@TitleOrderedDate,--[TitleOrderedDate] [datetime] NULL,
		@TitleSenttoAuction,--[TitleSenttoAuction] [datetime] NULL,
		@DatePaymentReceivedforCollatoral,--[DatePaymentReceivedforCollatoral] [datetime] NULL,
		@TitleReceivedDate,--[TitleReceivedDate] [datetime] NULL,
		@DateCollateralSold,--[DateCollateralSold] [datetime] NULL,
		@DateAppraisalVerified,--[DateAppraisalVerified] [datetime] NULL,
		@DateNoticeSenttoGuarantor,--[DateNoticeSenttoGuarantor] [datetime] NULL,
		@DateNoticeSenttoMaker,--[DateNoticeSenttoMaker] [datetime] NULL,
		@DateNoticeSenttoOther,--[DateNoticeSenttoOther] [datetime] NULL,
		@RepairDescription,--[RepairDescription] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CASE WHEN @CollateralRepairsNeeded IN('1','Y','T') THEN 1 ELSE 0 END,--[CollateralRepairsNeeded] [bit] NULL,
		CASE WHEN @SellAsIsorRepaired IN('1','Y','T') THEN 1 ELSE 0 END,--[SellAsIsorRepaired] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@CollateralSalePrice,--[CollateralSalePrice] [money] NULL,
		@CollateralStockNumber,--[CollateralStockNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@RepairedValue,--[RepairedValue] [money] NULL,
		@RepairComments,--[RepairComments] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@Location,--[Location] Varchar(100) NULL,
		@AuctionExpense--[AuctionExpense] [Money] NULL
	END
END

GO

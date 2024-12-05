SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAutoAuctionBid]
@client_id int,
@file_number int,
@ID int,
@BidderCode [varchar](10),
@BidAmount [money],
@AcceptBid [varchar](1),
@BidDate [datetime] 
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

	IF NOT EXISTS(SELECT * FROM [dbo].[Auto_AuctionBid] (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN
		INSERT INTO [dbo].[Auto_AuctionBid](
		[AccountID],
		[BidderCode],
		[BidAmount],
		[AcceptBid],
		[BidDate])

		SELECT 
		@receiverNumber,--[AccountID] [int] NOT NULL,
		@BidderCode,--[BidderCode] [varchar](10) NULL,
		@BidAmount,--[BidAmount] [money] NULL,
		CASE WHEN @AcceptBid IN('1','Y','T') THEN 1 ELSE 0 END,--[AcceptBid] [bit] NULL,
		@BidDate--[BidDate] [datetime] NULL,

	END
END

GO

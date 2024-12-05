SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAutoAuctionRepairBid]
@client_id int,
@file_number int,
@ID int,
@RepairCode [varchar](10),
@RepairEstimate [money],
@AcceptEstimate [varchar](1)
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

	IF NOT EXISTS(SELECT * FROM [dbo].[Auto_AuctionRepairBid] (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN
	
		INSERT INTO [dbo].[Auto_AuctionRepairBid](
		[AccountID],
		[RepairCode],
		[RepairEstimate],
		[AcceptEstimate])

		SELECT 
		@receiverNumber,--[AccountID] [int] NOT NULL,
		@RepairCode,--[RepairCode] [varchar](10) NULL,
		@RepairEstimate,--[RepairEstimate] [money] NULL,
		CASE WHEN @AcceptEstimate IN('1','Y','T') THEN 1 ELSE 0 END--[AcceptEstimate] [bit] NULL
	END
END

GO

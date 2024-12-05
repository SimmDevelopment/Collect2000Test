SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAutoAuctionAppraisal]
@client_id int,
@file_number int,
@ID [int],
@AppraiserCode [varchar](10),
@AverageValue [money],
@RetailValue [money],
@AppraisalSourcePublication [varchar](30),
@AppraisalReceivedDate [datetime]
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

	IF NOT EXISTS(SELECT * FROM [dbo].[Auto_AuctionAppraisal] (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN
		INSERT INTO [dbo].[Auto_AuctionAppraisal](
		[AccountID],
		[AppraiserCode],
		[AverageValue],
		[RetailValue],
		[AppraisalSourcePublication],
		[AppraisalReceivedDate])

		SELECT 
		@receiverNumber,--[AccountID] [int] NOT NULL,
		@AppraiserCode,--[AppraiserCode] [varchar](10) NULL,
		@AverageValue,--[AverageValue] [money] NULL,
		@RetailValue,--[RetailValue] [money] NULL,
		@AppraisalSourcePublication,--[AppraisalSourcePublication] [varchar](30) NULL,
		@AppraisalReceivedDate--[AppraisalReceivedDate] [datetime] NULL,

	END

END

GO

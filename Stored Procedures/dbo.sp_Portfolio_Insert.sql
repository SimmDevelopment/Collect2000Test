SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_Portfolio_Insert*/
---------------------------------------------------------------------------------
-- Stored procedure that will insert 1 row in the table 'Portfolio'
-- Gets: @iPortfolioId int
-- Gets: @iSellerBuyerId int
-- Gets: @iPortfolioType int
-- Gets: @sPortfolioName varchar(50)
-- Gets: @daTransactionDate datetime
-- Gets: @daWarrantyExpiration datetime
-- Gets: @curStatmentMediaCost money
-- Gets: @curApplicationCost money
-- Gets: @curPurchasePrice money
-- Gets: @curSalesPrice money
-- Gets: @sMisc1 varchar(100)
-- Gets: @sMisc2 varchar(100)
-- Gets: @sMisc3 varchar(100)
-- Gets: @sMisc4 varchar(100)
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[sp_Portfolio_Insert]
	@iPortfolioId int OUTPUT,
	@iSellerBuyerId int,
	@iPortfolioType int,
	@sPortfolioName varchar(50),
	@daTransactionDate datetime,
	@daWarrantyExpiration datetime,
	@curStatmentMediaCost money,
	@curApplicationCost money,
	@curPurchasePrice money,
	@curSalesPrice money,
	@sMisc1 varchar(100),
	@sMisc2 varchar(100),
	@sMisc3 varchar(100),
	@sMisc4 varchar(100),
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- INSERT a new row in the table.
INSERT [dbo].[Portfolio]
(
	[SellerBuyerId],
	[PortfolioType],
	[PortfolioName],
	[TransactionDate],
	[WarrantyExpiration],
	[StatmentMediaCost],
	[ApplicationCost],
	[PurchasePrice],
	[SalesPrice],
	[Misc1],
	[Misc2],
	[Misc3],
	[Misc4]
)
VALUES
(
	@iSellerBuyerId,
	@iPortfolioType,
	@sPortfolioName,
	@daTransactionDate,
	@daWarrantyExpiration,
	@curStatmentMediaCost,
	@curApplicationCost,
	@curPurchasePrice,
	@curSalesPrice,
	@sMisc1,
	@sMisc2,
	@sMisc3,
	@sMisc4
)

-- Get the identity key
SET @iPortfolioId = SCOPE_IDENTITY()

-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR


GO

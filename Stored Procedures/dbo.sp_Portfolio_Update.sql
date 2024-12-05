SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Portfolio_Update*/
---------------------------------------------------------------------------------
-- Stored procedure that will update an existing row in the table 'Portfolio'
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
CREATE PROCEDURE [dbo].[sp_Portfolio_Update]
	@iPortfolioId int,
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
-- UPDATE an existing row in the table.
UPDATE [dbo].[Portfolio]
SET 
	[SellerBuyerId] = @iSellerBuyerId,
	[PortfolioType] = @iPortfolioType,
	[PortfolioName] = @sPortfolioName,
	[TransactionDate] = @daTransactionDate,
	[WarrantyExpiration] = @daWarrantyExpiration,
	[StatmentMediaCost] = @curStatmentMediaCost,
	[ApplicationCost] = @curApplicationCost,
	[PurchasePrice] = @curPurchasePrice,
	[SalesPrice] = @curSalesPrice,
	[Misc1] = @sMisc1,
	[Misc2] = @sMisc2,
	[Misc3] = @sMisc3,
	[Misc4] = @sMisc4
WHERE
	[PortfolioId] = @iPortfolioId
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

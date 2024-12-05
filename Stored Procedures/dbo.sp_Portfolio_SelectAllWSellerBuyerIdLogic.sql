SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Portfolio_SelectAllWSellerBuyerIdLogic*/
---------------------------------------------------------------------------------
-- Stored procedure that will select one or more existing rows from the table 'Portfolio'
-- based on a foreign key field.
-- Gets: @iSellerBuyerId int
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_Portfolio_SelectAllWSellerBuyerIdLogic]
	@iSellerBuyerId int,
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- SELECT one or more existing rows from the table.
SELECT
	[PortfolioId],
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
FROM [dbo].[Portfolio]
WHERE
	[SellerBuyerId] = @iSellerBuyerId
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

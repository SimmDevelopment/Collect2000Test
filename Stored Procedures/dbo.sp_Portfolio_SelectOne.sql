SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Portfolio_SelectOne*/
---------------------------------------------------------------------------------
-- Stored procedure that will select an existing row from the table 'Portfolio'
-- based on the Primary Key.
-- Gets: @iPortfolioId int
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_Portfolio_SelectOne]
	@iPortfolioId int,
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- SELECT an existing row from the table.
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
	[PortfolioId] = @iPortfolioId
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

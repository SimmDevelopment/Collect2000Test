SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Portfolio_SelectAll*/
---------------------------------------------------------------------------------
-- Stored procedure that will select all rows from the table 'Portfolio'
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_Portfolio_SelectAll]
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- SELECT all rows from the table.
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
ORDER BY 
	[PortfolioId] ASC
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

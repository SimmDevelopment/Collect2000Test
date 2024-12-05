SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_SellerBuyer_SelectAll*/
---------------------------------------------------------------------------------
-- Stored procedure that will select all rows from the table 'SellerBuyer'
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_SellerBuyer_SelectAll]
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- SELECT all rows from the table.
SELECT
	[SellerBuyerId],
	[SellerBuyerType],
	[name],
	[Address1],
	[Address2],
	[Address3],
	[City],
	[State],
	[Zipcode],
	[Phone],
	[Fax],
	[Email],
	[WebSite],
	[Misc1],
	[Misc2],
	[Misc3],
	[Misc4]
FROM [dbo].[SellerBuyer]
ORDER BY 
	[SellerBuyerId] ASC
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

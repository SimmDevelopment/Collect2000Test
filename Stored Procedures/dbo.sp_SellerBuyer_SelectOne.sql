SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_SellerBuyer_SelectOne*/
---------------------------------------------------------------------------------
-- Stored procedure that will select an existing row from the table 'SellerBuyer'
-- based on the Primary Key.
-- Gets: @iSellerBuyerId int
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_SellerBuyer_SelectOne]
	@iSellerBuyerId int,
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- SELECT an existing row from the table.
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
WHERE
	[SellerBuyerId] = @iSellerBuyerId
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

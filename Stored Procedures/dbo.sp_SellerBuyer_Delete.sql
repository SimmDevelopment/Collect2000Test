SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_SellerBuyer_Delete*/
---------------------------------------------------------------------------------
-- Stored procedure that will delete an existing row from the table 'SellerBuyer'
-- using the Primary Key. 
-- Gets: @iSellerBuyerId int
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_SellerBuyer_Delete]
	@iSellerBuyerId int,
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- DELETE an existing row from the table.
DELETE FROM [dbo].[SellerBuyer]
WHERE
	[SellerBuyerId] = @iSellerBuyerId
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

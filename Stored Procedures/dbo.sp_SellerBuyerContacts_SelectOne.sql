SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_SellerBuyerContacts_SelectOne*/
---------------------------------------------------------------------------------
-- Stored procedure that will select an existing row from the table 'SellerBuyerContacts'
-- based on the Primary Key.
-- Gets: @iSellerBuyerId int
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_SellerBuyerContacts_SelectOne]
	@iSellerBuyerId int,
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- SELECT an existing row from the table.
SELECT
	[SellerBuyerId],
	[ContactId],
	[ContactType],
	[Name],
	[Title],
	[Address1],
	[Address2],
	[Address3],
	[City],
	[State],
	[Zipcode],
	[Phone],
	[Fax],
	[Email],
	[Website],
	[Misc1],
	[Misc2],
	[Misc3],
	[Misc4]
FROM [dbo].[SellerBuyerContacts]
WHERE
	[SellerBuyerId] = @iSellerBuyerId
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

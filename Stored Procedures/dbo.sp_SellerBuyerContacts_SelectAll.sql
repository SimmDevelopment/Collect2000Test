SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_SellerBuyerContacts_SelectAll*/
---------------------------------------------------------------------------------
-- Stored procedure that will select all rows from the table 'SellerBuyerContacts'
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_SellerBuyerContacts_SelectAll]
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- SELECT all rows from the table.
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
ORDER BY 
	[SellerBuyerId] ASC
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_SellerBuyerContacts_Update*/
---------------------------------------------------------------------------------
-- Stored procedure that will update an existing row in the table 'SellerBuyerContacts'
-- Gets: @iSellerBuyerId int
-- Gets: @iContactId int
-- Gets: @iContactType int
-- Gets: @sName varchar(30)
-- Gets: @sTitle varchar(30)
-- Gets: @sAddress1 varchar(30)
-- Gets: @sAddress2 varchar(30)
-- Gets: @sAddress3 varchar(30)
-- Gets: @sCity varchar(20)
-- Gets: @sState varchar(3)
-- Gets: @sZipcode varchar(10)
-- Gets: @sPhone varchar(20)
-- Gets: @sFax varchar(20)
-- Gets: @sEmail varchar(50)
-- Gets: @sWebsite varchar(50)
-- Gets: @sMisc1 varchar(100)
-- Gets: @sMisc2 varchar(100)
-- Gets: @sMisc3 varchar(100)
-- Gets: @sMisc4 varchar(100)
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_SellerBuyerContacts_Update]
	@iSellerBuyerId int,
	@iContactId int,
	@iContactType int,
	@sName varchar(30),
	@sTitle varchar(30),
	@sAddress1 varchar(30),
	@sAddress2 varchar(30),
	@sAddress3 varchar(30),
	@sCity varchar(20),
	@sState varchar(3),
	@sZipcode varchar(10),
	@sPhone varchar(20),
	@sFax varchar(20),
	@sEmail varchar(50),
	@sWebsite varchar(50),
	@sMisc1 varchar(100),
	@sMisc2 varchar(100),
	@sMisc3 varchar(100),
	@sMisc4 varchar(100),
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- UPDATE an existing row in the table.
UPDATE [dbo].[SellerBuyerContacts]
SET 
	--[ContactId] = @iContactId,
	[ContactType] = @iContactType,
	[Name] = @sName,
	[Title] = @sTitle,
	[Address1] = @sAddress1,
	[Address2] = @sAddress2,
	[Address3] = @sAddress3,
	[City] = @sCity,
	[State] = @sState,
	[Zipcode] = @sZipcode,
	[Phone] = @sPhone,
	[Fax] = @sFax,
	[Email] = @sEmail,
	[Website] = @sWebsite,
	[Misc1] = @sMisc1,
	[Misc2] = @sMisc2,
	[Misc3] = @sMisc3,
	[Misc4] = @sMisc4
WHERE
	[SellerBuyerId] = @iSellerBuyerId
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR

GO

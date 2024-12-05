SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_SellerBuyerContacts_Insert*/
---------------------------------------------------------------------------------
-- Stored procedure that will insert 1 row in the table 'SellerBuyerContacts'
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
CREATE  PROCEDURE [dbo].[sp_SellerBuyerContacts_Insert]
	@iContactId int OUTPUT,
	@iSellerBuyerId int,
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
-- INSERT a new row in the table.
INSERT [dbo].[SellerBuyerContacts]
(
	[SellerBuyerId],
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
)
VALUES
(
	@iSellerBuyerId,
	@iContactType,
	@sName,
	@sTitle,
	@sAddress1,
	@sAddress2,
	@sAddress3,
	@sCity,
	@sState,
	@sZipcode,
	@sPhone,
	@sFax,
	@sEmail,
	@sWebsite,
	@sMisc1,
	@sMisc2,
	@sMisc3,
	@sMisc4
)

-- Get the identity key
SET @iContactId = SCOPE_IDENTITY()

-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR


GO

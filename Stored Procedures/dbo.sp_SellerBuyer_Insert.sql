SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_SellerBuyer_Insert*/
---------------------------------------------------------------------------------
-- Stored procedure that will insert 1 row in the table 'SellerBuyer'
-- Gets: @iSellerBuyerId int
-- Gets: @iSellerBuyerType int
-- Gets: @sname varchar(30)
-- Gets: @sAddress1 varchar(30)
-- Gets: @sAddress2 varchar(30)
-- Gets: @sAddress3 varchar(30)
-- Gets: @sCity varchar(20)
-- Gets: @sState varchar(3)
-- Gets: @sZipcode varchar(10)
-- Gets: @sPhone varchar(15)
-- Gets: @sFax varchar(15)
-- Gets: @sEmail varchar(50)
-- Gets: @sWebSite varchar(50)
-- Gets: @sMisc1 varchar(100)
-- Gets: @sMisc2 varchar(100)
-- Gets: @sMisc3 varchar(100)
-- Gets: @sMisc4 varchar(100)
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[sp_SellerBuyer_Insert]
	@iSellerBuyerId int OUTPUT,
	@iSellerBuyerType int,
	@sname varchar(30),
	@sAddress1 varchar(30),
	@sAddress2 varchar(30),
	@sAddress3 varchar(30),
	@sCity varchar(20),
	@sState varchar(3),
	@sZipcode varchar(10),
	@sPhone varchar(15),
	@sFax varchar(15),
	@sEmail varchar(50),
	@sWebSite varchar(50),
	@sMisc1 varchar(100),
	@sMisc2 varchar(100),
	@sMisc3 varchar(100),
	@sMisc4 varchar(100),
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- INSERT a new row in the table.
INSERT [dbo].[SellerBuyer]
(
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
)
VALUES
(
	@iSellerBuyerType,
	@sname,
	@sAddress1,
	@sAddress2,
	@sAddress3,
	@sCity,
	@sState,
	@sZipcode,
	@sPhone,
	@sFax,
	@sEmail,
	@sWebSite,
	@sMisc1,
	@sMisc2,
	@sMisc3,
	@sMisc4
)

-- Get the identity key
SET @iSellerBuyerId = SCOPE_IDENTITY()

-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR


GO

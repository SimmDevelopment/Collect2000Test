SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Letter_Update*/
CREATE  Procedure [dbo].[sp_Letter_Update]
@LetterID int,
@Code varchar(5),
@Ctl varchar(3),
@OutsideService real,
@Description varchar(50),
@Documentname varchar(30),
@Allowclosed bit,
@Allowcollector bit,
@Allowoutside bit,
@Allowzero bit,
@Fee money,
@DocData image,
@Type varchar(5),
@AllowFirst30 bit,
@AllowAfter30 bit,
@CopyCustomer bit,
@SaveImage bit,
@EmailSubject varchar(50),
@VendorLetter bit,
@LinkedLetter bit = 0
AS
-- Name:		sp_Letter_Update
-- Function:		This procedure will update an existing letter in letter table
-- 			using input parameters.
-- Creation:		Unknown
--			Used by class Letter Console. 
-- Change History:
--			6/24/2005 jc added new column vendorLetter bit to database revised sp

	UPDATE letter
	SET
	code = @Code,
	ctl = @Ctl,
	OutsideService = @OutsideService,
	Description = @Description,
	documentname = @Documentname,
	allowclosed = @Allowclosed,
	allowcollector = @Allowcollector,
	allowoutside = @Allowoutside,
	allowzero = @Allowzero,
	fee = @Fee,
	DocData = @DocData,
	type = @Type,
	AllowFirst30 = @AllowFirst30,
	AllowAfter30 = @AllowAfter30,
	CopyCustomer = @CopyCustomer,
	SaveImage = @SaveImage,
	EmailSubject = @EmailSubject,
	vendorLetter = @VendorLetter,
	linkedLetter = @LinkedLetter
	WHERE LetterID = @LetterID
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Letter_Add*/
CREATE   Procedure [dbo].[sp_Letter_Add]
@LetterID int OUTPUT,
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
-- Name:		sp_Letter_Add
-- Function:		This procedure will add a new letter in letter table
-- 			using input parameters.
-- Creation:		Unknown
--			Used by class Letter Console. 
-- Change History:
--			6/24/2005 jc added new column vendorLetter bit to database revised sp

	--Make sure there is not already a letter with this Code
	IF EXISTS (SELECT code FROM letter WHERE Code = @Code)
	BEGIN
		RAISERROR('Can not create Letter. A Letter with this code already exists.', 16, 1)
		RETURN
	END

	INSERT INTO letter
	( code, ctl, OutsideService, Description, documentname, allowclosed, allowcollector,
	allowoutside, allowzero, fee, DocData, type, AllowFirst30, AllowAfter30, CopyCustomer,
	SaveImage, EmailSubject, vendorLetter, linkedLetter )
	VALUES
	( @Code, @Ctl, @OutsideService, @Description, @Documentname, @Allowclosed, @Allowcollector,
	@Allowoutside, @Allowzero, @Fee, @DocData, @Type, @AllowFirst30, @AllowAfter30, @CopyCustomer,
	@SaveImage, @EmailSubject, @VendorLetter, @LinkedLetter )

	SET @LetterID = SCOPE_IDENTITY()
GO

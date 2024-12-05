SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_BranchCode_Add*/
CREATE Procedure [dbo].[sp_BranchCode_Add]
@Code varchar(5),
@Name varchar(30),
@Manager varchar(30),
@Address1 varchar(30),
@Address2 varchar(30),
@City varchar(20),
@State varchar(3),
@Zipcode varchar(10),
@Phone varchar(20),
@Phone800 varchar(20),
@Fax varchar(20),
@Comment varchar(50)
AS
/*
** Name:		sp_BranchCode_Add
** Function:		This procedure will add a new Branch in BranchCodes table
** 			using input parameters.
** Creation:		6/18/2002 
**			Used by Letter Console
** Change History:	2/17/2004 jc added new parameter/column Phone800
*/

	INSERT INTO BranchCodes
	(
	Code,
	Name,
	Manager,
	Address1,
	Address2,
	City,
	state,
	Zipcode,
	phone,
	phone800,
	fax,
	comment
	)
	VALUES
	(
	@Code,
	@Name,
	@Manager,
	@Address1,
	@Address2,
	@City,
	@State,
	@Zipcode,
	@Phone,
	@Phone800,
	@Fax,
	@Comment
	)
	
	--SET @BranchCodeID = @@IDENTITY
GO

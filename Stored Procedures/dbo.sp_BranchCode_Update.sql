SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_BranchCode_Update*/
CREATE Procedure [dbo].[sp_BranchCode_Update]
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
** Name:		sp_BranchCode_Update
** Function:		This procedure will update Branch in BranchCodes table
** 			using input parameters.
** Creation:		6/18/2002 
**			Used by Letter Console
** Change History:	2/17/2004 jc added new parameter/column Phone800
*/

	UPDATE BranchCodes
	SET
	Name = @Name,
	Manager = @Manager,
	Address1 = @Address1,
	Address2 = @Address2,
	City = @City,
	state = @State,
	Zipcode = @Zipcode,
	phone = @Phone,
	phone800 = @Phone800,
	fax = @Fax,
	comment = @Comment
	WHERE Code = @Code
GO

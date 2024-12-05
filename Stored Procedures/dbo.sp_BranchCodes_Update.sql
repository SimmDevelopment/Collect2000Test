SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE  PROCEDURE sp_BranchCodes_Update*/
CREATE  PROCEDURE [dbo].[sp_BranchCodes_Update]
(
	@Code varchar(5),
	@BranchName varchar(30),
	@Manager varchar(30),
	@Street1 varchar(30),
	@Street2 varchar(30),
	@City varchar(20),
	@State varchar(3),
	@ZipCode varchar(10),
	@Phone varchar(20),
	@Phone800 varchar(20),
	@Fax varchar(20),
	@Comment varchar(50)
)
AS

/*
** Name:		sp_BranchCodes_Update
** Function:		This procedure will update a BranchCode in BranchCodes table
** 			using input parameters.
** Creation:		6/25/2002 jc
**			Used by class CBranchFactory. 
** Change History:	2/17/2004 jc added new parameter/column Phone800
*/

    BEGIN TRAN
	
	UPDATE BranchCodes
		SET Name = @BranchName,
		Manager = @Manager,
		Address1 = @Street1,
		Address2 = @Street2,
		City = @City,
		State = @State,
		Zipcode = @ZipCode,
		phone = @Phone,
		Phone800 = @Phone800,
		fax = @Fax,
		comment = @Comment
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_BranchCodes_Update: Cannot update BranchCodes table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*CREATE  PROCEDURE sp_BranchCodes_Insert*/
CREATE PROCEDURE [dbo].[sp_BranchCodes_Insert]
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
** Name:		sp_Branch_Insert
** Function:		This procedure will insert a new Branch in BranchCodes table
** 			using input parameters.
** Creation:		6/25/2002 jc
**			Used by class CBranchFactory. 
** Change History:	2/17/2004 jc added new parameter/column Phone800
*/

    BEGIN TRAN
	
	INSERT INTO BranchCodes
		(code,
		Name,
		Manager,
		Address1,
		Address2,
		City,
		State,
		Zipcode,
		phone,
		phone800,
		fax,
		comment)
	VALUES(
		@Code,
		@BranchName,
		@Manager,
		@Street1,
		@Street2,
		@City,
		@State,
		@ZipCode,
		@Phone,
		@Phone800,
		@Fax,
		@Comment)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Branch_Insert: Cannot insert into Branch table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO

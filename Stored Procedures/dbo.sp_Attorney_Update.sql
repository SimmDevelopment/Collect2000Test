SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Attorney_Update*/
CREATE   PROCEDURE [dbo].[sp_Attorney_Update]
(
	@AttorneyID int,
	@Code varchar(20),
	@AttorneyName varchar(50),
	@Initials varchar(10),
	@Firm varchar(100),
	@Street1 varchar(60),
	@Street2 varchar(60),
	@City varchar(20),
	@State varchar(3),
	@ZipCode varchar(10),
	@Phone varchar(20),
	@FeeRate money,
	@Contact varchar(30),
	@Fax varchar(50),
	@Email varchar(50),
	@YouGotClaimsID varchar(20),
	@Remarks varchar(500),
	@BarID varchar(50)
)
AS

/*
** Name:		sp_Attorney_Update
** Function:		This procedure will update a Attorney in Attorney table
** 			using input parameters.
** Creation:		6/25/2002 jc
**			Used by class CAttorneyFactory. 
** Change History:
**			2/26/2003 jc added fields AttorneyId, Fax, Email, and Remarks to database revised sp
**			4/14/2003 jc added field Firm to database revised sp
**			5/13/2003 jc added field Initials to database revised sp
**			5/13/2003 jc changed update where clause to use AttorneyID not Code
**			5/15/2003 jc added field YouGotClaimsID to database revised sp
**			6/2/2003 jc increased size of Attorney name from varchar(30) to varchar(50)
*/

    BEGIN TRAN
	
	UPDATE Attorney
		SET Name = @AttorneyName,
		Code = @Code,
		Initials = @Initials,
		Firm = @Firm,
		Street1 = @Street1,
		Street2 = @Street2,
		City = @City,
		State = @State,
		Zipcode = @ZipCode,
		phone = @Phone,
		feerate = @FeeRate,
		Contact = @Contact,
		Fax = @Fax,
		Email = @Email,
		YouGotClaimsID = @YouGotClaimsID,
		Remarks = @Remarks,
		BarID = @BarID
	WHERE AttorneyID = @AttorneyID

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Attorney_Update: Cannot update Attorney table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

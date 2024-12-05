SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Attorney_Insert*/
CREATE    PROCEDURE [dbo].[sp_Attorney_Insert]
(
	@AttorneyID int OUTPUT,
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
** Name:		sp_Attorney_Insert
** Function:		This procedure will insert a new Attorney in Attorney table
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
	
	INSERT INTO Attorney
		(Code,
		Name,
		Initials,
		Firm,
		Street1,
		Street2,
		City,
		State,
		Zipcode,
		phone,
		feerate,
		contact,
		Fax,
		Email,
		YouGotClaimsID,
		Remarks,
		BarID)
	VALUES(
		@Code,
		@AttorneyName,
		@Initials,		
		@Firm,
		@Street1,
		@Street2,
		@City,
		@State,
		@ZipCode,
		@Phone,
		@FeeRate,
		@Contact,
		@Fax,
		@Email,
		@YouGotClaimsID,
		@Remarks,
		@BarID)

	SET @AttorneyID = SCOPE_IDENTITY()

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Attorney_Insert: Cannot insert into Attorney table.')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO

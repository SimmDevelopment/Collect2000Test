SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spDebtor_Update*/
CREATE PROCEDURE [dbo].[spDebtor_Update]
	@DebtorID int,
	@Name varchar (30),
	@Prefix varchar (50),
	@FirstName varchar(50),
	@MiddleName varchar(50),
	@LastName varchar(50),
	@Suffix varchar(50),
	@Gender char(1),
	@IsBusiness bit,
	@IsParsed bit,
	@BusinessName varchar (50),
	@Street1 varchar (30),
	@Street2 varchar (30),
	@City varchar (30),
	@State varchar (3),
	@Zipcode varchar (10),
	@County varchar (50),
	@RegionCode char (2),
	@HomePhone varchar (30),
	@WorkPhone varchar (30),
	@SSN varchar (15),
	@MR bit,
	@OtherName varchar (30),
	@DOB datetime,
	@JobName varchar (50),
	@JobAddr1 varchar(50),
	@JobAddr2 varchar(50),
	@JobCSZ varchar(50),
	@JobMemo text,
	@Relationship varchar(20),
	@Spouse varchar (50),
	@SpouseJobName varchar(50),
	@SpouseJobAddr1 varchar(50),
	@SpouseJobAddr2 varchar(50),
	@SpouseJobCSZ varchar(50),
	@SpouseHomePhone varchar(20),
	@SpouseWorkPhone varchar(20),
	@SpouseJobMemo text,
	@Pager varchar (20),
	@OtherPhone1 varchar(20),
	@OtherPHone2 varchar(20),
	@OtherPhone3 varchar(20),
	@OtherPhone1Type varchar(15),
	@OtherPhone2Type varchar(15),
	@OtherPhone3Type varchar(15),
	@Language varchar (30),
	@Fax varchar (50),
	@DLNumber varchar (50),
	@Email varchar (50),
	@Responsible bit,
	@EarlyTimeZone INTEGER,
	@LateTimeZone INTEGER,
	@ObservesDST BIT,
	@UserLogin varchar(10)
AS
 /*
** Name:		spDebtorUpdate
** Function:		Updates a record into Debtors
** Creation:		7/11/2003 mr
**			Used by class Latitude.Debtor
** Change History:	11/21/2003 mr Added Statement that Creates a note if the SSN changed
**			01/16/2004 mr Added calls to PhoneHistory_Insert and AddressHistory_Insert procedures
**			7/29/2004  mr Commented out the line that adds a note on address and phone changes.  
**				      Its done in code
**			8/18/2004  mr Changed HomePhone and WorkPhone update.  Will write history even if the
**				      old phone was empty.
**			12/28/04   mr Commented out the section that writes a Note when Mail Return changes...
**				      Latitude.exe also creates a note.
 */

Declare @AccountID int
Declare @OldMR varchar (1)
Declare @Seq int
Declare @OldStreet1 varchar (30)
Declare @OldStreet2 varchar (30)
Declare @OldCity varchar (30)
Declare @OldState varchar(3)
Declare @OldZipcode varchar (15)
Declare @OldSSN varchar(15)
Declare @OldEmail varchar(50)
Declare @MRMsg varchar (100)

SELECT @AccountID=number, @Seq=Seq, @OldMR=ISNULL(MR, 'N'), @OldStreet1=ISNULL(Street1, ''), @OldStreet2=ISNULL(Street2, ''), @OldCity=ISNULL(City, ''), @OldState=ISNULL(State, ''), @OldZipcode=ISNULL(Zipcode, ''), @OldSSN=ISNULL(SSN, ''), @OldEmail=ISNULL(Email, '')
FROM Debtors WHERE DebtorID = @DebtorID

-- Write address history record if address is changed
IF (@OldStreet1<>@Street1) or (@OldStreet2<>@Street2) or (@OldCity<>@City) or (@OldState<>@State) or (@OldZipcode <> @Zipcode) BEGIN	
	EXEC AddressHistory_Insert @AccountID, @DebtorID, @UserLogin, @OldStreet1, @OldStreet2, @OldCity, @OldState, @OldZipcode,
					    @Street1, @Street2, @City, @State, @Zipcode
END

--Make note if SSN Changed
IF (@OldSSN <> @SSN) and (ltrim(@OldSSN) <> '') BEGIN
	INSERT INTO Notes (number, Created, User0, Action, Result, Comment, IsPrivate)
	VALUES (@AccountID, GetDate(), @UserLogin, '+++++', '+++++', 'Old SSN (' + cast(@Seq + 1 as varchar) + ') ' + @OldSSN, 1 )
END;
		
--Email History
IF (@OldEmail <> @Email) BEGIN
	EXEC EmailHistory_Insert @AccountID, @DebtorID, @UserLogin, @OldEmail, @Email
END;

DECLARE @Country VARCHAR(50);

SELECT @Country = LEFT([RegionInfo].[Name], 50)
FROM [dbo].[RegionInfo]
WHERE [RegionInfo].[Code] = ISNULL(@RegionCode, 'US');

UPDATE Debtors SET 
	Name = @Name,
	prefix = @Prefix,
	firstName = @FirstName,
	middleName = @MiddleName,
	lastName = @LastName,
	suffix = @Suffix,
	gender = @Gender,
	isBusiness = @IsBusiness,
	isParsed = @IsParsed,
	businessName = @BusinessName,
	Street1 = @Street1,
	Street2 = @Street2,
	City = @City,
	State = @State,
	Zipcode = @Zipcode,
	County = @County,
	Country = @Country,
	RegionCode = @RegionCode,
	SSN = @SSN,
	MR = case @MR when 0 then 'N' when 1 then 'Y' END,
	OtherName = @OtherName,
	DOB = @DOB,
	JobName = @JobName,
	JobAddr1 = @JobAddr1,
	JobAddr2 = @JobAddr2,
	JobCSZ = @JobCSZ,
	JobMemo = @JobMemo,
	Relationship = @Relationship,
	Spouse = @Spouse,
	SpouseJobName = @SpouseJobName,
	SpouseJobAddr1= @SpouseJobAddr1,
	SpouseJobAddr2 = @SpouseJobAddr2,
	SpouseJobCSZ = @SpouseJobCSZ,
	SpouseHomePhone = @SpouseHomePhone,
	SpouseWorkPhone = @SpouseWorkPhone, 
	SpouseJobMemo = @SpouseJobMemo, 
	Pager = @Pager,
	OtherPhone1 = @OtherPhone1, 
	OtherPhone2 = @OtherPhone2, 
	OtherPhone3 = @OtherPhone3,  
	OtherPhoneType = @OtherPhone1Type, 
	OtherPhone2Type = @OtherPhone2Type, 
	OtherPhone3Type = @OtherPhone3Type,
	Language = @Language,
	DLNum = @DLNumber,
	Fax = @Fax,
	Email = @Email,
	Responsible = @Responsible,
	EarlyTimeZone = @EarlyTimeZone,
	LateTimeZone = @LateTimeZone,
	ObservesDST = @ObservesDST,
	DateUpdated = GETDATE()
WHERE DebtorID = @DebtorID

IF @@Error <> 0
	Return @@Error

IF @Seq = 0
	UPDATE master set
	Name = @Name,
	Street1 = @Street1,
	Street2 = @Street2,
	City = LEFT(@City, 20),
	State = @State,
	Zipcode = @Zipcode,
	SSN = @SSN,
	MR = case @MR when 0 then 'N' when 1 then 'Y' END,
	Other = @OtherName,
	DOB = @DOB
	WHERE number = @AccountID


Return @@Error

GO

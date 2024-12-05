SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












/*spDebtor_Insert*/
CREATE          PROCEDURE [dbo].[spDebtor_Insert]
	@AccountID int,
	@Seq int,
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
	@Relationship varchar(15),
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
	@Language varchar(30),
	@Fax varchar (50),
	@DLNumber varchar (50),
	@Email varchar (50),
	@Responsible bit,
	@EarlyTimeZone INTEGER,
	@LateTimeZone INTEGER,
	@ObservesDST BIT,
	@ReturnID int Output
AS

 /*
** Name:		spDebtorInsert
** Function:		Inserts a record into Debtors
** Creation:		7/11/2003 mr
**			Used by class Latitude.Debtor
** Change History:	9/20/2003 Changed Value @MR to use a Case statement in the Insert Statement
 */
	--Select number from Debtors where number = @AccountID and Seq = @Seq
	IF EXISTS (Select number from Debtors where number = @AccountID and Seq = @Seq)
		Return -1
	ELSE BEGIN
		IF @IsParsed IS NULL OR @IsParsed = 0 BEGIN
			SET @IsParsed = 1;
			SET @FirstName = dbo.GetFirstName(@Name);
			SET @LastName = dbo.GetLastName(@Name);
			SET @MiddleName = dbo.GetMiddleName(@Name);
			SET @Suffix = '';
			SET @BusinessName = dbo.GetBusinessName(@Name, 5);
			IF LEN(@BusinessName) > 0
				SET @IsBusiness = 1;
			ELSE
				SET @IsBusiness = 0;
		END;

		DECLARE @Country VARCHAR(50);

		SELECT @Country = LEFT([RegionInfo].[Name], 50)
		FROM [dbo].[RegionInfo]
		WHERE [RegionInfo].[Code] = ISNULL(@RegionCode, 'US');

		INSERT INTO Debtors(Number, Seq, Name, Street1, Street2, City, State, Zipcode, County, Country, RegionCode, HomePhone, WorkPhone, SSN, MR, OtherName,
		DOB, JobName, JobAddr1, JobAddr2, JobCSZ, JobMemo, Relationship, Spouse, SpouseJobName, SpouseJobAddr1, SpouseJobAddr2,
		SpouseJobCSZ, SpouseHomePhone, SpouseWorkPhone, SpouseJobMemo, Pager, OtherPhone1, OtherPhone2, OtherPhone3, OtherPhoneType, 
		OtherPhone2Type, OtherPhone3Type, Language, Fax, DLNum, EMail, Responsible, prefix, firstName, middleName, lastName, suffix, gender, isBusiness, isParsed, businessName,
		EarlyTimeZone, LateTimeZone, ObservesDST)
		VALUES(@AccountID, @Seq, @Name, @Street1, @Street2, @City, @State, @Zipcode, @County, @Country, @RegionCode, @HomePhone, @WorkPhone, @SSN, Case @MR When 0 then 'N' When 1 then 'Y' End, @OtherName,
		@DOB, @JobName, @JobAddr1, @JobAddr2, @JobCSZ, @JobMemo, @Relationship, @Spouse, @SpouseJobName, @SpouseJobAddr1, @SpouseJobAddr2,
		@SpouseJobCSZ, @SpouseHomePhone, @SpouseWorkPhone, @SpouseJobMemo, @Pager, @OtherPhone1, @OtherPhone2, @OtherPhone3, @OtherPhone1Type,
		@OtherPhone2Type, @OtherPhone3Type, @Language, @Fax, @DLNumber, @Email, @Responsible, @Prefix, @FirstName, @MiddleName, @LastName, @Suffix, @Gender, @IsBusiness, @IsParsed, @BusinessName,
		@EarlyTimeZone, @LateTimeZone, @ObservesDST)
		
		IF @@Error = 0 BEGIN
			Select @ReturnID = SCOPE_IDENTITY()
			Return 0
		END
		ELSE
			Return @@Error
	END










GO

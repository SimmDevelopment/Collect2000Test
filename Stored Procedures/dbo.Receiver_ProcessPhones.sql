SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessPhones]
	@file_number int,
	@debtor_number int,
	@relationship varchar(50),
	@phone_type_id int,
	@phone_status_id int,
	@on_hold bit,
	@phone_number varchar(30),
	@phone_ext varchar(10),
	@phone_name varchar(50),
	@source varchar(50),
	@clientid int,
	--If no conset Data to digest
	@noConsent bit=1,
	--Newly Added
	@AllowManualCalling varchar(5)=NULL,--bit
	@AllowAutoDialer varchar(5)=NULL,
	@AllowFax varchar(5)=NULL,
	@AllowText varchar(5)=NULL,
	@WrittenConsent bit = 0,
	@ObtainedFrom nvarchar(100)='AIM',
	@EffectiveDate datetime2(7)=NULL,
	@Comment text=NULL,
	@UserID varchar(10)=NULL,
	/*Phone Preference*/
	 @MondayNeverCall VARCHAR(1) ='N' 
	,@MondayCallWindowStart varchar(20)=NULL
	,@MondayCallWindowEnd varchar(20)=NULL
	,@MondayNoCallWindowStart varchar(20)=NULL
	,@MondayNoCallWindowEnd varchar(20)=NULL
	,@TuesdayNeverCall VARCHAR(1) ='N'
	,@TuesdayCallWindowStart varchar(20)=NULL
	,@TuesdayCallWindowEnd varchar(20)=NULL
	,@TuesdayNoCallWindowStart varchar(20)=NULL
	,@TuesdayNoCallWindowEnd varchar(20)=NULL
	,@WednesdayNeverCall VARCHAR(1) ='N'
	,@WednesdayCallWindowStart varchar(20)=NULL
	,@WednesdayCallWindowEnd varchar(20)=NULL
	,@WednesdayNoCallWindowStart varchar(20)=NULL
	,@WednesdayNoCallWindowEnd varchar(20)=NULL
	,@ThursdayNeverCall VARCHAR(1) ='N'
	,@ThursdayCallWindowStart varchar(20)=NULL
	,@ThursdayCallWindowEnd varchar(20)=NULL
	,@ThursdayNoCallWindowStart varchar(20)=NULL
	,@ThursdayNoCallWindowEnd varchar(20)=NULL
	,@FridayNeverCall VARCHAR(1) ='N'
	,@FridayCallWindowStart varchar(20)=NULL
	,@FridayCallWindowEnd varchar(20)=NULL
	,@FridayNoCallWindowStart varchar(20)=NULL
	,@FridayNoCallWindowEnd varchar(20)=NULL
	,@SaturdayNeverCall VARCHAR(1) ='N'
	,@SaturdayCallWindowStart varchar(20)=NULL
	,@SaturdayCallWindowEnd varchar(20)=NULL
	,@SaturdayNoCallWindowStart varchar(20)=NULL
	,@SaturdayNoCallWindowEnd varchar(20)=NULL
	,@SundayNeverCall VARCHAR(1) ='N'
	,@SundayCallWindowStart varchar(20)=NULL
	,@SundayCallWindowEnd varchar(20)=NULL
	,@SundayNoCallWindowStart varchar(20)=NULL
	,@SundayNoCallWindowEnd varchar(20)=NULL
AS
BEGIN
IF(ISNULL(@AllowManualCalling,'')<>'')
	 BEGIN 
	 SELECT @AllowManualCalling = CASE WHEN @AllowManualCalling='Y' THEN '1' ELSE '0' 
	 END 
	 END
	 IF(ISNULL(@AllowAutoDialer,'')<>'')
	 BEGIN 
	 SELECT @AllowAutoDialer = CASE WHEN @AllowAutoDialer='Y' THEN '1' ELSE '0' 
	 END 
	 END
	 IF(ISNULL(@AllowFax,'')<>'')
	 BEGIN 
	 SELECT @AllowFax = CASE WHEN @AllowFax='Y' THEN '1' ELSE '0' 
	 END 
	 END
	 IF(ISNULL(@AllowText,'')<>'')
	 BEGIN 
	 SELECT @AllowText = CASE WHEN @AllowText='Y' THEN '1' ELSE '0' 
	 END 
	 END
	 IF(ISNULL(@EffectiveDate,'')='')
	 BEGIN 
	 SET  @EffectiveDate=CONVERT(DATETIME2,GETDATE())
	 END
	DECLARE @Identity_MasterPhoneId INT
	DECLARE @number int
	SET @phone_status_id=ISNULL(@phone_status_id,0)
	select @number = max(receivernumber)
	from receiver_reference rr with (nolock) 
	join master m with (nolock) on rr.receivernumber = m.number
	where sendernumber= @file_number and clientid = @clientid

	IF(@number is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @dnumber int
	select @dnumber = max(receiverdebtorid )
	from receiver_debtorreference rd with (nolock)
	join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
	join master m with (nolock) on d.number = m.number
	where senderdebtorid = @debtor_number
	and clientid = @clientid

	IF(@dnumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1) -- TODO Which error to raise here?
		RETURN
	END

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @number

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END
	
	-- Added by KAR on 02/25/2010 Need to determine if Phones_Master exists.
	DECLARE @SoftwareVersion varchar(25) 

	INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
	VALUES (@number,getdate(),'AIM','+++++','+++++','Phone information has been updated from client',0)

	-- Only do this if we have the Phones Master Table. KAR 02/25/2010
		SELECT @Identity_MasterPhoneId = max(MasterPhoneID)
		FROM Phones_Master pm WITH (NOLOCK)
		WHERE Number = @number AND DebtorID = @dnumber AND PhoneNumber = @phone_number;

		DECLARE @phonetype VARCHAR(20)
		SELECT @phonetype = PhoneTypeDescription
		FROM Phones_Types WHERE PhoneTypeID = @phone_type_id

		IF(@Identity_MasterPhoneId IS NOT NULL)
		BEGIN
		
			-- Changed by KAR 08/23/2011 if the phone for the phone_type_id exists...
			IF EXISTS(SELECT * FROM Phones_Master WITH (NOLOCK) 
					 WHERE Number = @number AND DebtorID = @dnumber AND PhoneNumber = @phone_number 
					 AND PhoneTypeID = @phone_type_id)
			-- Update the phone for the debtor, number and phone type
			--LAT-10597 After adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
			BEGIN
				UPDATE Phones_Master
				SET	Relationship = @relationship,
				PhoneStatusID = @phone_status_id,
				OnHold = @on_hold,
				PhoneExt = @phone_ext,
				PhoneName = @phone_name,
				--LoginName = 'AIM',
				LastUpdated = GETDATE(),
				UpdatedBy = 'AIM'
				WHERE Number = @number AND DebtorID = @dnumber AND PhoneNumber = @phone_number 
				AND PhoneTypeID = @phone_type_id
			END
			ELSE
			BEGIN
				-- Insert the PHone if the Phone Type exists
				--LAT-10597 After adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
				IF EXISTS(SELECT * FROM Phones_Types WITH (NOLOCK)
							WHERE PhoneTypeID = @phone_type_id)
				BEGIN
					INSERT INTO Phones_Master 
					(
					Number,
					PhoneTypeID,
					Relationship,
					PhoneStatusID,
					OnHold,
					PhoneNumber,
					PhoneExt,
					DebtorID,
					DateAdded,
					RequestID,
					PhoneName,
					LoginName,
					NearbyContactID,
					LastUpdated,
					UpdatedBy
					)
					VALUES
					(
					@number,
					@phone_type_id,
					@relationship,
					@phone_status_id,
					@on_hold,
					@phone_number,
					@phone_ext,
					@dnumber,
					GETDATE(),
					NULL,
					@phone_name,
					'AIM',
					NULL,
					NULL,
					NULL
					)
					SELECT @Identity_MasterPhoneId=SCOPE_IDENTITY();
				END
				ELSE
				-- Otherwise insert a note showing the phone number and type, but that the type does not exists.
				BEGIN
					INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
					VALUES (@number,getdate(),'AIM','+++++','+++++','Phone information received from client for debtor with debtor id of ' +
						cast(@dnumber as varchar(15)) + ' using phone number of ' + @phone_number + ' but the phone type of ' + cast(@phone_type_id as varchar(15)) + 
						' does not exists.',0)
				END
			END
		END
		ELSE
		BEGIN
		--LAT-10597 After adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
		INSERT INTO Phones_Master 
		(
		Number,
		PhoneTypeID,
		Relationship,
		PhoneStatusID,
		OnHold,
		PhoneNumber,
		PhoneExt,
		DebtorID,
		DateAdded,
		RequestID,
		PhoneName,
		LoginName,
		NearbyContactID,
		LastUpdated,
		UpdatedBy
		)
		VALUES
		(
		@number,
		@phone_type_id,
		@relationship,
		@phone_status_id,
		@on_hold,
		@phone_number,
		@phone_ext,
		@dnumber,
		GETDATE(),
		NULL,
		@phone_name,
		'AIM',
		NULL,
		NULL,
		NULL
		)
		SET @Identity_MasterPhoneId=SCOPE_IDENTITY();

	INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
		VALUES (@number,getdate(),'AIM','+++++','+++++',@phonetype + ' Phone ' + @phone_number + ' added',0)

		END

		IF(@noConsent<>1)
		BEGIN
			INSERT INTO Phones_Consent
			(
			[MasterPhoneId],
			[AllowManualCall],
			[AllowAutoDialer],
			[AllowFax],
			[AllowText],
			[WrittenConsent],
			[ObtainedFrom],
			[DocumentationId],
			[UserId],
			[EffectiveDate],
			[comment]
			)
			VALUES 
			(
				@Identity_MasterPhoneId,
				CAST(@AllowManualCalling AS BIT),
				CAST(@AllowAutoDialer AS BIT),
				CAST(@AllowFax AS BIT),
				CAST(@AllowText AS BIT),
				@WrittenConsent,
				@ObtainedFrom,
				'',
				CAST (@UserID AS INT),
				@EffectiveDate,
				@Comment
			)
		END

		IF EXISTS(SELECT 1 FROM Phones_Preferences WHERE MasterPhoneId = @Identity_MasterPhoneId)
		BEGIN
			DELETE FROM Phones_Preferences WHERE MasterPhoneId = @Identity_MasterPhoneId;
		END
		INSERT INTO Phones_Preferences
			(
			MasterPhoneId
			,MondayDoNotCall
			,MondayCallWindowStart
			,MondayCallWindowEnd
			,MondayNoCallWindowStart
			,MondayNoCallWindowEnd
			,TuesdayDoNotCall
			,TuesdayCallWindowStart
			,TuesdayCallWindowEnd
			,TuesdayNoCallWindowStart
			,TuesdayNoCallWindowEnd
			,WednesdayDoNotCall
			,WednesdayCallWindowStart
			,WednesdayCallWindowEnd
			,WednesdayNoCallWindowStart
			,WednesdayNoCallWindowEnd
			,ThursdayDoNotCall
			,ThursdayCallWindowStart
			,ThursdayCallWindowEnd
			,ThursdayNoCallWindowStart
			,ThursdayNoCallWindowEnd
			,FridayDoNotCall
			,FridayCallWindowStart
			,FridayCallWindowEnd
			,FridayNoCallWindowStart
			,FridayNoCallWindowEnd
			,SaturdayDoNotCall
			,SaturdayCallWindowStart
			,SaturdayCallWindowEnd
			,SaturdayNoCallWindowStart
			,SaturdayNoCallWindowEnd
			,SundayDoNotCall
			,SundayCallWindowStart
			,SundayCallWindowEnd
			,SundayNoCallWindowStart
			,SundayNoCallWindowEnd)
			VALUES
			(@Identity_MasterPhoneId
			,CASE @MondayNeverCall WHEN 'Y' THEN 1 ELSE 0 END
			,@MondayCallWindowStart 
			,@MondayCallWindowEnd 
			,@MondayNoCallWindowStart 
			,@MondayNoCallWindowEnd 
			,CASE @TuesdayNeverCall  WHEN 'Y' THEN 1 ELSE 0 END
			,@TuesdayCallWindowStart 
			,@TuesdayCallWindowEnd 
			,@TuesdayNoCallWindowStart 
			,@TuesdayNoCallWindowEnd 
			,CASE @WednesdayNeverCall  WHEN 'Y' THEN 1 ELSE 0 END
			,@WednesdayCallWindowStart 
			,@WednesdayCallWindowEnd 
			,@WednesdayNoCallWindowStart 
			,@WednesdayNoCallWindowEnd 
			,CASE @ThursdayNeverCall  WHEN 'Y' THEN 1 ELSE 0 END
			,@ThursdayCallWindowStart 
			,@ThursdayCallWindowEnd 
			,@ThursdayNoCallWindowStart 
			,@ThursdayNoCallWindowEnd 
			,CASE @FridayNeverCall  WHEN 'Y' THEN 1 ELSE 0 END
			,@FridayCallWindowStart 
			,@FridayCallWindowEnd 
			,@FridayNoCallWindowStart 
			,@FridayNoCallWindowEnd 
			,CASE @SaturdayNeverCall  WHEN 'Y' THEN 1 ELSE 0 END
			,@SaturdayCallWindowStart 
			,@SaturdayCallWindowEnd 
			,@SaturdayNoCallWindowStart 
			,@SaturdayNoCallWindowEnd 
			,CASE @SundayNeverCall  WHEN 'Y' THEN 1 ELSE 0 END
			,@SundayCallWindowStart 
			,@SundayCallWindowEnd 
			,@SundayNoCallWindowStart 
			,@SundayNoCallWindowEnd
			)
		
		INSERT INTO NOTES 
		(number,
		created,
		user0,
		action,
		result,
		comment
		)
		VALUES
		(@number,
		GETDATE(),
		'AIM',
		'+++++',
		'+++++',
		'Phone Number (' +@phone_number + ltrim(rtrim(' '+@phone_ext))+ ') was entered by AIM.  This phone number was originally entered by ' + @source
		);
END
GO

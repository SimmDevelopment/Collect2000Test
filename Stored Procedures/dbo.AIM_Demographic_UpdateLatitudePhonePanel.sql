SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[AIM_Demographic_UpdateLatitudePhonePanel]
(
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
	@agencyid int,
	--Newly Added
	@noConsent bit=1,
	@AllowManualCalling varchar(5)=NULL,--bit
	@AllowAutoDialer varchar(5)=NULL,
	@AllowFax varchar(5)=NULL,
	@AllowText varchar(5)=NULL,
	@WrittenConsent BIT=0,
	@ObtainedFrom nvarchar(100)='AIM',
	@EffectiveDate datetime2(7)=NULL,
	@Comment text=NULL,
	@UserID varchar(10)=NULL,
	/*Phone Preference*/
	 @MondayNeverCall bit =0 
	,@MondayCallWindowStart varchar(20)=NULL
	,@MondayCallWindowEnd varchar(20)=NULL
	,@MondayNoCallWindowStart varchar(20)=NULL
	,@MondayNoCallWindowEnd varchar(20)=NULL
	,@TuesdayNeverCall bit =0
	,@TuesdayCallWindowStart varchar(20)=NULL
	,@TuesdayCallWindowEnd varchar(20)=NULL
	,@TuesdayNoCallWindowStart varchar(20)=NULL
	,@TuesdayNoCallWindowEnd varchar(20)=NULL
	,@WednesdayNeverCall bit =0
	,@WednesdayCallWindowStart varchar(20)=NULL
	,@WednesdayCallWindowEnd varchar(20)=NULL
	,@WednesdayNoCallWindowStart varchar(20)=NULL
	,@WednesdayNoCallWindowEnd varchar(20)=NULL
	,@ThursdayNeverCall bit =0
	,@ThursdayCallWindowStart varchar(20)=NULL
	,@ThursdayCallWindowEnd varchar(20)=NULL
	,@ThursdayNoCallWindowStart varchar(20)=NULL
	,@ThursdayNoCallWindowEnd varchar(20)=NULL
	,@FridayNeverCall bit =0
	,@FridayCallWindowStart varchar(20)=NULL
	,@FridayCallWindowEnd varchar(20)=NULL
	,@FridayNoCallWindowStart varchar(20)=NULL
	,@FridayNoCallWindowEnd varchar(20)=NULL
	,@SaturdayNeverCall bit =0
	,@SaturdayCallWindowStart varchar(20)=NULL
	,@SaturdayCallWindowEnd varchar(20)=NULL
	,@SaturdayNoCallWindowStart varchar(20)=NULL
	,@SaturdayNoCallWindowEnd varchar(20)=NULL
	,@SundayNeverCall bit =0
	,@SundayCallWindowStart varchar(20)=NULL
	,@SundayCallWindowEnd varchar(20)=NULL
	,@SundayNoCallWindowStart varchar(20)=NULL
	,@SundayNoCallWindowEnd varchar(20)=NULL
)
as
BEGIN

	 SELECT @AllowManualCalling = CASE WHEN @AllowManualCalling='Y' THEN '1' ELSE '0' END
	 SELECT @AllowAutoDialer = CASE WHEN @AllowAutoDialer='Y' THEN '1' ELSE '0' END
	 SELECT @AllowFax = CASE WHEN @AllowFax='Y' THEN '1' ELSE '0' END
	 SELECT @AllowText = CASE WHEN @AllowText='Y' THEN '1' ELSE '0' END
	 
	declare @masterNumber int,@currentAgencyId int
	SET @phone_status_id=ISNULL(@phone_status_id,0)
	select @masterNumber = dv.number 
		,@currentagencyid = currentlyplacedagencyid
	from 	debtors dv with (nolock)
		left outer join aim_accountreference r on dv.number = r.referencenumber
	where 	dv.debtorid = @debtor_number
	
	declare @agencyname varchar(100)
	select @agencyname = name from aim_agency where agencyid = @agencyid
	if(@masterNumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end
	if(@masterNumber <> @file_number)
	begin
		RAISERROR ('15008',16,1)
		return
	end
	if(@currentAgencyId is null or (@currentAgencyId <> @agencyId))
	begin
		raiserror ('15004', 16, 1)
		return
	end

INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
VALUES (@file_number,getdate(),'AIM','+++++','+++++','Phone information has been updated from agency ' + @agencyname,0)

DECLARE @masterPhoneID INT,@masterPhoneTypeID INT,@masterPhoneStatusID INT
SELECT @masterPhoneID = max(MasterPhoneID)
FROM Phones_Master pm WITH (NOLOCK)
WHERE Number = @file_number AND DebtorID = @debtor_number AND PhoneNumber = @phone_number;

SELECT @masterPhoneTypeID = PhoneTypeID,@masterPhoneStatusID = PhoneStatusID
FROM Phones_Master WITH (NOLOCK) WHERE MasterPhoneID = @masterPhoneID

DECLARE @phonestatus VARCHAR(20)
SELECT @phonestatus = ISNULL(PhoneStatusDescription,'Unknown')
FROM Phones_Statuses WHERE PhoneStatusID = @phone_status_id

DECLARE @oldphonestatus VARCHAR(20)
SELECT @oldphonestatus = ISNULL(PhoneStatusDescription,'Unknown')
FROM Phones_Statuses WHERE PhoneStatusID = @masterPhoneStatusID

DECLARE @phonetype VARCHAR(20)
SELECT @phonetype = PhoneTypeDescription
FROM Phones_Types WHERE PhoneTypeID = @phone_type_id

IF(@masterPhoneID IS NOT NULL)
BEGIN
    --LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
	UPDATE Phones_Master
	SET
	PhoneTypeID = @phone_type_id,
	Relationship = @relationship,
	PhoneStatusID = @phone_status_id,
	OnHold = @on_hold,
	PhoneExt = @phone_ext,
	PhoneName = @phone_name,
	--LoginName = 'AIM',
	LastUpdated = GETDATE(),
	UpdatedBy = 'AIM'
	WHERE MasterPhoneID = @masterPhoneID

	IF(@masterPhoneStatusID <> @phone_status_id)
	BEGIN
		INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
		VALUES (@file_number,getdate(),'AIM','+++++','+++++',@phonetype + ' Phone ' + @phone_number + ' status changed from '+@oldphonestatus+' to ' +@phonestatus,0)
	END

END
ELSE
	BEGIN
	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
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
	@file_number,
	@phone_type_id,
	@relationship,
	@phone_status_id,
	@on_hold,
	@phone_number,
	@phone_ext,
	@debtor_number,
	GETDATE(),
	NULL,
	@phone_name,
	'AIM',
	NULL,
	NULL,
	NULL
	)
	SET @masterPhoneID=SCOPE_IDENTITY();
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
							@masterPhoneID,
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
						IF EXISTS(SELECT 1 FROM Phones_Preferences WHERE MasterPhoneId = @masterPhoneID)
						BEGIN
							DELETE FROM Phones_Preferences WHERE MasterPhoneId = @masterPhoneID;
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
								(@masterPhoneID  
								,ISNULL(@MondayNeverCall, 0)  
								,@MondayCallWindowStart   
								,@MondayCallWindowEnd   
								,@MondayNoCallWindowStart   
								,@MondayNoCallWindowEnd   
								,ISNULL(@TuesdayNeverCall, 0) 
								,@TuesdayCallWindowStart   
								,@TuesdayCallWindowEnd   
								,@TuesdayNoCallWindowStart   
								,@TuesdayNoCallWindowEnd   
								,ISNULL(@WednesdayNeverCall, 0)
								,@WednesdayCallWindowStart   
								,@WednesdayCallWindowEnd   
								,@WednesdayNoCallWindowStart   
								,@WednesdayNoCallWindowEnd   
								,ISNULL(@ThursdayNeverCall, 0)
								,@ThursdayCallWindowStart   
								,@ThursdayCallWindowEnd   
								,@ThursdayNoCallWindowStart   
								,@ThursdayNoCallWindowEnd   
								,ISNULL(@FridayNeverCall, 0)
								,@FridayCallWindowStart   
								,@FridayCallWindowEnd   
								,@FridayNoCallWindowStart   
								,@FridayNoCallWindowEnd   
								,ISNULL(@SaturdayNeverCall, 0)
								,@SaturdayCallWindowStart   
								,@SaturdayCallWindowEnd   
								,@SaturdayNoCallWindowStart   
								,@SaturdayNoCallWindowEnd   
								,ISNULL(@SundayNeverCall, 0)
								,@SundayCallWindowStart   
								,@SundayCallWindowEnd   
								,@SundayNoCallWindowStart   
								,@SundayNoCallWindowEnd  
								)  

	INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
	VALUES (@file_number,getdate(),'AIM','+++++','+++++',@phonetype + ' Phone ' + @phone_number + ' added',0)

END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Receiver_ProcessPlacementDebtor] 
	@file_number int,--
	@account varchar(30), -- 
	@name varchar(30),--
	@street1 varchar(30),--
	@street2 varchar(30),--
	@city varchar(30),--
	@state varchar(30),--
	@zipcode varchar(10),--
	@home_phone varchar(20),--
	@work_phone varchar(20),--
	@ssn varchar(10),--
	@mail_return char(1),--
	@other_name varchar(30),--
	@date_of_birth datetime,--
	@job_name varchar(30),--
	@job_street1 varchar(30),--
	@job_street2 varchar(30),--
	@job_city_state_zipcode varchar(10),--
	@spouse_name varchar(30),--
	@spouse_job_name varchar(30),--
	@spouse_job_street1 varchar(30),--
	@spouse_job_street2 varchar(30),--
	@spouse_job_city_state_zipcode varchar(10),--
	@spouse_home_phone varchar(10),--
	@spouse_work_phone varchar(10),--
	@debtor_number int, --
	@seq int,--
	@clientId int,--
	@county varchar(50) = null,
	@country varchar(50) = null,
	-- Added by KAR on 03/26/2010
	@attorney_name varchar(50) = null,	
	@attorney_firm varchar(100) = null,
	@attorney_street1 varchar(50) = null,
	@attorney_street2 varchar(50) = null,
	@attorney_city varchar(50) = null,
	@attorney_state varchar(5) = null,
	@attorney_zipcode varchar(20) = null,
	@attorney_phone varchar(20) = null,
	@attorney_fax varchar(20) = null,
	@attorney_notes varchar(500) = null
AS

	declare @receiverNumber int
	select @receivernumber = max(receivernumber) from receiver_reference where sendernumber = @file_number and clientid = @clientid
	if(@receivernumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end

	if(@seq = 0)
	begin

		update 	
			master
		set
			name = @name
			,street1 = @street1
			,street2 = @street2
			,city = left(@city,20)
			,state = @state
			,zipcode = @zipcode
			,homephone = @home_phone
			,workphone = @work_phone
			,ssn = @ssn
			,account = @account
			,seq = @seq
			,mr = @mail_return
		where
			number = @receiverNumber
	end

	DECLARE @regionCode VARCHAR(2);
	IF (ISNULL(RTRIM(LTRIM(@country)),'') != '')
	BEGIN
		SELECT @regionCode = [Code]
		FROM [dbo].[RegionInfo]
		WHERE [Name] = @country;
	END

	BEGIN
	insert into
		Debtors
		(
			number
			,Seq
			,Name
			,Street1
			,Street2
			,City
			,State
			,Zipcode
			,HomePhone
			,WorkPhone
			,SSN
			,JobName
			,JobAddr1
			,JobAddr2
			,JobCSZ
			,Spouse
			,SpouseJobName
			,SpouseJobAddr1
			,SpouseJobAddr2
			,SpouseJobCSZ
			,SpouseHomePhone	
			,SpouseWorkPhone
			,othername		
			,county
			,country	
			,mr
			,dob
			,regioncode
		)			
		values
		(	
			 @receiverNumber
			,@seq
			,@name
			,@street1
			,@street2
			,@city
			,@state
			,@zipcode
			,@home_phone
			,@work_phone
			,@ssn
			,@job_name
			,@job_street1
			,@job_street2
			,@job_city_state_zipcode
			,@spouse_name
			,@spouse_job_name
			,@spouse_job_street1
			,@spouse_job_street2
			,@spouse_job_city_state_zipcode 
			,@spouse_home_phone
			,@spouse_work_phone
			,@other_name
			,@county
			,@country
			,@mail_return
			,@date_of_birth
			,@regionCode
		)
	END	
	
BEGIN
	declare @receiverdebtorid int
	set @receiverdebtorid = SCOPE_IDENTITY()
	insert into receiver_debtorreference (senderdebtorid, receiverdebtorid, clientid) values ( @debtor_number, @receiverdebtorid, @clientId)
	
	-- Added by KAR on 03/26/2010 Handle the Debtor Attorneys
	IF(RTRIM(LTRIM(ISNULL(@attorney_name,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_firm,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_street1,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_street2,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_city,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_state,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_zipcode,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_phone,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_fax,''))) != '' OR 
		RTRIM(LTRIM(ISNULL(@attorney_notes,''))) != '')
	BEGIN

		INSERT INTO [dbo].[DebtorAttorneys]
		([AccountID],
		[DebtorID],
		[Name],
		[Firm],
		[Addr1],
		[Addr2],
		[City],
		[State],
		[Zipcode],
		[Phone],
		[Fax],
		[Email],
		[Comments])
		VALUES
		(@receiverNumber,
		@receiverdebtorid,
		ISNULL(@attorney_name,''),
		ISNULL(@attorney_firm,''),
		ISNULL(@attorney_street1,''),
		ISNULL(@attorney_street2,''),
		ISNULL(@attorney_city,''),
		ISNULL(@attorney_state,''),
		ISNULL(@attorney_zipcode,''),
		ISNULL(@attorney_phone,''),
		ISNULL(@attorney_fax,''),
		'',
		ISNULL(@attorney_notes,'')
		)
	END
	SELECT @receiverdebtorid
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessDeceased]
@client_id int,--OK
@debtor_number int,--OK
@file_number int,--OK
@ssn varchar(15) = NULL,--OK
@first_name varchar(30) = NULL,--OK
@last_name varchar(30) = NULL,--OK
@state varchar(3) = NULL,--OK
@postal_code varchar(10) = NULL,--OK
@date_of_birth datetime,--OK
@date_of_death datetime,--OK
@match_code varchar(5) = NULL,--OK
@transmit_date datetime,--OK
@claim_deadline_date datetime = NULL,
@filed_date datetime = NULL,
@case_number varchar(20) = NULL,
@executor varchar(50) = NULL,
@executor_phone varchar(50) = NULL,
@executor_fax varchar(50) = NULL,
@executor_street1 varchar(50) = NULL,
@executor_street2 varchar(50) = NULL,
@executor_state varchar(3) = NULL,
@executor_city varchar(100) = NULL,
@executor_zipcode varchar(10) = NULL,
@court_city varchar(50) = NULL,
@court_district varchar(200) = NULL,
@court_division varchar(100) = NULL,
@court_phone varchar(50) = NULL,
@court_street1 varchar(50) = NULL,
@court_street2 varchar(50) = NULL,
@court_state varchar(3) = NULL,
@court_zipcode varchar(15) = NULL
AS
BEGIN
	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @client_id
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @dnumber int
	select @dnumber = max(receiverdebtorid )
	from receiver_debtorreference rd with (nolock)
	join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
	where senderdebtorid = @debtor_number
	and clientid = @client_id

	IF(@dnumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1) -- TODO Which error to raise here?
		RETURN
	END
	
	DECLARE @Qlevel varchar(5)
	
	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @receiverNumber
	
	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END
	

	DECLARE @decID int
	SELECT @decID = [ID] 
	FROM [dbo].[Deceased] WITH (NOLOCK)
	WHERE [AccountID] = @receiverNumber 
		AND [DebtorID] = @dnumber
	
	-- An Insert??
	IF(@decID IS NULL) 
	BEGIN
	
		INSERT INTO [dbo].[Deceased]
		([AccountID],
		[DebtorID],
		[SSN],
		[FirstName],
		[LastName],
		[State],
		[PostalCode],
		[DOB],
		[DOD],
		[MatchCode],
		[TransmittedDate],
		[ClaimDeadline],
		[DateFiled],
		[CaseNumber],
		[Executor],
		[ExecutorPhone],
		[ExecutorFax],
		[ExecutorStreet1],
		[ExecutorStreet2],
		[ExecutorState],
		[ExecutorCity],
		[ExecutorZipcode],
		[CourtCity],
		[CourtDistrict],
		[CourtDivision],
		[CourtPhone],
		[CourtStreet1],
		[CourtStreet2],
		[CourtState],
		[CourtZipcode],
		[ctl])
		
		VALUES
		(@receiverNumber,--[AccountID] [int] NOT NULL,
		@dnumber,--[DebtorID] [int] NOT NULL,
		@ssn,--[SSN] [varchar](15) NULL,
		@first_name,--[FirstName] [varchar](30) NULL,
		@last_name,--[LastName] [varchar](30) NULL,
		@state,--[State] [varchar](3) NULL,
		@postal_code,--[PostalCode] [varchar](10) NULL,
		@date_of_birth,--[DOB] [datetime] NULL,
		@date_of_death,--[DOD] [datetime] NULL,
		@match_code,--[MatchCode] [varchar](5) NULL,
		@transmit_date,--[TransmittedDate] [smalldatetime] NULL,
		@claim_deadline_date,--[ClaimDeadline] [datetime] NULL,
		@filed_date,--[DateFiled] [datetime] NULL,
		@case_number,--[CaseNumber] [varchar](20) NULL,
		@executor,--[Executor] [varchar](50) NULL,
		@executor_phone,--[ExecutorPhone] [varchar](50) NULL,
		@executor_fax,--[ExecutorFax] [varchar](50) NULL,
		@executor_street1,--[ExecutorStreet1] [varchar](50) NULL,
		@executor_street2,--[ExecutorStreet2] [varchar](50) NULL,
		@executor_state,--[ExecutorState] [varchar](3) NULL,
		@executor_city,--[ExecutorCity] [varchar](100) NULL,
		@executor_zipcode,--[ExecutorZipcode] [varchar](10) NULL,
		@court_city,--[CourtCity] [varchar](50) NULL,
		@court_district,--[CourtDistrict] [varchar](200) NULL,
		@court_division,--[CourtDivision] [varchar](100) NULL,
		@court_phone,--[CourtPhone] [varchar](50) NULL,
		@court_street1,--[CourtStreet1] [varchar](50) NULL,
		@court_street2,--[CourtStreet2] [varchar](50) NULL,
		@court_state,--[CourtState] [varchar](3) NULL,
		@court_zipcode,--[CourtZipcode] [varchar](15) NULL,
		'AIM' --[ctl] [varchar](3) NULL,		
		)
		
	END
	-- Otherwise an Update
	ELSE
	BEGIN
		UPDATE [dbo].[Deceased]
		SET [SSN] = @ssn,--[SSN] [varchar](15) NULL,
		[FirstName] = @first_name, --[FirstName] [varchar](30) NULL,
		[LastName] = @last_name, --[LastName] [varchar](30) NULL,
		[State] = @state,--[State] [varchar](3) NULL,
		[PostalCode] = @postal_code,-- [PostalCode] [varchar](10) NULL,
		[DOB] = @date_of_birth,-- [DOB] [datetime] NULL,
		[DOD] = @date_of_death, --[DOD] [datetime] NULL,
		[MatchCode] = @match_code,--[MatchCode] [varchar](5) NULL,
		[TransmittedDate] = @transmit_date, --[TransmittedDate] [smalldatetime] NULL,
		[ClaimDeadline] = @claim_deadline_date,--[ClaimDeadline] [datetime] NULL,
		[DateFiled] =  @filed_date,--[DateFiled] [datetime] NULL,
		[CaseNumber] = @case_number, --[CaseNumber] [varchar](20) NULL,
		[Executor] = @executor, --[Executor] [varchar](50) NULL,
		[ExecutorPhone] = @executor_phone,--[ExecutorPhone] [varchar](50) NULL,
		[ExecutorFax] = @executor_fax, --[ExecutorFax] [varchar](50) NULL,
		[ExecutorStreet1] = @executor_street1,--[ExecutorStreet1] [varchar](50) NULL,
		[ExecutorStreet2] = @executor_street2,--[ExecutorStreet2] [varchar](50) NULL,
		[ExecutorState] = @executor_state, --[ExecutorState] [varchar](3) NULL,
		[ExecutorCity] = @executor_city, --[ExecutorCity] [varchar](100) NULL,
		[ExecutorZipcode] = @executor_zipcode,--[ExecutorZipcode] [varchar](10) NULL,
		[CourtCity] = @court_city,--[CourtCity] [varchar](50) NULL,
		[CourtDistrict] = @court_district, --[CourtDistrict] [varchar](200) NULL,
		[CourtDivision] = @court_division,--[CourtDivision] [varchar](100) NULL,
		[CourtPhone] = @court_phone,--[CourtPhone] [varchar](50) NULL,
		[CourtStreet1] = @court_street1, --[CourtStreet1] [varchar](50) NULL,
		[CourtStreet2] = @court_street2, --[CourtStreet2] [varchar](50) NULL,
		[CourtState] = @court_state,--[CourtState] [varchar](3) NULL,
		[CourtZipcode] = @court_zipcode,--[CourtZipcode] [varchar](15) NULL,
		[ctl] = 'AIM' 
		WHERE [ID] = @decID 
	END
END

GO

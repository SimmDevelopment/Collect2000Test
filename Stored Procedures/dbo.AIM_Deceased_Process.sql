SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Deceased_Process]
(
    @debtor_number   int
    ,@file_number int
	,@ssn varchar(50)
	,@first_name varchar(50)
	,@last_name varchar(50)
	,@state varchar(50)
	,@postal_code varchar(50)
	,@date_of_birth datetime
	,@date_of_death datetime
	,@match_code varchar(50)
	,@transmit_date datetime
	,@agencyId int
	,@claim_deadline_date DATETIME = NULL
	,@filed_date DATETIME  = NULL
	,@case_number VARCHAR(20)  = NULL
	,@executor VARCHAR(50)  = NULL
	,@executor_phone VARCHAR(50)  = NULL
	,@executor_fax VARCHAR(50)  = NULL
	,@executor_street1 VARCHAR(50)  = NULL
	,@executor_street2 VARCHAR(50)  = NULL
	,@executor_state VARCHAR(3)  = NULL
	,@executor_city VARCHAR(100)  = NULL
	,@executor_zipcode VARCHAR(10)  = NULL
	,@court_city VARCHAR(50)  = NULL
	,@court_district VARCHAR(200)  = NULL
	,@court_division VARCHAR(100)  = NULL
	,@court_phone VARCHAR(50)  = NULL
	,@court_street1 VARCHAR(50)  = NULL
	,@court_street2 VARCHAR(50)  = NULL
	,@court_state VARCHAR(3)  = NULL
	,@court_zipcode VARCHAR(15)  = NULL
)
as
begin

	declare @seq int
	declare @masterNumber int,@currentAgencyId int
	declare @agencyTier int
	select 	@seq = dv.seq
		,@masterNumber = dv.number 
		,@currentagencyid = currentlyplacedagencyid
	from 	debtors dv with (nolock)
		left outer join aim_accountreference r on dv.number = r.referencenumber
	where 	dv.debtorid = @debtor_number

	declare @nulldate datetime
	select @nulldate =  cast( '01/01/1900' as datetime)
	
	declare @notelogmessageid int, @filenumber int, @agencyname varchar(50), @closecode char(3), @closedate datetime
	select  
	@filenumber = @file_number	,
	@agencyname = a.name,
	@closecode = 'DEC',
	@closedate = GETDATE(),
	@agencyTier = a.AgencyTier
	from	AIM_AccountReference ar with (nolock)	inner join AIM_Agency a  with (nolock)
	on ar.currentlyplacedagencyid = a.agencyid
	where	ar.referencenumber = @file_number


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

    if (@date_of_death is null or @nulldate = @date_of_death)
    begin
        raiserror('150023', 16, 1)
        return
    end
    
	-- insert record

if exists( select * from deceased where accountid = @masternumber and debtorid = @debtor_number)
begin

		update deceased
		set
         accountid   =        @masternumber
		,debtorid	=		 @debtor_number
		,ssn		=		 @ssn
		,firstname	=		 @first_name
		,lastname	=		 @last_name
		,state		=		 @state 
		,postalcode	=		 @postal_code 
		,dob		=		 @date_of_birth
		,dod		=		 @date_of_death
		,matchcode	=		 @match_code 
		,transmitteddate=	 @transmit_date
		,ctl			=	 'AIM'
		,claimdeadline=@claim_deadline_date
		,datefiled=@filed_date
		,casenumber=@case_number
		,executor=@executor
		,executorphone=@executor_phone
		,executorfax=@executor_fax
		,executorstreet1=@executor_street1
		,executorstreet2=@executor_street2
		,executorstate=@executor_state
		,executorcity=@executor_city
		,executorzipcode=@executor_zipcode
		,courtcity=@court_city
		,courtdistrict=@court_district
		,courtdivision=@court_division
		,courtphone=@court_phone
		,courtstreet1=@court_street1
		,courtstreet2=@court_street2
		,courtstate=@court_state
		,courtzipcode=@court_zipcode


		where accountid = @masternumber and debtorid = @debtor_number


INSERT INTO Notes (number,created,user0,action,result,comment)
VALUES (@masternumber,getdate(),'AIM','AIM','AIM','Deceased information updated from AIM by ' + @agencyname)

end
else
begin  

	insert into 
		Deceased 
	(
		accountid
		,debtorid
		,ssn
		,firstname
		,lastname
		,state
		,postalcode
		,dob
		,dod
		,matchcode
		,transmitteddate
		,ctl
		,claimdeadline
		,datefiled
		,casenumber
		,executor
		,executorphone
		,executorfax
		,executorstreet1
		,executorstreet2
		,executorstate
		,executorcity
		,executorzipcode
		,courtcity
		,courtdistrict
		,courtdivision
		,courtphone
		,courtstreet1
		,courtstreet2
		,courtstate
		,courtzipcode
	)
	values
	(
		@masternumber
		,@debtor_number   
		,@ssn
		,@first_name
		,@last_name
		,@state 
		,@postal_code 
		,@date_of_birth 
		,@date_of_death 
		,@match_code 
		,@transmit_date 
		,'AIM'
		,@claim_deadline_date
		,@filed_date
		,@case_number
		,@executor
		,@executor_phone
		,@executor_fax
		,@executor_street1
		,@executor_street2
		,@executor_state
		,@executor_city
		,@executor_zipcode
		,@court_city
		,@court_district
		,@court_division
		,@court_phone
		,@court_street1
		,@court_street2
		,@court_state
		,@court_zipcode
)


INSERT INTO Notes (number,created,user0,action,result,comment)
VALUES (@masternumber,getdate(),'AIM','AIM','AIM','Deceased information inserted from AIM by ' + @agencyname)

end
UPDATE Debtors SET DOB = ISNULL(@date_of_birth,DOB) WHERE DebtorID = @debtor_number
IF(@seq = 0)
BEGIN
UPDATE Master SET DOB = ISNULL(@date_of_birth,DOB)WHERE Number = @masternumber
END

	-- run actions configured at agency level if agency does not keep deceased
	declare @keepsdec bit
	Select @keepsdec = keepsdeceased from aim_agency where agencyid = @agencyid

if((@keepsdec is null or @keepsdec = 0) and @seq = 0)
begin

	declare @moveToDeskValue varchar(50)
	declare @moveToQueueValue varchar(50)
	declare @changestatus varchar(5)
	select	@moveToDeskValue = movetodeskvalue,@moveToQueueValue = movetoqueuevalue,@changestatus = changestatus
	from	AIM_closestatuscode with (nolock) where code = 'DEC' and agencyid = @agencyId

	-- Get the info for notes
	
	if(@moveToDeskValue is not null)
	begin
		declare @branch varchar(5)
		Select @branch = branch from desk with (nolock) where code = @moveToDeskValue
		update master
		set
			desk = @moveToDeskValue,
			branch = @branch
		where
			number = @masterNumber	
				
		-- Add a note
		select @notelogmessageid = 1010
		exec AIM_AddAimNote @notelogmessageid, @filenumber, @moveToDeskValue, @closecode, @agencyname, @agencyId, @closedate
	end

	if(@moveToQueueValue is not null)
	begin
		
		DECLARE @oldqlevel VARCHAR(3)
		DECLARE @shouldqueue bit
		DECLARE @queuetype bit

		SELECT @oldqlevel = qlevel FROM [master] WITH (NOLOCK) WHERE Number = @masterNumber

		IF(@moveToQueueValue BETWEEN '600' AND '799')
			BEGIN
				
				IF(@oldqlevel NOT BETWEEN '600' AND '799')
					BEGIN
					SET @shouldqueue = 0
					END
				ELSE
					BEGIN
					SET @shouldqueue = 1
					END
			
				IF(@moveToQueueValue BETWEEN '600' AND '699')
					BEGIN
					SET @queuetype = 0
					END
				ELSE
					BEGIN
					SET @queuetype = 1
					END

				INSERT INTO SupportQueueItems (QueueCode,AccountID,DateAdded,DateDue,LastAccessed,ShouldQueue,UserName,QueueType,Comment)
				VALUES (@moveToQueueValue,@masterNumber,getdate(),getdate(),getdate(),@shouldqueue,'AIM',@queuetype,'Qlevel changed via AIM Deceased File')
		
			END	

		update master set qlevel = @moveToQueueValue where number = @masterNumber
		-- Add a note
		select @notelogmessageid = 1011
		exec AIM_AddAimNote @notelogmessageid, @filenumber, @moveToQueueValue, @closecode, @agencyname, @agencyId, @closedate
	end
	
	if(@changestatus is not null)
	begin

		insert into StatusHistory (AccountID,datechanged,username,oldstatus,newstatus)
		select number,getdate(),'AIM',status,@changestatus from master with (nolock) where number = @masterNumber

		DECLARE @closeAccount bit
		SELECT @closeAccount =  CASE statustype WHEN '0 - Active' THEN 0 WHEN '1 - CLOSED' THEN 1 END 
		FROM status WITH (NOLOCK) WHERE code = @changestatus
		
		
		update master
		set	status = @changestatus,qlevel = CASE @closeAccount WHEN 0 THEN qlevel WHEN 1 THEN '998' END,
		closed = CASE @closeAccount WHEN 0 THEN closed WHEN 1 THEN convert(varchar(10),getdate(),101) END
		where	number = @masterNumber

		
		-- Add a note
		select @notelogmessageid = 10111
		exec AIM_AddAimNote @notelogmessageid, @filenumber, @changestatus, @closecode, @agencyname, @agencyId, @closedate

	end
	-- Add a note
	select @notelogmessageid = 1007
	exec AIM_AddAimNote @notelogmessageid, @masterNumber

	-- recall account
	update  AIM_accountreference set 
			isPlaced = 0,lastrecalldate = getdate(),expectedpendingrecalldate = null,
			expectedfinalrecalldate = null,currentlyplacedagencyid = null,numdaysplacedbeforepending = null,
			numdaysplacedafterpending = null,currentcommissionpercentage = null,feeschedule = null,
			LastTier = @agencyTier,
			ObjectionFlag = 0
	from	AIM_accountreference ar with (nolock)
	where	referencenumber = @masterNumber

	-- flag master as recalled
	update	master
	set 	aimagency = null, aimassigned = null	,feecode = null
	where	number = @masterNumber

	-- deactivate PDT for recalled account
	UPDATE AIM_PostDatedTransaction
	SET Active = 0 
	WHERE AccountID = @masterNumber

	--Handle Recourse
	DECLARE @contractdate DATETIME
	SELECT @contractdate = p.ContractDate FROM master m WITH (NOLOCK) JOIN AIM_Portfolio P WITH (NOLOCK) ON m.purchasedportfolio = P.portfolioid
	WHERE number = @masterNumber
	IF(@contractdate IS NOT NULL AND @date_of_death IS NOT NULL)
	BEGIN
	IF NOT EXISTS(SELECT * FROM AIM_Ledger WHERE LedgerTypeID = 5 AND Status = 'Pending' AND Number = @MasterNumber)
		BEGIN
			EXEC dbo.AIM_InsertRecourseEntry @ledgerTypeId = 5,@number = @masterNumber
		END

	END
end
end

GO

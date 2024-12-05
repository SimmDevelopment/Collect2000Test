SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Bankruptcy_Process]
(
    @debtor_number   int
    ,@file_number int
	,@chapter int
	,@date_filed datetime
	,@case_number varchar(50)
	,@court_district varchar(200)
	,@court_division varchar(100)
	,@court_phone varchar(50)
	,@court_street1 varchar(50)
	,@court_street2 varchar(50)
	,@court_city varchar(50)
	,@court_state varchar(50)
	,@court_zipcode varchar(50)
	,@trustee varchar(50)
	,@trustee_street1 varchar(50)
	,@trustee_street2 varchar(50)
	,@trustee_city varchar(100)
	,@trustee_state varchar(50)
	,@trustee_zipcode varchar(50)
	,@trustee_phone varchar(50)
	,@three_forty_one_info_flag bit
	,@three_forty_one_date datetime
	,@three_forty_one_location varchar(200)
	,@comments varchar(500)
	,@status varchar(100)
	,@transmit_date datetime
	,@agencyId int
	,@notice_date DATETIME = NULL
	,@proof_filed_date DATETIME = NULL
	,@discharge_date DATETIME = NULL
	,@dismissal_date DATETIME = NULL
	,@confirmation_hearing_date DATETIME = NULL
	,@reaffirm_filed_date DATETIME = NULL
	,@voluntary_date DATETIME = NULL
	,@surrender_date DATETIME = NULL
	,@auction_date DATETIME = NULL
	,@reaffirm_amount MONEY = NULL
	,@voluntary_amount MONEY = NULL
	,@auction_amount MONEY = NULL
	,@auction_fee_amount MONEY = NULL
	,@auction_applied_amount MONEY = NULL
	,@secured_amount MONEY = NULL
	,@secured_percentage MONEY = NULL
	,@unsecured_amount MONEY = NULL
	,@unsecured_percentage MONEY = NULL
	,@converted_from_chapter INT = NULL
	,@has_asset CHAR(1) = NULL
	,@reaffirm_flag CHAR(1) = NULL
	,@reaffirm_terms VARCHAR(50) = NULL
	,@voluntary_terms VARCHAR(50) = NULL
	,@surrender_method VARCHAR(50) = NULL
	,@auction_house VARCHAR(50) = NULL
)
as
begin

	declare @seq int
	declare @masterNumber int,@currentAgencyId int
	declare @agencyTier int
	declare @notelogmessageid int, @filenumber int, @agencyname varchar(50), @closecode char(3), @closedate datetime
	
	select
		 @filenumber = @file_number
		,@agencyname = a.name
		,@closecode = 'B' + CASE WHEN len(@chapter) = 1 THEN  cast(@chapter as char(1)) ELSE cast(@chapter as char(2)) END
		,@closedate = GETDATE()
		,@agencyTier = a.AgencyTier
	from
		AIM_AccountReference ar with (nolock)
		inner join AIM_Agency a with (nolock) on ar.currentlyplacedagencyid = a.agencyid
	where
		ar.referencenumber = @file_number

	declare @nulldate datetime
	select @nulldate =  cast( '01/01/1900' as datetime)

	select 	@seq = dv.seq
		,@masterNumber = dv.number 
		,@currentagencyid = currentlyplacedagencyid
	from 	debtors dv with (nolock)
		left outer join aim_accountreference r with (nolock) on dv.number = r.referencenumber
	where 	dv.debtorid = @debtor_number

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
	if (@case_number is null)
    begin
        raiserror ('150024', 16, 1)
        return
    end
	
	if(@chapter not in (7,11,12,13))
    begin
        raiserror('150028', 16, 1)
        return
    end

    if (@chapter is null or @closecode is null)
    begin
        raiserror('150025', 16, 1)
        return
    end
    if (@date_filed is null or @nulldate = @date_filed)
    begin
        raiserror('150026', 16, 1)
        return
    end
 
	-- insert bankruptcy record
if exists ( select accountid from bankruptcy where accountid = @masternumber and debtorid = @debtor_number)
begin
update bankruptcy
set
		accountid     =  @masternumber
		,debtorid	=	 @debtor_number   
		,chapter	=	 @chapter 
		,datefiled	=	 @date_filed 
		,casenumber	=	 isnull(@case_number                    ,casenumber	)	
		,courtcity	=	 isnull(@court_city						,courtcity)	
		,courtdistrict=	 isnull(@court_district					,courtdistrict)
		,courtdivision=	 isnull(@court_division					,courtdivision)
		,courtphone	=	 isnull(@court_phone					,courtphone)	
		,courtstreet1=	 isnull(@court_street1					,courtstreet1)	
		,courtstreet2=	 isnull(@court_street2					,courtstreet2)
		,courtstate	=	 isnull(@court_state					,courtstate	)
		,courtzipcode=	 isnull(@court_zipcode					,courtzipcode)
		,trustee	=	 isnull(@trustee						,trustee)
		,trusteestreet1= isnull(@trustee_street1			,trusteestreet1)
		,trusteestreet2= isnull(@trustee_street2			,trusteestreet2)
		,trusteecity=	 isnull(@trustee_city					,trusteecity)
		,trusteestate=	 isnull(@trustee_state					,trusteestate)
		,trusteezipcode= isnull(@trustee_zipcode			,trusteezipcode)
		,trusteephone=	 isnull(@trustee_phone					,trusteephone)
		,has341info	=	 isnull(@three_forty_one_info_flag		,has341info)
		,datetime341=	 isnull(@three_forty_one_date			,datetime341)
		,location341=	 isnull(@three_forty_one_location		,location341)
		,comments	=	 isnull(@comments						,comments)
		,status		=	 isnull(@status							,status)
		,transmitteddate= @transmit_date 
		,ctl	=		 'AIM'
		,DateNotice = isnull(@notice_date ,DateNotice )
		,ProofFiled = isnull(@proof_filed_date ,ProofFiled )
		,DischargeDate = isnull(@discharge_date ,DischargeDate )
		,DismissalDate = isnull(@dismissal_date ,DismissalDate )
		,ConfirmationHearingDate = isnull(@confirmation_hearing_date , ConfirmationHearingDate)
		,ReaffirmDateFiled = isnull(@reaffirm_filed_date ,ReaffirmDateFiled )
		,VoluntaryDate = isnull(@voluntary_date ,VoluntaryDate )
		,SurrenderDate = isnull(@surrender_date ,SurrenderDate )
		,AuctionDate = isnull(@auction_date ,AuctionDate )
		,ReaffirmAmount = isnull(@reaffirm_amount, ReaffirmAmount)
		,VoluntaryAmount = isnull(@voluntary_amount,VoluntaryAmount )
		,AuctionAmount = isnull(@auction_amount,AuctionAmount )
		,AuctionFee = isnull(@auction_fee_amount,AuctionFee )
		,AuctionAmountApplied = isnull(@auction_applied_amount,AuctionAmountApplied )
		,SecuredAmount = isnull(@secured_amount,SecuredAmount )
		,SecuredPercentage = isnull(@secured_percentage,SecuredPercentage )
		,UnsecuredAmount = isnull(@unsecured_amount,UnsecuredAmount )
		,UnsecuredPercentage = isnull(@unsecured_percentage,UnsecuredPercentage )
		,ConvertedFrom = isnull(@converted_from_chapter,ConvertedFrom)
		,HasAsset = CASE WHEN @has_asset = 'T' THEN 1 ELSE 0 END
		,Reaffirm = CASE WHEN @reaffirm_flag = 'T' THEN 1 ELSE 0 END
		,ReaffirmTerms = isnull(@reaffirm_terms,ReaffirmTerms)
		,VoluntaryTerms = isnull(@voluntary_terms,VoluntaryTerms)
		,SurrenderMethod = isnull(@surrender_method,SurrenderMethod)
		,AuctionHouse = isnull(@auction_house ,AuctionHouse)
where accountid = @masternumber and debtorid = @debtor_number
	

INSERT INTO Notes (number,created,user0,action,result,comment)
VALUES (@masternumber,getdate(),'AIM','AIM','AIM','Bankruptcy information updated from AIM by ' + @agencyname)

end
else
begin
	insert into 
		Bankruptcy 
	(
		accountid
		,debtorid
		,chapter
		,datefiled
		,casenumber
		,courtcity
		,courtdistrict
		,courtdivision
		,courtphone
		,courtstreet1
		,courtstreet2
		,courtstate
		,courtzipcode
		,trustee
		,trusteestreet1
		,trusteestreet2
		,trusteecity
		,trusteestate
		,trusteezipcode
		,trusteephone
		,has341info
		,datetime341
		,location341
		,comments
		,status
		,transmitteddate
		,ctl
		,DateNotice
		,ProofFiled
		,DischargeDate
		,DismissalDate
		,ConfirmationHearingDate
		,ReaffirmDateFiled
		,VoluntaryDate
		,SurrenderDate
		,AuctionDate
		,ReaffirmAmount
		,VoluntaryAmount
		,AuctionAmount
		,AuctionFee
		,AuctionAmountApplied 
		,SecuredAmount
		,SecuredPercentage
		,UnsecuredAmount
		,UnsecuredPercentage
		,ConvertedFrom
		,HasAsset
		,Reaffirm
		,ReaffirmTerms
		,VoluntaryTerms
		,SurrenderMethod
		,AuctionHouse
	)
	values
	(
		@masternumber
		,@debtor_number   
		,@chapter 
		,@date_filed 
		,isnull(@case_number ,'')
		,isnull(@court_city ,'')
		,isnull(@court_district,'') 
		,isnull(@court_division ,'')
		,isnull(@court_phone ,'')
		,isnull(@court_street1 ,'')
		,isnull(@court_street2 ,'')
		,isnull(@court_state ,'')
		,isnull(@court_zipcode ,'')
		,isnull(@trustee ,'')
		,isnull(@trustee_street1,'') 
		,isnull(@trustee_street2 ,'')
		,isnull(@trustee_city ,'')
		,isnull(@trustee_state ,'')
		,isnull(@trustee_zipcode ,'')
		,isnull(@trustee_phone ,'')
		,isnull(@three_forty_one_info_flag,'0') 
		,isnull(@three_forty_one_date,'')
		,isnull(@three_forty_one_location ,'')
		,isnull(@comments ,'')
		,isnull(@status ,'')
		,@transmit_date 
		,'AIM'
		,@notice_date 
		,@proof_filed_date 
		,@discharge_date 
		,@dismissal_date 
		,@confirmation_hearing_date 
		,@reaffirm_filed_date 
		,@voluntary_date 
		,@surrender_date 
		,@auction_date 
		,@reaffirm_amount
		,@voluntary_amount
		,@auction_amount
		,@auction_fee_amount
		,@auction_applied_amount
		,@secured_amount
		,@secured_percentage
		,@unsecured_amount
		,@unsecured_percentage
		,@converted_from_chapter
		,@has_asset
		,@reaffirm_flag
		,@reaffirm_terms
		,@voluntary_terms
		,@surrender_method
		,@auction_house


	)


INSERT INTO Notes (number,created,user0,action,result,comment)
VALUES (@masternumber,getdate(),'AIM','AIM','AIM','Bankruptcy information inserted from AIM by ' + @agencyname)
end
	-- run actions configured at agency level if agency does not keep banko accounts
	declare @keepsbanko bit
	Select @keepsbanko = keepsbanko from aim_agency where agencyid = @agencyid

if((@keepsbanko is null or @keepsbanko = 0) and @seq = 0)
begin
	declare @moveToDeskValue varchar(50)
	declare @moveToQueueValue varchar(50)
	declare @changestatus varchar(5)
	select
		@moveToDeskValue = movetodeskvalue
		,@moveToQueueValue = movetoqueuevalue
		,@changestatus  = changestatus
	from
		AIM_closestatuscode with (nolock)
	where
		code =  @closecode 
		and agencyid = @agencyId

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
				VALUES (@moveToQueueValue,@masterNumber,getdate(),getdate(),getdate(),@shouldqueue,'AIM',@queuetype,'Qlevel changed via AIM Bankruptcy File')
		
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
	declare @chaptercode char(3), @datefiled datetime
	select @notelogmessageid = 1006
	
	exec AIM_AddAimNote @notelogmessageid, @masterNumber, @closecode, @date_filed

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


	-- deactivate PDT from agency
	update AIM_PostDatedTransaction
	SET Active = 0 WHERE AccountID = @masterNumber
	
	
--HANDLE RECOURSE
DECLARE @contractdate DATETIME
SELECT @contractdate = p.ContractDate FROM master m WITH (NOLOCK) JOIN AIM_Portfolio P WITH (NOLOCK) ON m.purchasedportfolio = P.portfolioid
WHERE number = @masterNumber
	IF(@contractdate IS NOT NULL AND @date_filed IS NOT NULL AND @chapter IS NOT NULL AND @case_number IS NOT NULL AND @date_filed < @contractdate)
		BEGIN
		IF NOT EXISTS(SELECT * FROM AIM_Ledger WHERE LedgerTypeID = 4 AND Status = 'Pending' AND Number = @MasterNumber)
			BEGIN
				EXEC dbo.AIM_InsertRecourseEntry @ledgerTypeId = 4,@number = @masterNumber
			END

		END
end
end

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Close_Process]
(
      	@file_number   int
     	,@account varchar(20)
	,@close_status_code char(3)
	,@close_date datetime
	,@agencyId int
)
as
begin

	-- verify account
	declare @masterNumber int
	declare @agencyTier int
	declare @current0 money,@currentAgencyId int
	select 	@masterNumber = m.number ,
		@currentAgencyId = r.currentlyplacedagencyid
	from 	master m with (nolock)
		left outer join aim_accountreference r on m.number = r.referencenumber
	where 	m.number = @file_number

	if(@masterNumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end
	if(@currentAgencyId is null or (@currentAgencyId <> @agencyId))
	begin
		raiserror ('15004', 16, 1)
		return
	end

	declare @closeName varchar(50)
	select	@closeName = name
	from	AIM_closestatuscode
	where	code = @close_status_code
		and agencyid = @agencyId
	if(@closeName is null)
	begin
		RAISERROR ('15005', 16, 1)
		return
	end

	-- run actions configured at agency level
	declare @moveToDeskValue varchar(50)
	declare @moveToQueueValue varchar(50)
	declare @changeStatus varchar(5)
	select	@moveToDeskValue = movetodeskvalue
		,@moveToQueueValue = movetoqueuevalue
		,@changeStatus = changestatus
	from	AIM_closestatuscode with (nolock)
	where	code = @close_status_code
		and agencyid = @agencyId

	-- Get the info for notes
	declare @notelogmessageid int, @filenumber int, @agencyname varchar(50), @closecode char(3), @closedate datetime
	select
		 @filenumber = @file_number
		,@agencyname = a.name
		,@closecode = @close_status_code
		,@closedate = @close_date
		,@agencyTier = a.AgencyTier
	from
		AIM_AccountReference ar
		inner join AIM_Agency a on ar.currentlyplacedagencyid = a.agencyid
	where
		ar.referencenumber = @file_number

	if(@moveToDeskValue is not null)
	begin
		declare @branch varchar(5)
		Select @branch = branch from desk where code = @moveToDeskValue
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
				VALUES (@moveToQueueValue,@masterNumber,getdate(),getdate(),getdate(),@shouldqueue,'AIM',@queuetype,'Qlevel changed via AIM Close File')
		
			END	

		-- Removed the following line per Kenny's request TJL 08/16/2010
		--update master set qlevel = @moveToQueueValue where number = @masterNumber
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
	select @notelogmessageid = 1005
	exec AIM_AddAimNote @notelogmessageid, @filenumber, @agencyname, @agencyId, @closedate, @closecode

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
	set 	aimagency = null, aimassigned = null, feecode = null
	where	number = @masterNumber

	--deactivate PDT transactions
	UPDATE AIM_PostDatedTransaction
	SET Active = 0
	WHERE AccountID = @masterNumber
end

GO

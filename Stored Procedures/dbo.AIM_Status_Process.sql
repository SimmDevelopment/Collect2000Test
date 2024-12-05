SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   procedure [dbo].[AIM_Status_Process]
(
  	@file_number   int
  	,@debtor_number int
 	,@status varchar(3)
	,@note varchar(75)
	,@note_date datetime
	,@notification varchar(3)
	,@agencyId int
	
)
as
begin

	
	declare @RecallAndClose varchar(5)
	declare @masterNumber int
	declare @oldStatus varchar(5)
	declare @currentAgencyId int
	declare @agencyTier int
	declare @overWriteStatus bit
	
	set @overWriteStatus = 1
--Select Variables
	select 	@masterNumber = m.number ,@currentAgencyId=currentlyplacedagencyid,@oldStatus = m.status,
	@agencyTier = a.AgencyTier
	from 	master m with (nolock)
		left outer join aim_accountreference r on m.number = r.referencenumber
		join aim_Agency a with (nolock) on a.agencyid = r.currentlyplacedagencyid
	where 	m.number = @file_number


--Validate Record Data
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

	if(@status not in (select code from status with (nolock)) and @overWriteStatus = 1 and @status is not null and LTRIM(RTRIM(@status)) <> '')
	begin
		raiserror ('15007', 16,1)
		return
	end

	if(@notification is not null and LTRIM(RTRIM(@notification)) <> '' and (@notification not between '600' and '799' or @notification not in (select code from qlevel with (nolock))) )
	begin
		raiserror('15011',16,1)
		return
	end

	

	if(@notification is not null and LTRIM(RTRIM(@notification)) <> '')
	begin
	DECLARE @queuetype bit
	--Insert SupportQueueItems
	IF(@notification BETWEEN '600' AND '699')
		BEGIN
		SET @queuetype = 0
		END
	ELSE
		BEGIN
		SET @queuetype = 1
		END

	INSERT INTO SupportQueueItems (QueueCode,AccountID,DateAdded,DateDue,LastAccessed,ShouldQueue,UserName,QueueType,Comment)
	VALUES (@notification,@masterNumber,getdate(),getdate(),getdate(),0,'AIM',@queuetype,'Support Queue Item entered by AIM via notification (' + @notification + ') in AIM Status File')
		

	
	--Write Note
	INSERT INTO Notes (number,created,user0,action,result,comment)
	VALUES (@masterNumber,getdate(),'AIM','+++++','+++++','Support Queue Item entered by AIM via notification (' + @notification + ') in AIM Status File')

	

	end
--Overwrite and insert notes and history
	if(@overWriteStatus = 1 and @status is not null and LTRIM(RTRIM(@status)) <> '')
	begin
	
		DECLARE @closeAccount bit
		SELECT @closeAccount =  CASE statustype WHEN '0 - Active' THEN 0 WHEN '1 - CLOSED' THEN 1 END 
		FROM status WITH (NOLOCK) WHERE code = @status
	

		update master set status = @status ,qlevel = CASE @closeAccount WHEN 0 THEN qlevel WHEN 1 THEN '998' END,
		closed = CASE @closeAccount WHEN 0 THEN closed WHEN 1 THEN convert(varchar(10),getdate(),101) END
		where	number = @file_number

		INSERT INTO Notes(number,user0,action,result,comment,created)
		VALUES(@file_number,'AIM','+++++','+++++','Status has changed from ' + @oldStatus + ' to ' + @status,getdate())

		INSERT INTO StatusHistory (AccountID,DateChanged,UserName,OldStatus,NewStatus)
		VALUES (@file_number,getdate(),'AIM',@oldStatus,@status)
		
	end
--Write notes if applicable
	if(@note is not null and ltrim(rtrim(@note)) <> '')
	begin
	INSERT INTO Notes(number,ctl,user0,action,result,comment,created)
	VALUES(@file_number,'AIM','AIM','+++++','+++++',@note,@note_date)

	
	if(@RecallAndClose = 'True' and @status is not null and LTRIM(RTRIM(@status))  <> '')
		
		begin
			declare @statustype varchar(10)
			select @statustype =  statustype from status with (nolock) where code = @status
			if(  '1 - Closed' = @statusType)
			begin
				update  AIM_accountreference set 
					isPlaced = 0,lastrecalldate = getdate(),expectedpendingrecalldate = null,
					expectedfinalrecalldate = null,currentlyplacedagencyid = null,numdaysplacedbeforepending = null,
					numdaysplacedafterpending = null,currentcommissionpercentage = null,feeschedule = null,
					LastTier = @agencyTier,ObjectionFlag = 0
				from	AIM_accountreference ar with (nolock)
				where	referencenumber = @masterNumber

			-- flag master as recalled
				update	master
				set 	aimagency = null, aimassigned = null,feecode = null,closed = convert(varchar(10),getdate(),121),qlevel = '998'
				where	number = @masterNumber


			-- deactivate PDT from agency
				update AIM_PostDatedTransaction
				SET Active = 0 WHERE AccountID = @masterNumber

			INSERT INTO Notes(number,ctl,user0,action,result,comment,created)
			VALUES(@masterNumber,'AIM','AIM','AIM','AIM','Account recalled from agency due to Close Status Code in ASTS file.',getdate())
			end
		end
	end

end

GO

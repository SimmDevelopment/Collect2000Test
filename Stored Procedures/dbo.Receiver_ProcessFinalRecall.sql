SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [dbo].[Receiver_ProcessFinalRecall]
	@file_number int
	,@account varchar(30)
	,@is_pending_recall varchar(3) = NULL
	,@recall_reason varchar(3)
	,@objection_date datetime
	,@desk varchar(10)
	,@record_type varchar(4) = NULL
	,@Filler varchar(2) = NULL
	,@clientid int
AS

	declare @receiverNumber int
	select @receivernumber = max(receivernumber) from receiver_reference with (nolock) where sendernumber = @file_number
	and clientid = @clientid

	if(@receivernumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end
	declare @currentdesk varchar(7)
	declare @qlevel varchar(3)
	declare @status varchar(5)
	select
		@qlevel = qlevel,
		@status = status,
		@currentdesk = desk
	from
		master with (nolock)
	where
		number = @receiverNumber
	if(@qlevel = '999')
	begin
		insert into 
			notes
			(
				number
				,created
				,user0
				,action
				,result
				,comment				
			)
			values
			(
				@receiverNumber
				,getdate()
				,'AIM'
				,'+++++'
				,'+++++'
				,'Received a final recall, but already returned.'			
			)
	end
	else
	begin

		update	master
		set	qlevel = '999'
			,returned = getdate()
			,closed = isnull(closed,getdate()) -- only if not closed
			,shouldqueue = 0	
			,status = 'RCL'		
		where	number = @receiverNumber

		if(@desk is not null and len(@desk) > 2 and @currentdesk <> @desk)
		begin
		
		declare @branch varchar(5)
		Select @branch = branch from desk with (nolock) where code = @desk
		update master
		set
			desk = @desk,
			branch = @branch
		where
		number = @receiverNumber
		
		insert into notes (number,created,user0,action,result,comment)
		values  (@receiverNumber,getdate(),'AIM','+++++','+++++','Desk Changed | ' +@currentdesk+' | ' + @desk + ' | Account Recalled')
		
		end

		insert into notes (number,created,user0,action,result,comment)
		values  (@receiverNumber,getdate(),'AIM','+++++','+++++','Status Changed | ' +@status+' | RCL | Account Recalled')
		insert into statushistory (accountid,datechanged,username,oldstatus,newstatus)
		values (@receiverNumber,getdate(),'AIM',@status,'RCL')
		insert into notes(number,created,user0,action,result,comment)
		values(	@receiverNumber	,getdate(),'AIM','+++++','+++++','Received a final recall; closing and returning.')
		
		
	end

GO

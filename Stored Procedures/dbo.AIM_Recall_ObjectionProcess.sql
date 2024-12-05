SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Change History
--6/11/2009
--Modified the update to AIM_Account_Reference to calculate the ExpectedPendingRecallDate after receiving an objection
--notice, it will now be calculated based on the ExpectedFinalRecallDate - NumDaysPlacedAfterPending + RecallExtensionDays
CREATE   procedure [dbo].[AIM_Recall_ObjectionProcess]
(
      	@file_number   int
     	,@account varchar(30)
	,@objection_reason_code char(3)
	,@objection_date datetime
	,@agencyId int
)
as
begin

	-- verify account
	declare @masterNumber int
	declare @current0 money,@currentAgencyId int
	select 	@masterNumber = m.number ,@currentAgencyId = r.currentlyplacedagencyid
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

	-- see what to do for recall objection
	declare @recallExtension int
	select
		@recallExtension = extensionnumdays
	from
		AIM_objectionreason
	where
		code = @objection_reason_code

	if(@recallExtension is null)
	begin	
		RAISERROR ('15003', 16, 1)
		return
	end
	else
	begin

		-- extend recall
		update AIM_accountreference
			set expectedpendingrecalldate = expectedfinalrecalldate - isnull(NumDaysPlacedAfterPending,0) + @recallExtension
			,expectedfinalrecalldate = expectedfinalrecalldate + @recallExtension
			,objectionflag = 1
		from
			AIM_accountreference ar
		where
			ar.referencenumber = @masterNumber
	end

	-- Add a note
	declare @notelogmessageid int, @filenumber int, @agencyname varchar(50), @objectionreason char(3), @currentdate datetime, @newrecalldate datetime
	select
		@notelogmessageid = 1003
		,@filenumber = @file_number
		,@agencyname = a.name
		,@objectionreason = @objection_reason_code
		,@currentdate = getdate()
		,@newrecalldate = ar.expectedfinalrecalldate
	from
		AIM_AccountReference ar
		inner join AIM_Agency a on ar.currentlyplacedagencyid = a.agencyid
	where
		ar.referencenumber = @file_number
	
	exec AIM_AddAimNote @notelogmessageid, @filenumber, @agencyname, @agencyId, @objectionreason, @currentdate, @newrecalldate
end



GO

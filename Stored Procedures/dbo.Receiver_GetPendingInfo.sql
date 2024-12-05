SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[Receiver_GetPendingInfo]
	@file_number int
	,@account varchar(30)
	,@recall_reason varchar(3)
	,@is_pending_recall varchar(1) = NULL
	,@objection_date datetime
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

	select
		number
		,qlevel
		,desk
		,status
		,closed
		,dbo.Receiver_HasAValidPromise(@receiverNumber, getdate()) as haspromises
		,dbo.Receiver_HasPostDatedChecks(@receiverNumber, getdate()) as haspdcs
		,lastpaid
	from
		master  with (nolock)
	where
		number = @receiverNumber

GO

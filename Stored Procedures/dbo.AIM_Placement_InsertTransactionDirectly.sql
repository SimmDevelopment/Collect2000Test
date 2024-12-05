SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE                   procedure [dbo].[AIM_Placement_InsertTransactionDirectly]
(
    @referenceNumber   int,
    @agencyId   int,
	@commissionPercentage decimal,
	@autoRecallOn bit,
	@pendingRecallDays int,
	@finalRecallDays int,
	@feeSchedule varchar(5) = null,
	@desk varchar(10) = null,
	@recalldesk varchar(10) = null
)
as
begin

	declare @accountReferenceId int 
	exec AIM_Account_GetAccountReference @referenceNumber, @accountReferenceId out

	declare @current0 money
	select	@current0 = current0 from	master where number = @referenceNumber

	insert into AIM_accounttransaction (accountreferenceid,transactiontypeid,transactionstatustypeid,
				createddatetime,agencyid,commissionpercentage,balance,feeSchedule,desk)
	values(@accountReferenceId,1,1,getdate(),@agencyId,@commissionPercentage,@current0,@feeSchedule,@desk)

	update AIM_accountreference
	set isPlaced = 0
	,lastPlacementDate = null
	,expectedPendingRecallDate = null 
	,expectedFinalRecallDate = null
	,numdaysplacedbeforepending = case @autorecallon when 1 then @pendingrecalldays else null end
	,numdaysplacedafterpending = case @autorecallon when 1 then @finalRecallDays else null end
	,currentlyplacedagencyid = null
	,currentcommissionpercentage = null
	,feeschedule = null
	,recalldesk = case @autorecallon when 1 then @recalldesk else null end
	where	accountreferenceid = @accountReferenceid


end



GO

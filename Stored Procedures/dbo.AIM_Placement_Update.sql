SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[AIM_Placement_Update]
(
	@referenceNumber int,
	@newCommissionPercentage float,
      	@newPendingRecallDate   datetime,
      	@newFinalRecallDate   datetime
)
as
begin

	update 
		AIM_accountreference
	set 
		expectedpendingrecalldate = @newPendingRecallDate
		,expectedfinalrecalldate = @newFinalRecallDate
		,currentCommissionPercentage = @newCommissionPercentage
	from
		AIM_accountreference ar
	where
		ar.referenceNumber = @referenceNumber
		

	exec AIM_Account_InsertTransaction @referenceNumber,'Account', null, 14, null, null, 2, @newCommissionPercentage, null,null,'Fee and/or Recall Dates changed'


end

GO

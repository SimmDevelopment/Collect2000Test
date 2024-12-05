SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                  procedure [dbo].[AIM_Account_InsertTransactionFromDebtor]
(
      	@debtor_number   int
     	,@batchFileHistoryId int
	,@transactionTypeId int
	,@transactionContext text
	,@agencyId   int
      	,@logMessageId int
)
as
begin

	declare @referenceNumber int
	select 
		@referenceNumber = number 
	from 
		AIM_debtorview 
	where 
		debtorid = @debtor_number

	declare @accountReferenceId int 
	exec AIM_Account_GetAccountReference @referenceNumber, @accountReferenceId out

	insert into AIM_accounttransaction 
	(
		accountreferenceid
		,batchfilehistoryid
		,transactiontypeid
		,transactioncontext
		,transactionstatustypeid
		,createddatetime
		,completeddatetime
		,agencyid
		,logmessageid
		,tier
		,commissionpercentage
		,balance
		,paymentbatchnumber
		,recallreasoncodeid
	)
	values
	(
		@accountReferenceId
		,@batchFileHistoryId
		,@transactionTypeId
		,@transactionContext
		,3 -- status type completed
		,getdate()
		,getdate()
		,@agencyId
		,@logMessageId
		,null
		,null
		,null
		,null
		,null
	)

end



GO

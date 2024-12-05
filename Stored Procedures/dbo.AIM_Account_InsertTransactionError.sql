SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE                   procedure [dbo].[AIM_Account_InsertTransactionError]
(
     @referenceNumber   int = null
    ,@batchFileHistoryId int
	,@transactionTypeId int
	,@transactionContext text = null
	,@agencyId   int
    ,@logMessageId int
	,@commissionPercentage decimal = null
	,@balance money = null
	,@paymentBatchNumber int = null
	,@comment varchar(100) = null
)
as
begin

	
	insert into AIM_AccountTransactionError 
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
		,comment
	)
	values
	(
		null
		,@batchFileHistoryId
		,@transactionTypeId
		,@transactionContext
		,3-- status type completed
		,getdate()
		,getdate()
		,@agencyId
		,@logMessageId
		,null
		,@commissionPercentage
		,@balance
		,@paymentBatchNumber
		,null
		,@comment
	)



end



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   procedure [dbo].[AIM_Account_InsertTransaction]
(
     @referenceNumber   int
	,@referenceContext varchar(10)
    ,@batchFileHistoryId int
	,@transactionTypeId int
	,@transactionContext text
	,@agencyId   int
    ,@logMessageId int
	,@commissionPercentage decimal = null
	,@paymentBatchNumber int = null
	,@comment varchar(100) = null
)
as
begin

	declare @fileNumber int
	declare @balance money
	if(@referenceContext = 'Account')
	begin
		select @fileNumber = Number,@balance = m.Current0 from dbo.master m WITH (NOLOCK) where m.number = @referenceNumber
	end
	else
	begin
		select @fileNumber = d.Number,@balance = m.Current0 from Debtors d
		WITH (NOLOCK) JOIN dbo.master m WITH (NOLOCK) ON m.number = d.number where d.debtorid = @referenceNumber
	end
		
	declare @accountReferenceId int 
	exec AIM_Account_GetAccountReference @fileNumber, @accountReferenceId out

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
		,comment
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
		,@commissionPercentage
		,@balance
		,@paymentBatchNumber
		,null
		,@comment
	)

end

GO

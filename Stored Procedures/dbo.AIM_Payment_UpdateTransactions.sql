SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[AIM_Payment_UpdateTransactions]
(
      @agencyId   int
	,@batchFileHistoryId int
)
as
begin

	declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	while @@rowcount>0
	begin
		set rowcount @sqlbatchsize
		update 	AIM_accounttransaction  
		set 	batchfilehistoryid = @batchFileHistoryId
			,TransactionStatusTypeId = 3 -- completed
			,completeddatetime = getdate()
			,balance = m.current0
		from	AIM_accounttransaction atr with (nolock)
			join AIM_accountreference ar on ar.accountreferenceid = atr.accountreferenceid
			join master m with (nolock) on m.number = ar.referencenumber
		where	transactionstatustypeid = 4 -- processing
			and TransactionTypeId = 10 --  export payment
			and agencyid = @agencyId
	end
	set rowcount 0
end

GO

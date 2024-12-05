SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[AIM_UpdateTransactions]
(
      @agencyId   int
	,@batchFileHistoryId int
	,@transactionTypeId int
	,@rawFile image = null
	,@dataSet text = null
	,@datasetdatadiff text = null
	,@filename varchar(100)
	,@logmessageid int
	,@numrecords int
	,@numerrors INT
    ,@errorOnOpening VARCHAR(4000) = NULL
)
as
begin
	declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	while @@rowcount>0
	begin
		set rowcount @sqlbatchsize
		update 	 AIM_accounttransaction  with (rowlock) 
		set 	TransactionStatusTypeId = 3 -- completed
			,completeddatetime = getdate()
			,balance = m.current0
		from	AIM_accounttransaction atr
			join AIM_accountreference ar on ar.accountreferenceid = atr.accountreferenceid
			join master m with (nolock) on m.number = ar.referencenumber
		where	atr.transactiontypeid = @transactionTypeId -- 
			and atr.TransactionStatusTypeId = 4 -- processing
			and atr.agencyid = @agencyId
			and batchfilehistoryid = @batchFileHistoryId
	end
	set rowcount 0

	update aim_batchfilehistory
	set	
		filename = @filename
		,logmessageid = @logmessageid
		,numrecords = isnull(numrecords,0)+@numrecords
		,numerrors = isnull(numerrors,0)+@numerrors
		,[ErrorOnOpening] = @errorOnOpening
	where	batchfilehistoryid = @batchfilehistoryid

end


GO

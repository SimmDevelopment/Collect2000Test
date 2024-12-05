SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[AIM_Demographic_UpdateTransactions]
(
      @agencyId   int
	,@batchFileHistoryId int
)
as
begin
	declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	declare @notes table (tid int identity(1,1) primary key,accountreferenceid int)
	insert into @notes (accountreferenceid)
	select	ar.accountreferenceid
	from	AIM_AccountReference ar
		join AIM_AccountTransaction atr on ar.accountreferenceid = atr.accountreferenceid
		join AIM_Agency a on ar.currentlyplacedagencyid = a.agencyid
	where	atr.transactiontypeid = 11 -- being placed
		and atr.TransactionStatusTypeId = 4 -- placement
		and atr.transactiontypeid = 1 -- placement
		and atr.agencyid = @agencyId

	select @maxid= max(tid) from @notes
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

	while @rowcount <= @maxid
	begin

		insert into notes with (rowlock) (number,created,user0,action,result,comment)
		select	ar.referencenumber,ar.lastplacementdate,'AIM','+++++','+++++'
			,'Demographic information has been sent to agency '+a.name+'('+cast(a.agencyId as varchar(8))+').'
		from	@notes n
			join AIM_AccountReference ar on n.accountreferenceid = ar.accountreferenceid
			join AIM_AccountTransaction atr on ar.accountreferenceid = atr.accountreferenceid
			join AIM_Agency a on ar.currentlyplacedagencyid = a.agencyid
		where	atr.transactiontypeid = 11 -- being placed
			and atr.TransactionStatusTypeId = 4 -- placement
			and atr.transactiontypeid = 1 -- placement
			and atr.agencyid = @agencyId
			and n.tid between @currentrow and @rowcount

		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end

	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	while @@rowcount>0
	begin
		set rowcount @sqlbatchsize
		update  AIM_accounttransaction  with (rowlock) 
		set 	TransactionStatusTypeId = 3 -- completed
			,completeddatetime = getdate()
			,balance = m.current0
			,batchfilehistoryid = @batchfilehistoryid
		from	AIM_accounttransaction atr
			join AIM_accountreference ar on ar.accountreferenceid = atr.accountreferenceid
			join master m with (nolock) on m.number = ar.referencenumber
		where	atr.transactiontypeid = 11 -- 
			and atr.TransactionStatusTypeId = 4 -- placement
			and atr.agencyid = @agencyId
	end
	set rowcount 0
end

GO

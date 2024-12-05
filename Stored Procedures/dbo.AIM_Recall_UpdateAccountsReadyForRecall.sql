SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE              procedure [dbo].[AIM_Recall_UpdateAccountsReadyForRecall]

as
begin

/* *************************************************************************
*  This proc goes through the accounts looking for ones
*  that have passed their pending or final recall dates.
*  If found then get the transactions ready.
* 7/15/2009 KMG corrected a typo in the last update statement
***********************************************************************/
	declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	declare @trans table (tid int identity(1,1) primary key,accountreferenceid int)
	
	insert into @trans(accountreferenceid)
	select	ar.accountReferenceId
	from
		AIM_accountreference ar with (nolock) left outer join
		AIM_AccountTransaction atr with (nolock) on ar.accountreferenceid = atr.accountreferenceid and atr.transactiontypeid in (2,3)
			and atr.transactionstatustypeid = 1
	where(
		expectedpendingrecalldate < getdate()
		or 
		expectedfinalrecalldate < getdate())
		and atr.accountreferenceid is null

	declare @trans2 table (tid int identity(1,1) primary key,accounttransactionid int)
	insert into @trans2(accounttransactionid)
	select atr.accounttransactionid
	from aim_accountreference ar with (nolock) join
		 aim_accounttransaction atr with (nolock) on ar.accountreferenceid = atr.accountreferenceid and atr.transactiontypeid = 2
		and atr.transactionstatustypeid =1
	where expectedfinalrecalldate < getdate()

	select @maxid= max(tid) from @trans
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

	while @rowcount <= @maxid
	begin

		insert into AIM_accounttransaction  with (rowlock) 
		(
			accountreferenceid
			,transactiontypeid
			,transactionstatustypeid
			,createddatetime
			,agencyid
			,recallreasoncodeid
			,desk
		)
		select	AR.accountReferenceId
			,case
				when AR.expectedfinalrecalldate < getdate() then 3 -- final recall type
				when AR.expectedpendingrecalldate < getdate() then 2 -- pending recall type
				else 2
			end
			,1 -- open status type
			,getdate()
			,AR.currentlyplacedagencyid
			,0
			,AR.recallDesk
		from
			@trans t 
			join AIM_accountreference AR with (nolock) on t.accountreferenceid = AR.accountreferenceid
		where
			(AR.expectedpendingrecalldate < getdate()
			or 
			AR.expectedfinalrecalldate < getdate())
		and  t.tid between @currentrow and @rowcount

		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end


	select @maxid= max(tid) from @trans2
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

	while @rowcount <= @maxid
	begin
		update aim_accounttransaction
		set transactiontypeid = 3
		from @trans2 t
		join aim_accounttransaction atr with (nolock) on t.accounttransactionid = atr.accounttransactionid
		where t.tid between @currentrow and @rowcount
		
		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end
end



GO

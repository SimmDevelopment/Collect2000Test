SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[AIM_MovePortfolioToSold]
	@portfolioId int
AS
	declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	update aim_portfolio
	set 	portfolioTypeid = 1
	where	portfolioId = @portfolioId

	insert into statushistory(accountid,datechanged,username,oldstatus,newstatus)
	select number,getdate(),'PM',status,'SLD' from master  WITH (NOLOCK) where soldportfolio = @portfolioid

	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	while @@rowcount>0
	begin
		set rowcount @sqlbatchsize
		update 	master with (rowlock) 
		set status = 'SLD'
			,qlevel = '999'
			,restrictedaccess = 1
			,shouldqueue = 0
		where	soldportfolio = @portfolioid
		and status <> 'SLD' 
	end
	set rowcount 0

	declare @portfolioCode varchar(50)
	select	@portfolioCode = code
	from	aim_portfolio
	where	portfolioid = @portfolioid

	declare @notes table (tid int identity(1,1) primary key,number int)
	insert into @notes (number)
	select number
	from master  WITH (NOLOCK) where soldportfolio = @portfolioid

	select @maxid= max(tid) from @notes
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

	while @rowcount <= @maxid
	begin
		insert into dbo.Notes with (rowlock) (number,created,user0,action,result,comment)
		select n.number,getdate(),'PM','+++++','+++++','Sold account to portfolio: '+@portfolioCode
		from @notes n
		join master m WITH (NOLOCK) on n.number = m.number
		where m.soldportfolio = @portfolioid
		and n.tid between @currentrow and @rowcount

		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end


	declare @currentlyplacedagencyid int
	update	aim_accountreference with (rowlock) 
	set	expectedfinalrecalldate = getdate()
	from	master m  WITH(NOLOCK)
		join aim_accountreference ar on ar.referencenumber = m.number
	where	currentlyplacedagencyid > 0
		and soldportfolio = @portfolioid

	exec AIM_ProcessSoldPortfolio @portfolioid

GO

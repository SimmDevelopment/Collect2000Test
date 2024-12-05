SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE             procedure [dbo].[AIM_CallAddToSoldPortfolio] 
(
	@portfolioId int
)

AS

declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

DECLARE @portfolioTypeid INT,@portfolioCode VARCHAR(50),@buyerName VARCHAR(50)
SELECT	@portfolioTypeid = portfoliotypeid,@portfoliocode = code,@buyerName = g.Name
FROM	aim_portfolio p JOIN AIM_Group g ON p.buyergroupid = g.groupid
WHERE	portfolioid = @portfolioId
	

IF(@portfolioTypeId = 1)
BEGIN


	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	while @@rowcount>0
	begin
		set rowcount @sqlbatchsize
		
		-- Added by KAR on 03/10/2011 Add the status history record.
		INSERT INTO StatusHistory(AccountID,DateChanged,USerName,OldStatus,NewStatus)
		select  m.number,getdate(),'AIM',m.status,'SLD'
		FROM AIM_TempSoldAccounts t
		join master m on t.number = m.number
		where SoldPortfolio <> @portfolioId or SoldPortfolio is null
		
		UPDATE Master  with (rowlock) 
		SET SoldPortfolio = @portfolioId,status = 'SLD',qlevel = '999' 
		FROM AIM_TempSoldAccounts t
		join master m on t.number = m.number
		where SoldPortfolio <> @portfolioId or SoldPortfolio is null
	end
	set rowcount 0

	declare @notes table (tid int identity(1,1) primary key,number int)
	insert into @notes(number) select number from AIM_TempSoldAccounts

	select @maxid= max(tid) from @notes
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

	while @rowcount <= @maxid
	begin
		INSERT INTO NOTES  with (rowlock) ( Number,Created,User0,Action,Result,Comment )
		select n.Number,GETDATE(),'AIM','+++++','+++++',dbo.AIM_GetLogMessage(1012,@portfolioCode,@buyerName,'','','','')
		from @notes n
		where n.tid between @currentrow and @rowcount

		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end	

	select @maxid= max(tid) from @notes
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

	while @rowcount <= @maxid
	begin

		INSERT INTO AIM_AccountTransaction  with (rowlock) (AccountReferenceID,TransactionTypeID,TransactionStatusTypeID,CreatedDateTime,AgencyID,RecallReasonCodeID)
		SELECT AR.AccountReferenceID,3,1,GETDATE(),AR.CurrentlyPlacedAgencyID,2 
		FROM @notes n
		join AIM_AccountREference AR WITH (NOLOCK) on n.number = AR.ReferenceNumber
		WHERE AR.CurrentlyPlacedAgencyID IS NOT NULL 
		and n.tid between @currentrow and @rowcount

		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end

END

	
--		update 	master
--		set 	status = 'SLD',qlevel = '999',restrictedaccess = 1,shouldqueue = 0
--		where	soldportfolio = @portfolioId

--		insert into dbo.Notes(number,created,user0,action,result,comment)
--		select number,getdate(),'AIM','+++++','+++++',dbo.AIM_GetLogMessage(1012, @portfolioCode,g.[name] , '', '', '', '') 
--		from 	master m with (nolock) 
--		join aim_portfolio p with (nolock) on p.portfolioid = m.soldportfolio
--		join aim_group g with (nolock) on g.groupid = p.buyergroupid
--		where m.soldportfolio = @portfolioId

--		insert into AIM_accounttransaction(accountreferenceid,transactiontypeid,
--			transactionstatustypeid,createddatetime,agencyid,recallreasoncodeid)
--		select	ar.accountReferenceId,3,1,getdate(),currentlyplacedagencyid,2
--		from	master m with (nolock) 
--			join aim_accountreference ar with (nolock) on ar.referencenumber = m.number
--		where	currentlyplacedagencyid is not null
--			and soldportfolio = @portfolioid
--	end

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[AIM_Recall_SelectTransactionsReadyForFile]
		@agencyId int,
		@transactionTypeID int
as
begin

/* *************************************************************************
*  This proc gets all accounts to be recalled 
*  Then marks the transaction table as being processed.
*
****************************************************************************/

	declare @sqlbatchsize int
	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'
	create table #recallaccounts (referenceNumber int primary key, accountreferenceid int)
	declare @executeSQL varchar(8000)
	set @executeSQL =
	'insert into #recallaccounts
	select	top ' + cast(@sqlbatchsize as VARCHAR(16)) + ' referenceNumber
		,max(ar.accountreferenceid)
	from	AIM_accountreference ar with (nolock)
		join AIM_accounttransaction atr with (nolock) on atr.accountreferenceid = ar.accountreferenceid
	where	atr.agencyid = ' + CAST(@agencyId as VARCHAR(8)) + ' 
		and transactiontypeid in (2,3) 
		and transactionstatustypeid = 1
	group by referencenumber'
	
	exec(@executeSQL)
	-- any transaction records are final recalls
	select	
		case when atr.transactiontypeid = 3 then 'CFIN' 
			 when atr.transactiontypeid = 2 then 'CPEN' end as record_type
		,number as file_number
		,account as account
		,rec.code as recall_reason
		--,objection_date = 
		--	case 
		--		when atr.transactiontypeid = 3 then '19000101' --null
		--		when atr.transactiontypeid = 2 then dbo.AIM_FormatDateYYYYMMDD(ar.expectedfinalrecalldate)
		--		else '19000101'
		--	end
		,objection_date = 
			case 
				when atr.transactiontypeid = 3 then NULL
				when atr.transactiontypeid = 2 then ar.expectedfinalrecalldate
				else NULL
			end
		,is_pending_recall = 
			case 
				when atr.transactiontypeid = 3 then 'N'
				when atr.transactiontypeid = 2 then 'Y'
				when ar.expectedfinalrecalldate < getdate() then 'N'
				else 'N'
			end
		,'' as Filler

	from 
		#recallaccounts ra
		join master av with (nolock) on ra.referencenumber = av.number
		join AIM_accountreference ar with (nolock) on ar.referencenumber = av.number
		join AIM_accounttransaction atr with (nolock) on atr.accountreferenceid = ar.accountreferenceid
		left outer join AIM_recallreasoncode  rec with (nolock) on rec.recallreasoncodeid = atr.recallreasoncodeid
	where
		transactiontypeid in (2,3) -- recall
		and transactionstatustypeid = 1 -- open
		and ar.currentlyplacedagencyid = @agencyId

	-- now mark as being processed

		update  AIM_accounttransaction with (rowlock) 
			set transactionstatustypeid = 4 -- being recalled
		from #recallaccounts ra
		join aim_accounttransaction atr on ra.accountreferenceid = atr.accountreferenceid
		where
			transactiontypeid in (2,3) -- recall
			and transactionstatustypeid = 1 -- open
			and agencyid = @agencyid
	
		drop table #recallaccounts
end

GO

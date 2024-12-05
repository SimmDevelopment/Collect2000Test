SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[AIM_Batch_UpdateBatchCompleted]
(
	@batchId int,
	@usingExistingBatchId bit  = 0
)
as

IF(@usingExistingBatchId = 0)
BEGIN
	update AIM_batch
		set completeddatetime = getdate(),systemmonth = currentmonth,systemyear = currentyear
	from controlfile
	where
		batchid = @batchId
END
	-- setup stair step report

	declare @batchFiles table(batchfilehistoryid int, agencyid int, totalnumberplaced int, totaldollarsplaced money)
	insert into 
		@batchFiles
	select
		b.batchfilehistoryid
		,b.agencyid
		,count(*) as totalnumberplaced
		,sum(isnull(balance,0)) as totaldollarsplaced
	from
		aim_batchfilehistory b with (nolock)
		join aim_accounttransaction atr with (nolock) on atr.batchfilehistoryid = b.batchfilehistoryid
	where
		batchid = @batchid
		and batchfiletypeid = 1
	group by
		b.batchfilehistoryid
		,b.agencyid


	insert into
		aim_stairstep
		(
			batchfilehistoryid
			,agencyid
			,totalnumberplaced
			,totaldollarsplaced
			,adjustments
			,totalfees
			,dateplaced
			,placementsysmonth
			,placementsysyear
			,totalcollected
		)
			select
				batchfilehistoryid
				,agencyid
				,totalnumberplaced
				,totaldollarsplaced
				,0
				,0
				,getdate()
				,month(getdate())
				,year(getdate())
				,0
			from
				@batchfiles

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE      procedure [dbo].[Custom_SelectBatchHistory]
	@customerreferenceid int
	,@startDate datetime
	,@enddate datetime
as
begin

	select 
		batchhistoryid as [Batch History Id]
		,endeddatetime as [Completed Datetime]
		,bt.name as [File Type]
		,rawsourcefilename as [Raw File]
	from
		custom_batchhistory bh
		join custom_batchtype bt on bt.batchtypeid = bh.batchtypeid
	where
		customerreferenceid = @customerreferenceid
		and endeddatetime between @startdate and @enddate + 1
	order by endeddatetime desc
end





GO

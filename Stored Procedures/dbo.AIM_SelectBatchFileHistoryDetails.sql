SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  procedure [dbo].[AIM_SelectBatchFileHistoryDetails]
(@batchFileHistoryId int)
AS

select 	f.batchfilehistoryid
	,CompletedDatetime as Date
	,l.logmessage as Status
	,ft.name as [File Type]
	,f.Filename	
	,f.rawfile
	,f.dataset
	,f.datasetdatadiff
from	aim_batchfilehistory f with (nolock)
	join aim_batch b on b.batchid = f.batchid
	join aim_batchfiletype ft on ft.batchfiletypeid = f.batchfiletypeid
	join aim_logmessage l on l.logmessageid = f.logmessageid
where	f.batchfilehistoryid = @batchfilehistoryid

GO

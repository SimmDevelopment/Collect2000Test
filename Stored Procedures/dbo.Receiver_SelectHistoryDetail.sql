SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  procedure [dbo].[Receiver_SelectHistoryDetail]
(@HistoryId int)
AS


select
	h.historyid,
	h.TransactionDate as Date,
	r.Description as Status,
	f.Name as [File Type],
	h.fileName,
	null as rawfile,
	null as dataset,
	null as datasetdatadiff
from
	Receiver_History h with(nolock)
	join receiver_result r with(nolock) on r.ResultId = h.ResultId
	join receiver_filetype f with(nolock) on f.FileTypeId = h.FileTypeId
where
	h.historyid = @HistoryId

GO

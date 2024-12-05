SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE      procedure [dbo].[Receiver_SelectHistory]
@clientId int,
@startdate datetime,
@enddate datetime
AS

select
	h.historyid,
	h.TransactionDate as Date,
	r.Description as Status,
	f.Name as [File Type],
	h.NumRecords,
	h.NumErrors,
	h.FileName	
from
	Receiver_History h with(nolock)
	join receiver_result r with(nolock) on r.ResultId = h.ResultId
	join receiver_filetype f with(nolock) on f.FileTypeId = h.FileTypeId
where
	h.clientid = @clientId
	and h.TransactionDate between @startdate and @enddate
order by h.historyid desc

GO

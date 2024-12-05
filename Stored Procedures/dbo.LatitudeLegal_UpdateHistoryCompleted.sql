SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE     procedure [dbo].[LatitudeLegal_UpdateHistoryCompleted]
(
	@llhistoryid int
	,@endeddatetime datetime
)
as
begin

	UPDATE LatitudeLegal_History
	SET endeddatetime = @endeddatetime
	WHERE LLHistoryID = @llhistoryid
	

end



GO

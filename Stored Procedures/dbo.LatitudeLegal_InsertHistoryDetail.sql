SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     procedure [dbo].[LatitudeLegal_InsertHistoryDetail]
(
	@llhistoryid int
	,@filename varchar(100)
	,@rawsource image
	,@attorneyid int
)
as
begin

	INSERT INTO LatitudeLegal_HistoryDetail
	(LLHistoryID,FileName,RawSource,AttorneyID)
	VALUES
	(@llhistoryid,@filename,@rawsource,@attorneyid)

	SELECT @@IDENTITY FROM LatitudeLegal_HistoryDetail

end


GO

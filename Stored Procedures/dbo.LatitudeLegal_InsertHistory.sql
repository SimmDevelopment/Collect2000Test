SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     procedure [dbo].[LatitudeLegal_InsertHistory]
(
	@username varchar(50)
	,@starteddatetime datetime
	,@sentrecon bit
	,@test bit
	,@type varchar(15)
)
as
begin

	INSERT INTO LatitudeLegal_History
	(LatitudeUserName,StartedDateTime,SentReconciliation,Test,Type)
	VALUES
	(@username,@starteddatetime,@sentrecon,@test,@type)

	SELECT @@IDENTITY FROM LatitudeLegal_History

end


GO

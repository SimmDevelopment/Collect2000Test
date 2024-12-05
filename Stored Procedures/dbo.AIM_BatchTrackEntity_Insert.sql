SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_BatchTrackEntity_Insert]
	@batchTrackId INT,
	@entityId VARCHAR(10),
	@type TINYINT
AS
BEGIN
	
	INSERT INTO [AIM_BatchTrackEntity]
		([BatchTrackId]
		,[EntityId]
		,[Type])
	VALUES
		(@batchTrackId
		,@entityId
		,@type)

END

GO

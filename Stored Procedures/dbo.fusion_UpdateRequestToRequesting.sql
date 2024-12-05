SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[fusion_UpdateRequestToRequesting]
	@RequestID int ,  @ServiceID int, @BatchID uniqueidentifier, 
	@ProfileID uniqueidentifier, @PackageID int
AS
-- Name:			[fusion_UpdateRequestToRequesting]
-- Function:		This procedure will update servicehistory record for outside service
--					as fusion begins processing the request
-- Creation:		9/28/2007 kmg
--			Used by Latitude Fusion.

	DECLARE @SystemMonth int, @SystemYear int, @Number int

	SELECT @SystemMonth = [ControlFile].[CurrentMonth], @SystemYear = [ControlFile].[CurrentYear] 
	FROM [dbo].[ControlFile] AS [ControlFile] WITH(NOLOCK)

	UPDATE ServiceHistory
	SET	RequestingDate = getdate(),
		ServiceId = @ServiceID,
		SystemYear = @SystemYear,
		SystemMonth = @SystemMonth,
		Processed = 1,
		BatchID = @BatchID,
		ProfileID = @ProfileID
	WHERE RequestID = @RequestID

GO

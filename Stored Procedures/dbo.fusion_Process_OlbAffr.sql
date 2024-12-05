SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Name:		fusion_Process_OlbAffr
-- Function:		This procedure will process returned OlbAffr info
-- Creation:		Jeff Mixon		11/15/06
-- Change History:	

CREATE procedure [dbo].[fusion_Process_OlbAffr]
	@RequestID int
AS
	UPDATE [ServiceHistory]
	SET [ServiceHistory].[Processed] = 0 --0 processed, 1 requested, 2 sent
	FROM [dbo].[ServiceHistory] AS [ServiceHistory]
	WHERE [ServiceHistory].[RequestId] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler
	
----
cuExit:
	IF (@@ERROR != 0) GOTO ErrHandler
	RETURN
ErrHandler:
	RAISERROR('Error encountered in fusion_Process_ExperianCollectionAdvantage for request %d.  fusion_Process_OlbAffr failed.', 11, 1, @RequestID)
	RETURN
GO

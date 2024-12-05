SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Process_PropertyInfo]
@requestId int
AS
BEGIN
SET NOCOUNT ON;

UPDATE [ServiceHistory] SET [ServiceHistory].[Processed] = 0
FROM [dbo].[ServiceHistory] AS [ServiceHistory]
WHERE [ServiceHistory].[RequestId] = @RequestID
IF (@@ERROR != 0) GOTO ErrHandler
	
	----
	cuExit:
		IF (@@ERROR != 0) GOTO ErrHandler
		RETURN
	ErrHandler:
		RAISERROR('Error encountered in fusion_Process_PropertyInfo for request %d.  fusion_Process_PropertyInfo failed.', 11, 1, @RequestID)
		RETURN

END
GO

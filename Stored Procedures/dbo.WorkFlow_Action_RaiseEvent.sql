SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_RaiseEvent] @EventID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM [dbo].[WorkFlow_Events] WHERE [ID] = @EventID) BEGIN
	INSERT INTO [dbo].[WorkFlow_EventQueue] ([EventID], [AccountID], [Occurred])
	SELECT @EventID, [WorkFlowExec].[AccountID], GETDATE()
	FROM #WorkFlowExec AS [WorkFlowExec];
END;

RETURN 0;
GO

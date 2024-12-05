SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_ResumeAccountWorkFlow] @ExecID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

UPDATE [dbo].[WorkFlow_Execution]
SET [PauseCount] = 0
WHERE [ID] = @ExecID;

RETURN 0;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[WorkFlow_StartAccountWorkFlow] @AccountID INTEGER, @WorkFlowID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

DECLARE @ActivityID UNIQUEIDENTIFIER;

SELECT @ActivityID = [StartingActivity]
FROM [dbo].[WorkFlows]
WHERE [ID] = @WorkFlowID;

IF @@ROWCOUNT = 0 BEGIN
	RAISERROR('WorkFlow not found.', 16, 1);
	RETURN 1;
END;
IF @ActivityID IS NULL BEGIN
	RETURN 1;
END;

DECLARE @Now DATETIME;
DECLARE @ExecID UNIQUEIDENTIFIER;
declare @prioritydate datetime
SET @Now = GETDATE();
SET @ExecID = NEWID();
select @prioritydate = (Select * FROM [dbo].[WorkFlow_GetPriorityDate](@Now, 100))

INSERT INTO [dbo].[WorkFlow_Execution] ([AccountID], [ActivityID], [EnteredDate], [NextEvaluateDate], [LastEvaluated], [Priority], [LastEvaluatedWithPriority], [PauseCount])
VALUES (@AccountID, @ActivityID, GETDATE(), GETDATE(), GETDATE(), 100, @prioritydate, 0)

RETURN 0;

GO

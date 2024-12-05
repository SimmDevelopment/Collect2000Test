SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[WorkFlow_QueryAction_StartWorkFlow] @WorkFlowID UNIQUEIDENTIFIER, @Accounts IMAGE
AS
SET NOCOUNT ON;

DECLARE @ActivityID UNIQUEIDENTIFIER;
DECLARE @Now DATETIME;

SET @Now = GETDATE();

SELECT @ActivityID = [WorkFlows].[StartingActivity]
FROM [dbo].[WorkFlows]
WHERE [WorkFlows].[ID] = @WorkFlowID;

IF @ActivityID IS NULL BEGIN
	RETURN 0;
END;

INSERT INTO [dbo].[WorkFlow_Execution] ([AccountID], [ActivityID], [EnteredDate], [NextEvaluateDate], [LastEvaluated], [Priority], [LastEvaluatedWithPriority], [PauseCount], [ChildExecID])
SELECT [accts].[Value], @ActivityID, @Now, @Now, @Now, 100, p.PriorityDate, 0, NULL
FROM [dbo].[fnExtractIDs](@Accounts, 1) AS [accts]
CROSS APPLY ( Select * FROM [dbo].[WorkFlow_GetPriorityDate](@Now, 100)) p;

RETURN 0;

GO

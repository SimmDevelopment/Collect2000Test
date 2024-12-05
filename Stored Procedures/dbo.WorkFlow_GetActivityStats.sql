SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_GetActivityStats] @ActivityID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

SELECT CAST(COUNT(*) AS INTEGER) AS [Accounts],
	MIN([WorkFlow_Execution].[EnteredDate]) AS [MinimumEnteredDate],
	GETDATE() AS [CurrentDate]
FROM [dbo].[WorkFlow_Execution]
WHERE [ActivityID] = @ActivityID
AND [WorkFlow_Execution].[PauseCount] <= 0
AND [WorkFlow_Execution].[ChildExecID] IS NULL
AND [WorkFlow_Execution].[NextEvaluateDate] <= GETDATE();

RETURN 0;
GO

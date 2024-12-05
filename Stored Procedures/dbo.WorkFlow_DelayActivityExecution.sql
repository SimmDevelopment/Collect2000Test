SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[WorkFlow_DelayActivityExecution] @ActivityID UNIQUEIDENTIFIER, @Delay BIGINT
AS
SET NOCOUNT ON;

DECLARE @CurrentDate DATETIME;
SET @CurrentDate = GETDATE();

UPDATE [dbo].[WorkFlow_Activities]
SET [NextEvaluateDate] = DATEADD(MINUTE, @Delay, @CurrentDate)
WHERE [ID] = @ActivityID;

UPDATE [dbo].[WorkFlow_Execution]
SET [LastEvaluated] = @CurrentDate,
	[LastEvaluatedWithPriority] = p.PriorityDate
FROM [WorkFlow_Execution]
CROSS APPLY ( Select * FROM [dbo].[WorkFlow_GetPriorityDate](@CurrentDate, [WorkFlow_Execution].[Priority])) p
WHERE [ActivityID] = @ActivityID;

RETURN 0;

GO

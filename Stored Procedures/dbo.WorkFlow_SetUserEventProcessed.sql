SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_SetUserEventProcessed] @EventID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

DECLARE @Now DATETIME;
SET @Now = GETDATE();

UPDATE [dbo].[WorkFlow_Events]
SET [LastEvaluated] = @Now,
	[NextEvaluateDate] = n.NextEvaluateDate 
FROM [dbo].[WorkFlow_Events]
CROSS APPLY (SELECT * FROM  [dbo].[WorkFlow_GetNextEvaluateDate](COALESCE([NextEvaluateDate], @Now), @Now, [NextEvaluateDelay])) n
WHERE [ID] = @EventID;

RETURN 0;

GO

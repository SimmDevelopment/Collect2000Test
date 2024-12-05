SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_QueueAccount] @QueueLevel VARCHAR(3), @QueueDays SMALLINT, @QueueTime VARCHAR(4), @ShouldQueue BIT
AS
SET NOCOUNT ON;

DECLARE @QueueDate DATETIME;

SELECT @ShouldQueue = COALESCE(@ShouldQueue, [ShouldQueue])
FROM [dbo].[QLevel]
WHERE [code] = @QueueLevel;

IF @@ROWCOUNT = 0 BEGIN
	RAISERROR('Queue level "%s" does not exist.', 16, 1, @QueueLevel);
	RETURN 1;
END;

SET @QueueDate = DATEADD(DAY, @QueueDays, { fn CURDATE() });

BEGIN TRANSACTION;

UPDATE [WorkFlowAcct]
SET [Comment] = CASE
		WHEN [master].[qlevel] IN ('998', '999')
		THEN 'Cannot change queue level of closed account.'
		ELSE 'Queue level changed from "' + COALESCE([master].[qlevel], '') + '" to "' + @QueueLevel + '" for queue date "' + CONVERT(VARCHAR(50), @QueueDate, 101) + '".'
	END
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master] WITH (ROWLOCK, UPDLOCK)
ON [WorkFlowAcct].[AccountID] = [master].[number];

UPDATE [dbo].[master]
SET [qlevel] = @QueueLevel,
	[qdate] = CONVERT(CHAR(8), @QueueDate, 112),
	[qtime] = @QueueTime
FROM [dbo].[master] WITH (ROWLOCK)
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [master].[number] = [WorkFlowAcct].[AccountID]
WHERE [master].[qlevel] NOT IN ('998', '999');

COMMIT TRANSACTION;

RETURN 0;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[PoolQueue_RecordWorked] @UID UNIQUEIDENTIFIER, @AccountID INTEGER
AS
SET NOCOUNT ON;

DECLARE @AccountWorkedUID UNIQUEIDENTIFIER;
DECLARE @Worked BIT;
DECLARE @Contacted BIT;

SELECT @Worked = CASE
		WHEN [worked] IS NULL THEN 0
		WHEN [worked] >= { fn CURDATE() } THEN 1
		ELSE 0
	END,
	@Contacted = CASE
		WHEN [contacted] IS NULL THEN 0
		WHEN [contacted] >= { fn CURDATE() } THEN 1
		ELSE 0
	END
FROM [dbo].[master]
WHERE [number] = @AccountID;

SELECT TOP 1 @AccountWorkedUID = [UID]
FROM [dbo].[PoolQueueAssignments_WorkHistoryAccounts]
WHERE [HistoryID] = @UID
AND [AccountID] = @AccountID
AND [EndDate] IS NULL
ORDER BY [StartDate] DESC;

BEGIN TRANSACTION;

UPDATE [dbo].[PoolQueueAssignments_WorkHistory]
SET [EndDate] = GETDATE(),
	[Worked] = CASE @Worked
		WHEN 1 THEN [Worked] + 1
		ELSE [Worked]
	END,
	[Contacted] = CASE @Contacted
		WHEN 1 THEN [Contacted] + 1
		ELSE [Contacted]
	END
WHERE [UID] = @UID;

IF @AccountWorkedUID IS NOT NULL
	UPDATE [dbo].[PoolQueueAssignments_WorkHistoryAccounts]
	SET [EndDate] = GETDATE(),
		[Worked] = @Worked,
		[Contacted] = @Contacted
	WHERE [UID] = @AccountWorkedUID;

COMMIT TRANSACTION;

RETURN 0;



GO

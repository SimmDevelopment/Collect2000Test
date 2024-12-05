SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[QueueEngine_SupportQueue_MoveNext] @Queue VARCHAR(3), @Remaining INTEGER OUTPUT
AS
SET NOCOUNT ON;

DECLARE @ReturnValue INTEGER;

EXEC @ReturnValue = [dbo].[SupportQueueItem_Get] @QueueCode = @Queue;

SELECT @Remaining = COUNT(*)
FROM [dbo].[SupportQueueItems]
WHERE [QueueCode] = @Queue;

RETURN @ReturnValue;

GO

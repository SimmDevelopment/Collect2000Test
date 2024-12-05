SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[QueueEngine_SupportQueue_GetQueues] @QueueType TINYINT
AS
SET NOCOUNT ON;

DECLARE @LowCode VARCHAR(3);
DECLARE @HighCode VARCHAR(3);

IF @QueueType = 6 BEGIN
	SET @LowCode = '600';
	SET @HighCode = '699';
END;
ELSE BEGIN
	SET @LowCode = '700';
	SET @HighCode = '799';
END;

SELECT [QLevel].[code] AS [QueueLevel], [QLevel].[QName] AS [Description], COUNT(*) AS [Total]
FROM [dbo].[QLevel]
INNER JOIN [dbo].[SupportQueueItems]
ON [QLevel].[code] = [SupportQueueItems].[QueueCode]
WHERE [QLevel].[code] BETWEEN @LowCode AND @HighCode
GROUP BY [QLevel].[code], [QLevel].[QName]
ORDER BY [QueueLevel];

RETURN 0;

GO

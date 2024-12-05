SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_LetterRequest_GetTopPendingByLetter]
	@LetterID INTEGER,
	@ThroughDate DATETIME
WITH RECOMPILE
AS

DECLARE @DocSize INTEGER;
DECLARE @BatchSize INTEGER;

SELECT @DocSize = DATALENGTH([DocData])
FROM [dbo].[letter]
WHERE [letter].[LetterID] = @LetterID;

IF @DocSize > 0 BEGIN
	SET @BatchSize = 10485760 / @DocSize;
	IF @BatchSize < 10 BEGIN
		SET @BatchSize = 10;
	END;
	ELSE IF @BatchSize > 100 BEGIN
		SET @BatchSize = 100;
	END;
END;
ELSE BEGIN
	SET @BatchSize = 100;
END;

SET ROWCOUNT @BatchSize;

SELECT [LR].*, [L].[Description]
FROM [dbo].[LetterRequest] AS [LR]
INNER JOIN [dbo].[letter] AS [L]
ON [LR].[LetterID] = [L].[LetterID]
WHERE [LR].[DateRequested] <= @ThroughDate
AND [L].[LetterID] = @LetterID
AND ([DateProcessed] IS NULL
	OR [DateProcessed] = '1753-01-01 12:00:00')
AND [LR].[Deleted] = 0
AND [LR].[AddEditMode] = 0
AND [LR].[Suspend] = 0
AND [LR].[Edited] = 0
ORDER BY [LR].[AccountID];

SET ROWCOUNT 0;
RETURN 0;


GO

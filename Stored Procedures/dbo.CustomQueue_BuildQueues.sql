SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[CustomQueue_BuildQueues]
AS
SET NOCOUNT ON;


DECLARE @QueueName VARCHAR(20), @TheSql NVARCHAR(MAX), @PromptForFU CHAR(1)

DECLARE SqlCursor CURSOR FAST_FORWARD FOR
  SELECT [QueueName], [TheSql], CAST(COALESCE([PromptForFU], 0) AS CHAR(1)) AS [PromptForFU]
FROM [dbo].[CustomQueue]
WHERE [Schedule] LIKE '%' + CAST(DATEPART(WEEKDAY, GETDATE()) AS CHAR(1)) + '%';

OPEN SqlCursor
FETCH NEXT FROM SqlCursor INTO @QueueName, @TheSql, @PromptForFU

WHILE @@FETCH_STATUS = 0 BEGIN
  DECLARE @TableName NVARCHAR(128);
DECLARE @QueueID INTEGER;
DECLARE @SQL NVARCHAR(MAX);

EXEC [dbo].[CustomQueue_CreateQueue]
	@QueueName = @QueueName,
	@Overwrite = 1,
	@ObjectName = @TableName OUTPUT,
	@QueueID = @QueueID OUTPUT;


IF OBJECT_ID('tempdb..#TEMP_7263543') IS NOT NULL DROP TABLE #TEMP_7263543;

SET @SQL = STUFF(@TheSQL, CHARINDEX('FROM', @TheSQL), LEN('FROM'), 'INTO #TEMP_7263543 FROM')+';'+
' INSERT INTO ' + @TableName + ' ([Number], [Done], [ZipCode], [SetFollowup]) SELECT [number], ''N'', LEFT([ZipCode], 5), ' + COALESCE(@PromptForFU, 'NULL') + ' FROM (SELECT * FROM #TEMP_7263543) AS [x]'+
'; DROP TABLE #TEMP_7263543;'

EXEC [sp_executesql] @stmt = @SQL;
  
  FETCH NEXT FROM SqlCursor INTO @QueueName, @TheSql, @PromptForFU
END

CLOSE SqlCursor
DEALLOCATE SqlCursor 

RETURN 0;
GO

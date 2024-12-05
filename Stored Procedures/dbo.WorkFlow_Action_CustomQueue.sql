SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_CustomQueue] @QueueName VARCHAR(200), @SetFollowup BIT
AS
SET NOCOUNT ON;

DECLARE @TableName SYSNAME;
DECLARE @QueueID INTEGER;
DECLARE @IndexName SYSNAME;
DECLARE @SQL NVARCHAR(4000);

EXEC [dbo].[CustomQueue_CreateQueue] @QueueName = @QueueName, @Overwrite = 0, @ObjectName = @TableName OUTPUT, @QueueID = @QueueID OUTPUT;

SET @SQL = 'INSERT INTO ' + @TableName + ' ([Number], [ZipCode], [SetFollowup]) SELECT DISTINCT [WorkFlowAcct].[AccountID], LEFT([master].[zipcode], 5), @SetFollowup FROM #WorkFlowAcct AS [WorkFlowAcct] INNER JOIN [dbo].[master] WITH (NOLOCK) ON [WorkFlowAcct].[AccountID] = [master].[number];';

UPDATE #WorkFlowAcct
SET [Comment] = 'Account queued into custom queue "' + @QueueName + '"';

EXEC sp_executesql @SQL, N'@SetFollowup BIT', @SetFollowup = @SetFollowup;

RETURN 0;
GO

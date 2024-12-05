SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*SupportQueueItem_Get*/
CREATE  PROCEDURE [dbo].[SupportQueueItem_Get]
	@QueueCode varchar (5)
AS

 /*
**Name		:SupportQueueItem_Get
**Function	:Gets a single record from the SupportQueueItems table and updates that records LastAccessed column
**		:so that same record will not be selected by another user working that queue.  If left in the queue, 
**		:it will not be retrieved again until all other records have been accessed.
**Creation	:7/12/2004 mr
**Used by 	:Latitude.exe SupportQueue class
**Change History:
*/
set nocount on

DECLARE @RecID INTEGER;

BEGIN TRANSACTION;

SELECT TOP 1 @RecID = [ID]
FROM [dbo].[SupportQueueItems] WITH (ROWLOCK, UPDLOCK)
WHERE [QueueCode] = @QueueCode
ORDER BY [LastAccessed];

IF @RecID IS NOT NULL
	UPDATE [dbo].[SupportQueueItems]
	SET [LastAccessed] = GETDATE()
	WHERE [ID] = @RecID;

COMMIT TRANSACTION;

SELECT *
FROM [dbo].[SupportQueueItems]
WHERE [ID] = @RecID;

/*

Create Table #TempTable (RecID int Not NULL)

INSERT INTO #TempTable(RecID) SELECT TOP 1 ID FROM SupportQueueItems where QueueCode = @QueueCode
ORDER BY LastAccessed

SELECT @RecID = RecID from #TempTable

DROP TABLE #TempTable

UPDATE SupportQueueItems SET LastAccessed = GetDate() WHERE ID = @RecID

SELECT * FROM SupportQueueItems WHERE ID = @RecID

SELECT * FROM SupportQueueItems

*/


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*CustomQueueItem_Get */
CREATE PROCEDURE [dbo].[CustomQueueItem_Get]
	@QueueName varchar (50)

AS

Declare @AccountID int
Declare @SQL varchar (1000)

 /*
**Name		:CustomQueueItem_Get
**Function	:Gets a single record from a CustomQueue table and updates that records LastAccessed column
**		:so that same record will not be selected by another user working that queue.  If left in the queue, 
**		:it will not be retrieved again until all other records have been accessed.
**Creation	:7/12/2004 mr
**Used by 	:Latitude.exe QueueItems class
**Change History:
*/

set nocount on

BEGIN TRAN

Create Table #TempTable (AccountID int Not NULL, ZipCode varchar(10)Null, LastAccessed datetime Null, SetFollowup bit Null)

IF @@Error <> 0 GOTO eh

SET @SQL = 'INSERT INTO #TempTable(AccountID, ZipCode, LastAccessed, SetFollowup) SELECT TOP 1 Number, Zipcode, LastAccessed, SetFollowup FROM tmp' + @QueueName + ' ORDER BY LastAccessed'
EXEC(@SQL)

IF @@Error <> 0 GOTO eh

Select @AccountID = AccountID from #TempTable

SET @SQL = 'UPDATE tmp' + @QueueName + ' SET LastAccessed = GetDate() WHERE Number = ' + convert(varchar, @AccountID)
EXEC(@SQL)

If @@Error <> 0 GOTO eh

SELECT * FROM #TempTable

COMMIT TRAN

Return 0
eh:
	ROLLBACK TRAN
	Return @@Error
GO

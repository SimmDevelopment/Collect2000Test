SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*SupportQueueItem_Insert*/
CREATE  PROCEDURE [dbo].[SupportQueueItem_Insert]
	@AccountID int,
	@QueueCode varchar (5),
	@QueueType tinyint,
	@DateDue datetime,
	@ShouldQueue bit, 
	@UserName varchar(10),
	@Comment varchar(4000),
	@ReturnID int Output

AS

 /*
**Name		:SupportQueueItem_Insert
**Function	:Inserts a single record from a CustomQueue table and optionally sets the Master.ShouldQueue column
**Creation	:7/12/2004 mr
**Used by 	:Latitude.exe SupportQueueItem class
**Change History:
*/

SELECT ID FROM SupportQueueItems WHERE AccountID = @AccountID and QueueCode = @QueueCode

IF @@RowCount > 0 Return -1  -- One entry allowed per Account/SupportCode combination


BEGIN TRAN

INSERT INTO SupportQueueItems(QueueCode, QueueType, AccountID, DateAdded, DateDue, LastAccessed, ShouldQueue, UserName, Comment)
VALUES(@QueueCode, @QueueType, @AccountID, GetDate(), @DateDue, GetDate(), @ShouldQueue, @UserName, @Comment)

IF @@Error <> 0 GOTO eh

UPDATE Master SET ShouldQueue = @ShouldQueue WHERE number = @AccountID

IF @@Error <> 0 GOTO eh

COMMIT TRAN

SELECT @ReturnID = SCOPE_IDENTITY()
Return 0
eh:
	ROLLBACK TRAN
	Return @@Error


GO

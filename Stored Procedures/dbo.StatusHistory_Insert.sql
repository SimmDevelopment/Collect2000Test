SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/*StatusHistory_Insert  */
CREATE PROCEDURE [dbo].[StatusHistory_Insert]
	@AccountID int,
	@UserName varchar(50),
	@OldStatus varchar(5),
	@NewStatus varchar(5)
AS

 /*
**Name		:StatusHistory_Insert		
**Function	:Inserts a record in the StatusHistory table when a status is changed
**Creation	:10/14/2003 mr
**Used by 	:Latitude.Account class		
**Change History:	
*/
	INSERT INTO StatusHistory
	(AccountID, DateChanged, UserName, OldStatus, NewStatus)
	VALUES
	(@AccountID, GetDate(), @UserName, @OldStatus, @NewStatus)

	Return @@Error
GO

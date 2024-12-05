SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*EmailHistory_Insert*/
CREATE PROCEDURE [dbo].[EmailHistory_Insert]
	@AccountID int,
	@DebtorID int,
	@UserChanged varchar(50),
	@OldEmail varchar(50),
	@NewEmail varchar(50)

AS
 /*
**Name		:	EmailHistory_Insert	
**Function	:	Inserts a record in the EmailHistory Table to track Email Changes
**Creation	:	8/18/2004
**Used by 	:	Called from spDebtor_Update
**Change History:	
*/

	INSERT INTO EmailHistory
	(AccountID, DebtorID, DateChanged, UserChanged, OldEmail, NewEmail)
	VALUES
	(@AccountID, @DebtorID, GetDate(), @UserChanged, @OldEmail, @NewEmail)

	Return @@Error
GO

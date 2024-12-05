SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*PhoneHistory_Insert    Script Date: 10/14/2003 1:27:56 PM ******/
CREATE PROCEDURE [dbo].[PhoneHistory_Insert]
	@AccountID int,
	@DebtorID int,
	@UserChanged varchar(50),
	@PhoneType tinyint,
	@OldNumber varchar(50),
	@NewNumber varchar(50)

AS
 /*
**Name		:	PhoneHistory_Insert	
**Function	:	Inserts a record in the PhoneHistory Table to track Phone Number Changes
**Creation	:	10/14/2003
**Used by 	:	Called from spDebtor_Update and from the dialerupdate service.
**NOTE    	:	PhoneType 1 = HomePhone, 2 = WorkPhone (others may follow)
**Change History:	MDD - 5/17/2006 - compare @UserChanged and default to dblogin name if not specified.
*/

	IF ISNULL(@UserChanged, suser_sname()) = '' 
		Select @UserChanged = suser_sname()
	ELSE
		Select @UserChanged = @UserChanged

	INSERT INTO PhoneHistory
	(AccountID, DebtorID, DateChanged, UserChanged, PhoneType, OldNumber, NewNumber)
	VALUES
	(@AccountID, @DebtorID, GetDate(), @UserChanged, @PhoneType, @OldNumber, @NewNumber)

	Return @@Error
GO

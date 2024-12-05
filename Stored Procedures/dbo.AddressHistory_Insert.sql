SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*AddressHistory_Insert    Script Date: 10/14/2003 1:27:56 PM ******/
CREATE PROCEDURE [dbo].[AddressHistory_Insert]
	@AccountID int,
	@DebtorID int,
	@UserChanged varchar(50),
	@OldStreet1 varchar(50),
	@OldStreet2 varchar(50),
	@OldCity varchar(50),
	@OldState varchar(50),
	@OldZipcode varchar(50),
	@NewStreet1 varchar(50),
	@NewStreet2 varchar(50),
	@NewCity varchar(50),
	@NewState varchar(50),
	@NewZipcode varchar(50)
AS
 /*
** Name:		AddressHistory_Insert		
** Function:		Adds a record to the AddressHistory Table
** Creation:		10/14/2003 version 4.0.16
**Used by :		Called from sp_Debtor_Update
** Change History:	
*/

	INSERT INTO AddressHistory(AccountID, DebtorID, DateChanged, UserChanged, 
	OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1, NewStreet2,
	NewCity, NewState, NewZipcode)
	VALUES(@AccountID, @DebtorID, GetDate(),@UserChanged, 
	@OldStreet1, @OldStreet2, @OldCity, @OldState, @OldZipcode, @NewStreet1, @NewStreet2,
	@NewCity, @NewState, @NewZipcode)

	Return @@Error
GO

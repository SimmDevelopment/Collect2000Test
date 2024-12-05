SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spRestrictions_Update*/
CREATE  PROCEDURE [dbo].[spRestrictions_Update]
@RestrictionID int,
@UserID int,
@Home bit,
@Work bit,
@Calls bit,
@Letters bit,
@Comment text,
@Disputed bit,
@LettersToAtty bit

AS

Declare @Number int	     --not used but the first select statement wont work without it
Declare @LastUser int	     --The last user to update the record

 /*
History	:11/29/2004 mr added a check for isnull on UpdatedBy 
*/


Select @Number=number, @LastUser=isnull(UpdatedBy,0) from Restrictions where RestrictionID = @RestrictionID
IF @@RowCount = 0
	Return -2
ELSE 
	IF (@LastUser = @UserID) BEGIN

		UPDATE Restrictions Set
			Home = @Home,
			Job = @Work,
			Calls = @Calls,
			SuppressLetters = @Letters,
			LettersToAtty = @LettersToAtty,
			Comment = @Comment,
			Disputed = @Disputed,
			DateUpdated = GetDate(),
			UpdatedBy = @UserID
		WHERE RestrictionID = @RestrictionID
		
		Return @@Error
	END
	ELSE
		Return -1


GO

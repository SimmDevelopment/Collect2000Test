SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spRestrictions_Insert*/
CREATE PROCEDURE [dbo].[spRestrictions_Insert]
	@AccountID int,
	@DebtorID int,
	@UserID int,
	@Home bit,
	@Work bit,
	@Calls bit,
	@Letters bit,
	@Comment text,
	@Disputed bit,
	@LettersToAtty bit,
	@ReturnID int Output
AS

	SELECT @ReturnID=RestrictionID from Restrictions where Number = @AccountID and DebtorID = @DebtorID

	IF @@RowCount = 0 BEGIN

		INSERT INTO Restrictions(number, DebtorID, Home, Job, Calls, SuppressLetters, LettersToAtty, Comment,
			    Disputed, DateUpdated, UpdatedBy)
		Values(@AccountID, @DebtorID, @Home, @Work, @Calls, @Letters, @LettersToAtty, @Comment,
			    @Disputed, GetDate(), @UserID)

		IF @@Error = 0	BEGIN
			Select @ReturnID = SCOPE_IDENTITY()
			Return 0
		END
		ELSE
			Return @@Error
	END
	ELSE
		Return -1	--there is already a record for this Debtor and only one is allowed. Return its ID via @ReturnID



GO

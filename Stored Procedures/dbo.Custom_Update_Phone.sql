SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_Update_Phone]
@Number int,
@DebtorID int,
@NewPhone varchar(10),
@OldPhone varchar(10),
@SEQ int,
@PhoneType varchar(1),
@User0 varchar(10)
AS

-- Variable declaration.
DECLARE @ACTION VARCHAR(6)
DECLARE @RESULT VARCHAR(6)
DECLARE @Comment VARCHAR(5000)

-- Variable assignment.
SET @ACTION = 'GEXCH'
SET @RESULT = 'UPDATE'

-- Begin transactional processing.
BEGIN TRAN

-- If is the primary debtor...
IF @SEQ = '0'
	BEGIN
		IF @PhoneType = '0'
			BEGIN		
				UPDATE Master SET HomePhone = @NewPhone
				WHERE Number = @Number

				-- ErrorHandler call.
				IF @@Error <> 0 
				GOTO ERRORHANDLER

				UPDATE DEBTORS SET HomePhone = @NewPhone
				WHERE NUMBER = @Number and debtorid = @DebtorID

				-- ErrorHandler call.
				IF @@Error <> 0 
				GOTO ERRORHANDLER
			END
		ELSE
			BEGIN
				UPDATE Master SET WorkPhone = @NewPhone
				WHERE Number = @Number

				-- ErrorHandler call.
				IF @@Error <> 0 
				GOTO ERRORHANDLER

				UPDATE DEBTORS SET WorkPhone = @NewPhone
				WHERE NUMBER = @Number and debtorid = @DebtorID

				-- ErrorHandler call.
				IF @@Error <> 0 
				GOTO ERRORHANDLER		
			END
		-- End if DO NOT UNCOMMENT.
	END

-- An additional debtor...
ELSE
	BEGIN
		IF @PHONETYPE = '0'

			UPDATE DEBTORS SET HomePhone = @NewPhone
			WHERE NUMBER = @Number and debtorid = @DebtorID

			-- ErrorHandler call.
			IF @@Error <> 0 
			GOTO ERRORHANDLER
		ELSE

			UPDATE DEBTORS SET WorkPhone = @NewPhone
			WHERE NUMBER = @Number and debtorid = @DebtorID

			-- ErrorHandler call.
			IF @@Error <> 0 
			GOTO ERRORHANDLER

		-- END IF DO NOT UNCOMMENT.
	END
-- END IF DO NOT UNCOMMENT.

-- Add a note.
BEGIN
	
	-- Create the comment for the note.
	SET @COMMENT = 'Old Phone updated - ' + @OldPhone

	-- Add a note record.
	EXEC Custom_Insert_Note @Number, @User0, @ACTION, @RESULT, @COMMENT

	IF @@Error <> 0 
    GOTO ERRORHANDLER	

	-- Add a phone history record.
	EXEC Custom_Insert_PhoneHistory @Number, @DebtorID, @User0, 
                                    @PhoneType, @OldPhone, @NewPhone

	IF @@Error <> 0 
    GOTO ERRORHANDLER
END

-- Commit the pending transaction.
COMMIT TRAN

-- Return successful process indicator.
RETURN 0

-- Error Handling.
ERRORHANDLER:
	-- Return dbase to previous state.
	ROLLBACK TRAN
	-- Return unsuccessful process indicator.
	RETURN @@Error
GO

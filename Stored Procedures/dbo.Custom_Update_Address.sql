SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_Update_Address]
@AccountID int,
@DebtorID int,
@SEQ int,
@OldStreet1 varchar(50),
@OldStreet2 varchar(50),
@OldCity varchar(50),
@OldState varchar(50),
@OldZipCode varchar(50),
@NewStreet1 varchar(50),
@NewStreet2 varchar(50),
@NewCity varchar(50),
@NewState varchar(50),
@NewZipCode varchar(50),
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

BEGIN
	UPDATE Debtors
	SET Street1 = @NewStreet1,
    	Street2 = @NewStreet2,
	    City = @NewCity,
	    State = @NewState,
	    ZipCode = @NewZipCode
	WHERE DEBTORID = @DebtorID

	-- ErrorHandler call.
	IF @@Error <> 0 
    GOTO ERRORHANDLER
END

BEGIN 
	-- If this is the primary debtor...
	IF @Seq = 0 
		UPDATE MASTER
		SET Street1 = @NewStreet1,
    		Street2 = @NewStreet2,
		    City = @NewCity,
		    State = @NewState,
		    ZipCode = @NewZipCode
		WHERE NUMBER = @AccountID

		-- Errorhandler call 
		IF @@Error <> 0 
		GOTO ERRORHANDLER
END

-- Add a note/Address history record.
BEGIN
	
	-- Create the comment for the note.
	SET @COMMENT = 'Old Address updated - ' + @OldStreet1 + ' ' + @OldStreet2 + ' ' + @OldCity + ' ' + @OldState + ' ' + @OldZipCode

	-- Add a note.
	EXEC Custom_Insert_Note @AccountID, @User0, @ACTION, @RESULT, @COMMENT

	IF @@Error <> 0 
    GOTO ERRORHANDLER	

	-- Add an address history record.
	EXEC Custom_Insert_AddressHistory @AccountID, @DebtorID, @User0, @OldStreet1, @OldStreet2,
                                      @OldCity, @OldState, @OldZipCode, @NewStreet1, @NewStreet2,
                                      @NewCity, @NewState, @NewZipCode

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

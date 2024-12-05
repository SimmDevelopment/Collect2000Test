SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_Update_QLevel]
@Number int,
@NewQLevel varchar(3),
@OldQLevel varchar(3),
@User varchar(10)
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
		UPDATE Master SET QLevel = @NewQLevel 
		WHERE Number = @Number

		IF @@Error <> 0 
		GOTO ERRORHANDLER	

		DELETE FROM supportqueueitems 
		WHERE AccountID = @Number

		IF @@Error <> 0 
		GOTO ERRORHANDLER
	END	

	-- Add a note.
	BEGIN
		
		-- Create the comment for the note.
		SET @COMMENT = 'Old queue Level update - ' + @OldQlevel

		-- Execute the proc.
		EXEC Custom_Insert_Note @Number, @User, @ACTION, @RESULT, @COMMENT

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

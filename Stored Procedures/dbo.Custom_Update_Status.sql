SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_Update_Status]
@Number int,
@NewStatus varchar(5),
@OldStatus varchar(5),
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

		UPDATE Master SET Status = @NewStatus 
		WHERE Number = @Number

		IF @@Error <> 0 
		GOTO ERRORHANDLER	
	END	

	-- Add a note.
	BEGIN
		
		-- Create the comment for the note.
		SET @COMMENT = 'Old status update - ' + @OldStatus

		-- Add a note record.
		EXEC Custom_Insert_Note @Number, @User0, @ACTION, @RESULT, @COMMENT

		IF @@Error <> 0 
		GOTO ERRORHANDLER

		-- Add a status history record.			
		EXEC Custom_Inserts_StatusHistory @Number, @OldStatus, @NewStatus

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

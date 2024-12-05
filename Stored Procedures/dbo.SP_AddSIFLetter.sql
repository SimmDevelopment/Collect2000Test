SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_AddSIFLetter]    @Number int,    @Entered DateTime,    @Requested Datetime,    @LetterDesc varchar (50),    @LetterCode varchar (5),    @SifAmt money,    @DueDate DateTime,    @SendRM varchar (1),    @returnSts bit output  AS BEGIN TRANSACTION    INSERT INTO Future (Number, Entered, Requested, LetterCode, LetterDesc, duedate, amtdue, action, sendRM)    VALUES (@Number, @Entered, @Requested, @LetterCode, @LetterCode + ' - ' + @LetterDesc, @DueDate, @SifAmt, 'LETTER', @SendRM)    IF (@Requested = GetDate() ) BEGIN        INSERT INTO master (promamt, promdue)        VALUES (@SifAmt, @DueDate)    END IF (@@error <> 0) BEGIN    GOTO Abort_Transaction END COMMIT TRAN Set @ReturnSts = 1 RETURN @ReturnSts Abort_Transaction:    ROLLBACK TRAN    SET @ReturnSts = 0 
GO

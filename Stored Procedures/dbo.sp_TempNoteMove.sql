SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_TempNoteMove] 
@StartDate datetime, 
@EndDate datetime, 
@SuccessCount int Output, 
@ReturnStatus int Output AS 
Declare @Number int 
Declare @User0 varchar(10) 
Declare @Action varchar(6) 
Declare @Result varchar(6) 
Declare @Comment varchar(1000) 
Declare @Seq int 
Declare @Created datetime 
Declare @Err int 

SET @SuccessCount = 0 
Declare Crsr Cursor 
FOR SELECT Number, User0, Action, Result, Comment, Seq, Created From OldNotes WHERE Created between @StartDate and @EndDate 
Order by number, created, Seq 
Open Crsr FETCH NEXT FROM Crsr INTO @Number, @User0, @Action, @Result, @Comment, @Seq, @Created 

WHILE @@Fetch_Status = 0 BEGIN
	INSERT INTO NOTES (Number, Seq, Created, User0, Action, Result, Comment) 
	VALUES (@Number, @Seq, @Created, @User0, @Action, @Result, @Comment) 
	SELECT @Err = @@Error 
	IF @Err <> 0 BEGIN 
		Set @ReturnStatus = @Err 
		Return @Err 
		FETCH NEXT FROM Crsr INTO @Number, @User0, @Action, @Result, @Comment, @Seq, @Created 
	END 
	SET @SuccessCount = @SuccessCount + 1 
End  
Close Crsr 
Deallocate Crsr 

DELETE FROM OldNotes WHERE Created Between @StartDate and @EndDate SET @ReturnStatus = 0 Return 0
GO

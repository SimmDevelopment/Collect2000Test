SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[sp_AddNewNote]
	@AcctID int,
	@Action varchar(5),
	@Result varchar(5),
	@Comment varchar(1000),
	@Desk varchar (10),
	@DateTime datetime,
	@Worked bit,
	@Contacted bit,
	@Touched bit,
	@ReturnSts int output
AS
	Declare @TheDate datetime
	Declare @TotalWorked int
	Declare @TotalContacted int
	Declare @TotalTouched int

	SET @TheDate = CONVERT(Varchar(10),GetDate(),101)

	BEGIN TRAN
	
	INSERT INTO Notes(number, action, result, comment, created, user0)
	VALUES (@AcctID, @Action, @Result, @Comment, @DateTime,@Desk)

	SELECT @TotalWorked=Worked, @TotalContacted=Contacted, @TotalTouched=Touched
	FROM DeskStats 
	WHERE desk = @Desk and TheDate = @TheDate

	IF (@@rowcount=0)
		INSERT INTO DeskStats (Desk, TheDate, Worked, Contacted, Touched)
		VALUES (@Desk,@TheDate,@Worked, @Contacted, @Touched)
	ELSE
		UPDATE DeskStats SET Worked = @TotalWorked + @Worked, Contacted = @TotalContacted + @Contacted, Touched = @TotalTouched + @Touched
		WHERE Desk = @Desk and TheDate = @TheDate 

	SELECT @TotalWorked=TotalWorked, @TotalContacted=TotalContacted, @TotalTouched=TotalViewed
	FROM Master where number = @AcctID

	IF (@@RowCount=0)
		Goto ErrorExit
	ELSE BEGIN
		UPDATE Master set TotalWorked=@TotalWorked+@Worked, TotalViewed = @TotalTouched+@Touched, @TotalContacted=@TotalContacted+@Contacted
		WHERE number = @AcctID
		
		IF @Worked=1
			UPDATE Master SET Worked = @DateTime WHERE number = @AcctID
		IF @Contacted=1
			UPDATE Master SET Contacted = @DateTime WHERE number = @AcctID
	END

	IF (@@Error=0) BEGIN
		COMMIT TRAN
		Set @ReturnSts = 1
		Return 1
	END
ErrorExit:
	ROLLBACK TRAN
	Set @ReturnSts = -1
	Return -1
GO

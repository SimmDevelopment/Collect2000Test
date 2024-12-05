SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_AddPromise*/
CREATE   PROCEDURE [dbo].[sp_AddPromise]
	@AcctID int,
	@Seq tinyint,
	@Amount money,
	@DueDate datetime,
	@SendRM bit,
	@SendRMDate datetime,
	@LetterCode varchar(5),
	@PromiseMode tinyint,
	@LatitudeUser	varchar(255),
	@ArrangementID INTEGER = NULL,
	@ReturnMessage varchar(30) output,
	@ReturnUID int output
AS
	Declare @Entered datetime
	Declare @Desk varchar (10)
	Declare @Customer varchar(7)
	Declare @QLevel varchar (3)
	Declare @ReturnError int 
	Declare @Rowcount int

	set @Entered = cast(CONVERT(varchar, GETDATE(), 107)as datetime)

	IF ISNULL(@LatitudeUser, suser_sname()) = '' 
		Select @LatitudeUser = suser_sname()
	ELSE
		Select @LatitudeUser = @LatitudeUser

	Select @Desk=Desk, @Customer=Customer, @QLevel = QLevel from master WHERE number = @AcctID
	SELECT @ReturnError = @@Error, @Rowcount = @@ROWCOUNT
	IF (@Rowcount = 0) 
	BEGIN
		SET @ReturnMessage = 'Account does not exist'
		Return -1
	END
	ELSE IF @ReturnError <> 0
	BEGIN
		Return @ReturnError
	END
	ELSE IF @QLevel in ('998', '999') 
	BEGIN
		SET @ReturnMessage = 'Closed QLevel'
		Return -1
	END
	ELSE 
	BEGIN
		INSERT INTO Promises(AcctID, DebtorID, Desk, Customer, 
			Entered, Amount, DueDate, SendRM, 
			SendRMDate, LetterCode,PromiseMode,
			CreatedBy, ArrangementID)
		VALUES(@AcctID, @Seq, @Desk, @Customer, 
			@Entered, @Amount, @DueDate, @SendRM, 
			@SendRMDate, @LetterCode, @PromiseMode,
			@LatitudeUser, @ArrangementID)

		SET @ReturnError = @@Error
		IF @ReturnError = 0 
		BEGIN
			Select @ReturnUID = SCOPE_IDENTITY()
			Return 0
		END
		ELSE 
		BEGIN
			SET @ReturnMessage = 'Error in Insert'
			Return @ReturnError
		END		
	END

GO

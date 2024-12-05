SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_AddNewPOD*/
CREATE  PROCEDURE [dbo].[sp_AddNewPOD]
	@Number int,
	@InvoiceNumber varchar(25),
	@InvoiceDate datetime,
	@InvoiceDetail text,
	@Amount money,
	@Branch varchar (10),
	@UpdateStats bit,
	@ReturnUID int Output

 AS

	Declare @Customer varchar(8)
	Declare @SysMonth tinyint
	Declare @SysYear smallint

	BEGIN TRAN

	INSERT INTO PODDetail (Number, InvoiceNumber, InvoiceDate, InvoiceDetail, InvoiceAmount, PaidAmt, CurrentAmt, CustBranch)
	VALUES (@Number, @InvoiceNumber, @InvoiceDate, @InvoiceDetail, @Amount,0,@Amount, @Branch)

	SELECT @ReturnUID = SCOPE_IDENTITY()
	
	UPDATE Master set original=original+@Amount, original1=Original1+@Amount,Current0=Current0+@Amount, Current1=Current1+@Amount
	WHERE number = @Number

	IF @UpdateStats = 1 BEGIN
		SELECT @Customer=Customer from master where number =@Number

		SELECT @SysMonth = CurrentMonth, @SysYear = CurrentYear from controlFile

		SELECT * FROM CustomerStats Where Customer = @Customer and TheDate = cast(CONVERT(varchar, GETDATE(), 107)as datetime) and SystemMonth = @SysMonth

		IF (@@Rowcount=0)
			INSERT INTO CustomerStats(TheDate, Customer, SystemMonth, SystemYear, NewItems, NewDollars)
			VALUEs(cast(CONVERT(varchar, GETDATE(), 107)as datetime), @Customer, @SysMonth, @SysYear, 1, @Amount)
		ELSE
			UPDATE CustomerStats SET NewItems = NewItems+1, NewDollars = NewDollars+@Amount 
			WHERE Customer=@Customer and TheDate = cast(CONVERT(varchar, GETDATE(), 107)as datetime) and SystemMonth = @SysMonth

		SELECT * FROM StairStep WHERE Customer = @Customer and SSYear = @SysYear and SSMonth = @SysMonth
		IF (@@rowcount=0) 
			INSERT INTO StairStep(Customer, SSYear, SSMonth, NumberPlaced, GrossDollarsPlaced, 
			NetDollarsPlaced, Adjustments, GTCollections, GTFees, TMCollections, TMFees,
			LMCollections, LMFees, Month1, Month2, Month3, Month4, Month5, Month6, Month7,
			Month8, Month9, Month10, Month11, Month12, Month13, Month14, Month15, Month16,
			Month17, Month18, Month19, Month20, Month21, Month22, Month23, Month24, Month99)
			VALUES(@Customer, @SysYear, @SysMonth, 1, @Amount, @Amount, 0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
		ELSE
			UPDATE StairStep Set GrossDollarsPlaced = GrossDollarsPlaced + @Amount, NetDollarsPlaced =
			NetDollarsPlaced + @Amount WHERE Customer=@Customer and SSYear = @SysYear and SSMonth = @SysMonth
	END


IF (@@error = 0) 
	COMMIT TRAN
ELSE BEGIN
	ROLLBACK TRAN
	SET @ReturnUID = 0
END


GO

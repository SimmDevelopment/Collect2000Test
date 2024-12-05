SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_UpdateNewPODStats]

	@Number int,
	@Amount money,
	@ReturnStatus int output

 AS
	Declare @Customer varchar(8)
	Declare @SysMonth tinyint
	Declare @SysYear smallint
	
	SELECT @Customer=Customer from master where number =@Number

	SELECT @SysMonth = CurrentMonth, @SysYear = CurrentYear from controlFile

	SELECT * FROM CustomerStats Where Customer = @Customer and TheDate = GetDate() and SystemMonth = @SysMonth

	BEGIN TRAN

	IF (@@Rowcount=0)
		INSERT INTO CustomerStats(TheDate, Customer, SystemMonth, SystemYear, NewItems, NewDollars)
		VALUEs(GetDate(), @Customer, @SysMonth, @SysYear, 1, @Amount)
	ELSE
		UPDATE CustomerStats SET NewItems = NewItems+1, NewDollars = NewDollars+@Amount 
		WHERE Customer=@Customer and TheDate = GetDate() and SystemMonth = @SysMonth

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



IF (@@error = 0) BEGIN
	COMMIT TRAN
	SET @ReturnStatus = 1
END
ELSE BEGIN
	ROLLBACK TRAN
	SET @ReturnStatus = 0
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_UpdateViewed*/
CREATE  PROCEDURE [dbo].[sp_UpdateViewed]
	@AcctID int,
	@UserLogin varchar(10)
AS 

Declare @CustCode varchar(7)
Declare @TotalViewed smallint
Declare @TheDate datetime
Declare	@SysMonth tinyint
Declare	@SysYear smallint

SET @TheDate = cast(CONVERT(varchar, GETDATE(), 107)as datetime)

--Update master table 
SELECT @TotalViewed = totalviewed, @CustCode = customer from master where number = @AcctID

IF @@Rowcount = 0 
	Return -1
ELSE BEGIN
	IF @TotalViewed is null SET @TotalViewed = 0

	UPDATE master set totalviewed = @TotalViewed + 1, viewed = GETDATE() WHERE number = @AcctID

	IF @@Error <> 0 Return @@Error


	--Update DeskStats
	SELECT @TotalViewed = Touched from DeskStats Where Desk = @UserLogin and TheDate = @TheDate

	IF @@RowCount = 0 BEGIN
		SELECT @SysMonth = CurrentMonth, @SysYear = CurrentYear from controlFile

		INSERT Into DeskStats(Desk, TheDate, Worked, Contacted, Touched, Collections, Fees, SystemMonth, SystemYear)
		VALUES(@UserLogin, @TheDate, 0, 0, 1, 0, 0, @SysMonth, @SysYear)

		IF @@Error <> 0 Return @@Error
	END
	ELSE BEGIN
		IF @TotalViewed is null SET @TotalViewed = 0

		UPDATE DeskStats Set Touched = @TotalViewed + 1 Where Desk = @UserLogin and TheDate = @TheDate 
		
		IF @@Error <> 0 Return @@Error
	END

	--Update CustomerStats  
	SELECT @TotalViewed = Touched from CustomerStats Where Customer = @CustCode and TheDate = @TheDate

	IF @@RowCount = 0 BEGIN
		SELECT @SysMonth = CurrentMonth, @SysYear = CurrentYear from controlFile
		
		INSERT INTO CustomerStats(Customer, TheDate, Touched, Worked, Contacted, Collections, Fees, NewItems, NewDollars, SystemMonth, SystemYear)
		VALUES(@CustCode, @TheDate, 1, 0, 0, 0, 0, 0, 0, @SysMonth, @SysYear)
		
		IF @@Error <> 0 Return @@Error
	END
	ELSE BEGIN
		IF @TotalViewed is null SET @TotalViewed = 0

		UPDATE CustomerStats Set Touched = @TotalViewed +1 
		WHERE Customer = @CustCode and TheDate = @TheDate

		IF @@Error <> 0 Return @@Error
	END
END
Return 0


GO

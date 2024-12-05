SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_UpdateWorked*/
CREATE PROCEDURE [dbo].[sp_UpdateWorked]
	@AcctID int,
	@UserLogin varchar(10)
AS 

Declare @CustCode varchar(7)
Declare @TotalWorked smallint
Declare @TheDate datetime
Declare @SysMonth tinyint
Declare @SysYear smallint
Declare @Hour tinyint

SET @TheDate = cast(CONVERT(varchar, GETDATE(), 107)as datetime)
SELECT @SysMonth = CurrentMonth, @SysYear = CurrentYear from ControlFile
IF @@Error <> 0 
	Return @@Error

--Update master table 
SELECT @TotalWorked = totalworked, @CustCode = customer from master where number = @AcctID

IF @@Rowcount = 0 
	Return -1

ELSE BEGIN
	IF @TotalWorked is null SET @TotalWorked = 0

	UPDATE master set worked = @TheDate, totalWorked = @TotalWorked + 1 WHERE number = @AcctID

	IF @@Error <> 0 Return @@Error


	--Update DeskStats 
	SELECT @TotalWorked = Worked from DeskStats Where Desk = @UserLogin and TheDate = @TheDate

	IF @@RowCount = 0 BEGIN
		INSERT Into DeskStats(Desk, TheDate, Worked, Contacted, Touched, Collections, Fees, SystemMonth, SystemYear)
		VALUES(@UserLogin, @TheDate, 1, 0, 0, 0, 0, @SysMonth, @SysYear)

		IF @@Error <> 0 Return @@Error
	END
	ELSE BEGIN
		IF @TotalWorked is null SET @TotalWorked = 0

		UPDATE DeskStats Set Worked = @TotalWorked + 1 Where Desk = @UserLogin and TheDate = @TheDate 

		IF @@Error <> 0 Return @@Error
	END


	--Update CustomerStats 
	SELECT @TotalWorked = Worked from CustomerStats Where Customer = @CustCode and TheDate = @TheDate

	IF @@RowCount = 0 BEGIN
		INSERT INTO CustomerStats(Customer, TheDate, Touched, Worked, Contacted, Collections, Fees, NewItems, NewDollars, SystemMonth, SystemYear)
		VALUES(@CustCode, @TheDate, 0, 1, 0, 0, 0, 0, 0, @SysMonth, @SysYear)
		
		IF @@Error <> 0 Return @@Error
	END
	ELSE BEGIN
		IF @TotalWorked is null SET @TotalWorked = 0
		
		UPDATE CustomerStats Set Worked = @TotalWorked +1 
		WHERE Customer = @CustCode and TheDate = @TheDate

		IF @@Error <> 0 Return @@Error
	END


	--Update Account_WorkStats table

	SET @Hour = DatePart(hh, GetDate())

	SELECT AccountID from Account_WorkStats Where AccountID = @AcctID

	IF @@RowCount = 0 BEGIN
		IF DATENAME(dw,GetDate()) in ('Saturday', 'Sunday')
			INSERT INTO Account_WorkStats(AccountID, Weekend_MW)Values(@AcctID, 1)
		ELSE BEGIN
			IF @Hour < 12
				INSERT INTO Account_WorkStats(AccountID, Morning_MW)Values(@AcctID, 1)
			IF @Hour >= 12 and @Hour < 18
				INSERT INTO Account_WorkStats(AccountID, Afternoon_MW)Values(@AcctID, 1)
			IF @Hour >= 18
				INSERT INTO Account_WorkStats(AccountID, Evening_MW)Values(@AcctID, 1)
		END
	END
	ELSE BEGIN
		IF DATENAME(dw,GetDate()) in ('Saturday', 'Sunday')
			UPDATE Account_WorkStats Set Weekend_MW = Weekend_MW + 1 WHERE AccountID = @AcctID
		ELSE BEGIN
			IF @Hour < 12
				UPDATE Account_WorkStats Set Morning_MW = Morning_MW + 1 WHERE AccountID = @AcctID
			IF @Hour >= 12 and @Hour < 18
				UPDATE Account_WorkStats Set Afternoon_MW = Afternoon_MW + 1 WHERE AccountID = @AcctID
			IF @Hour >= 18
				UPDATE Account_WorkStats Set Evening_MW = Evening_MW + 1 WHERE AccountID = @AcctID
		END
	END

	Return 0

END
GO

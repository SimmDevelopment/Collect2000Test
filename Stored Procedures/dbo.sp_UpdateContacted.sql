SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_UpdateContacted*/
CREATE PROCEDURE [dbo].[sp_UpdateContacted]
	@AcctID int,
	@UserLogin varchar(10)
AS 

Declare @CustCode varchar(7)
Declare @TotalContacted smallint
Declare @TheDate datetime
Declare @SysMonth tinyint
Declare @SysYear smallint
Declare @Hour tinyint

SET @TheDate = cast(CONVERT(varchar, GETDATE(), 107)as datetime)
SELECT @SysMonth = CurrentMonth, @SysYear = CurrentYear from ControlFile
If @@Error <> 0
	Return @@Error

--Update master table 
SELECT @TotalContacted = totalcontacted, @CustCode = customer from master where number = @AcctID

IF @@Rowcount = 0 
	Return -1

ELSE BEGIN
	IF @TotalContacted is null SET @TotalContacted = 0

	UPDATE master set contacted = @TheDate, totalContacted = @TotalContacted + 1 WHERE number = @AcctID

	IF @@Error <> 0 Return @@Error


	--Update DeskStats 
	SELECT @TotalContacted = contacted from DeskStats Where Desk = @UserLogin and TheDate = @TheDate
	IF @@RowCount = 0 BEGIN
		INSERT Into DeskStats(Desk, TheDate, Worked, Contacted, Touched, Collections, Fees, SystemMonth, SystemYear)
		VALUES(@UserLogin, @TheDate, 0, 1, 0, 0, 0, @SysMonth, @SysYear)

		IF @@Error <> 0 Return @@Error
	END
	ELSE BEGIN
		IF @TotalContacted is null SET @TotalContacted = 0

		UPDATE DeskStats Set Contacted = @TotalContacted + 1 Where Desk = @UserLogin and TheDate = @TheDate 

		IF @@Error <> 0 Return @@Error
	END

	--Update CustomerStats 
	SELECT @TotalContacted = Contacted from CustomerStats Where Customer = @CustCode and TheDate = @TheDate
	IF @@RowCount = 0 BEGIN
		INSERT INTO CustomerStats(Customer, TheDate, Touched, Worked, Contacted, Collections, Fees, NewItems, NewDollars, SystemMonth, SystemYear)
		VALUES(@CustCode, @TheDate, 0, 0, 1, 0, 0, 0, 0, @SysMonth, @SysYear)
	
		IF @@Error <> 0 Return @@Error
	END
	ELSE BEGIN
		IF @TotalContacted is null SET @TotalContacted = 0

		UPDATE CustomerStats Set Contacted = @TotalContacted +1 
		WHERE Customer = @CustCode and TheDate = @TheDate

		IF @@Error <> 0 Return @@Error
	END

	--Update Account_WorkStats table
	SET @Hour = DatePart(hh, GetDate())

	SELECT AccountID from Account_WorkStats Where AccountID = @AcctID

	IF @@RowCount = 0 BEGIN
		IF DATENAME(dw,GetDate()) in ('Saturday', 'Sunday')
			INSERT INTO Account_WorkStats(AccountID, Weekend_MC)Values(@AcctID, 1)
		ELSE BEGIN
			IF @Hour < 12
				INSERT INTO Account_WorkStats(AccountID, Morning_MC)Values(@AcctID, 1)
			IF @Hour >= 12 and @Hour < 18
				INSERT INTO Account_WorkStats(AccountID, Afternoon_MC)Values(@AcctID, 1)
			IF @Hour >= 18
				INSERT INTO Account_WorkStats(AccountID, Evening_MC)Values(@AcctID, 1)
		END
	END
	ELSE BEGIN
		IF DATENAME(dw,GetDate()) in ('Saturday', 'Sunday')
			UPDATE Account_WorkStats Set Weekend_MC = Weekend_MC + 1 WHERE AccountID = @AcctID
		ELSE BEGIN
			IF @Hour < 12
				UPDATE Account_WorkStats Set Morning_MC = Morning_MC + 1 WHERE AccountID = @AcctID
			IF @Hour >= 12 and @Hour < 18
				UPDATE Account_WorkStats Set Afternoon_MC = Afternoon_MC + 1 WHERE AccountID = @AcctID
			IF @Hour >= 18
				UPDATE Account_WorkStats Set Evening_MC = Evening_MC + 1 WHERE AccountID = @AcctID
		END
	END
END
Return 0
GO

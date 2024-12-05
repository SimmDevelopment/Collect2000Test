SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Object:  Stored Procedure dbo.sp_DeskChange    Script Date: 1/21/2003 11:55:11 AM ******/
CREATE PROCEDURE [dbo].[sp_DeskChange]    
   @AcctID int,
   @Qlevel varchar (3),
   @Qdate varchar (8),
   @NewDesk varchar (10),
   @UserID varchar (10)
AS
DECLARE @ErrCode int
DECLARE @Balance money 
DECLARE @OldDesk varchar (10) 
DECLARE @NewItems int 
DECLARE @NewAmt money 
DECLARE @Cust varchar (10) 
DECLARE @TheYear varchar (4) 
DECLARE @TheMonth varchar (2) 
DECLARE @Branch varchar(5)

/**Validate NewDesk and get Branch**/
SELECT @Branch = Branch from Desk where Code = @NewDesk
IF @@rowcount = 0   --no such desk
	Return -1
IF @Branch = NULL
	Set @Branch = '00000'
/**************Get Local Variables****************/ 
SELECT  @Balance = Current0, @OldDesk = desk, @Cust = customer FROM master WHERE number = @AcctID 
SELECT @TheYear = currentyear, @TheMonth = currentmonth FROM ControlFile

/*************Update Master.desk***************/ 
UPDATE master SET desk = @NewDesk, Branch = (Select Branch from Desk where code = @NewDesk), Qlevel = @Qlevel, QDate= @qdate 
WHERE number = @AcctID 
Select @ErrCode = @@error
If @ErrCode <> 0 
	Return @ErrCode
/************ If New Account, Update New Stats.   If not New Account, Update Other Stats***********/ 
IF (@qlevel = '015')  BEGIN 
       	--See if theres a record for Desk Stats for that desk, that cust, that year and that month
      	 SELECT @NewItems = NewNumberIn, @NewAmt = NewAmtIn FROM DeskInventoryStats 
      	 WHERE Desk = @newdesk and Customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth 
       	
	Select @ErrCode = @@Error
       	IF @ErrCode <> 0
		Return @ErrCode

       	IF (@@rowcount = 0)  BEGIN 
           	--Theres no record so create one
           		INSERT INTO DeskInventoryStats (Desk, Customer, NewNumberIn, NewAmtIn, SysYear, SysMonth) 
           		VALUES (@newdesk, @Cust, 1, @Balance, @TheYear, @TheMonth) 

	 	Select @ErrCode = @@Error
	   	IF @ErrCode <> 0 
			Return @ErrCode

       		END 
       	ELSE BEGIN 
           	--There is a record so just update it
           		UPDATE DeskInventoryStats Set NewNumberIn = @NewItems + 1, NewAmtIn = @NewAmt + @Balance 
           		WHERE Desk = @newdesk and Customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth 

		Select @ErrCode = @@Error
		IF @ErrCode <> 0
			Return @ErrCode
	END 
END 
ELSE BEGIN 
      	--See if theres a record for Desk Stats for that desk, that cust, that year and that month
       	SELECT @NewItems = OtherNumberIn, @NewAmt = OtherAmtIn FROM DeskInventoryStats 
       	WHERE Desk = @newdesk and Customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth 

       	IF (@@rowcount = 0) BEGIN 
           	--Theres no record so create one
           		INSERT INTO DeskInventoryStats (Desk, Customer, OtherNumberIn, OtherAmtIn, SysYear, SysMonth) 
           		VALUES (@newdesk, @Cust, 1, @Balance, @TheYear, @TheMonth) 

		Select @ErrCode = @@Error
		IF @ErrCode <> 0 
			Return @ErrCode

       	END 
       	ELSE BEGIN 
           	--There is a record so just update it 
           		UPDATE DeskInventoryStats Set OtherNumberIn = @NewItems + 1, OtherAmtIn = @NewAmt + @Balance 
           		WHERE Desk = @newdesk and Customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth 

		Select @ErrCode = @@Error
		IF @ErrCode <> 0
			Return @ErrCode
		
       	END 
END 
/****************Update or Create a record in DeskInventoryStats for the OLD Desk NumberOut and AmtOut**************/ 
--See if there is a record for the old desk, customer, year and month
SELECT @NewItems = NumberOut, @NewAmt = AmtOut          --@NewItems and @NewAmt seems wrong here but we're just reusing variables instead of declaring @OldItems and @OldAmt
FROM DeskInventoryStats                     
WHERE SysYear = @TheYear and SysMonth = @TheMonth and Desk = @OldDesk and customer = @Cust 

IF (@@rowcount = 0) BEGIN 
       	--Theres no record so create one
       	INSERT INTO DeskInventoryStats (Desk, Customer, NumberOut, AmtOut, SysYear, SysMonth) 
       	VALUES (@OldDesk, @Cust, 1, @Balance, @TheYear, @TheMonth) 

	Select @ErrCode = @@Error
	IF @ErrCode <> 0 
		Return @ErrCode

END 
ELSE BEGIN 
       	--There is a record so just update it
       	UPDATE DeskInventoryStats Set NumberOut = @NewItems + 1, AmtOut = @NewAmt + @Balance 
       	WHERE SysYear = @TheYear and SysMonth = @TheMonth and Desk = @OldDesk and customer = @Cust 
	
	Select @ErrCode = @@Error
	IF @ErrCode <> 0 
		Return @ErrCode

END 
/********Comment Notes*************/ 
INSERT INTO Notes (Number, created, User0, Action, Result, Comment) VALUES (@AcctID, getdate(), @UserID, 'DESK', 'CHNG',  @OldDesk + ':' + @newdesk) 

Select @ErrCode = @@Error
IF @ErrCode <> 0 
	Return @ErrCode
GO

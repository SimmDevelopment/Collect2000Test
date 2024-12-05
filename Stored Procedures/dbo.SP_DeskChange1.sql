SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_DeskChange1]     /**Use This SP to make simple Desk Changesdesk **/
	@number int,			      /**the Distribution Job Object Uses SP_DeskChange2 **/	
	@qdate varchar (8),		      /**The only difference is that this SP does not create a record in DeskChgDetails Table to allow Undo of Distribution Jobs**/
	@newdesk varchar (10),                      /**which desk-change many accounts as a group.*/
	@UserID varchar (10),
	@returnSts int output

AS
	DECLARE @qlevel varchar (3)
	DECLARE @Balance money
	DECLARE @OldDesk varchar (10)
	DECLARE @NewItems int
	DECLARE @NewAmt money
	DECLARE @Cust varchar (10)
	DECLARE @TheYear varchar (4)
	DECLARE @TheMonth varchar (2)

BEGIN TRANSACTION

	/*******************************************Get Local Variables*********************************************************************************************************************/
	SELECT @qlevel = qlevel, @Balance = Current0, @OldDesk = desk, @Cust = customer
	FROM master 
	WHERE number = @number


	SELECT @TheYear = currentyear, @TheMonth = currentmonth
	FROM ControlFile

	
	/*******************************************Update Master.desk*********************************************************************************************************************/
	UPDATE master SET desk = @newdesk
	WHERE number = @number
	
	/******************************************* If New Account, Update New Stats.   If not New Account, Update Other Stats************************************************/
	IF (@qlevel = '015')  BEGIN
		/**See if theres a record for Desk Stats for that desk, that cust, that year and that month**/
		SELECT @NewItems = NewNumberIn, @NewAmt = NewAmtIn
		FROM DeskInventoryStats
		WHERE Desk = @newdesk and Customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth


		IF (@@rowcount = 0)  BEGIN
			/**Theres no record so create one**/
			INSERT INTO DeskInventoryStats (Desk, Customer, NewNumberIn, NewAmtIn, SysYear, SysMonth)
			VALUES (@newdesk, @Cust, 1, @Balance, @TheYear, @TheMonth)
		END
		ELSE BEGIN
			/**There is a record so just update it**/
			UPDATE DeskInventoryStats Set NewNumberIn = @NewItems + 1, NewAmtIn = @NewAmt + @Balance
			WHERE Desk = @newdesk and Customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth
		END
	END
	ELSE BEGIN
		
		/**See if theres a record for Desk Stats for that desk, that cust, that year and that month**/			
		SELECT @NewItems = OtherNumberIn, @NewAmt = OtherAmtIn
		FROM DeskInventoryStats
		WHERE Desk = @newdesk and Customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth

			
		IF (@@rowcount = 0) BEGIN
			/**Theres no record so create on**/
			INSERT INTO DeskInventoryStats (Desk, Customer, OtherNumberIn, OtherAmtIn, SysYear, SysMonth)
			VALUES (@newdesk, @Cust, 1, @Balance, @TheYear, @TheMonth)
		END
		ELSE BEGIN
			/**There is a record so just update it**/
			UPDATE DeskInventoryStats Set OtherNumberIn = @NewItems + 1, OtherAmtIn = @NewAmt + @Balance
			WHERE Desk = @newdesk and Customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth
		END
	END
	/***************************************Update or Create a record in DeskInventoryStats for the OLD Desk NumberOut and AmtOut**************************************/

	/**See if there is a record for the old desk, customer, year and month**/
	SELECT @NewItems = NumberOut, @NewAmt = AmtOut          /**@NewItems and @NewAmt seems wrong here but we're just reusing variables instead of declaring @OldItems and @OldAmt**/
	FROM DeskInventoryStats				       
	WHERE SysYear = @TheYear and SysMonth = @TheMonth and Desk = @OldDesk and customer = @Cust

	IF (@@rowcount = 0) BEGIN
		/**Theres no record so create one**/
		INSERT INTO DeskInventoryStats (Desk, Customer, NumberOut, AmtOut, SysYear, SysMonth)
		VALUES (@OldDesk, @Cust, 1, @Balance, @TheYear, @TheMonth)
	END
	ELSE BEGIN
		/**There is a record so just update it**/
		UPDATE DeskInventoryStats Set NumberOut = @NewItems + 1, AmtOut = @NewAmt + @Balance
		WHERE SysYear = @TheYear and SysMonth = @TheMonth and Desk = @OldDesk and customer = @Cust
	END

	/*******************************************Add entry into DeskChgDetails so we can undo********************************************************************************/
	/**INSERT INTO DeskChgDetails (JobID, JobDate, FileNumber, OldDesk, NewDesk, UserID) VALUES (@JobName, GetDate(), @number, @OldDesk, @NewDesk, @UserID)**/
	/**REMd out because this is done in SP_DeskChange2 when a Distribution Job makes changes.  It's not done in this SP**/

	/*******************************************Comment Notes*********************************************************************************************************************/
	INSERT INTO Notes (Number, created, User0, Action, Result, Comment) VALUES (@number, getdate(), @UserID, 'DESK', 'CHNG',  @OldDesk + ':' + @newdesk)

IF (@@error <> 0) BEGIN
	GOTO Abort_Transaction
END


	
COMMIT TRAN
SET @ReturnSts = 1
RETURN @ReturnSts
Abort_Transaction:
	ROLLBACK TRAN
	SET @ReturnSts = 0
GO

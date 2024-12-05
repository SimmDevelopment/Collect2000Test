SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_StatusChange2]       /*Changes Status from an Active Type to a Closed Type, Closing the account and updating DeskInventory Stats */   
 @FileNumber int,    
@Status varchar (3),    
@ReturnSts bit output 
 AS    DECLARE @Balance money    
DECLARE @Desk varchar (7)   
 DECLARE @Cust varchar (7)   
 DECLARE @TheMonth int    
DECLARE @TheYear int   
 DECLARE @NumberOut int    
DECLARE @AmtOut money 
BEGIN TRANSACTION   
 	SELECT @Balance=current0, @Desk=Desk, @Cust=Customer FROM master where number = @FileNumber   
 	SELECT @TheMonth=currentmonth, @TheYear=currentyear FROM controlFile   
 /*Update DeskInventoryStats*/    
	SELECT @NumberOut=NumberOut, @AmtOut=AmtOut FROM DeskInventoryStats 
	WHERE Desk = @Desk and customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth   
 IF (@@RowCount = 0)  BEGIN
        INSERT INTO DeskInventoryStats (desk, SysYear, SysMonth, customer, NumberOut, AmtOut)
        VALUES (@Desk, @TheYear, @TheMonth, @Cust, 1, @Balance)
END   
ELSE BEGIN
        UPDATE DeskInventoryStats SET NumberOut = @NumberOut + 1, AmtOut = @AmtOut + @Balance
         WHERE Desk = @Desk and customer = @Cust and SysYear = @TheYear and SysMonth = @TheMonth   
 END
    /*Update master*/    
UPDATE master set status = @status, Qlevel = '998', closed = getdate()     WHERE number = @FileNumber
 IF (@@error <> 0) BEGIN
    Set @ReturnSts = 0 
   ROLLBACK TRAN
 END
 ELSE BEGIN 
   set @ReturnSts = 1
    COMMIT TRAN END 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_StatusChange1]    /*Makes a simple status change when the old and new status are both ACTIVE Type statuses*/    
@FileNumber int,    
@NewStatus varchar (3),    
@ReturnSts bit Output  
AS    

UPDATE master set Status = @NewStatus where number = @FileNumber       
 IF (@@error = 0 ) BEGIN       
 set @ReturnSts = 1   
 END    
ELSE BEGIN        
set @ReturnSts = 0   
 END 
GO

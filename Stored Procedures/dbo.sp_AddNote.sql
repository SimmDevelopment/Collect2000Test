SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* sp_AddNote procedure */
CREATE procedure [dbo].[sp_AddNote]    -- Differs from addnote stored procedure in that this sp takes a Created datetime parameter
   @AcctID int, 
   @Created datetime, 
   @UserLogin varchar (10), 
   @AC varchar (5), 
   @RC varchar(5), 
   @Comment text, 
   @UpdateNewStatus bit 
        
AS       

 /*Name		:sp_AddNote
**Usedby	:GSSNotes.dll, Dialer Update service(?)
**Updates	:5/1/2004 added call to EXEC Daily_Account_Contacted_Add
**		:8/24/2004 changed EXEC Daily_Account_Contacted_Add call to not be formed as dynamic sql
**		:2011/12/13 disable call to Daily_Account_Contacted_Add
*/

Declare @Status varchar(3) 
Declare @FirstWorkDate datetime 

 /* add to the daily contacted list */
-- exec Daily_Account_Contacted_Add  @AcctID - call disabled as per LAT-4237, now handled elsewhere

SELECT @Status = Status, @FirstWorkDate=Complete1 from master where number = @AcctID 

INSERT INTO notes (number, created,user0,action,result,comment) 
VALUES(@AcctID, @Created,@UserLogin,@AC,@RC,@Comment) 

IF @@Error <> 0 
   Return @@Error 

 /*
IF (@UpdateNewStatus = 1) and (@Status = 'NEW') 
   BEGIN 
       UPDATE master SET Status = 'ACT', QLevel = '599' WHERE number = @AcctID 
       IF @FirstWorkDate is NULL 
           UPDATE master SET Complete1 = cast(CONVERT(varchar, GETDATE(), 107)as datetime) WHERE number = @AcctID 
   END 
Return @@Error
*/
IF (@UpdateNewStatus = 1) and (@Status = 'NEW')
	BEGIN
		UPDATE master set Status = 'ACT' WHERE number = @AcctID
		IF @FirstWorkDate is NULL
			UPDATE master SET Complete1 = cast(CONVERT(varchar, GETDATE(), 107)as datetime) WHERE number = @AcctID 
	END
Return @@Error

GO

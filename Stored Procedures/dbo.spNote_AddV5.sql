SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* spNote_AddV5*/
CREATE  procedure [dbo].[spNote_AddV5]    
   @AcctID int, 
   @Created datetime, 
   @UserLogin varchar (10), 
   @AC varchar (5), 
   @RC varchar(5), 
   @Comment text, 
   @UpdateNewStatus bit,
   @IsPrivate bit
        
AS       

 /*Name		:spNote_Add  -  Replaces sp_AddNote in version 5
**Usedby	:GSSNotes.dll
**Updates	:
**		:
*/

IF @Created IS NULL
	SET @Created = GETDATE();

Declare @Status varchar(3) 
Declare @FirstWorkDate datetime 
Declare @WasNew as bit
Declare @Err int

 /* add to the daily contacted list */
-- exec Daily_Account_Contacted_Add  @AcctID - call disabled as per LAT-4237, now handled elsewhere

INSERT INTO notes (number, created,user0,action,result,comment, IsPrivate) 
VALUES(@AcctID, @Created,@UserLogin,@AC,@RC,@Comment,@IsPrivate) 

-- capture the error value
SET @Err = @@ERROR

IF (@Err = 0) 
BEGIN
	IF (@UpdateNewStatus = 1)
	BEGIN
		EXEC @Err = UpdateNewToActive @AcctId, @WasNew OUTPUT
	END
END

Return @Err

GO

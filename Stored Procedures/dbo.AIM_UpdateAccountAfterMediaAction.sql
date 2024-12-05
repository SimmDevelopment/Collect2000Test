SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_UpdateAccountAfterMediaAction]
@ledgerId int,
@action varchar(10),
@username varchar(10)=''
AS


DECLARE @number int
DECLARE @updateDesk varchar(5)
DECLARE @updateStatus varchar(5)
DECLARE @updateQlevel varchar(5)
DECLARE @desk varchar(5)
DECLARE @status varchar(5)
DECLARE @qlevel varchar(5)
DECLARE @ledgerType int

SELECT @number = number,@ledgerType = ledgertypeid FROM AIM_Ledger WITH (NOLOCK) WHERE LedgerID = @ledgerId

IF(@ledgerType in (27))
BEGIN

SELECT @updateDesk = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Media.'   + @action + 'ChangeDesk'
SELECT @updateStatus = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Media.'	 + @action + 'ChangeStatus'
SELECT @updateQlevel = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Media.'	 + @action + 'ChangeQlevel'
SELECT @desk = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Media.'  + @action + 'Desk'
SELECT @status = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Media.' + @action + 'Status'
SELECT @qlevel = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Media.' + @action + 'Qlevel'

END
ELSE
BEGIN


SELECT @updateDesk = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.MediaAfterSale.'   + @action + 'ChangeDesk'
SELECT @updateStatus = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.MediaAfterSale.'	 + @action + 'ChangeStatus'
SELECT @updateQlevel = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.MediaAfterSale.'	 + @action + 'ChangeQlevel'
SELECT @desk = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.MediaAfterSale.'  + @action + 'Desk'
SELECT @status = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.MediaAfterSale.' + @action + 'Status'
SELECT @qlevel = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.MediaAfterSale.' + @action + 'Qlevel'

END



if(@updateDesk = 'True' and ltrim(rtrim(@desk)) <> '')
begin
update master set desk = @desk where number = @number
end

if(@updateStatus= 'True' and ltrim(rtrim(@status)) <> '')
begin
update master set status = @status where number = @number
end

--ADDED 08/17/2010 by TJL----------------------------------------------------
if(@updateQlevel= 'True' and ltrim(rtrim(@qlevel)) <> '')
	begin
		DECLARE @notelogmessageid int
		DECLARE @oldqlevel VARCHAR(3)
		DECLARE @shouldqueue bit
		DECLARE @queuetype bit

		SELECT @oldqlevel = qlevel FROM [master] WITH (NOLOCK) WHERE Number = @Number

		IF(@qlevel BETWEEN '600' AND '799')
			BEGIN
				
				IF(@oldqlevel NOT BETWEEN '600' AND '799')
					BEGIN
					SET @shouldqueue = 0
					END
				ELSE
					BEGIN
					SET @shouldqueue = 1
					END
			
				IF(@qlevel BETWEEN '600' AND '699')
					BEGIN
					SET @queuetype = 0
					END
				ELSE
					BEGIN
					SET @queuetype = 1
					END

				INSERT INTO SupportQueueItems (QueueCode,AccountID,DateAdded,DateDue,LastAccessed,ShouldQueue,UserName,QueueType,Comment)
				VALUES (@qLevel,@number,getdate(),getdate(),getdate(),@shouldqueue,'AIM',@queuetype,'Qlevel changed via AIM Close File')
		
			END	
			
			INSERT INTO NOTES(Created,action,result,number,comment,user0)
			VALUES(getdate(),'+++++','+++++',@number,'Qlevel changed via AIM Close File','AIM')
			
	end

--END TJL 08/17/2010---------------------------------------------------



INSERT INTO NOTES(Created,action,result,number,comment,user0)
VALUES(getdate(),'+++++','+++++',@number,'Media Entry Has Received A ' + @action + ' by ' + @username,'AIM')

GO

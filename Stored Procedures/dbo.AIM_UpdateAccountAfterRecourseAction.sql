SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_UpdateAccountAfterRecourseAction]
@ledgerId int,
@action varchar(10),
@username varchar(10)=''
AS

DECLARE @number int
DECLARE @updateDesk varchar(10)
DECLARE @updateStatus varchar(5)
DECLARE @updateQlevel varchar(5)
DECLARE @desk varchar(10)
DECLARE @status varchar(5)
DECLARE @qlevel varchar(3)
DECLARE @ledgerType int


SELECT @number = number,@ledgerType = ledgertypeid FROM AIM_Ledger WITH (NOLOCK) WHERE LedgerID = @ledgerId

IF(@ledgerType in (22,30,31,32,33,34))
BEGIN
IF(@action = 'Approval')
BEGIN
      DECLARE @buyerName varchar(50)
      DECLARE @soldName varchar(100)
      SELECT @buyerName = G.Name,@soldName = s.code from aim_portfolio s with (nolock) join aim_group g on s.buyergroupid = g.groupid join master m with (nolock) 
      on m.soldportfolio = s.portfolioid where m.number = @number
      UPDATE Master SET soldportfolio = null,qlevel = '100',closed = null,returned = null where number = @number
      
      DELETE FROM AIM_PortfolioSoldAccounts WHERE Number = @number

      
      INSERT INTO Notes (created,utccreated,number,user0,action,result,comment)
      VALUES (getdate(),getutcdate(),@number,'PM','+++++','+++++','Account has been bought back from ' + isnull(@buyerName,'') + ' and portfolio code ' + isnull(@soldName,''))
END
SELECT @updateDesk = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.BB'   + @action + 'ChangeDesk'
SELECT @updateStatus = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.BB'   + @action + 'ChangeStatus'
SELECT @updateQlevel = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.BB'   + @action + 'ChangeQlevel'
SELECT @desk = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.BB'  + @action + 'Desk'
SELECT @status = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.BB' + @action + 'Status'
SELECT @qlevel = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.BB' + @action + 'Qlevel'

END
ELSE
BEGIN


SELECT @updateDesk = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.'   + @action + 'ChangeDesk'
SELECT @updateStatus = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.'     + @action + 'ChangeStatus'
SELECT @updateQlevel = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.'     + @action + 'ChangeQlevel'
SELECT @desk = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.'  + @action + 'Desk'
SELECT @status = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.' + @action + 'Status'
SELECT @qlevel = [Value] FROM AIM_AppSetting WHERE [Key] = 'PM.Recourse.' + @action + 'Qlevel'

END



if(@updateDesk = 'True' and ltrim(rtrim(@desk)) <> '')
begin
INSERT INTO NOTES(Created,action,result,number,comment,user0)
SELECT getdate(),'DESK','CHNG',@number,'Desk Changed from ' + desk + ' to ' + @desk,'PM' FROM master with (nolock) where number = @number


update master set desk = @desk where number = @number
end

if(@updateStatus= 'True' and ltrim(rtrim(@status)) <> '')
begin

INSERT INTO NOTES(Created,action,result,number,comment,user0)
SELECT getdate(),'STS','CHNG',@number,'Status Changed | '+ [status]  + ' | ' + @status ,'PM' FROM master with (nolock) where number = @number


update master set status = @status where number = @number
end




INSERT INTO NOTES(Created,action,result,number,comment,user0)
SELECT getdate(),'QLVL','CHNG',@number,'QLEVEL Changed | '+ qlevel  + ' | ' + @qlevel ,'PM' FROM master with (nolock) where number = @number

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
		SELECT getdate(),'QLVL','CHNG',@number,'QLEVEL Changed | '+ qlevel  + ' | ' + @qlevel ,'PM' FROM master with (nolock) where number = @number

	end

--END TJL 08/17/2010---------------------------------------------------


INSERT INTO NOTES(Created,action,result,number,comment,user0)
VALUES(getdate(),'+++++','+++++',@number,'Recourse Entry Has Received a ' + @action + ' Status Update','PM')

GO

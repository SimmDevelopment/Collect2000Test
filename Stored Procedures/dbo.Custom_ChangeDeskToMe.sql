SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_ChangeDeskToMe]   
 @number int,   
 @user varchar(50),  
 @debug varchar(10)  
AS  
  
set nocount on

if(@debug = 'true')  
 print 'Debug: Changing this account to '+@user+'''s desk.'  

declare @restrictiveCount int
set @restrictiveCount = 0
Select @restrictiveCount=count(*) from SupportQueueItems where accountid = @number
  
declare @qlevel varchar(3),@currentdesktype varchar(20)  
select @qlevel = qlevel,@currentdesktype=desktype   
from master m  
join desk d on d.code = m.desk    
where number = @number  
if(@restrictiveCount > 0 or @qlevel in ('875','998','999'))  
begin  
 print 'This account is in a restricted queue.'  
 return  
end  
  
if(@currentdesktype <> 'Inventory')  
begin  
 print 'Current desktype is not an "Inventory" type of desk.'  
 return  
end  
  
declare @desktype varchar(30)  
declare @loginname varchar(30)  
declare @caselimit int  
declare @desk varchar(10)  
select @loginname = u.loginname, @desktype = d.desktype,   
  @caselimit = caselimit, @desk = d.code  
from desk d  
join users u on u.deskcode = d.code  
where u.username = @user  
  
if(@desk is null)  
begin  
 print 'Your user has not been assigned a desk.'  
 return  
end  
  
declare @count int  
select @count = count(*) from master where desk = @desk and (qlevel < '600' or (qlevel > '800' and qlevel < '899'))  
if(@count+1 > @caselimit and @caselimit > 0)  
begin  
 print 'The case limit has been exceeded for desk: '+@desk+'.'  
 return  
end  
  
if(@desktype <> 'Collector')  
begin  
 print 'User''s desktype is not a "Collector" type of desk.'  
 return  
end  
  
declare @promise int  
select @promise = count(*) from master m with(nolock) join promises p with(nolock) on p.acctid = m.number where m.number = @number and p.active = 1  
select @promise = @promise+count(*) from master m with(nolock) join pdc p with(nolock) on p.number = m.number where m.number = @number and p.active = 1  
select @promise = @promise+count(*) from master m with(nolock) join debtorcreditcards p with(nolock) on p.number = m.number where m.number = @number and p.isactive = 1  
if(@promise = 0)  
begin  
 print 'No Promise or Payment or Post Date have been setup on this account.'  
 return  
end  
  
IF (@@error <> 0) BEGIN  
 return  
END  
  
--GET TEMP TABLE OF FOLLOWER ACCOUNTS THAT ARE IN AN INVENTORY DESK  
DECLARE @link INT  
SELECT @link = link FROM master WHERE number = @number  
IF (@link <> 0)  
BEGIN  
 DECLARE @tempAccounts TABLE (link int,Number int)  
 INSERT INTO @tempAccounts  
 SELECT m.link,m.number  
 FROM master m (NOLOCK)   
 JOIN desk d (NOLOCK) ON d.code = m.desk  
 WHERE m.link = @link  
 AND d.desktype = 'Inventory'  
 and m.number <> @number  
  
 DELETE @tempAccounts WHERE link IS NULL  
  
 --CURSOR FOR CALLING THE DESK CHANGE STORED PROCEDURE  
 DECLARE DESK_CURSOR Cursor Local FORWARD_ONLY OPTIMISTIC   
  
 FOR  
 SELECT number,link  FROM @tempAccounts  
  
 Open DESK_CURSOR   
 DECLARE @VAR1Number int, @VAR2link int  
  
 Fetch NEXT FROM DESK_CURSOR INTO @VAR1Number, @VAR2link  
 While (@@FETCH_STATUS <> -1)  
 BEGIN  
  IF (@@FETCH_STATUS <> -2)  
  BEGIN  
    EXECUTE [dbo].[SP_DeskChange2] @VAR1Number,'My Desk Button',null, @desk, @loginname, null  
  END  
  FETCH NEXT FROM DESK_CURSOR INTO @VAR1Number, @VAR2link  
 END  
 CLOSE DESK_CURSOR  
 DEALLOCATE DESK_CURSOR  
  
END  
ELSE
BEGIN  
 EXECUTE [dbo].[SP_DeskChange2] @number,'My Desk Button',null, @desk, @loginname, null  
END

print 'Successfully moved account to my desk('+@desk+').'  + CHAR(13) + CHAR(10) + 'Please refresh the account to see the changes.'   

GO

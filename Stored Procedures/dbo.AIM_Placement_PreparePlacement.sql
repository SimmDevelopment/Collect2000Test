SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_Placement_PreparePlacement]
@agencyid int,
@commissionpercentage float,
@autoRecall bit,
@pendingdays int,
@finaldays int,
@feeschedule varchar(5) = null,
@sql varchar(8000),
@desk varchar(10) = null,
@recalldesk varchar(10) = null,
@topcount int = 1000000
AS

BEGIN
--Insert (if needed) AIM_AccountReference records as the account has never been
--placed via AIM

DECLARE @executeSQL VARCHAR(8000)
SET @executeSQL = 
'INSERT INTO AIM_AccountReference (ReferenceNumber)
SELECT DISTINCT TOP ' + cast(@topcount as varchar(10)) + ' master.number ' + @sql + ' AND AIM_AccountReferenceAIM.AccountReferenceID IS NULL'
EXEC(@executeSQL)

if not object_id('tempdb..#AIM_AccountTransaction') is null drop table #AIM_AccountTransaction
create table #AIM_AccountTransaction  (tid int identity(1,1) primary key,AccountReferenceID int)

SET @executeSQL = 
'INSERT INTO #AIM_AccountTransaction (AccountReferenceID)
SELECT	DISTINCT TOP ' + cast(@topcount as varchar(10)) + ' [aim_accountreferenceAIM].accountReferenceId' + ' ' + @sql
EXEC(@executeSQL)


SET @executeSQL = 
'declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int; '+
'select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = ''AIM.Database.SqlBatchTransactionSize''; '+
'select @maxid= max(tid) from #AIM_AccountTransaction; '+
'select @currentrow = 1; '+ 
'select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end; '+
'select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = ''AIM.Database.SqlBatchTransactionSize''; '+
'while @rowcount <= @maxid begin ' +

'INSERT INTO AIM_AccountTransaction (AccountReferenceID,TransactionTypeID,TransactionStatusTypeID,CreatedDateTime,AgencyID,CommissionPercentage,Balance,FeeSchedule,Desk)
Select	DISTINCT [aim_accountreferenceAIM].accountReferenceId
,1
,1
,getdate()
,' + cast(@agencyId as varchar(10))+
',' + cast(@commissionpercentage as varchar(10)) +
',[dbo].[master].[current0]' +
',' + CASE WHEN @feeschedule is null THEN 'null' ELSE +''''+@feeschedule+''' ' END + 
',' + CASE WHEN @desk is null THEN 'null ' ELSE + ''''+ CAST(@desk AS VARCHAR(10))+ ''' ' END   + @sql+ ' ' +

 ' and [aim_accountreferenceAIM].accountReferenceId in (select accountReferenceId from  #AIM_AccountTransaction where tid between @currentrow and @rowcount); '+
 'select @currentrow = @rowcount + 1; '+
 'select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end; '+
'end'
EXEC(@executeSQL)

SET @executeSQL =
'UPDATE AIM_AccountReference
SET ObjectionFlag = 0' +
CASE @autoRecall WHEN 1 THEN
',numdaysplacedbeforepending = ' + CAST(@pendingdays as varchar(5)) +
',numdaysplacedafterpending = ' + CAST(@finaldays as varchar(5)) + ' '
ELSE ' ' END
+
',recalldesk = ' +CASE WHEN @recalldesk is null THEN 'null ' ELSE + ''''+ CAST(@recalldesk AS VARCHAR(10))+ ''' ' END
+ @sql
EXEC(@executeSQL)





END




GO

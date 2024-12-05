SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Recall_PrepareRecall]
@recallreasoncodeid int,
@transactiontypeid int,
@sql varchar(8000),
@recallDesk varchar(10) = null,
@topcount int = 1000000

AS

BEGIN

DECLARE @executeSQL VARCHAR(8000)

if not object_id('tempdb..#AIM_AccountTransaction') is null drop table #AIM_AccountTransaction
create table #AIM_AccountTransaction  (tid int identity(1,1) primary key,AccountReferenceID int,AgencyID INT,AccountTransactionID INT,UpdateFlag BIT DEFAULT(0))

SET @executeSQL = 
'INSERT INTO #AIM_AccountTransaction (AccountReferenceID,AgencyID)
SELECT	DISTINCT TOP ' + cast(@topcount as varchar(10)) + '  [aim_accountreferenceAIM].accountReferenceId,[aim_accountreferenceAIM].CurrentlyPlacedAgencyID ' + ' ' + @sql
EXEC(@executeSQL)

IF (@transactiontypeid = 2) --Pending Recall
BEGIN
DELETE #AIM_AccountTransaction
FROM #AIM_AccountTransaction at JOIN AIM_AccountTransaction ATR WITH (NOLOCK)
ON at.AccountReferenceID = ATR.AccountReferenceID AND ATR.AgencyID = at.AgencyID 
AND ATR.TransactionStatusTypeID = 1 AND ATR.TransactionTypeID in (2,3)
END
ELSE IF (@transactiontypeid = 3) --Final Recall
BEGIN
DELETE #AIM_AccountTransaction
FROM #AIM_AccountTransaction at JOIN AIM_AccountTransaction ATR WITH (NOLOCK)
ON at.AccountReferenceID = ATR.AccountReferenceID AND ATR.AgencyID = at.AgencyID 
AND ATR.TransactionStatusTypeID = 1 AND ATR.TransactionTypeID = 3

UPDATE #AIM_AccountTransaction
SET AccountTransactionID = atr.AccountTransactionID,UpdateFlag = 1
FROM #AIM_AccountTransaction at JOIN AIM_AccountTransaction ATR WITH (NOLOCK)
ON at.AccountReferenceID = ATR.AccountReferenceID AND at.AgencyID = ATR.AgencyID 
AND ATR.TransactionStatusTypeID = 1 AND ATR.TransactionTypeID = 2
END

SET @executeSQL = 
'declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int; '+
'select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = ''AIM.Database.SqlBatchTransactionSize''; '+
'select @maxid= max(tid) from #AIM_AccountTransaction; '+
'select @currentrow = 1; '+ 
'select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end; '+
'select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = ''AIM.Database.SqlBatchTransactionSize''; '+
'while @rowcount <= @maxid begin ' +
'INSERT INTO AIM_AccountTransaction (AccountReferenceID,TransactionTypeID,TransactionStatusTypeID,CreatedDateTime,AgencyID,RecallReasonCodeId,Desk)
 SELECT	DISTINCT [aim_accountreferenceAIM].accountReferenceId
 ,' + CAST(@transactiontypeid as VARCHAR(5)) +
 ',1
 ,getdate()
 ,[aim_AccountReferenceAIM].currentlyplacedagencyid
 ,' + CAST(@recallreasoncodeid as VARCHAR(5)) + 
',' + CASE WHEN @recallDesk is null THEN 'null ' ELSE + ''''+ CAST(@recallDesk AS VARCHAR(10))+ ''' ' END+ @sql + ' ' +
 ' and [aim_accountreferenceAIM].accountReferenceId in (select accountReferenceId from  #AIM_AccountTransaction where tid between @currentrow and @rowcount and updateflag=0); '+
 'select @currentrow = @rowcount + 1; '+
 'select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end; '+
'end'
EXEC(@executeSQL)


IF(@transactiontypeid = 3)
BEGIN
SET @executeSQL =
'declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int; '+
'select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = ''AIM.Database.SqlBatchTransactionSize''; '+
'select @maxid= max(tid) from #AIM_AccountTransaction; '+
'select @currentrow = 1; '+ 
'select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end; '+
'select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = ''AIM.Database.SqlBatchTransactionSize''; '+
'while @rowcount <= @maxid begin ' +
'UPDATE AIM_AccountTransaction SET TransactionTypeID = 3 FROM #AIM_AccountTransaction at JOIN AIM_AccountTransaction ATR WITH (NOLOCK) ON at.AccountTransactionID = ATR.AccountTransactionID '+
'WHERE at.tid BETWEEN @currentrow and @rowcount and UpdateFlag = 1; ' +
'select @currentrow = @rowcount + 1; '+
 'select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end; '+
'end'
EXEC(@executeSQL)

END
SET @executeSQL =
'UPDATE AIM_AccountReference SET ObjectionFlag = 0 ' + @sql
EXEC(@executeSQL)





END


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[AIM_Placement_UpdateTransactions]
(
	@agencyId   int
	,@batchFileHistoryId int
)
AS

BEGIN

declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

DECLARE @updateNumber int
DECLARE @updateFeeCode varchar(5)
DECLARE @LastPlacementDate DATETIME
SET @LastPlacementDate = GETDATE()


DECLARE @PlaceAccounts TABLE (ID INT IDENTITY(1,1) primary key,Number INT,AccountTransactionID INT,AccountReferenceID INT,FeeSchedule VARCHAR(5),CommissionPercentage FLOAT,Balance MONEY,Desk VARCHAR(10),
Balance1 MONEY,Balance2 MONEY,Balance3 MONEY,Balance4 MONEY,Balance5 MONEY,Balance6 MONEY,Balance7 MONEY,Balance8 MONEY,Balance9 MONEY,PlacedEquipmentCount INT,PlacedEquipmentValue MONEY)
INSERT INTO @PlaceAccounts (Number,AccountTransactionID,AccountReferenceID,FeeSchedule,CommissionPercentage,Balance,Desk,
Balance1 ,Balance2 ,Balance3 ,Balance4 ,Balance5 ,Balance6 ,Balance7 ,Balance8 ,Balance9,PlacedEquipmentCount,PlacedEquipmentValue)
SELECT
AR.ReferenceNumber,ATR.AccountTransactionID,AR.AccountReferenceID,
ATR.FeeSchedule,ATR.CommissionPercentage,Balance,ATR.Desk,
Current1,Current2,Current3,Current4,Current5,Current6,Current7,Current8,Current9,
Count(*),
SUM(ISNULL(eqp.Val,0))
FROM
master m WITH (NOLOCK) JOIN
AIM_AccountReference AR WITH (NOLOCK) ON m.Number = AR.ReferenceNumber
JOIN AIM_AccountTransaction ATR WITH (NOLOCK) ON AR.AccountReferenceID = ATR.AccountReferenceID
LEFT OUTER JOIN PBEquipment eqp WITH (NOLOCK) ON m.Number = eqp.Number
WHERE
ATR.TransactionStatusTypeID = 2
AND ATR.TransactionTypeID = 1
AND ATR.AgencyID = @AgencyID
AND ISNULL(eqp.Recovered,0) = 0
GROUP BY 
AR.ReferenceNumber,ATR.AccountTransactionID,AR.AccountReferenceID,
ATR.FeeSchedule,ATR.CommissionPercentage,Balance,ATR.Desk,
Current1,Current2,Current3,Current4,Current5,Current6,Current7,Current8,Current9

--UPDATE AIM ACCOUNT REFERENCE
select @maxid= max(id) from @PlaceAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin

	UPDATE  AIM_AccountReference 
	SET
	IsPlaced = 1,ObjectionFlag = 0,LastPlacementDate = @LastPlacementDate,
	ExpectedPendingRecallDate = DATEADD(Day,NumDaysPlacedBeforePending,GETDATE()),
	ExpectedFinalRecallDate = DATEADD(Day,NumDaysPlacedAfterPending,DATEADD(Day,NumDaysPlacedBeforePending,GETDATE())),
	FeeSchedule = CASE WHEN pa.FeeSchedule = 'null' THEN null ELSE pa.FeeSchedule END,
	CurrentlyPlacedAgencyID = @AgencyID,CurrentCommissionPercentage = pa.CommissionPercentage
	FROM
	AIM_AccountReference AR WITH (NOLOCK) JOIN @PlaceAccounts pa
	ON AR.AccountReferenceID = pa.AccountReferenceID
	where pa.id between @currentrow and @rowcount
		
	select @currentrow = @rowcount + 1
	select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
					   when @rowcount = @maxid then @maxid+1 
				  else @maxid end
end
	




--UPDATE AIM_ACCOUNT TRANSACTIONS
select @maxid= max(id) from @PlaceAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin
	UPDATE AIM_AccountTransaction 
	SET
	TransactionStatusTypeID = 3,
	CompletedDateTime = GETDATE(),
	Balance = pa.Balance,
	Balance1 = pa.Balance1,
	Balance2 = pa.Balance2,
	Balance3 = pa.Balance3,
	Balance4 = pa.Balance4,
	Balance5 = pa.Balance5,
	Balance6 = pa.Balance6,
	Balance7 = pa.Balance7,
	Balance8 = pa.Balance8,
	Balance9 = pa.Balance9,
	PlacedEquipmentCount = pa.PlacedEquipmentCount,
	PlacedEquipmentValue = pa.PlacedEquipmentValue,
	BatchFileHistoryID = @BatchFileHistoryID,
	LogMessageID = 2
	FROM @PlaceAccounts pa JOIN AIM_AccountTransaction atr WITH (NOLOCK)
	ON atr.AccountTransactionID  = pa.AccountTransactionID
	where pa.id between @currentrow and @rowcount
	
	select @currentrow = @rowcount + 1
	select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
					   when @rowcount = @maxid then @maxid+1 
				  else @maxid end
end



select @maxid= max(id) from @PlaceAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin

	INSERT INTO DeskChangeHistory (Number,JobNumber,OldDesk,NewDesk,OldQLevel,NewQLevel,OldQDate,NewQDate,OldBranch,NewBranch,[User],DMDateStamp)
	SELECT pa.number,0,m.Desk,pa.Desk,m.Qlevel,m.qlevel,m.qdate,m.qdate,m.branch,d.branch,'AIM',GETDATE()
	FROM @PlaceAccounts pa JOIN [Master] m ON pa.Number = m.number
	JOIN Desk d ON d.Code = pa.Desk
	WHERE pa.id between @currentrow and @rowcount AND pa.Desk IS NOT NULL

	select @currentrow=@rowcount+1
	select @rowcount= case when @rowcount+@sqlbatchsize<@maxid  then @rowcount+@sqlbatchsize
						   when @rowcount=@maxid then @maxid+1 
					  else @maxid end
end

select @maxid= max(id) from @PlaceAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin

	INSERT INTO NOTES(Created,action,result,number,comment,user0)
	SELECT getdate(),'DESK','CHNG',pa.number,'Desk Changed from ' + m.Desk + ' to ' + pa.Desk,'AIM' 
	FROM @PlaceAccounts pa JOIN [Master] m ON pa.Number = m.number
	JOIN Desk d ON d.Code = pa.Desk
	WHERE pa.id between @currentrow and @rowcount AND pa.Desk IS NOT NULL

	select @currentrow=@rowcount+1
	select @rowcount= case when @rowcount+@sqlbatchsize<@maxid  then @rowcount+@sqlbatchsize
						   when @rowcount=@maxid then @maxid+1 
					  else @maxid end
end

select @maxid= max(id) from @PlaceAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin

	UPDATE Master  with (rowlock) 
	SET AIMAgency = @agencyid,AIMAssigned = GETDATE(),FeeCode = pa.feeschedule,Desk = ISNULL(pa.Desk,master.Desk),Branch = ISNULL(d.Branch,master.Branch)
	from @PlaceAccounts pa
	join master on pa.number=master.number
	left outer join desk d on pa.desk = d.code
	where pa.id between @currentrow and @rowcount

	select @currentrow=@rowcount+1
	select @rowcount= case when @rowcount+@sqlbatchsize<@maxid  then @rowcount+@sqlbatchsize
						   when @rowcount=@maxid then @maxid+1 
					  else @maxid end
end

--INSERT NOTES
select @maxid= max(id) from @PlaceAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin

	INSERT INTO Notes with (rowlock) (Number,Created,User0,Action,Result,Comment) 
	SELECT pa.Number,GETDATE(),'AIM','+++++','+++++','This account has been placed with outsource agency '+A.Name+'('+cast(A.AgencyID as varchar(8))+') on '+
				cast(ar.LastPlacementDate as varchar(12))+' with a balance of '+cast(isnull(pa.Balance,0) as varchar(12))+
				' with a pending recall date of '+isnull(cast(ExpectedPendingRecallDate as varchar(11)),'none')
	FROM @PlaceAccounts pa
	JOIN AIM_AccountReference ar WITH (NOLOCK)
	ON AR.AccountReferenceID = pa.AccountReferenceID,AIM_Agency A WITH (NOLOCK) 
	WHERE A.AgencyID = @AgencyID 
	and pa.id between @currentrow and @rowcount

	select @currentrow=@rowcount+1
	select @rowcount= case when @rowcount+@sqlbatchsize<@maxid  then @rowcount+@sqlbatchsize
						   when @rowcount=@maxid then @maxid+1 
					  else @maxid end
end


END

GO

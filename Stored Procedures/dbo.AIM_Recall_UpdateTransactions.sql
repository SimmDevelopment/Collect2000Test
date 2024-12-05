SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[AIM_Recall_UpdateTransactions]

@AgencyID   INT,
@BatchFileHistoryID INT

AS
BEGIN

--11/20/2007 KMG Modifed to use a cursor to update master instead of a bulk update
--3/3/2008 KMG Modified to use temp tables for better efficiency
--9/9/9 KMG Modified to update AIM_AccountReference to NULL ON FINAL RECALL ONLY
declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

DECLARE @AgencyTier INT
SELECT @AgencyTier = AgencyTier FROM AIM_Agency WHERE AgencyID = @AgencyID
--CREATE TEMP TABLE OF ACCOUNTS
DECLARE @RecallAccounts TABLE (ID INT IDENTITY(1,1) primary key,Number INT,TransactionTypeID INT,RecallReasonCodeID INT,AccountTransactionID INT,Balance MONEY,AccountReferenceID INT,CreatedDateTime DATETIME,Desk VARCHAR(10))

--LOAD TEMP TABLE
INSERT INTO @RecallAccounts (Number,TransactionTypeID,RecallReasonCodeID,AccountTransactionID,AccountReferenceID,CreatedDateTime,Desk)
SELECT AR.ReferenceNumber,ATR.TransactionTypeID,ATR.RecallReasonCodeID,ATR.AccountTransactionID,ATR.AccountReferenceID,ATR.CreatedDateTime,ATR.Desk
FROM AIM_AccountReference AR WITH (NOLOCK)
JOIN AIM_AccountTransaction ATR WITH (NOLOCK) 
ON AR.AccountReferenceID = ATR.AccountReferenceID
WHERE ATR.TransactionStatusTypeID = 4
AND ATR.TransactionTypeID IN (2,3)
AND ATR.AgencyID = @AgencyID
AND AR.CurrentlyPlacedAgencyID = @AgencyID

--UPDATE TEMP WITH Master Balance
UPDATE @RecallAccounts
SET
Balance = Current0
FROM @RecallAccounts RA
JOIN [Master] M WITH (NOLOCK) 
ON M.Number = RA.Number


--INSERT NOTES

--UPDATE AIM Account Reference
select @maxid= max(id) from @RecallAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin
	UPDATE  AIM_AccountReference 
	SET 
	ObjectionFlag = 0,
	IsPlaced = CASE RA.TransactionTypeID WHEN 2 THEN IsPlaced WHEN 3 THEN 0 END,
	LastRecallDate = CASE RA.TransactionTypeID WHEN 2 THEN LastRecallDate WHEN 3 THEN GETDATE() END,
	ExpectedPendingRecallDate = NULL,
	ExpectedFinalRecallDate = CASE RA.TransactionTypeID WHEN 2 THEN ExpectedFinalRecallDate WHEN 3 THEN NULL END,
	CurrentlyPlacedAgencyID = CASE RA.TransactionTypeID WHEN 2 THEN CurrentlyPlacedAgencyID WHEN 3 THEN NULL END,
	NumDaysPlacedBeforePending = CASE RA.TransactionTypeID WHEN 2 THEN NumDaysPlacedBeforePending WHEN 3 THEN NULL END,
	NumDaysPlacedAfterPending = CASE RA.TransactionTypeID WHEN 2 THEN NumDaysPlacedAfterPending WHEN 3 THEN NULL END,
	CurrentCommissionPercentage = CASE RA.TransactionTypeID WHEN 2 THEN CurrentCommissionPercentage WHEN 3 THEN NULL END,
	FeeSchedule = CASE RA.TransactionTypeID WHEN 2 THEN FeeSchedule WHEN 3 THEN NULL END,
	LastTier = CASE RA.TransactionTypeID WHEN 2 THEN LastTier WHEN 3 THEN CASE WHEN cl.ReversePlacement = 1 OR cl.AvailableForSameTier = 1 THEN LastTier ELSE @AgencyTier END END,
	RecallDesk = CASE RA.TransactionTypeID WHEN 2 THEN RecallDesk WHEN 3 THEN NULL END
	FROM @RecallAccounts RA
	JOIN AIM_AccountReference AR WITH (NOLOCK)
	ON RA.Number = AR.ReferenceNumber
	JOIN AIM_RecallReasonCode CL WITH (NOLOCK)
	ON RA.RecallReasonCodeID = CL.RecallReasonCodeID
	where RA.id between @currentrow and @rowcount

	select @currentrow = @rowcount + 1
	select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
						   when @rowcount = @maxid then @maxid+1 
					  else @maxid end
end


--UPDATE PREVIOUS PLACEMENT's VALIDPLACEMENT FLAG TO 0 IF THE RECALL REASON IS 
--OF TYPE 'REVERSEPLACEMENT' , ONLY DO THIS IF WE HAVE TO
IF EXISTS(SELECT TOP 1 * FROM @RecallAccounts RA JOIN AIM_RecallReasonCode R WITH (NOLOCK) ON RA.RecallReasonCodeID = R.RecallReasonCodeID WHERE R.ReversePlacement = 1)
BEGIN
	DECLARE @tempTransactionTable TABLE (AccountTransactionID INT,AccountReferenceID INT,CreatedDateTime DATETIME)
	INSERT INTO @tempTransactionTable (AccountTransactionID,AccountReferenceID,CreatedDateTime)
	SELECT AccountTransactionID,AccountReferenceId,CreatedDateTime 
	FROM @RecallAccounts RA 
	JOIN AIM_RecallReasonCode c WITH (NOLOCK) 
	ON c.RecallReasonCodeID = RA.RecallReasonCodeID AND c.ReversePlacement = 1
	WHERE RA.TransactionTypeId = 3
     
	DECLARE @tempUpdateIDs TABLE (tid int identity(1,1) primary key,accounttransactionid int)
	INSERT INTO @tempUpdateIDs (accounttransactionid )
	SELECT max(atr.accounttransactionid)
	FROM 
	AIM_AccountTransaction atr WITH (NOLOCK) 
	JOIN @tempTransactionTable tt 
	ON tt.accountreferenceid = atr.accountreferenceid AND tt.CreatedDateTime > atr.CompletedDateTime
	WHERE AgencyId = @agencyId 
	AND TransactionTypeId = 1 AND TransactionStatusTypeId = 3 AND ValidPlacement = 1
	GROUP BY atr.accountreferenceid
 
	select @maxid= max(tid) from @tempUpdateIDs
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

	while @rowcount <= @maxid
	begin
		UPDATE AIM_AccountTransaction  
		SET 
		ValidPlacement = 0 
		FROM @tempUpdateIDs t JOIN AIM_AccountTransaction at WITH (NOLOCK)
		ON t.accounttransactionid = at.accounttransactionid
		where t.tid between @currentrow and @rowcount

		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end

END
 

 
--UPDATE AIM Account Transaction
select @maxid= max(id) from @RecallAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin

	UPDATE  AIM_AccountTransaction 
	SET
	BatchFileHistoryID = @BatchFileHistoryID,
	TransactionStatusTypeID = 3,
	CompletedDateTime = GETDATE(),
	Balance = RA.Balance,
	LogMessageID = 2
	FROM @RecallAccounts RA
	JOIN AIM_AccountTransaction ATR WITH (NOLOCK)
	ON RA.AccountTransactionID = ATR.AccountTransactionID
	where RA.id between @currentrow and @rowcount

	select @currentrow = @rowcount + 1
	select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
						   when @rowcount = @maxid then @maxid+1 
					  else @maxid end
end

 
--DECLARE CURSOR FOR UPDATING MASTER

select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

select @maxid= max(id) from @RecallAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin

	INSERT INTO DeskChangeHistory (Number,JobNumber,OldDesk,NewDesk,OldQLevel,NewQLevel,OldQDate,NewQDate,OldBranch,NewBranch,[User],DMDateStamp)
	SELECT ra.number,0,m.Desk,ra.Desk,m.Qlevel,m.qlevel,m.qdate,m.qdate,m.branch,d.branch,'AIM',GETDATE()
	FROM @RecallAccounts ra JOIN [Master] m ON ra.Number = m.number
	JOIN Desk d ON d.Code = ra.Desk
	WHERE ra.id between @currentrow and @rowcount AND ra.Desk IS NOT NULL

	select @currentrow=@rowcount+1
	select @rowcount= case when @rowcount+@sqlbatchsize<@maxid  then @rowcount+@sqlbatchsize
						   when @rowcount=@maxid then @maxid+1 
					  else @maxid end
end

select @maxid= max(id) from @RecallAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin

	INSERT INTO NOTES(Created,action,result,number,comment,user0)
	SELECT getdate(),'DESK','CHNG',ra.number,'Desk Changed from ' + m.Desk + ' to ' + ra.Desk,'AIM' 
	FROM @RecallAccounts ra JOIN [Master] m ON ra.Number = m.number
	JOIN Desk d ON d.Code = ra.Desk
	WHERE ra.id between @currentrow and @rowcount AND ra.Desk IS NOT NULL

	select @currentrow=@rowcount+1
	select @rowcount= case when @rowcount+@sqlbatchsize<@maxid  then @rowcount+@sqlbatchsize
						   when @rowcount=@maxid then @maxid+1 
					  else @maxid end
end

select @maxid= max(id) from @RecallAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

while @rowcount <= @maxid
begin
	UPDATE Master  with (rowlock) SET AIMAgency = null,AIMAssigned = Null,FeeCode = null,Desk = ISNULL(ra.Desk,m.Desk),Branch = ISNULL(d.Branch,m.Branch) 
	from @RecallAccounts RA 
	join master m on ra.number = m.number
	left outer join desk d on ra.desk = d.code
	WHERE RA.TransactionTypeID = 3
	and AIMAgency is not null and ra.id between @currentrow and @rowcount

	select @currentrow=@rowcount+1
	select @rowcount= case when @rowcount+@sqlbatchsize<@maxid  then @rowcount+@sqlbatchsize
						   when @rowcount=@maxid then @maxid+1 
					  else @maxid end

end


select @maxid= max(id) from @RecallAccounts
select @currentrow = 1 
select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end


while @rowcount <= @maxid
begin
	INSERT INTO Notes with (rowlock) (Number,Created,User0,Action,Result,Comment)
	SELECT RA.Number,GETDATE(),'AIM','+++++','+++++',
	CASE RA.TransactionTypeID WHEN 2 THEN 'A pending recall has been sent to agency '+a.name+'('+cast(a.agencyId as varchar(8))+') on '+cast(getdate() as varchar(11))+' for this account.'
							  WHEN 3 THEN 'A final recall has been sent to agency '+a.name+'('+cast(a.agencyId as varchar(8))+') on '+cast(getdate() as varchar(11))+' for this account.' END
	FROM @RecallAccounts RA,AIM_Agency A WITH (NOLOCK) 
	WHERE A.AgencyID = @AgencyID 
	and	  RA.id between @currentrow and @rowcount

	select @currentrow = @rowcount + 1
	select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
						   when @rowcount = @maxid then @maxid+1 
					  else @maxid end
end


--Deactivate PDT for final recalled accounts
UPDATE AIM_PostDatedTransaction
SET Active = 0
FROM AIM_PostDatedTransaction PDT WITH (NOLOCK) JOIN @RecallAccounts ra
ON ra.Number = PDT.AccountID and ra.TransactionTypeID = 3

END

GO

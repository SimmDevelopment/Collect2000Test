SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AIM_SelectBatchFileHistory]
(@agencyId int
,@startdate datetime
,@enddate datetime)
AS

DECLARE @transactions TABLE (TransactionTypeID INT,BatchFileHistoryID INT,ISERROR INT)
INSERT INTO @transactions
SELECT
ATR.TransactionTypeID,
ATR.BatchFileHistoryID,
CASE WHEN ATR.LogMessageID is NULL THEN 0 WHEN ATR.LogMessageID = 2 THEN 0 ELSE 1 END
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN AIM_BatchFileHistory BFH WITH (NOLOCK)
ON ATR.BatchFileHistoryID = BFH.BatchFileHistoryID
JOIN AIM_Batch B WITH (NOLOCK)
ON BFH.BatchID = B.BatchID
WHERE BFH.AgencyID = @agencyid
AND B.CompletedDateTime BETWEEN @startdate AND @enddate
AND BFH.BatchFileTypeID NOT IN (4,17)
INSERT INTO @transactions
SELECT
ATR.TransactionTypeID,
ATR.BatchFileHistoryID,
1
FROM AIM_AccountTransactionError ATR WITH (NOLOCK)
JOIN AIM_BatchFileHistory BFH WITH (NOLOCK)
ON ATR.BatchFileHistoryID = BFH.BatchFileHistoryID
JOIN AIM_Batch B WITH (NOLOCK)
ON BFH.BatchID = B.BatchID
WHERE BFH.AgencyID = @agencyid
AND B.CompletedDateTime BETWEEN @startdate AND @enddate
AND BFH.BatchFileTypeID NOT IN (4,17)


SELECT
 	BFH.BatchFileHistoryID
	,B.CompletedDatetime as [Date]
	,CAST(LM.LogMessage as varchar(100)) as [Status]
	,ISNULL(TT.Name,BFT.Name) as [File Type]
	,COUNT(*) as [NumRecords]
	,SUM(t.ISERROR) as [NumErrors]
	,BFH.[FileName]
	,t.[TransactionTypeID]

FROM
AIM_BatchFileHistory BFH WITH (NOLOCK)
JOIN AIM_Batch B WITH (NOLOCK)
ON B.BatchID = BFH.BatchID
JOIN AIM_LogMessage LM WITH (NOLOCK) 
ON LM.LogMessageID = BFH.LogMessageID
JOIN @transactions t 
ON t.BatchFileHistoryID = BFH.BatchFileHistoryID
LEFT OUTER JOIN AIM_TransactionType TT WITH (NOLOCK) 
ON TT.TransactionTypeID = t.TransactionTypeID
LEFT OUTER JOIN AIM_BatchFileType BFT 
ON BFT.BatchFileTypeID = BFH.BatchFileTypeID
	
WHERE
BFH.AgencyID = @agencyid
AND B.CompletedDateTime between @startdate and @enddate
AND BFH.BatchFileTypeID NOT IN (4,17)
GROUP BY BFH.BatchFileHistoryID,B.CompletedDatetime,
CAST(LM.LogMessage AS VARCHAR(100)),TT.Name,BFH.FileName,
BFT.Name,t.TransactionTypeID

UNION

SELECT
	BFH.BatchFileHistoryID
	,B.CompletedDatetime as [Date]
	,CAST(LM.LogMessage as varchar(100)) as [Status]
	,BFT.Name as [File Type]
	,NumRecords
	,NumErrors
	,BFH.[FileName]
	,CASE BFH.BatchfileTypeID WHEN 4 THEN 6 WHEN 17 THEN 23 END 
FROM
AIM_BatchFileHistory BFH WITH (NOLOCK)
JOIN AIM_Batch B WITH (NOLOCK)
ON B.BatchID = BFH.BatchID
JOIN AIM_LogMessage LM WITH (NOLOCK) 
ON LM.LogMessageID = BFH.LogMessageID
JOIN AIM_BatchFileType BFT 
ON BFT.BatchFileTypeID = BFH.BatchFileTypeID
	
WHERE
BFH.AgencyID = @agencyid
AND B.CompletedDateTime between @startdate and @enddate
AND BFH.BatchFileTypeID IN (4,17)

UNION

SELECT 
	h.[BatchFileHistoryId],
	b.[CompletedDateTime] [Date],
	h.[ErrorOnOpening] [Status],
	f.[Name] [File Type],
	0,
	0,
	h.[FileName],
	0
FROM [dbo].[AIM_BatchFileHistory] h
INNER JOIN [dbo].[AIM_Batch] b
ON [b].[BatchId] = [h].[BatchId]
INNER JOIN [dbo].[AIM_LogMessage] lm
ON [lm].[LogMessageId] = [h].[LogMessageId]
INNER JOIN [dbo].[AIM_BatchFileType] f
ON [f].[BatchFileTypeId] = [h].[BatchFileTypeId]
WHERE h.[AgencyId] = @agencyId
AND b.[CompletedDateTime] BETWEEN @startdate AND @enddate
AND h.[ErrorOnOpening] IS NOT NULL
ORDER BY b.[CompletedDateTime] DESC

GO

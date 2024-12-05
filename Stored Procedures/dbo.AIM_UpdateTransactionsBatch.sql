SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_UpdateTransactionsBatch]
@transactionTypeID INT,
@AgencyID   INT,
@BatchFileHistoryID INT

AS

BEGIN

DECLARE @sqlBatchSize INT
SELECT @sqlBatchSize = CAST(CAST([Value] AS VARCHAR) AS INT)
FROM AIM_AppSetting
WHERE [Key] = 'AIM.Database.SqlBatchTransactionSize'

CREATE TABLE #AIMCompletedAccounts(ID INT IDENTITY(1,1) primary key,AccountTransactionID INT,Number INT,Balance MONEY)

DECLARE @executeSQL VARCHAR(8000)
SET @executeSQL =
'INSERT INTO #AIMCompletedAccounts (AccountTransactionID,Number)
SELECT TOP ' + CAST(@sqlbatchsize AS VARCHAR) + ' 
ATR.AccountTransactionID,AR.ReferenceNumber
FROM AIM_AccountReference AR WITH (NOLOCK)
JOIN AIM_AccountTransaction ATR WITH (NOLOCK) 
ON AR.AccountReferenceID = ATR.AccountReferenceID 
AND ATR.TransactionStatusTypeID = 4
AND ATR.AgencyID = ' + CAST(@AgencyID AS VARCHAR) + '
AND ATR.TransactionTypeID = ' + CAST(@transactionTypeID AS VARCHAR)

EXEC(@executeSQL)

UPDATE #AIMCompletedAccounts
SET
Balance = Current0
FROM #AIMCompletedAccounts RA
JOIN [Master] M WITH (NOLOCK) 
ON M.Number = RA.Number


UPDATE  AIM_AccountTransaction 
SET
BatchFileHistoryID = @BatchFileHistoryID,
TransactionStatusTypeID = 3,
CompletedDateTime = GETDATE(),
Balance = ACA.Balance,
LogMessageID = 2
FROM #AIMCompletedAccounts ACA
JOIN AIM_AccountTransaction ATR WITH (NOLOCK)
ON ACA.AccountTransactionID = ATR.AccountTransactionID

DECLARE @RETURNVALUE INT
SELECT @RETURNVALUE = COUNT(*)
FROM
AIM_AccountReference AR WITH (NOLOCK) JOIN AIM_AccountTransaction ATR WITH (NOLOCK)
ON AR.AccountReferenceID = ATR.AccountReferenceID
WHERE
ATR.TransactionStatusTypeID = 4
AND ATR.TransactionTypeID = @transactionTypeID
AND ATR.AgencyID =@AgencyID
--AND AR.CurrentlyPlacedAgencyID = @AgencyID

DROP TABLE #AIMCompletedAccounts;

            
RETURN @RETURNVALUE
END 
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_RequestAndResponse_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS

BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId

SELECT
	  'CRAR' as [record_type]
	  ,rar.AccountID as [file_number]
      ,req.Code as [request_code]
	  ,res.Code as [response_code]
	  ,CASE WHEN RequestOrigination IS NOT NULL THEN rar.OutsideRequestID ELSE rar.ID END as [request_id]
	  ,CASE WHEN RequestOrigination IS NULL AND ResponseID IS NULL THEN RequestText ELSE ResponseText END as [text]
      
FROM #AIMExecutingExportTransactions [temp] 
JOIN AIM_RequestsAndResponses rar WITH (NOLOCK) 
ON rar.ID = [temp].foreigntableuniqueid
JOIN AIM_RequestCode req WITH (NOLOCK) ON req.ID = rar.RequestID
LEFT OUTER JOIN AIM_ResponseCode res WITH (NOLOCK) ON rar.ResponseID = res.ID


UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions rar ON rar.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END

GO

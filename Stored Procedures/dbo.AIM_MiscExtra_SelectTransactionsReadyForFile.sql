SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_MiscExtra_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS

BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId



	SELECT
		    'CMIS' as record_type,
			m.number as [file_number],
			ma.account as [account],
			m.title as [title],
			m.thedata as [thedata]
	FROM #AIMExecutingExportTransactions [temp]
	JOIN miscextra m WITH (NOLOCK) ON [temp].[ForeignTableUniqueID] = m.ID
	JOIN master ma WITH (NOLOCK) ON m.Number = ma.Number

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END

GO

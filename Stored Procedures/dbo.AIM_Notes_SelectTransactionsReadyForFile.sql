SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Notes_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS

BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId


	SELECT 
		'CNOT' as record_type,
		n.number as file_number,
		created as created_datetime,
		action as note_action,
		result as note_result,
		--n.comment as note_comment
		[dbo].[fnRemoveUnwantedCharsFromNoteComment](n.uid) as note_comment
	FROM #AIMExecutingExportTransactions [temp]
	JOIN Notes n  WITH (NOLOCK) ON [temp].[ForeignTableUniqueID] = N.UID
	ORDER BY n.UID

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END

GO

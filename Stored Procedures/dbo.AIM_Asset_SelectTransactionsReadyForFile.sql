SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Asset_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS
BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId

SELECT 
'CAST' as record_type,
da.DebtorID as [debtor_number],
da.AccountID as [file_number],
CASE WHEN da.CreatedBy = 'AIM' THEN da.OutsideAssetID ELSE da.ID END as [asset_id],
da.AssetType as [asset_type_id],
da.Name as [asset_name],
da.Description as [asset_description],
ISNULL(da.CurrentValue,0) as [asset_value],
ISNULL(da.LienAmount,0) as [asset_lien_value],
CASE da.ValueVerified WHEN 1 THEN 'T' ELSE 'F' END as [asset_value_verified_flag],
CASE da.LienVerified WHEN 1 THEN 'T' ELSE 'F' END as [asset_lien_value_verified_flag]
FROM #AIMExecutingExportTransactions a
JOIN [Debtor_Assets] da WITH (NOLOCK) ON da.ID = a.foreigntableuniqueid




UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions

END

GO

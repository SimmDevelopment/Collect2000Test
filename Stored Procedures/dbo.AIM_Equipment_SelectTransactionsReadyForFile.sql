SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Equipment_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS

BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId

      SELECT
                'CEQP' as record_type
                  ,e.number as [file_number]
                  ,[Act#]
                  ,[Collat_desc]
                  ,[Lic#]
                  ,[Vin#]
                  ,[Yr]
                  ,[Mk]
                  ,[Mdl]
                  ,[Ser]
                  ,[Color]
                  ,[Key_CD]
                  ,[Cond]
                  ,[Loc]
                  ,[tag#]
                  ,[Dlr#]
                  ,[PLN_CD]
                  ,[Repo_DT]
                  ,[DSP_DT]
                  ,[Ins]
                  ,[Prd_Cmplt#]
                  ,[Val]
                  ,[UCC_CD]
                  ,[Fil_DT]
                  ,[Fil_Loc]
                  ,[X_COll]
                  ,[LN#]
                  ,[Rec_Mthd_CD]
                  ,[Reas_CD]
                  ,[Typ_CO_CD]
                  ,[DSP_CD]
                  ,[DSP_ANAL]
                  ,CASE isnull([Recovered],0) WHEN 0 THEN 'F' WHEN 1 THEN 'T' ELSE 'F' END as [Recovered]
                  ,[RecoveredDate] as RecoveredDate
                  ,CASE isnull([Commissionable],0) WHEN 0 THEN 'F' WHEN 1 THEN 'T' ELSE 'F' END as [Commissionable]
                  ,[WhenLoaded]as [WhenLoaded]
                  ,[UID] as equipment_id
                  ,'' as Filler
      FROM #AIMExecutingExportTransactions [temp]
      JOIN PBEquipment e with (nolock) ON [temp].[ForeignTableUniqueID] = e.UID
      

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions

END

GO

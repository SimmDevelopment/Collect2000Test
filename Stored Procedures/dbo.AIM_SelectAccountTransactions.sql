SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                procedure [dbo].[AIM_SelectAccountTransactions]
(
      @referenceNumber   int
)
as
begin

select 
	tt.Name as [Transaction Type]
	,a.Name as [Agency/Attorney]
	,atr.CompletedDateTime as [Date] 
	,cast(lm.LogMessage as varchar(8000)) as [Message] 
	,atr.Balance
	,ar.ReferenceNumber as [Account ID]  
	,isnull(cast(atr.TransactionContext as varchar(8000)),'<Record><Data>Check History for Data</Data></Record>' )as [Transaction Context] 
	,newid() as [AccountTransactionID]
from dbo.AIM_AccountReference ar with (nolock)  
INNER JOIN  dbo.AIM_AccountTransaction atr with (nolock)  ON  ar.AccountReferenceId =  atr.AccountReferenceId 
INNER JOIN  dbo.AIM_Agency a with (nolock) ON  a.AgencyId =  atr.AgencyId 
INNER JOIN  dbo.AIM_TransactionType tt with (nolock)  ON  tt.TransactionTypeId =  atr.TransactionTypeId 
LEFT OUTER JOIN  dbo.AIM_LogMessage lm with (nolock)  ON  lm.LogMessageId =  isnull(atr.LogMessageId,2)
where ar.referencenumber = @referencenumber

UNION

SELECT
	'Import Reconciliation Check' as [Transaction Type]
	,a.Name						 as [Agency/Attorney]
	,b.CompletedDateTime as [Date]
	,'Processed' as [Message] 
	,rec.[Current] as [Balance]
	,rec.Number as [Account ID]
	,'<Record><Data>Run Processing Report for Data</Data></Record>'as [Transaction Context] 
	,newid() as [AccountTransactionID]
FROM dbo.AIM_Reconciliation rec WITH (NOLOCK)
INNER JOIN  dbo.AIM_Agency a with (nolock) ON  a.AgencyId =  rec.AgencyId 
INNER JOIN  dbo.AIM_BatchFileHistory bfh with (nolock) ON  bfh.BatchfileHistoryID = rec.BatchFileHistoryID
INNER JOIN dbo.AIM_Batch b WITH (NOLOCK) ON b.BatchID = bfh.BatchID
WHERE rec.Number = @referencenumber

UNION
SELECT
	'Import Acknowledgement' as [Transaction Type]
	,a.Name						 as [Agency/Attorney]
	,b.CompletedDateTime as [Date]
	,'Processed' as [Message] 
	,rec.[Current] as [Balance]
	,rec.Number as [Account ID]
	,'<Record><Data>Run Processing Report for Data</Data></Record>'as [Transaction Context] 
	,newid() as [AccountTransactionID]
FROM dbo.AIM_Acknowledgment rec WITH (NOLOCK)
INNER JOIN  dbo.AIM_Agency a with (nolock) ON  a.AgencyId =  rec.AgencyId 
INNER JOIN  dbo.AIM_BatchFileHistory bfh with (nolock) ON  bfh.BatchfileHistoryID = rec.BatchFileHistoryID
INNER JOIN dbo.AIM_Batch b WITH (NOLOCK) ON b.BatchID = bfh.BatchID
WHERE rec.Number = @referencenumber

UNION

SELECT
'YGC Import Record Type ' + RecordType as [Transaction Type],
YGCID as [Agency/Attorney],
DateTimeEntered as [Date],
'Processed, no errors' as [Message],
Balance,
AccountID as [Account ID],
'<Record><Data>Check Legal Panel for Data</Data></Record>' as [Transaction Context],
ID as [AccountTransactionID]
from LatitudeLegal_Transactions
WHERE AccountID = @referenceNumber
ORDER BY atr.CompletedDateTime DESC

end

GO

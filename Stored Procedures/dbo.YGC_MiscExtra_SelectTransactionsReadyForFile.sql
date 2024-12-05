SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[YGC_MiscExtra_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS
BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId

DECLARE @AIMYGCID VARCHAR(8)
SELECT @AIMYGCID = alphacode FROM AIM_agency WITH (NOLOCK)
WHERE AgencyID = @agencyId;

DECLARE @myyougotclaimsid VARCHAR(8)
SELECT  
@myyougotclaimsid = yougotclaimsid
FROM controlfile;
	
SELECT            
		'09'						as [Record Code],
		m.number					as [FILENO],
		m.account					as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		getdate()					as PDATE, 
		'*CC:W122'					as PCODE,
		'Miscellaneous Extra Data:TITLE=' + me.title+'|DATA='+me.thedata as PCMT

FROM #AIMExecutingExportTransactions [temp]
JOIN miscextra me with (nolock) ON [temp].foreigntableuniqueid = me.id
JOIN master m with (nolock) on me.number = m.number 


UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END

GO

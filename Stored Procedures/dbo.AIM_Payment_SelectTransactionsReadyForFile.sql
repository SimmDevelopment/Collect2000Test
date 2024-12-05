SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Payment_SelectTransactionsReadyForFile] 
(
	@agencyId INT,
	@transactionTypeID INT
)
AS
BEGIN

CREATE TABLE #AIMExecutingExportTransactions 
(AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
DECLARE @sqlbatchsize int
SELECT @sqlbatchsize = CAST(CAST(VALUE AS VARCHAR)AS INT) FROM Aim_AppSetting WHERE [Key] = 'AIM.Database.SqlBatchTransactionSize'

DECLARE @executeSQL VARCHAR(8000)
SET @executeSQL =
'INSERT INTO #AIMExecutingExportTransactions (AccountTransactionID,ForeignTableUniqueId)
SELECT TOP ' + cast(@sqlbatchsize as VARCHAR(16)) + ' AccountTransactionID,ForeignTableUniqueId
FROM	AIM_AccountReference AR WITH (NOLOCK)
	JOIN AIM_accounttransaction ATR WITH (NOLOCK,INDEX(IX_AIM_AccountTransaction_TransactionType)) ON ATR.AccountReferenceID = AR.AccountReferenceid
	
WHERE	atr.agencyid = ' + CAST(@agencyId as VARCHAR(8)) + ' 
	AND transactiontypeid = ' + CAST(@transactiontypeid AS VARCHAR(8)) + '
	AND transactionstatustypeid = 1
	AND ATR.AgencyID IS NOT NULL '

EXEC(@executeSQL)


DECLARE @agencyFileFormat VARCHAR(50)
SELECT @agencyFileFormat = FileFormat FROM AIM_Agency WHERE AgencyId = @agencyId
DECLARE @myyougotclaimsid VARCHAR(20),@AIMYGCID VARCHAR(10)
	
SELECT  
@myyougotclaimsid = yougotclaimsid
FROM controlfile;

SELECT
@AIMYGCID = AlphaCode
FROM AIM_Agency WHERE AgencyID = @agencyID;

--SELECT TRANSACTIONS FOR FILE

IF(@agencyFileFormat='YGC')
BEGIN
	SELECT            
		'12'						AS [Record Code],
		cast(substring(transactioncontext,charindex('<file_number>',transactioncontext)+13,charindex('</file_number>',transactioncontext)-charindex('<file_number>',transactioncontext)-13) as int)					AS [FILENO],
		substring(transactioncontext,charindex('<account>',transactioncontext)+9,charindex('</account>',transactioncontext)-charindex('<account>',transactioncontext)-9)				AS [FORW_FILE],
		null						AS [MASCO_FILE],
		@myyougotclaimsid			AS [FORW_ID],
		@AIMYGCID					AS FIRM_ID,
		Convert(varchar(8),cast(substring(atr.transactioncontext,charindex('<payment_date>',atr.transactioncontext)+14,charindex('</payment_date>',atr.transactioncontext)-charindex('<payment_date>',atr.transactioncontext)-14) as datetime),112)					AS DP_DATE,
		CASE substring(transactioncontext,charindex('<payment_type>',transactioncontext)+14,charindex('</payment_type>',transactioncontext)-charindex('<payment_type>',transactioncontext)-14)
		 WHEN 'PC' THEN 'Payment' WHEN 'PCR' THEN 'NSF' ELSE 'Adjustment' END AS DP_CMT,
		CASE substring(transactioncontext,charindex('<payment_type>',transactioncontext)+14,charindex('</payment_type>',transactioncontext)-charindex('<payment_type>',transactioncontext)-14)
		 WHEN 'DA' THEN cast(substring(transactioncontext,charindex('<payment_amount>',transactioncontext)+16,charindex('</payment_amount>',transactioncontext)-charindex('<payment_amount>',transactioncontext)-16) as money)
		 WHEN 'DAR' THEN -1*cast(substring(transactioncontext,charindex('<payment_amount>',transactioncontext)+16,charindex('</payment_amount>',transactioncontext)-charindex('<payment_amount>',transactioncontext)-16) as money)
			ELSE 0 END AS DP_MERCH,
		CASE substring(transactioncontext,charindex('<payment_type>',transactioncontext)+14,charindex('</payment_type>',transactioncontext)-charindex('<payment_type>',transactioncontext)-14)
		 WHEN 'PC' THEN cast(substring(transactioncontext,charindex('<payment_amount>',transactioncontext)+16,charindex('</payment_amount>',transactioncontext)-charindex('<payment_amount>',transactioncontext)-16) as money)
		 WHEN 'PCR' THEN -1*cast(substring(transactioncontext,charindex('<payment_amount>',transactioncontext)+16,charindex('</payment_amount>',transactioncontext)-charindex('<payment_amount>',transactioncontext)-16) as money)
		 ELSE 0 END AS DP_CASH,
		CASE substring(transactioncontext,charindex('<payment_type>',transactioncontext)+14,charindex('</payment_type>',transactioncontext)-charindex('<payment_type>',transactioncontext)-14)
		 WHEN 'PC' THEN cast(substring(transactioncontext,charindex('<payment_amount>',transactioncontext)+16,charindex('</payment_amount>',transactioncontext)-charindex('<payment_amount>',transactioncontext)-16) as money)
		 WHEN 'PCR' THEN -1*cast(substring(transactioncontext,charindex('<payment_amount>',transactioncontext)+16,charindex('</payment_amount>',transactioncontext)-charindex('<payment_amount>',transactioncontext)-16) as money)
		 ELSE 0 END AS DP_NOFEE
	FROM 	#AIMExecutingExportTransactions [temp]
	JOIN AIM_AccountTransaction atr WITH (NOLOCK) ON [temp].AccountTransactionID = atr.AccountTransactionID


END
ELSE
BEGIN
	SELECT 	'CPAY' AS record_type,
		pv.number AS file_number,
		substring(transactioncontext,charindex('<account>',transactioncontext)+9,charindex('</account>',transactioncontext)-charindex('<account>',transactioncontext)-9) AS account,
		pv.paid1 AS principle,
		pv.paid2 AS interest,
		pv.paid3 AS other3,
		pv.paid4 AS other4,
		pv.paid5 AS other5,
		pv.paid6 AS other6,
		pv.paid7 AS other7,
		pv.paid8 AS other8,
		pv.paid9 AS other9,
		pv.datepaid AS payment_date,
		substring(transactioncontext,charindex('<payment_type>',transactioncontext)+14,charindex('</payment_type>',transactioncontext)-charindex('<payment_type>',transactioncontext)-14) AS batch_type,
		pv.uid AS payment_identifier,
		pv.comment
	FROM 	#AIMExecutingExportTransactions [temp]
	JOIN AIM_AccountTransaction atr WITH (NOLOCK) ON [temp].AccountTransactionID = atr.AccountTransactionID
	JOIN payhistory pv WITH (NOLOCK) ON [temp].ForeignTableUniqueId = pv.UID
END


--UPDATE AIM_ACCOUNTTRANSACTION.TRANSACTIONSTATUSTYPE
--DIRECT PAYMENTS AND ADJUSTMENTS

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END
GO

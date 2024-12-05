SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[YGC_Bankruptcy_SelectTransactionsReadyForFile]
	@agencyId INT,
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
		'19'						as [Record Code],
		m.number					as [FILENO],
		m.account					as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		'00' + cast(d.SEQ+1 as char(1))	as DBTR_NUM,
		b.chapter					as CHAPTER,
		b.casenumber				as BK_FILENO,
		b.courtdistrict				as LOC,
		b.datefiled					as FILED_DATE,
		b.dismissaldate				as DSMIS_DATE,
		b.dischargedate				as DSCHG_DATE,
		null						as CLOSE_DATE,
		null						as CNVRT_DATE,
		convert(varchar(16),b.datetime341,121)			as MTG_341_DATETIME,
		b.location341				as MTG_341_LOC,
		null						as JUDGE_INIT,
		b.reaffirmamount			as REAF_AMT,
		b.reaffirmdatefiled			as REAF_DATE,
		null						as PAY_AMT,
		null						as PAY_DATE,
		null						as CONF_DATE,
		null						as CURE_DATE

FROM #AIMExecutingExportTransactions [temp] JOIN
	bankruptcy b with (nolock) ON b.BankruptcyId = [temp].ForeignTableUniqueId
JOIN [dbo].[AIM_AccountReference] ar WITH (NOLOCK) ON ar.referencenumber = b.accountid
JOIN [dbo].[AIM_AccountTransaction] atr WITH (NOLOCK) ON atr.accountreferenceid = ar.accountreferenceid and atr.foreigntableuniqueid = b.bankruptcyid
JOIN [dbo].[debtors] d WITH (NOLOCK) ON b.debtorid = d.debtorid AND d.seq <= 2
JOIN [dbo].[master] m WITH (NOLOCK) ON m.number = b.accountid

WHERE atr.transactiontypeid = @transactionTypeID and atr.transactionstatustypeid = 1
and atr.agencyid = @agencyid

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END

GO

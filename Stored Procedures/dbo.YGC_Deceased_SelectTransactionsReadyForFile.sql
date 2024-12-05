SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[YGC_Deceased_SelectTransactionsReadyForFile]
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
		'15'						as [Record Code],
		m.number					as [FILENO],
		m.account					as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		'00' + cast(d.SEQ+1 as char(1))	as DBTR_NUM,
		dec.dod						as DOD,
		dec.casenumber				as PRB_CASE_NO,
		dec.state					as PRB_ST,
		null						as PRB_CTY,
		dec.courtdistrict			as PRB_CRT,
		dec.datefiled				as PRB_DATE,
		dec.claimdeadline			as PRB_EXP,
		dec.executor				as REP_NAME,
		dec.executorstreet1			as REP_STRT1,
		dec.executorstreet2			as REP_STRT2,
		dec.executorcity			as REP_CITY,
		dec.executorstate			as REP_ST,
		dec.executorzipcode			as REP_ZIP,
		dec.executorphone			as REP_PHONE,
		null						as ATTY_NAME,
		null						as ATTY_FIRM,
		null						as ATTY_STRT1,
		null						as ATTY_STRT2,
		null						as ATTY_CITY,
		null						as ATTY_ST,
		null						as ATTY_ZIP,
		null						as ATTY_PHONE,
		null						as REP_CNTRY,
		null						as ATTY_CNTRY


FROM [dbo].[deceased] [dec] WITH (NOLOCK)
JOIN [dbo].[AIM_AccountReference] ar WITH (NOLOCK) ON ar.referencenumber = dec.accountid
JOIN [dbo].[AIM_AccountTransaction] atr WITH (NOLOCK) ON atr.accountreferenceid = ar.accountreferenceid and atr.foreigntableuniqueid = dec.id
JOIN [dbo].[debtors] d WITH (NOLOCK) ON d.debtorid = dec.debtorid AND d.seq <= 2
JOIN [dbo].[master] m WITH (NOLOCK) ON m.number = dec.accountid

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

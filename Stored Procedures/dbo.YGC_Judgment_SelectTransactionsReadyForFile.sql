SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[YGC_Judgment_SelectTransactionsReadyForFile]
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
		'07'						as [Record Code],
		cc.AccountID				as [FILENO],
		m.account					as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		c.county					as CRT_COUNTY,
		null						as CRT_DESIG,
		null						as CRT_TYPE,
		c.courtname					as SHER_NAME,
		c.clerklastname+', '+c.clerkfirstname as SHER_NAME2,
		c.address1 + ' '+c.address2 as SHER_STREET,
		c.city+', '+c.state+', '+c.zipcode as SHER_CSZ,
		null 						as SUIT_AMT,
		null 						as CNTRCT_FEE,
		null 						as STAT_FEE,
		null 						as DOCKET_NO,
		cc.casenumber				as JDGMNT_NO,
		null						as BKCY_NO,
		null						as SUIT_DATE,
		cc.judgementdate			as JDGMNT_DATE,
		cc.judgementintrate			as JDGMNT_AMT,
		cc.judgementamt				as JUDG_PRIN,
		m.interestrate				as PREJ_INT,
		cc.judgementcostaward		as JDG_COSTS,
		null						as ADJUSTMENT,
		null						as SHER_CNTRY
FROM #AIMExecutingExportTransactions j 
join [dbo].[courtcases] cc with(nolock) on j.foreigntableuniqueid = cc.CourtCaseID
join [dbo].[courts] c with(nolock) on c.courtid = cc.courtid
join master m with (nolock) on cc.AccountID = m.number


UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END

GO

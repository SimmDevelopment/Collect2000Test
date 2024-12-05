SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[YGC_Asset_SelectTransactionsReadyForFile]
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
		'16'							as [Record Code],
		m.number						as [FILENO],
		m.account						as [FORW_FILE],
		null							as [MASCO_FILE],
		@myyougotclaimsid				as [FORW_ID],
		@AIMYGCID						as FIRM_ID,
		'00' + cast(d.SEQ+1 as char(1))	as DBTR_NUM,
		da.ID							AS ASSET_ID,
		d.Name							AS ASSET_OWNER,
		d.Street1 						AS STREET,
		d.Street2 						AS STREET_2,
		NULL							AS STREET_3,
		d.City							AS CITY,
		NULL 							AS TOWN,
		NULL 							AS CNTY,
		d.State							AS STATE,
		d.Zipcode						AS ZIP,
		NULL 							AS CNTRY,
		NULL 							AS PHONE,
		NULL 							AS BLOCK,
		NULL 							AS LOT,
		da.currentvalue					AS ASSET_VALUE,
		da.Name + ' ' + da.Description	AS ASSET_DESC,
		NULL 							AS ASSET_VIN,
		NULL 							AS ASSET_LIC_PLATE,
		NULL 							AS ASSET_COLOR,
		NULL 							AS ASSET_YEAR,
		NULL 							AS ASSET_MAKE,
		NULL 							AS ASSET_MODEL,
		NULL 							AS REPO_FILE_NUM,
		NULL 							AS REPO_D,
		NULL 							AS REPO_AMT,
		NULL 							AS CERT_TITLE_NAME,
		NULL 							AS CERT_TITLE_D,
		NULL 							AS MORT_FRCL_D,
		NULL 							AS MORT_FRCL_FILENO,
		NULL 							AS MORT_FRCL_DISMIS_D,
		NULL 							AS MORT_PMT,
		NULL 							AS MORT_RATE,
		NULL 							AS MORT_BOOK_1,
		NULL 							AS MORT_PAGE_1,
		NULL 							AS MORT_BOOK_2,
		NULL 							AS MORT_PAGE_2,
		NULL 							AS MORT_RECRD_D,
		NULL 							AS MORT_DUE_D,
		NULL 							AS LIEN_FILE_NUM,
		NULL 							AS LIEN_CASE_NUM,
		NULL 							AS LIEN_D,
		NULL 							AS LIEN_BOOK,
		NULL 							AS LIEN_PAGE,
		NULL 							AS LIEN_AOL,
		NULL 							AS LIEN_RLSE_D,
		NULL 							AS LIEN_RLSE_BOOK,
		NULL 							AS LIEN_RLSE_PAGE,
		NULL 							AS LIEN_LITIG_D,
		NULL 							AS LIEN_LITIG_BOOK,
		NULL 							AS LIEN_LITIG_PAGE

FROM [debtor_assets] da WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions acct ON acct.foreigntableuniqueid = da.ID
JOIN master m WITH (NOLOCK) ON m.number = da.AccountID
JOIN debtors d WITH (NOLOCK) ON da.DebtorID = d.DebtorID

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions

	
END

GO

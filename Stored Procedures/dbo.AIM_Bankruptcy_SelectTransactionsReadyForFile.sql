SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Bankruptcy_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS
BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId

SELECT
	'CBKP' as record_type,
	b.debtorid as debtor_number,
	b.accountid as file_number,
	b.chapter as chapter,
	b.datefiled as date_filed,
	b.casenumber as case_number,
	b.courtdistrict as court_district,
	b.courtdivision as court_division,
	b.courtphone as court_phone,
	b.courtstreet1 as court_street1,
	b.courtstreet2 as court_street2,
	b.courtcity as court_city,
	b.courtstate as court_state,
	rtrim(ltrim(replace(replace(b.courtzipcode,'-',''),' ',''))) as court_zipcode,
	b.trustee as trustee,
	b.trusteestreet1 as trustee_street1,
	b.trusteestreet2 as trustee_street2,
	b.trusteecity as trustee_city,
	b.trusteestate as trustee_state,
	rtrim(ltrim(replace(replace(b.trusteezipcode,'-',''),' ',''))) as trustee_zipcode,
	b.trusteephone as trustee_phone,
	cast(CASE WHEN b.has341info = 1 THEN '1' ELSE '0' END as varchar(1)) as three_forty_one_info_flag,
	b.datetime341 as three_forty_one_date,
	b.location341 as three_forty_one_location,
	b.comments as comments,
	b.status as status,
	b.transmitteddate as transmit_date,
	[DateNotice] AS notice_date,
	[ProofFiled] AS proof_filed_date,
	[DischargeDate] AS discharge_date,
	[DismissalDate] AS dismissal_date,
	[ConfirmationHearingDate] AS confirmation_hearing_date,
	[ReaffirmDateFiled] AS reaffirm_filed_date,
	[VoluntaryDate] AS voluntary_date,
	[SurrenderDate] AS surrender_date,
	[AuctionDate] AS auction_date,
	[ReaffirmAmount] AS reaffirm_amount,
	[VoluntaryAmount] AS voluntary_amount,
	AuctionAmount AS auction_amount,
	AuctionFee AS auction_fee_amount,
	AuctionAmountApplied AS auction_applied_amount,
	SecuredAmount AS secured_amount,
	SecuredPercentage AS secured_percentage,
	UnsecuredAmount AS unsecured_amount,
	UnsecuredPercentage AS unsecured_percentage,
	ConvertedFrom AS converted_from_chapter,
	CASE HasAsset WHEN 1 THEN '1' ELSE '0' END AS has_asset,
	Reaffirm AS reaffirm_flag,
	[ReaffirmTerms] AS reaffirm_terms,
	VoluntaryTerms AS voluntary_terms,
	[SurrenderMethod] AS surrender_method,
	AuctionHouse AS auction_house


FROM #AIMExecutingExportTransactions [temp] JOIN
	bankruptcy b with (nolock) ON b.BankruptcyId = [temp].ForeignTableUniqueId
	
		
UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions

END

GO

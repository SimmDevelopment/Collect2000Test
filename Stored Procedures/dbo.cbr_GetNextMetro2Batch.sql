SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description:	Returns the next set of records for credit reporting...
-- =============================================
CREATE   PROCEDURE [dbo].[cbr_GetNextMetro2Batch] @BatchSize INTEGER = 50000, @ReportChangesOnly BIT = 1
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Err int
--change to temp table #CBRAccounts
IF NOT OBJECT_ID('tempdb..#CBRAccounts') IS NULL DROP TABLE #CBRAccounts;

CREATE TABLE #CBRAccounts  (
	[AccountID] INTEGER NOT NULL
);

-- Lets clean the cbr_config_customer table...
EXEC @Err = cbr_config_customer_CLEAN
SET @Err = @@ERROR
IF @Err > 0 
	PRINT 'Error occurred (' + CAST(@Err AS varchar(10)) + ') running cbr_config_customer_CLEAN.'
SET ROWCOUNT @BatchSize;

IF NOT EXISTS (SELECT TOP 1 * FROM cbrCustomGroup)

	INSERT INTO #CBRAccounts ([AccountID])
	SELECT DISTINCT [a].[accountID]
	FROM [dbo].[cbr_accounts] AS [a]
	INNER JOIN [dbo].[Master] AS [m] 
		ON [a].[accountID] = [m].[number]
	INNER JOIN [dbo].[status] AS [s] 
		ON [m].[status] = [s].[code]
	LEFT OUTER JOIN [dbo].[cbr_debtors] AS d	
		ON [a].[accountID] = [d].[accountID]
	WHERE [a].[written] = 0
	AND [m].[cbrPrevent] = 0
	AND [s].[cbrReport] = 1
	AND (@ReportChangesOnly = 0
		OR [a].[lastUpdated] > coalesce([a].[lastReported],'01/01/1900')
		OR [d].[lastUpdated] > coalesce([a].[lastReported],'01/01/1900'))
ELSE
		
	INSERT INTO #CBRAccounts ([AccountID])
	SELECT DISTINCT [a].[accountID]
	FROM [dbo].[cbr_accounts] AS [a]
	INNER JOIN cbrCustomGroup AS [g] 
		ON [g].[number] = [a].[accountID]
	INNER JOIN [dbo].[Master] AS [m]
		ON [g].[number] = [m].[number]
	INNER JOIN [dbo].[status] AS [s] 
		ON [m].[status] = [s].[code]
	LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d]	
		ON [m].[number] = [d].[accountID]
	WHERE [a].[written] = 0
	AND [m].[cbrPrevent] = 0
	AND [s].[cbrReport] = 1
	AND (@ReportChangesOnly = 0
		OR [a].[lastUpdated] > coalesce([a].[lastReported],'01/01/1900')
		OR [d].[lastUpdated] > coalesce([a].[lastReported],'01/01/1900'));


SET ROWCOUNT 0;

WITH ReportDebtors AS
(
SELECT d.debtorid, d.number, d.Seq FROM [dbo].[Debtors] d  
WHERE d.number IN (Select AccountID FROM #CBRAccounts)
AND d.debtorid NOT IN ( select distinct h.debtorid from cbrDebtorHistory(null) h where h.debtorseq <> 0 AND h.ecoaCode IN ('T','X','W','Z') ) 
AND d.Seq <> 0),
ReportDebtorsPivot AS
(
SELECT number, [1] AS D1, [2] AS D2, [3] AS D3, [4] AS D4, [5] AS D5, [6] AS D6
FROM(SELECT d.number, d.debtorid, d.Seq FROM ReportDebtors d) AS sourceTable
PIVOT 
(MAX(sourceTable.DebtorID) FOR sourceTable.Seq IN ([1], [2], [3], [4], [5], [6])) PIV
),
Reports AS
(
SELECT [a].[accountID] AS [accountID], [a].[customerID] AS [customerID], [a].[primaryDebtorID] AS [primaryDebtorID], [a].[portfolioType] AS [portfolioType], [a].[accountType] AS [accountType], [a].[accountStatus] AS [accountStatus], [a].[originalLoan] AS [originalLoan], [a].[actualPayment] AS [actualPayment], [a].[currentBalance] AS [currentBalance], [a].[amountPastDue] AS [amountPastDue], [a].[termsDuration] AS [termsDuration], [a].[specialComment] AS [specialComment], [a].[complianceCondition] AS [complianceCondition], [a].[openDate] AS [openDate], 
[a].[billingDate] AS [billingDate], [a].[delinquencyDate] AS [delinquencyDate], [a].[closedDate] AS [closedDate], [a].[lastPaymentDate] AS [lastPaymentDate], 
[a].[originalCreditor] AS [originalCreditor], [a].[creditorClassification] AS [creditorClassification], [a].[written] AS [written], [a].[lastUpdated] AS [lastUpdated], [a].[lastReported] AS [lastReported], [a].[lastFileID] AS [lastFileID], [a].[batchID] AS [batchID], [a].[ConsumerAccountNumber] AS [ConsumerAccountNumber], [a].[ChargeOffAmount] AS [ChargeOffAmount], [a].[PaymentHistoryProfile] AS [PaymentHistoryProfile], [a].[PaymentHistoryDate] AS [PaymentHistoryDate], [a].[CreditLimit] AS [CreditLimit], [a].[SecondaryAgencyIdenitifier] AS [SecondaryAgencyIdenitifier], [a].[SecondaryAccountNumber] AS [SecondaryAccountNumber], [a].[MortgageIdentificationNumber] AS [MortgageIdentificationNumber],
[a].[PortfolioIndicator] AS [PortfolioIndicator], [a].[SoldToPurchasedFrom] AS [SoldToPurchasedFrom], [ccc].[cbr_config_id] AS [SetupID],
[c].[portfolioType] AS [c_portfolioType], [c].[accountType] AS [c_accountType], [c].[minBalance] AS [c_minBalance], [c].[waitDays] AS [c_waitDays], [c].[creditorClass] AS [c_creditorClass], [c].[principalOnly] AS [c_principalOnly], [c].[includeCodebtors] AS [c_includeCodebtors], [c].[deleteReturns] AS [c_deleteReturns],
[d0].[debtorID] AS [d0_debtorID], [d0].[transactionType] AS [d0_transactionType], [d0].[surname] AS [d0_surname], [d0].[firstName] AS [d0_firstName], [d0].[middleName] AS [d0_middleName], [d0].[generationCode] AS [d0_generationCode], [d0].[ssn] AS [d0_ssn], [d0].[dob] AS [d0_dob], [d0].[phone] AS [d0_phone], [d0].[ecoaCode] AS [d0_ecoaCode], [d0].[informationIndicator] AS [d0_informationIndicator], [d0].[countryCode] AS [d0_countryCode], [d0].[address1] AS [d0_address1], [d0].[address2] AS [d0_address2], [d0].[city] AS [d0_city], [d0].[state] AS [d0_state], [d0].[zipcode] AS [d0_zipcode], [d0].[addressIndicator] AS [d0_addressIndicator], [d0].[residenceCode] AS [d0_residenceCode], [d0].[lastUpdated] AS [d0_lastUpdated], [d0].[AuthorizedUserSegment] AS [d0_AuthorizedUserSegment],
[d1].[debtorID] AS [d1_debtorID], [d1].[transactionType] AS [d1_transactionType], [d1].[surname] AS [d1_surname], [d1].[firstName] AS [d1_firstName], [d1].[middleName] AS [d1_middleName], [d1].[generationCode] AS [d1_generationCode], [d1].[ssn] AS [d1_ssn], [d1].[dob] AS [d1_dob], [d1].[phone] AS [d1_phone], [d1].[ecoaCode] AS [d1_ecoaCode], [d1].[informationIndicator] AS [d1_informationIndicator], [d1].[countryCode] AS [d1_countryCode], [d1].[address1] AS [d1_address1], [d1].[address2] AS [d1_address2], [d1].[city] AS [d1_city], [d1].[state] AS [d1_state], [d1].[zipcode] AS [d1_zipcode], [d1].[addressIndicator] AS [d1_addressIndicator], [d1].[residenceCode] AS [d1_residenceCode], [d1].[lastUpdated] AS [d1_lastUpdated], [d1].[AuthorizedUserSegment] AS [d1_AuthorizedUserSegment],
[d2].[debtorID] AS [d2_debtorID], [d2].[transactionType] AS [d2_transactionType], [d2].[surname] AS [d2_surname], [d2].[firstName] AS [d2_firstName], [d2].[middleName] AS [d2_middleName], [d2].[generationCode] AS [d2_generationCode], [d2].[ssn] AS [d2_ssn], [d2].[dob] AS [d2_dob], [d2].[phone] AS [d2_phone], [d2].[ecoaCode] AS [d2_ecoaCode], [d2].[informationIndicator] AS [d2_informationIndicator], [d2].[countryCode] AS [d2_countryCode], [d2].[address1] AS [d2_address1], [d2].[address2] AS [d2_address2], [d2].[city] AS [d2_city], [d2].[state] AS [d2_state], [d2].[zipcode] AS [d2_zipcode], [d2].[addressIndicator] AS [d2_addressIndicator], [d2].[residenceCode] AS [d2_residenceCode], [d2].[lastUpdated] AS [d2_lastUpdated], [d2].[AuthorizedUserSegment] AS [d2_AuthorizedUserSegment],
[d3].[debtorID] AS [d3_debtorID], [d3].[transactionType] AS [d3_transactionType], [d3].[surname] AS [d3_surname], [d3].[firstName] AS [d3_firstName], [d3].[middleName] AS [d3_middleName], [d3].[generationCode] AS [d3_generationCode], [d3].[ssn] AS [d3_ssn], [d3].[dob] AS [d3_dob], [d3].[phone] AS [d3_phone], [d3].[ecoaCode] AS [d3_ecoaCode], [d3].[informationIndicator] AS [d3_informationIndicator], [d3].[countryCode] AS [d3_countryCode], [d3].[address1] AS [d3_address1], [d3].[address2] AS [d3_address2], [d3].[city] AS [d3_city], [d3].[state] AS [d3_state], [d3].[zipcode] AS [d3_zipcode], [d3].[addressIndicator] AS [d3_addressIndicator], [d3].[residenceCode] AS [d3_residenceCode], [d3].[lastUpdated] AS [d3_lastUpdated], [d3].[AuthorizedUserSegment] AS [d3_AuthorizedUserSegment],
[d4].[debtorID] AS [d4_debtorID], [d4].[transactionType] AS [d4_transactionType], [d4].[surname] AS [d4_surname], [d4].[firstName] AS [d4_firstName], [d4].[middleName] AS [d4_middleName], [d4].[generationCode] AS [d4_generationCode], [d4].[ssn] AS [d4_ssn], [d4].[dob] AS [d4_dob], [d4].[phone] AS [d4_phone], [d4].[ecoaCode] AS [d4_ecoaCode], [d4].[informationIndicator] AS [d4_informationIndicator], [d4].[countryCode] AS [d4_countryCode], [d4].[address1] AS [d4_address1], [d4].[address2] AS [d4_address2], [d4].[city] AS [d4_city], [d4].[state] AS [d4_state], [d4].[zipcode] AS [d4_zipcode], [d4].[addressIndicator] AS [d4_addressIndicator], [d4].[residenceCode] AS [d4_residenceCode], [d4].[lastUpdated] AS [d4_lastUpdated], [d4].[AuthorizedUserSegment] AS [d4_AuthorizedUserSegment],
[d5].[debtorID] AS [d5_debtorID], [d5].[transactionType] AS [d5_transactionType], [d5].[surname] AS [d5_surname], [d5].[firstName] AS [d5_firstName], [d5].[middleName] AS [d5_middleName], [d5].[generationCode] AS [d5_generationCode], [d5].[ssn] AS [d5_ssn], [d5].[dob] AS [d5_dob], [d5].[phone] AS [d5_phone], [d5].[ecoaCode] AS [d5_ecoaCode], [d5].[informationIndicator] AS [d5_informationIndicator], [d5].[countryCode] AS [d5_countryCode], [d5].[address1] AS [d5_address1], [d5].[address2] AS [d5_address2], [d5].[city] AS [d5_city], [d5].[state] AS [d5_state], [d5].[zipcode] AS [d5_zipcode], [d5].[addressIndicator] AS [d5_addressIndicator], [d5].[residenceCode] AS [d5_residenceCode], [d5].[lastUpdated] AS [d5_lastUpdated], [d5].[AuthorizedUserSegment] AS [d5_AuthorizedUserSegment],
[d6].[debtorID] AS [d6_debtorID], [d6].[transactionType] AS [d6_transactionType], [d6].[surname] AS [d6_surname], [d6].[firstName] AS [d6_firstName], [d6].[middleName] AS [d6_middleName], [d6].[generationCode] AS [d6_generationCode], [d6].[ssn] AS [d6_ssn], [d6].[dob] AS [d6_dob], [d6].[phone] AS [d6_phone], [d6].[ecoaCode] AS [d6_ecoaCode], [d6].[informationIndicator] AS [d6_informationIndicator], [d6].[countryCode] AS [d6_countryCode], [d6].[address1] AS [d6_address1], [d6].[address2] AS [d6_address2], [d6].[city] AS [d6_city], [d6].[state] AS [d6_state], [d6].[zipcode] AS [d6_zipcode], [d6].[addressIndicator] AS [d6_addressIndicator], [d6].[residenceCode] AS [d6_residenceCode], [d6].[lastUpdated] AS [d6_lastUpdated], [d6].[AuthorizedUserSegment] AS [d6_AuthorizedUserSegment]
FROM #CBRAccounts AS [ca]
INNER JOIN [dbo].[cbr_accounts] AS [a]
	ON [ca].[AccountID] = [a].[accountID]
INNER JOIN [dbo].[cbr_debtors] AS [d0]
	ON [d0].[debtorID] = [a].[primaryDebtorID]
INNER JOIN [dbo].[cbr_EffectiveConfiguration] AS [c]
	ON [c].[customerID] = [a].[customerID]
LEFT OUTER JOIN [dbo].[cbr_config_customer] AS [ccc]
	ON [ccc].[CustomerID] = [a].[customerID] AND [ccc].[enabled] = 1
LEFT OUTER JOIN ReportDebtorsPivot rdp 
	ON [ca].[AccountID] = rdp.number
LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d1]
	ON [d1].[accountID] = [a].[accountID] AND [d1].[DebtorID] = rdp.D1
LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d2]
	ON [d2].[accountID] = [a].[accountID] AND [d2].[DebtorID] = rdp.D2
LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d3]
	ON [d3].[accountID] = [a].[accountID] AND [d3].[DebtorID] = rdp.D3
LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d4]
	ON [d4].[accountID] = [a].[accountID] AND [d4].[DebtorID] = rdp.D4
LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d5]
	ON [d5].[accountID] = [a].[accountID] AND [d5].[DebtorID] = rdp.D5
LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d6]
	ON [d6].[accountID] = [a].[accountID] AND [d6].[DebtorID] = rdp.D6
)

SELECT DISTINCT * FROM Reports 
;

UPDATE [a]
SET [written] = 1
FROM [dbo].[cbr_accounts] AS [a]
INNER JOIN #CBRAccounts AS [ca]
ON [ca].[AccountID] = [a].[accountID];

RETURN 0;
GO

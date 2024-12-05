SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 01/20/2023
-- Description:	Exports reformatted placement file
-- Changes:		03/23/2023 BGM Added Order to Consumers portion so the debtors will load in sequence and prevent a Secondary as being the first records in the misc extra.
--				07/18/2023 BGM Count Equabli Placement files being sent with maintenance records in them by adding code for
--							sub records to look for an account record to create an entry in the placement file.
--				11/28/2023 BGM Updated fields and layout to version 3.4
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Placement_File_V34]
	-- Add the parameters for the stored procedure here

	--  Exec Custom_Equabli_Export_Placement_File_V34
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--Accounts
SELECT ceai.recordType, ceai.equabliAccountNumber, ceai.clientAccountNumber, ceai.equabliClientId, ceai.equabliPlacementId, ceai.agencyCycle, ceai.originalLenderCreditor,
ceai.currentLenderCreditor, ceai.originalAccountNumber, ceai.additionalAccountNumber, ceai.consentFlag, ceai.customerType, ceai.dateAccountOpened, ceai.dateLastPayment, 
ceai.lastPaymentAmount, ceai.dateAssigned, ceai.dateofdelinquency, ceai.chargeOffDate, ceai.lastPurchaseDate, ceai.lastCashAdvanceDate, ceai.lastBalanceTransferDate, 
ceai.interestAccuredPostChargeOff, ceai.feesAccuredPostChargeOff, ceai.postChargeOffPayments, ceai.postChargeOffCredits, ceai.postChargeOffFeesRate, ceai.postChargeOffInterestRate, 
ceai.preChargeOffPrincipal, ceai.preChargeOffInterest, ceai.preChargeOffInterestRate, ceai.preChargeOffFees, ceai.ChargeOffBalance, ceai.preChargeOffFeeRate, ceai.amountAssigned, 
ceai.principalAmountAssigned, ceai.interstAmountAssigned, ceai.lateFeesAmountAssigned, ceai.otherFeesAmountAssigned, ceai.lastPurchaseAmount, ceai.lastCashAdvanceAmount, 
ceai.lastBalanceTransferAmount, ceai.courtCostsAmountAssigned, ceai.attorneyFeesAmountAssigned, ceai.lastContactDatePreChargeOff, ceai.dateFirstDelinquency, 
ceai.accountLevelMilitaryStatus, ceai.accountLevelCeaseDesistFlag, ceai.productCode, ceai.postChargeOffUnpaidCharges, ceai.monthlyPaymentBeforeChargeoff, ceai.SOLDate, 
ceai.accountOpenLocation, ceai.applicationType, ceai.accountOpenIPAddress, ceai.debtSettlementFlag, ceai.affinity, ceai.debtType, ceai.productSubType, ceai.creditLimit, 
ceai.originalBal, ceai.appApr, ceai.loanReason, ceai.appId, ceai.originTerm, ceai.appReqLoanAmt, ceai.paymentUnitsPostCo, ceai.nsfUnitsPostCo, ceai.nsfDollarsPostCo, 
ceai.receivingMailedStatements, ceai.clientPortfolioId, ceai.bankruptcyStatus, ceai.isDeceased, ceai.isFraud, ceai.accountLevelOFACFlag, ceai.accountChannel, 
ceai.accountLevelAttorneyRepFlag, ceai.accountLevelCCCSFlag, ceai.accountLevelLitigiousFlag, ceai.preLegalTalkoff
FROM Custom_Equabli_Account_Info ceai WITH (NOLOCK)

--Consumers
SELECT ceci.recordType, ceci.equabliAccountNumber, ceci.clientAccountNumber, ceci.equabliClientId, ceci.clientConsumerNumber, ceci.equabliConsumerId, ceci.contactType, 
ceci.contactFirstName, ceci.contactMiddleName, ceci.contactLastName, ceci.contactBusinessName, ceci.contactSuffix, ceci.nationalIdentificationNumber, ceci.dateOfBirth, 
ceci.dateOfDeath, ceci.serviceBranch, ceci.militaryStatus, ceci.activeDutyStartDate, ceci.activeDutyEndDate, ceci.contactAlias, ceci.driversLicenseNumber, 
ceci.driversLicenseStateCode, ceci.preferredLanguage, ceci.contactDescription, ceci.isActive, ceci.isAuthorisedPayer, ceci.isSCRA, 
ISNULL(ceai.address1, ceai1.address1) AS address1, ISNULL(ceai.address2, ceai1.address2) AS address1, ISNULL(ceai.city, ceai1.city) AS city, 
ISNULL(ceai.country, ceai1.country) AS country, ISNULL(ceai.state, ceai1.state) AS state, ISNULL(ceai.zip, ceai1.zip) AS zip, 
ISNULL(ceai.addressStatus, ceai1.addressStatus) AS addressStatus, ISNULL(ceai.addressType, ceai1.addressType) AS addressType, 
ISNULL(ceai.addressUpdateDate, ceai1.addressUpdateDate) AS addressUpdateDate, ISNULL(ceai.isPrimaryAddress, ceai1.isPrimaryAddress) AS isPrimaryAddress, 
ISNULL(ceai.isVerified, ceai1.isVerified) AS isVerified, ISNULL(ceai.externalSystemId, ceai1.externalSystemId) AS addExternalSystemID,	
ceei.emailAddress, ceei.emailWorkFlag, ceei.optoutFlag, ceei.emailValidityFlag, ceei.consentFlag, ceei.consentDateTime, 
ceei.statusCode, ceei.isPrimary, ceei1.employerName, ceei1.employerAddress1, ceei1.employerAddress2, ceei1.employerCity, ceei1.employerState, 
ceei1.employerZipCode, ceei1.employerCountry, ceei1.employerPhone, ceei1.employerFax, ceei1.consumerIdentificationNumber AS empConsumerIdentificationNumber, ceei1.employerEmployeeFirstName, 
ceei1.employerEmployeeMiddleName, ceei1.employerEmployeeLastName, ceei1.employerPosition, ceei1.employerTitle, ceei1.employerCode, ceei1.employerManager, 
ceei1.employerEmployeeId, ceei1.employerDisclaimer, ceei1.employerPayrollDisclaimer, ceei1.employerWageBasis, ceei1.employerStatus, ceei1.employerDivisionCode, 
ceei1.employerEffectiveDate, ceei1.employerMostRecent, ceei1.employerLength, ceei1.employerTerminiation, ceei1.employerIsActive, ceei1.employerId, ceei1.amtConsumerWages,
cechi.communicationId, cechi.communicationChannel, cechi.communicationReason, cechi.communicationSubreason, cechi.communicationDate, cechi.communicationTime, cechi.communicationOutcome, 
cechi.communicationDirection, cechi.communicationDisposition, cechi.communicationDetails, cechi.discountPercentage, cechi.rpcReceivedFlag, cechi.rpcReceivedDate, 
cechi.complianceType AS commComplianceType, cechi.complianceSubType AS commComplianceSubType, cechi.complianceDate, cechi.complianceId, cechi.dateCommunicationUpdate, 
cechi.communicationUpdateTime, cechi.regulatoryBody AS commRegulatoryBody, cechi.commentRemark, ceci1.complianceType, ceci1.complianceSubType, 
ceci1.description AS compDescription, ceci1.filingDate, ceci1.complianceChannel, ceci1.complianceCreationMode, ceci1.complianceStatus, ceci1.resolutionNote, ceci1.resolvedDate, ceci1.contactDetails, 
ceci1.complianceReason, ceci1.validationRequiredFlag, ceci1.remark, ceci1.raisedDate, ceci1.regulatoryBody, ceci1.firstSLADate, ceci1.secondSLADate, ceci1.caseFileNumber, 
ceci1.bkPrincipal, ceci1.bkInterest, ceci1.bkFees, ceci1.totalAmount, ceci1.courtCity, ceci1.externalSystemId AS compExternalSystemID, ceci1.consumerIdentificationNumber AS compConsumerIdentificationNumber, ceci1.bankruptcyType, 
ceci1.complianceAction, ceci1.defendant, ceci1.balanceAtTimeOfEvent, ceci1.attorneyRetained, ceci1.attorneyDate, ceci1.attorneyType, ceci1.attorneyOfficeFax, ceci1.dueClaimProofDate, 
ceci1.filedClaimProofDate, ceci1.eventDate, ceci1.balanceAtTimeOfNotification, ceori.requestNumber AS oprequestRequestNumber, ceori.requestType, ceori.queueReasonCode, ceori.description AS oprequestDescription, 
ceori.requestSource, ceori.requestSourceId, ceori.requestDate, ceori.fulfillmentDate, ceori.requestStatus, ceori1.requestNumber AS opresponseRequestNumber, ceori1.responseSource, ceori1.responseSourceId, 
ceori1.responseStatus, ceori1.description AS opresponseDescription, ceori1.responseDate
FROM Custom_Equabli_Consumer_Info ceci WITH (NOLOCK) 
LEFT OUTER JOIN Custom_Equabli_Address_Info ceai WITH (NOLOCK) ON ceci.equabliConsumerId = ceai.equabliConsumerId AND ceai.addressStatus = 'A' AND ceai.isPrimaryAddress = 'Y'
LEFT OUTER JOIN Custom_Equabli_Address_Info ceai1 WITH (NOLOCK) ON ceci.equabliConsumerId = ceai1.equabliConsumerId AND ceai1.addressStatus = 'A' AND ceai1.isPrimaryAddress = 'N'
LEFT OUTER JOIN Custom_Equabli_Email_Info ceei WITH (NOLOCK) ON ceci.equabliConsumerId = ceei.equabliConsumerId AND ceei.isPrimary = 'Y'
LEFT OUTER JOIN Custom_Equabli_Employer_Info ceei1 WITH (NOLOCK) ON ceci.equabliConsumerId = ceei1.equabliConsumerId LEFT OUTER JOIN Custom_Equabli_CommunicationHistory_Info cechi WITH (NOLOCK) ON ceci.equabliConsumerId = cechi.equabliConsumerId
LEFT OUTER JOIN Custom_Equabli_Compliance_Info ceci1 WITH (NOLOCK) ON ceci.equabliConsumerId = ceci1.equabliConsumerId LEFT OUTER JOIN Custom_Equabli_OpRequest_Info ceori WITH (NOLOCK) ON ceci.equabliConsumerId = ceori.equabliConsumerId
LEFT OUTER JOIN Custom_Equabli_OpResponse_Info ceori1 WITH (NOLOCK) ON ceci.equabliConsumerId = ceori1.equabliConsumerId 
WHERE ceci.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)
ORDER BY ceci.equabliAccountNumber, ceci.contactType, ceci.equabliConsumerId

--Alt Address
SELECT '2Address' AS recordtype, ceai.equabliAccountNumber, ceai.clientAccountNumber, ceai.equabliClientId, ceai.clientConsumerNumber, 
ceai.equabliConsumerId, ceai.address1, ceai.address2, ceai.city, ceai.country, ceai.state, ceai.zip, ceai.addressStatus, ceai.addressType, 
ceai.addressUpdateDate, ceai.isPrimaryAddress, ceai.isVerified, ceai.externalSystemId AS add2ExternalSystemID
FROM Custom_Equabli_Address_Info ceai WITH (NOLOCK) 
WHERE ceai.addressStatus in ('F', 'S', 'U') AND ceai.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--Phones
SELECT cepi.recordType, cepi.equabliAccountNumber, cepi.clientAccountNumber, cepi.equabliClientId, cepi.clientConsumerNumber, 
cepi.equabliConsumerId, ceci.nationalIdentificationNumber, cepi.phoneNumber, cepi.phoneType, cepi.wirelessIndicator, cepi.isPrimary, cepi.doNotCallFlag, cepi.consentFlag, 
cepi.consentDateTime, cepi.phoneStatus, cepi.phoneUpdateDateTime, cepi.smsConsentFlag, cepi.smsConsentDate, cepi.externalSystemId AS phoneExternalSystemID
FROM Custom_Equabli_Phones_Info cepi WITH (NOLOCK) LEFT OUTER JOIN Custom_Equabli_Consumer_Info ceci WITH (NOLOCK)  ON cepi.equabliConsumerId = ceci.equabliConsumerId
WHERE ceci.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--SELECT cepi.recordType, cepi.equabliAccountNumber, cepi.clientAccountNumber, cepi.equabliClientId, cepi.clientConsumerNumber, 
--cepi.equabliConsumerId, cepi.phoneNumber, cepi.phoneType, cepi.wirelessIndicator, cepi.isPrimary, cepi.doNotCallFlag, cepi.consentFlag, 
--cepi.consentDateTime, cepi.phoneStatus, cepi.phoneUpdateDateTime, cepi.smsConsentFlag, cepi.smsConsentDate, cepi.externalSystemId,
--	cedpi.phone, CASE WHEN cedpi.weekdayno = '1' THEN 'Sunday' ELSE '' END AS Exc_Sunday, CASE WHEN cedpi.weekdayno = '1' THEN cedpi.excludedTimeFrom ELSE '' END AS Exc_Sunday_Start, CASE WHEN cedpi.weekdayno = '1' THEN cedpi.excludedTimeTo ELSE '' END AS Exc_Sunday_End,
--	CASE WHEN cedpi.weekdayno = '2' THEN 'Monday' ELSE '' END AS Exc_Monday, CASE WHEN cedpi.weekdayno = '2' THEN cedpi.excludedTimeFrom ELSE '' END AS Exc_Monday_Start, CASE WHEN cedpi.weekdayno = '2' THEN cedpi.excludedTimeTo ELSE '' END AS Exc_Monday_End,
--	CASE WHEN cedpi.weekdayno = '3' THEN 'Tuesday' ELSE '' END AS Exc_Tuesday, CASE WHEN cedpi.weekdayno = '3' THEN cedpi.excludedTimeFrom ELSE '' END AS Exc_Tuesday_Start, CASE WHEN cedpi.weekdayno = '3' THEN cedpi.excludedTimeTo ELSE '' END AS Exc_Tuesday_End,
--	CASE WHEN cedpi.weekdayno = '4' THEN 'Wednesday' ELSE '' END AS Exc_Wednesday, CASE WHEN cedpi.weekdayno = '4' THEN cedpi.excludedTimeFrom ELSE '' END AS Exc_Wednesday_Start, CASE WHEN cedpi.weekdayno = '4' THEN cedpi.excludedTimeTo ELSE '' END AS Exc_Wednesday_End,
--	CASE WHEN cedpi.weekdayno = '5' THEN 'Thursday' ELSE '' END AS Exc_Thursday, CASE WHEN cedpi.weekdayno = '5' THEN cedpi.excludedTimeFrom ELSE '' END AS Exc_Thursday_Start, CASE WHEN cedpi.weekdayno = '5' THEN cedpi.excludedTimeTo ELSE '' END AS Exc_Thursday_End,
--	CASE WHEN cedpi.weekdayno = '6' THEN 'Friday' ELSE '' END AS Exc_Friday, CASE WHEN cedpi.weekdayno = '6' THEN cedpi.excludedTimeFrom ELSE '' END AS Exc_Friday_Start, CASE WHEN cedpi.weekdayno = '6' THEN cedpi.excludedTimeTo ELSE '' END AS Exc_Friday_End,
--	CASE WHEN cedpi.weekdayno = '7' THEN 'Saturday' ELSE '' END AS Exc_Saturday, CASE WHEN cedpi.weekdayno = '7' THEN cedpi.excludedTimeFrom ELSE '' END AS Exc_Saturday_Start, CASE WHEN cedpi.weekdayno = '7' THEN cedpi.excludedTimeTo ELSE '' END AS Exc_Saturday_End
--FROM Custom_Equabli_Phones_Info cepi WITH (NOLOCK) LEFT OUTER JOIN Custom_Equabli_Consumer_Info ceci WITH (NOLOCK)  ON cepi.equabliConsumerId = ceci.equabliConsumerId
--LEFT OUTER JOIN Custom_Equabli_DialPreference_Info cedpi WITH (NOLOCK) ON cepi.equabliConsumerId = cedpi.equabliConsumerId AND cepi.phoneNumber = cedpi.phone AND CAST(cedpi.excludedTimeFrom AS TIME) > '08:00' AND CAST(cedpi.excludedTimeTo AS TIME) < '10:00'
--ORDER BY cedpi.phone

--Alt Email
SELECT '2Email' AS recordtype, ceei.equabliAccountNumber, ceei.clientAccountNumber, ceei.equabliClientId, ceei.clientConsumerNumber, 
ceei.equabliConsumerId, ceei.emailAddress, ceei.emailWorkFlag, ceei.optoutFlag, ceei.emailValidityFlag, ceei.consentFlag, 
ceei.consentDateTime, ceei.statusCode, ceei.isPrimary
FROM Custom_Equabli_Email_Info ceei WITH (NOLOCK) 
WHERE ceei.isPrimary = 'N' AND ceei.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--Email Preference
SELECT ceepi.recordType, ceepi.equabliAccountNumber, ceepi.clientAccountNumber, ceepi.equabliClientId, ceepi.clientConsumerNumber, 
ceepi.equabliConsumerId, ceepi.emailAddress, ceepi.weekDayNo, ceepi.excludedTimeFrom, ceepi.excludedTimeTo
FROM Custom_Equabli_EmlPreference_Info ceepi WITH (NOLOCK) 
WHERE ceepi.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--dial preference
SELECT cedpi.recordType, cedpi.equabliAccountNumber, cedpi.clientAccountNumber, cedpi.equabliClientId, cedpi.clientConsumerNumber, 
cedpi.equabliConsumerId, cedpi.phone, cedpi.weekDayNo, cedpi.excludedTimeFrom, cedpi.excludedTimeTo
FROM Custom_Equabli_DialPreference_Info cedpi WITH (NOLOCK) 
WHERE cedpi.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--sms preference
SELECT cesi.recordType, cesi.equabliAccountNumber, cesi.clientAccountNumber, cesi.equabliClientId, cesi.clientConsumerNumber, 
cesi.equabliConsumerId, cesi.phone, cesi.weekDayNo, cesi.excludedTimeFrom, cesi.excludedTimeTo
FROM Custom_Equabli_SMSPreference_Info cesi WITH (NOLOCK) 
WHERE cesi.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--Serviceing History
SELECT ceshi.recordType, ceshi.equabliAccountNumber, ceshi.clientAccountNumber, ceshi.equabliClientId, ceshi.lastCallOutboundDate, 
ceshi.lastPhoneDialed, ceshi.lastCallOutcome, ceshi.lastInboundCallDate, ceshi.lastRPCDate, ceshi.lastRPCDisposition, 
ceshi.lastLetterOutboundDate, ceshi.lastLetterOutcome, ceshi.lastDiscountOffer, ceshi.lastEmailOutboundDate, ceshi.lastEmailAddress, 
ceshi.lastEmailOutcome, ceshi.lastSMSOutboundDate, ceshi.lastSMSNumber, ceshi.lastSMSOutcome, ceshi.isBrokenSettlement, 
ceshi.settlementBrokenDate, ceshi.settlementOfferDate, ceshi.settlementOfferCount, ceshi.settlementMethod, ceshi.settlementPaymentAmount
FROM Custom_Equabli_ServiceHistory_Info ceshi WITH (NOLOCK) 
WHERE ceshi.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--RankScore
SELECT cersi.recordType, cersi.equabliAccountNumber, cersi.clientAccountNumber, cersi.equabliClientId, cersi.equabliPartnerId, 
cersi.servicingIntensityBucket, cersi.maximumDiscount, cersi.scoreDate, cersi.priority1Phone, cersi.priority2Phone, cersi.priority3Phone, 
cersi.priority1Email, cersi.priority2Email, cersi.rankUniqueId
FROM Custom_Equabli_RankScore_Info cersi WITH (NOLOCK) 
WHERE cersi.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--Statute
SELECT cesi.recordType, cesi.equabliAccountNumber, cesi.clientAccountNumber, cesi.equabliClientId, cesi.solDate 
FROM Custom_Equabli_Statute_Info cesi WITH (NOLOCK) 
WHERE cesi.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--ACStatusChange
SELECT ceasci.recordType, ceasci.equabliAccountNumber, ceasci.clientAccountNumber, ceasci.equabliClientId, ceasci.queue, ceasci.status, 
ceasci.reason, ceasci.bankruptcyStatus, ceasci.isDeceased, ceasci.isFraud, ceasci.accountChannel, ceasci.accountLevelAttorneyRepFlag, 
ceasci.accountLevelCCCSFlag, ceasci.accountLevelLitigiousFlag, ceasci.accountLevelCeaseDesistFlag, ceasci.preLegalTalkoff, 
ceasci.debtSettlementFlag
FROM Custom_Equabli_AcStatusChange_Info ceasci WITH (NOLOCK) 
WHERE ceasci.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--ACAmountChange
SELECT ceaaci.recordType, ceaaci.equabliAccountNumber, ceaaci.clientAccountNumber, ceaaci.equabliClientId, ceaaci.amountAssigned
FROM Custom_Equabli_AcAmountChange_Info ceaaci WITH (NOLOCK) 
WHERE ceaaci.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--Adjustment
SELECT ceai.recordType, ceai.equabliAccountNumber, ceai.clientAccountNumber, ceai.equabliClientId, ceai.equabliPartnerId, 
ceai.adjustmentType, ceai.adjustmentDate, ceai.adjustentAmount, ceai.principalAmount, ceai.interestAmount, ceai.lateFeeAmount, 
ceai.otherFeeAmount, ceai.courtCostAmount, ceai.attorneyFeeAmount
FROM Custom_Equabli_Adjustment_Info ceai WITH (NOLOCK) 
WHERE ceai.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--UCC
SELECT ceui.recordType, ceui.equabliAccountNumber, ceui.clientAccountNumber, ceui.equabliClientId, ceui.uccFilingNumber, ceui.uccFilingDate, 
ceui.uccRenewalDate, ceui.uccRenewalFileDate, ceui.uccRenewalFilingConfirmNumber, ceui.ucc1FilingDate, ceui.ucc1FilingNum, 
ceui.ucc1TotalFilingCost, ceui.ucc1FilingCompleteDate, ceui.ucc1AddedCollateralLPDate, ceui.ucc3TerminationFilingDate, ceui.ucc3FilingNum, 
ceui.ucc3TotalFilingCost, ceui.ucc3FilingCompleteDate, ceui.ucc3AddedCollateralLPDate, ceui.rejectedFiling
FROM Custom_Equabli_UCC_Info ceui WITH (NOLOCK) 
WHERE ceui.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--Asset
SELECT ceai.recordType, ceai.equabliAccountNumber, ceai.assetId, ceai.clientAccountNumber, ceai.equabliClientId, ceai.assetCategory, 
ceai.assetTypeCode, ceai.assetName, ceai.vin, ceai.mileage, ceai.bookValue, ceai.bookValueDate, ceai.color, ceai.gpsStatus, ceai.opcode, 
ceai.licensePlate, ceai.gap, ceai.warranty, ceai.propertyAddressLine1, ceai.propertyAddressLine2, ceai.propertyCountry, ceai.propertyCity, 
ceai.propertyState, ceai.propertyZipCode, ceai.filingCountyTownCity, ceai.oVCost, ceai.assetCompany, ceai.assetBranch, ceai.assetRouting, 
ceai.assetAcctno, ceai.assetPhone, ceai.assetFax, ceai.assetValue, ceai.assetParcel, ceai.assetOwner, ceai.assetOwnerSecondary, 
ceai.assetSaleDate, ceai.assetSalePrice, ceai.assetSellerName, ceai.assetMortgageAmount, ceai.assetValueAssessed, ceai.assetMarketValue, 
ceai.assetLegalDescription, ceai.externalSystemId AS assetExternalSystemID, ceai.assetYear, ceai.assetModel, ceai.assetVersion
FROM Custom_Equabli_Asset_Info ceai WITH (NOLOCK) 
WHERE ceai.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--CreditScore
SELECT cecsi.recordType, cecsi.equabliAccountNumber, cecsi.clientAccountNumber, cecsi.equabliClientId, cecsi.equabliConsumerId, 
cecsi.clientConsumerNumber, cecsi.creditscoreSourceType, cecsi.creditscoreSourceId, cecsi.creditscoreCode, cecsi.dateOfScore, 
cecsi.creditScore
FROM Custom_Equabli_CreditScore_Info cecsi WITH (NOLOCK) 
WHERE cecsi.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--Cost
SELECT ceci.recordType, ceci.equabliAccountNumber, ceci.clientAccountNumber, ceci.equabliClientId, ceci.equabliPartnerId, ceci.costType, 
ceci.dateOfCost, ceci.costAmount
FROM Custom_Equabli_Cost_Info ceci WITH (NOLOCK) 
WHERE ceci.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

--ChangeLog
SELECT cecli.recordType, cecli.equabliAccountNumber, cecli.clientAccountNumber, cecli.equabliClientId, cecli.entityShortName, 
cecli.attributeName, cecli.externalSourceType, cecli.externalSourceId, cecli.externalSystemId AS changeLogExternalSystemID, cecli.previousValue, cecli.newValue, 
cecli.clientConsumerNumber, cecli.equabliConsumerId
FROM Custom_Equabli_ChangeLog_Info cecli WITH (NOLOCK) 
WHERE cecli.equabliAccountNumber IN (SELECT equabliAccountNumber FROM Custom_Equabli_Account_Info)

END
GO

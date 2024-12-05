SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 10/07/2019
-- Description:	Export Latitude compatible file for import from the US Bank CACS system
-- BGM - 5/13/2019 added Codebtor, and other contacts, filtered out preferred address/emails since already in main contact table.
-- BGM - 02/28/2020 Added Debtor name relationships D- Authorized Officer, O -  Guarantor to secondary Debtors
-- BGM - 03/30/2021 Changed Placement record to return transaction code 209 when it is 210
-- BGM - 06/11/2024 Changed how full name is ordered to Last, first middle and separated from business names
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Export_Transaction_File] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
--Placement
SELECT  AgencyId, LocationCode, AcctNumber, CASE WHEN TransactionCode = '210' THEN '209' ELSE TransactionCode END AS TransactionCode, 
		TransactionDate, CustomerName, DateAssigned, CommPercent,
        AmountPlaced, AssignLagDate, TargetSettlePercent, TargetSettleAmount, RecallDate, CurrentAmountDue, InterestRate,
        LastPaymentDate, LastPaymentAmount, CreditLimitAmount, CyclesDelinquentCount, DaysDelinquent, LoanType,
        LoanOfficer, DealerNumber, SourceChannel, ChargeOffReason, AcctStatus1, AcctStatus2, AcctStatus3, AcctStatus4,
        AcctStatus5, AcctStatus6, AcctStatus7, AcctStatus8, AcctStatus9, AcctStatus10, DailyDollarRate, DateReceived,
        ContractDate, ChargeOffDate, ChargeOffAmount, PrincipalAmount, TotalFeesCosts, InterestDue, CurrentBalance,
        RecoveryScore, NextPaymentDate, LastContactDate, AdditionalBalCat1, AdditionalBalDue1, AdditionalBalCat2,
        AdditionalBalDue2, AdditionalBalCat3, AdditionalBalDue3, AdditionalBalCat4, AdditionalBalDue4, AdditionalBalCat5,
        AdditionalBalDue5, AdditionalBalCat6, AdditionalBalDue6, AdditionalBalCat7, AdditionalBalDue7, AdditionalBalCat8,
        AdditionalBalDue8, AdditionalBalCat9, AdditionalBalDue9, AdditionalBalCat10, AdditionalBalDue10,
        AdditionalBalCat11, AdditionalBalDue11, AdditionalBalCat12, AdditionalBalDue12, AdditionalBalCat13,
        AdditionalBalDue13, AdditionalBalCat14, AdditionalBalDue14, AdditionalBalCat15, AdditionalBalDue15,
        AdditionalBalCat16, AdditionalBalDue16, AdditionalBalCat17, AdditionalBalDue17, AdditionalBalCat18,
        AdditionalBalDue18, AdditionalBalCat19, AdditionalBalDue19, AdditionalBalCat20, AdditionalBalDue20,
        PlacementLevel
FROM    Custom_USBank_Temp_Placement cubtp WITH ( NOLOCK ) 
WHERE TransactionCode IN ('210', '211', '110', '111')
	

--Primary Debtor contactID - NationalIDNumber
SELECT  cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, 
		CASE WHEN cb.NationalIDNumberType = 'S' THEN (CASE WHEN cb.LastName = '' THEN dbo.GetLastName(cb.Name) ELSE cb.LastName END + ', ' + 
		CASE WHEN cb.FirsstName = '' THEN dbo.GetFirstName(cb.Name) ELSE cb.FirsstName END + ' ' + CASE WHEN cb.MiddleName = '' THEN dbo.GetMiddleName(cb.Name) 
		ELSE cb.MiddleName END) ELSE cb.Name END AS Name,
		cb.Prefix, CASE WHEN cb.FirsstName = '' THEN dbo.GetFirstName(cb.Name) ELSE cb.FirsstName END AS FirsstName, 
        CASE WHEN cb.MiddleName = '' THEN dbo.GetMiddleName(cb.Name) ELSE cb.MiddleName END AS MiddleName, 
        CASE WHEN cb.LastName = '' THEN dbo.GetLastName(cb.Name) ELSE cb.LastName END AS LastName, cb.Suffix, cb.MaternalName,
        cb.NationalIDNumber, cb.NationalIDNumberType, cb.DateofBirth, cb.RighttoPrivacy, cb.ISOLanguageCode,
        cb.AddressDisplayFormat, cb.Notes, cb.Employer, cb.CustomerSinceDate, cb.UserDefinedStatus1,
        cb.UserDefinedStatus2, cb.UserDefinedStatus3, cb.UserDefinedStatus4, cb.UserDefinedStatus5, cb.UserDefinedDate1,
        cb.UserDefinedDate2, cb.UserDefinedDate3, cb.UserDefinedDate4, cb.UserDefinedDate5, cb.UserDefinedText1,
        cb.UserDefinedText2, cb.UserDefinedText3, cb.UserDefinedText4, cb.UserDefinedText5, cb.SearchName, cb.Fill,
        cb.DateLastVerified, ad.ExternalKey AS AddressExternalKey, ad.NickName, ad.AddressRelationship, ad.AddressStatus, ad.SeasonalAddressFrom, ad.SeasonalAddressTo,
        ad.AddressBlockInd, ad.PrefferredAddressInd, ad.CreditBureauAddress, ad.CreditBureauAddressIndicatorDateUpdated,
        ad.AddressLine1, ad.AddressLine2, ad.AddressLine3, ad.City, ad.State, ad.PostalCode, ad.County, ad.Country, ad.ChangeDate AS PriAddressChangeDate,
        e.EmailAddress
FROM    Custom_USBank_Temp_ContactAcct cc WITH ( NOLOCK )
        INNER JOIN Custom_USBank_Temp_BaseContact cb WITH ( NOLOCK ) ON cc.ContactId = cb.ContactId
        LEFT OUTER JOIN Custom_USBank_Temp_Address ad WITH (NOLOCK) ON cc.ContactId = ad.ContactId AND ad.PrefferredAddressInd = 'Y'
        LEFT OUTER JOIN Custom_USBank_Temp_Emails e WITH (NOLOCK) ON cc.ContactId = e.ContactId AND e.PreferredEmailAddressInd = 'Y' AND e.EmailAvailability NOT IN ('I', 'N')
WHERE LeadContactInd = 'Y'
AND (cc.TransCode IN ('210', '211', '110', '111') or cb.TransCode IN ('210', '211', '110', '111') or ad.TransCode IN ('210', '211', '110', '111')
or e.TransCode IN ('210', '211', '110', '111'))


ORDER BY cc.AcctNum

--Secondary account names contactid - NationalIDNumber
SELECT DISTINCT cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, 
		CASE WHEN cb.NationalIDNumberType = 'S' THEN (CASE WHEN cb.LastName = '' THEN dbo.GetLastName(cb.Name) ELSE cb.LastName END + ', ' + 
		CASE WHEN cb.FirsstName = '' THEN dbo.GetFirstName(cb.Name) ELSE cb.FirsstName END + ' ' + CASE WHEN cb.MiddleName = '' THEN dbo.GetMiddleName(cb.Name) 
		ELSE cb.MiddleName END) ELSE cb.Name END AS Name,
		cb.Prefix, CASE WHEN cb.FirsstName = '' THEN dbo.GetFirstName(cb.Name) ELSE cb.FirsstName END AS FirsstName, 
        CASE WHEN cb.MiddleName = '' THEN dbo.GetMiddleName(cb.Name) ELSE cb.MiddleName END AS MiddleName, 
        CASE WHEN cb.LastName = '' THEN dbo.GetLastName(cb.Name) ELSE cb.LastName END AS LastName, cb.Suffix, cb.MaternalName,
        cb.NationalIDNumber, cb.NationalIDNumberType, cb.DateofBirth, cb.RighttoPrivacy, cb.ISOLanguageCode,
        cb.AddressDisplayFormat, cb.Notes, cb.Employer, cb.CustomerSinceDate, cb.UserDefinedStatus1,
        cb.UserDefinedStatus2, cb.UserDefinedStatus3, cb.UserDefinedStatus4, cb.UserDefinedStatus5, cb.UserDefinedDate1,
        cb.UserDefinedDate2, cb.UserDefinedDate3, cb.UserDefinedDate4, cb.UserDefinedDate5, cb.UserDefinedText1,
        cb.UserDefinedText2, cb.UserDefinedText3, cb.UserDefinedText4, cb.UserDefinedText5, cb.SearchName, cb.Fill,
        cb.DateLastVerified, ad.ExternalKey AS AddressExternalKey, ad.NickName, ad.AddressRelationship, ad.AddressStatus, ad.SeasonalAddressFrom, ad.SeasonalAddressTo,
        ad.AddressBlockInd, ad.PrefferredAddressInd, ad.CreditBureauAddress, ad.CreditBureauAddressIndicatorDateUpdated,
        ad.AddressLine1, ad.AddressLine2, ad.AddressLine3, ad.City, ad.State, ad.PostalCode, ad.County, ad.Country, ad.ChangeDate AS PriAddressChangeDate,
        e.EmailAddress
FROM    Custom_USBank_Temp_ContactAcct cc WITH ( NOLOCK )
        INNER JOIN Custom_USBank_Temp_BaseContact cb WITH ( NOLOCK ) ON cc.ContactId = cb.ContactId
        INNER JOIN Custom_USBank_Temp_Address ad WITH (NOLOCK) ON cc.ContactId = ad.ContactId AND ad.PrefferredAddressInd = 'Y'
        LEFT OUTER JOIN Custom_USBank_Temp_Emails e WITH (NOLOCK) ON cc.ContactId = e.ContactId AND e.PreferredEmailAddressInd = 'Y' AND e.EmailAvailability NOT IN ('I', 'N')
WHERE LeadContactInd <> 'Y' AND cc.NameRelationship IN ('A', 'B', 'C', 'D', 'O') AND cc.AcctNum = cb.AcctNumber
AND (cc.TransCode IN ('210', '211', '110', '111') or cb.TransCode IN ('210', '211', '110', '111') or ad.TransCode IN ('210', '211', '110', '111')
or e.TransCode IN ('210', '211', '110', '111'))

ORDER BY cc.AcctNum

--Other account names contactid - NationalIDNumber
SELECT DISTINCT cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, CASE WHEN cb.NationalIDNumberType = 'S' THEN (CASE WHEN cb.LastName = '' THEN dbo.GetLastName(cb.Name) ELSE cb.LastName END + ', ' + 
		CASE WHEN cb.FirsstName = '' THEN dbo.GetFirstName(cb.Name) ELSE cb.FirsstName END + ' ' + CASE WHEN cb.MiddleName = '' THEN dbo.GetMiddleName(cb.Name) 
		ELSE cb.MiddleName END) ELSE cb.Name END AS Name,
		cb.Prefix, CASE WHEN cb.FirsstName = '' THEN dbo.GetFirstName(cb.Name) ELSE cb.FirsstName END AS FirsstName, 
        CASE WHEN cb.MiddleName = '' THEN dbo.GetMiddleName(cb.Name) ELSE cb.MiddleName END AS MiddleName, 
        CASE WHEN cb.LastName = '' THEN dbo.GetLastName(cb.Name) ELSE cb.LastName END AS LastName, cb.Suffix, cb.MaternalName,
        cb.NationalIDNumber, cb.NationalIDNumberType, cb.DateofBirth, cb.RighttoPrivacy, cb.ISOLanguageCode,
        cb.AddressDisplayFormat, cb.Notes, cb.Employer, cb.CustomerSinceDate, cb.UserDefinedStatus1,
        cb.UserDefinedStatus2, cb.UserDefinedStatus3, cb.UserDefinedStatus4, cb.UserDefinedStatus5, cb.UserDefinedDate1,
        cb.UserDefinedDate2, cb.UserDefinedDate3, cb.UserDefinedDate4, cb.UserDefinedDate5, cb.UserDefinedText1,
        cb.UserDefinedText2, cb.UserDefinedText3, cb.UserDefinedText4, cb.UserDefinedText5, cb.SearchName, cb.Fill,
        cb.DateLastVerified, ad.ExternalKey AS AddressExternalKey, ad.NickName, ad.AddressRelationship, ad.AddressStatus, ad.SeasonalAddressFrom, ad.SeasonalAddressTo,
        ad.AddressBlockInd, ad.PrefferredAddressInd, ad.CreditBureauAddress, ad.CreditBureauAddressIndicatorDateUpdated,
        ad.AddressLine1, ad.AddressLine2, ad.AddressLine3, ad.City, ad.State, ad.PostalCode, ad.County, ad.Country, ad.ChangeDate AS PriAddressChangeDate,
        e.EmailAddress
FROM    Custom_USBank_Temp_ContactAcct cc WITH ( NOLOCK )
        INNER JOIN Custom_USBank_Temp_BaseContact cb WITH ( NOLOCK ) ON cc.ContactId = cb.ContactId
        INNER JOIN Custom_USBank_Temp_Address ad WITH (NOLOCK) ON cc.ContactId = ad.ContactId AND ad.PrefferredAddressInd = 'Y'
        LEFT OUTER JOIN Custom_USBank_Temp_Emails e WITH (NOLOCK) ON cc.ContactId = e.ContactId AND e.PreferredEmailAddressInd = 'Y' AND e.EmailAvailability NOT IN ('I', 'N')
WHERE LeadContactInd <> 'Y' AND cc.NameRelationship NOT IN ('A', 'B', 'C', 'D', 'O') AND cc.AcctNum = cb.AcctNumber
AND (cc.TransCode IN ('210', '211', '110', '111') or cb.TransCode IN ('210', '211', '110', '111') or ad.TransCode IN ('210', '211', '110', '111')
or e.TransCode IN ('210', '211', '110', '111'))

ORDER BY cc.AcctNum

--All Addresses - must map externalkey
SELECT DISTINCT ct.AgencyId, ct.LocationCode, ct.AcctNumber, ct.TransCode, ct.TransDate, ct.ContactId, ContactRecordType, ExternalKey, ct.ActionCode,
        NickName, AddressRelationship, AddressStatus, SeasonalAddressFrom, SeasonalAddressTo, AddressBlockInd,
        PrefferredAddressInd, CreditBureauAddress, CreditBureauAddressIndicatorDateUpdated, AddressLine1, AddressLine2,
        AddressLine3, City, State, PostalCode, County, Country, ChangeDate
FROM    Custom_USBank_Temp_Address ct WITH ( NOLOCK ) 
WHERE ct.TransCode IN ('210', '211', '110', '111') AND PrefferredAddressInd <> 'Y'

--All Emails - must map externalkey
SELECT DISTINCT  ce.AgencyId, ce.LocationCode, ce.AcctNumber, ce.TransCode, ce.TransDate, ce.ContactId, ContactRecordType, ExternalKey, ce.ActionCode,
        NickName, EmailAddress, EmailType, EmailAvailability, PreferredEmailAddressInd, ChangeDate
FROM    Custom_USBank_Temp_Emails ce WITH ( NOLOCK ) 
WHERE ce.TransCode IN ('210', '211', '110', '111') AND PreferredEmailAddressInd <> 'Y'

--All Phones - must map externalkey
SELECT DISTINCT ph.AgencyId, ph.LocationCode, ph.AcctNumber, ph.TransCode, ph.TransDate, ph.ContactId, ph.ContactRecordType, ph.ExternalKey, ph.ActionCode,
        ph.NickName, ph.PhoneNumber, ph.Extension, ph.PhoneType, ph.PhoneFormat, ph.PhoneAvailability, ph.PreferredPhoneNumberInd,
        ph.ServiceType, ph.DoNotContact, ph.ChangeDate, ph.Filler
FROM    Custom_USBank_Temp_Phones ph WITH ( NOLOCK ) 
WHERE ph.TransCode IN ('210', '211', '110', '111')
		
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- BGM - 5/13/2019 added Codebtor, and other contacts, filtered out preferred address/emails since already in main contact table.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_SunTrust_CACS_Export_Transaction_File] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
--Placement
SELECT  AgencyId, LocationCode, AcctNumber, CASE WHEN TransactionCode = '210' THEN '209' ELSE TransactionCode END AS TransactionCode, 
		TransactionDate, CustomerName, DateAssigned, CommPercent, CommFlatAmt,
        AmountPlaced, TotalDelinqAmt, DisputedAmt, TotalDueAmt, CurrentAmountDue, InterestRate, DateToBeRecal,
        LastPaymentDate, LastPaymentAmount, OverLimitAmt, CreditLimitAmount, CyclesDelinquentCount, DaysDelinquent, AsgnLagDate,
        TSRPercent, TSRAmount, PrincipalDelqAmt, ServiceCharge, 
        ChargeOffFee, ChargeOffDate, BankNumber, BranchName
        
FROM    Custom_SunTrust_Temp_Placement cubtp WITH ( NOLOCK ) 
WHERE TransactionCode IN ('210', '211', '110', '111')
	

--Primary Debtor contactID - NationalIDNumber
SELECT  cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, cb.Name, cb.Prefix, CASE WHEN cb.FirsstName = '' THEN dbo.GetFirstName(cb.Name) ELSE cb.FirsstName END AS FirsstName, 
        CASE WHEN cb.MiddleName = '' THEN dbo.GetMiddleName(cb.Name) ELSE cb.MiddleName END AS MiddleName, 
        CASE WHEN cb.LastName = '' THEN dbo.GetLastName(cb.Name) ELSE cb.LastName END AS LastName, cb.Suffix, cb.MaternalName,
        cb.NationalIDNumber, cb.NationalIDNumberType, cb.DateofBirth,cb.PreferredContactMethod1,cb.PreferredContactMethod2,cb.PreferredContactMethod3, cb.RighttoPrivacy, cb.ISOLanguageCode,
        cb.AddressDisplayFormat, cb.Notes, cb.Employer, cb.CustomerSinceDate, cb.UserDefinedStatus1,
        cb.UserDefinedStatus2, cb.UserDefinedStatus3, cb.UserDefinedStatus4, cb.UserDefinedStatus5, cb.UserDefinedDate1,
        cb.UserDefinedDate2, cb.UserDefinedDate3, cb.UserDefinedDate4, cb.UserDefinedDate5, cb.UserDefinedText1,
        cb.UserDefinedText2, cb.UserDefinedText3, cb.UserDefinedText4, cb.UserDefinedText5, cb.SearchName, cb.UserDefinedSearch1,cb.UserDefinedSearch2,
        cb.DateLastVerified, ad.ExternalKey AS AddressExternalKey, ad.NickName, ad.AddressRelationship, ad.AddressStatus, ad.SeasonalAddressFrom, ad.SeasonalAddressTo,
        ad.AddressBlockInd, ad.PrefferredAddressInd, ad.CreditBureauAddress, ad.CreditBureauAddressIndicatorDateUpdated,
        ad.AddressLine1, ad.AddressLine2, ad.AddressLine3, ad.City, ad.State, ad.PostalCode, ad.County, ad.Country,ad.AddressTimezone, ad.ChangeDate AS PriAddressChangeDate,
        e.EmailAddress
FROM    Custom_SunTrust_Temp_ContactAcct cc WITH ( NOLOCK )
        INNER JOIN Custom_SunTrust_Temp_BaseContact cb WITH ( NOLOCK ) ON cc.ContactId = cb.ContactId
        LEFT OUTER JOIN Custom_SunTrust_Temp_Address ad WITH (NOLOCK) ON cc.ContactId = ad.ContactId AND ad.PrefferredAddressInd = 'Y'
        LEFT OUTER JOIN Custom_SunTrust_Temp_Emails e WITH (NOLOCK) ON cc.ContactId = e.ContactId AND e.PreferredEmailAddressInd = 'Y' AND e.EmailAvailability NOT IN ('I', 'N')
WHERE LeadContactInd = 'Y'
AND (cc.TransCode IN ('210', '211', '110', '111') or cb.TransCode IN ('210', '211', '110', '111') or ad.TransCode IN ('210', '211', '110', '111')
or e.TransCode IN ('210', '211', '110', '111'))


ORDER BY cc.AcctNum

--Secondary account names contactid - NationalIDNumber
SELECT DISTINCT cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, cb.Name, cb.Prefix, cb.FirsstName, cb.MiddleName, cb.LastName, cb.Suffix, cb.MaternalName,
        cb.NationalIDNumber, cb.NationalIDNumberType, cb.DateofBirth,cb.PreferredContactMethod1,cb.PreferredContactMethod2,cb.PreferredContactMethod3, cb.RighttoPrivacy, cb.ISOLanguageCode,
        cb.AddressDisplayFormat, cb.Notes, cb.Employer, cb.CustomerSinceDate, cb.UserDefinedStatus1,
        cb.UserDefinedStatus2, cb.UserDefinedStatus3, cb.UserDefinedStatus4, cb.UserDefinedStatus5, cb.UserDefinedDate1,
        cb.UserDefinedDate2, cb.UserDefinedDate3, cb.UserDefinedDate4, cb.UserDefinedDate5, cb.UserDefinedText1,
        cb.UserDefinedText2, cb.UserDefinedText3, cb.UserDefinedText4, cb.UserDefinedText5, cb.SearchName, cb.UserDefinedSearch1,cb.UserDefinedSearch2,
        cb.DateLastVerified, ad.ExternalKey AS AddressExternalKey, ad.NickName, ad.AddressRelationship, ad.AddressStatus, ad.SeasonalAddressFrom, ad.SeasonalAddressTo,
        ad.AddressBlockInd, ad.PrefferredAddressInd, ad.CreditBureauAddress, ad.CreditBureauAddressIndicatorDateUpdated,
        ad.AddressLine1, ad.AddressLine2, ad.AddressLine3, ad.City, ad.State, ad.PostalCode, ad.County, ad.Country,ad.AddressTimezone, ad.ChangeDate AS PriAddressChangeDate,
        e.EmailAddress
FROM    Custom_SunTrust_Temp_ContactAcct cc WITH ( NOLOCK )
        INNER JOIN Custom_SunTrust_Temp_BaseContact cb WITH ( NOLOCK ) ON cc.ContactId = cb.ContactId
        INNER JOIN Custom_SunTrust_Temp_Address ad WITH (NOLOCK) ON cc.ContactId = ad.ContactId AND ad.PrefferredAddressInd = 'Y'
        LEFT OUTER JOIN Custom_SunTrust_Temp_Emails e WITH (NOLOCK) ON cc.ContactId = e.ContactId AND e.PreferredEmailAddressInd = 'Y' AND e.EmailAvailability NOT IN ('I', 'N')
WHERE LeadContactInd <> 'Y' AND cc.NameRelationship IN ('A', 'B', 'C') AND cc.AcctNum = cb.AcctNumber
AND (cc.TransCode IN ('210', '211', '110', '111') or cb.TransCode IN ('210', '211', '110', '111') or ad.TransCode IN ('210', '211', '110', '111')
or e.TransCode IN ('210', '211', '110', '111'))

ORDER BY cc.AcctNum

--Other account names contactid - NationalIDNumber
SELECT DISTINCT cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, cb.Name, cb.Prefix, cb.FirsstName, cb.MiddleName, cb.LastName, cb.Suffix, cb.MaternalName,
        cb.NationalIDNumber, cb.NationalIDNumberType, cb.DateofBirth, cb.PreferredContactMethod1,cb.PreferredContactMethod2,cb.PreferredContactMethod3,cb.RighttoPrivacy, cb.ISOLanguageCode,
        cb.AddressDisplayFormat, cb.Notes, cb.Employer, cb.CustomerSinceDate, cb.UserDefinedStatus1,
        cb.UserDefinedStatus2, cb.UserDefinedStatus3, cb.UserDefinedStatus4, cb.UserDefinedStatus5, cb.UserDefinedDate1,
        cb.UserDefinedDate2, cb.UserDefinedDate3, cb.UserDefinedDate4, cb.UserDefinedDate5, cb.UserDefinedText1,
        cb.UserDefinedText2, cb.UserDefinedText3, cb.UserDefinedText4, cb.UserDefinedText5, cb.SearchName, cb.UserDefinedSearch1,cb.UserDefinedSearch2,
        cb.DateLastVerified, ad.ExternalKey AS AddressExternalKey, ad.NickName, ad.AddressRelationship, ad.AddressStatus, ad.SeasonalAddressFrom, ad.SeasonalAddressTo,
        ad.AddressBlockInd, ad.PrefferredAddressInd, ad.CreditBureauAddress, ad.CreditBureauAddressIndicatorDateUpdated,
        ad.AddressLine1, ad.AddressLine2, ad.AddressLine3, ad.City, ad.State, ad.PostalCode, ad.County, ad.Country,ad.AddressTimezone, ad.ChangeDate AS PriAddressChangeDate,
        e.EmailAddress
FROM    Custom_SunTrust_Temp_ContactAcct cc WITH ( NOLOCK )
        INNER JOIN Custom_SunTrust_Temp_BaseContact cb WITH ( NOLOCK ) ON cc.ContactId = cb.ContactId
        INNER JOIN Custom_SunTrust_Temp_Address ad WITH (NOLOCK) ON cc.ContactId = ad.ContactId AND ad.PrefferredAddressInd = 'Y'
        LEFT OUTER JOIN Custom_SunTrust_Temp_Emails e WITH (NOLOCK) ON cc.ContactId = e.ContactId AND e.PreferredEmailAddressInd = 'Y' AND e.EmailAvailability NOT IN ('I', 'N')
WHERE LeadContactInd <> 'Y' AND cc.NameRelationship NOT IN ('A', 'B', 'C') AND cc.AcctNum = cb.AcctNumber
AND (cc.TransCode IN ('210', '211', '110', '111') or cb.TransCode IN ('210', '211', '110', '111') or ad.TransCode IN ('210', '211', '110', '111')
or e.TransCode IN ('210', '211', '110', '111'))

ORDER BY cc.AcctNum

--All Addresses - must map externalkey
SELECT DISTINCT ct.AgencyId, ct.LocationCode, ct.AcctNumber, ct.TransCode, ct.TransDate, ct.ContactId, ContactRecordType, ExternalKey, ct.ActionCode,
        NickName, AddressRelationship, AddressStatus, SeasonalAddressFrom, SeasonalAddressTo, AddressBlockInd,
        PrefferredAddressInd, CreditBureauAddress, CreditBureauAddressIndicatorDateUpdated, AddressLine1, AddressLine2,
        AddressLine3, City, State, PostalCode, County, Country, AddressTimezone,ChangeDate
FROM    Custom_SunTrust_Temp_Address ct WITH ( NOLOCK ) 
WHERE ct.TransCode IN ('210', '211', '110', '111') AND PrefferredAddressInd <> 'Y'

--All Emails - must map externalkey
SELECT DISTINCT  ce.AgencyId, ce.LocationCode, ce.AcctNumber, ce.TransCode, ce.TransDate, ce.ContactId, ContactRecordType, ExternalKey, ce.ActionCode,
        NickName, EmailAddress, EmailType, EmailAvailability, PreferredEmailAddressInd, ChangeDate,ConsentToContact,TypeOfConsent,SourceOfConsent,DateOfConsent
FROM    Custom_SunTrust_Temp_Emails ce WITH ( NOLOCK ) 
WHERE ce.TransCode IN ('210', '211', '110', '111') AND PreferredEmailAddressInd <> 'Y'

--All Phones - must map externalkey
SELECT DISTINCT ph.AgencyId, ph.LocationCode, ph.AcctNumber, ph.TransCode, ph.TransDate, ph.ContactId, ph.ContactRecordType, ph.ExternalKey, ph.ActionCode,
        ph.NickName, ph.PhoneNumber, ph.Extension,ph.Priority, ph.PhoneType, ph.PhoneFormat, ph.PhoneAvailability, ph.PreferredPhoneNumberInd,
        ph.ServiceType, ph.DoNotContact, ph.ChangeDate, ph.CustomerConsent, ph.CustomerConsentType, ph.CustomerConsentSource, ph.DateOfConsent,ph.PartyGivingConsent
FROM    Custom_SunTrust_Temp_Phones ph WITH ( NOLOCK ) 
WHERE ph.TransCode IN ('210', '211', '110', '111')
		
END
GO

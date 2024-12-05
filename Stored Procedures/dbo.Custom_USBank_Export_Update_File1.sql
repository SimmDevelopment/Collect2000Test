SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Export_Update_File1] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
--Placement
SELECT  AgencyId, LocationCode, AcctNumber, TransactionCode, TransactionDate, CustomerName, DateAssigned, CommPercent,
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
WHERE TransactionCode IN ('110', '111')
	

--Primary Debtor contactID - relationship
SELECT  cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, cb.Name, cb.Prefix, cb.FirsstName, cb.MiddleName, cb.LastName, cb.Suffix, cb.MaternalName,
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
AND (cc.TransCode IN ('110', '111') or cb.TransCode IN ('110', '111') or ad.TransCode IN ('110', '111')
or e.TransCode IN ('110', '111'))




ORDER BY cc.AcctNum

--Secondary account names contactid - relationship
SELECT  cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, cb.Name, cb.Prefix, cb.FirsstName, cb.MiddleName, cb.LastName, cb.Suffix, cb.MaternalName,
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
WHERE LeadContactInd <> 'Y'
AND (cc.TransCode IN ('110', '111') or cb.TransCode IN ('110', '111') or ad.TransCode IN ('110', '111')
or e.TransCode IN ('110', '111'))

ORDER BY cc.AcctNum

--All Addresses - must map externalkey
SELECT  AgencyId, LocationCode, AcctNumber, TransCode, TransDate, ContactId, ContactRecordType, ExternalKey, ActionCode,
        NickName, AddressRelationship, AddressStatus, SeasonalAddressFrom, SeasonalAddressTo, AddressBlockInd,
        PrefferredAddressInd, CreditBureauAddress, CreditBureauAddressIndicatorDateUpdated, AddressLine1, AddressLine2,
        AddressLine3, City, State, PostalCode, County, Country, ChangeDate
FROM    Custom_USBank_Temp_Address cubta WITH ( NOLOCK )
WHERE TransCode IN ('110', '111')

--All Emails - map to misc extra use externalkey
SELECT  AgencyId, LocationCode, AcctNumber, TransCode, TransDate, ContactId, ContactRecordType, ExternalKey, ActionCode,
        NickName, EmailAddress, EmailType, EmailAvailability, PreferredEmailAddressInd, ChangeDate
FROM    Custom_USBank_Temp_Emails cubte WITH ( NOLOCK )
WHERE TransCode IN ('110', '111')

--All Phones - must map externalkey
SELECT  ph.AgencyId, ph.LocationCode, ph.AcctNumber, ph.TransCode, ph.TransDate, ph.ContactId, ph.ContactRecordType, ph.ExternalKey, ph.ActionCode,
        ph.NickName, ph.PhoneNumber, ph.Extension, ph.PhoneType, ph.PhoneFormat, ph.PhoneAvailability, ph.PreferredPhoneNumberInd,
        ph.ServiceType, ph.DoNotContact, ph.ChangeDate, ph.Filler, ttc.TimePref, ttc.Monday, ttc.Tuesday, ttc.Wednesday, ttc.Thursday, ttc.Friday,
        ttc.Saturday, ttc.Sunday, ttc.AnyTime, ttc.StartTime, ttc.EndTime, ttc.TimeZone
FROM    Custom_USBank_Temp_Phones ph WITH ( NOLOCK ) LEFT OUTER JOIN Custom_USBank_Temp_TimeToCall ttc WITH (NOLOCK) ON ph.ExternalKey = ttc.ExternalKey
WHERE ph.TransCode IN ('110', '111') OR ttc.TransCode IN ('110', '111')
END
GO

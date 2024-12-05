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
CREATE PROCEDURE [dbo].[Custom_M&T_CACS_Export_Transaction_File_Newer] 
	-- Add the parameters for the stored procedure here

-- Exec [Custom_M&T_CACS_Export_Transaction_File_Newer]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
--Placement
SELECT  cmtp.AgencyId, cmtp.LocationCode, cmtp.AcctNumber, CASE WHEN TransactionCode = '210' THEN '209' ELSE TransactionCode END AS TransactionCode, 
		TransactionDate, CustomerName, DateAssigned, CommPercent, CommFlatAmt,
        AmountPlaced, TotalDelinqAmt, DisputedAmt, TotalDueAmt, CurrentAmountDue, InterestRate, DateToBeRecal,
        LastPaymentDate, LastPaymentAmount, OverLimitAmt, CreditLimitAmount, CyclesDelinquentCount, DaysDelinquent, AsgnLagDate,
        TSRPercent, TSRAmount        
FROM    Custom_MT_Temp_Placement cmtp WITH ( NOLOCK )
WHERE TransactionCode IN ('210', '211', '110', '111')
	

--Primary Debtor contactID - NationalIDNumber
SELECT  cmtca.AgencyId, cmtca.LocationCode, cmtca.AcctNum, cmtca.TransCode, cmtca.TransDate, cmtca.ContactId, cmtca.ContactRecType,
        cmtca.NameRelationship, cmtca.LeadContactInd, cmtca.ResponsibleParty, cmtca.PreferredCurrency, cmtbc.ContactRecType, cmtbc.Filler,
        cmtbc.ActionCode, cmtbc.Name, cmtbc.Prefix, CASE WHEN cmtbc.FirsstName = '' THEN dbo.GetFirstName(cmtbc.Name) ELSE cmtbc.FirsstName END AS FirsstName, 
        CASE WHEN cmtbc.MiddleName = '' THEN dbo.GetMiddleName(cmtbc.Name) ELSE cmtbc.MiddleName END AS MiddleName, 
        CASE WHEN cmtbc.LastName = '' THEN dbo.GetLastName(cmtbc.Name) ELSE cmtbc.LastName END AS LastName, cmtbc.Suffix, cmtbc.MaternalName,
        cmtbc.NationalIDNumber, cmtbc.NationalIDNumberType, cmtbc.DateofBirth,cmtbc.PreferredContactMethod1,cmtbc.PreferredContactMethod2,cmtbc.PreferredContactMethod3, cmtbc.RighttoPrivacy, cmtbc.ISOLanguageCode,
        cmtbc.AddressDisplayFormat, cmtbc.Notes, cmtbc.Employer, cmtbc.CustomerSinceDate, cmtbc.UserDefinedStatus1,
        cmtbc.UserDefinedStatus2, cmtbc.UserDefinedStatus3, cmtbc.UserDefinedStatus4, cmtbc.UserDefinedStatus5, cmtbc.UserDefinedDate1,
        cmtbc.UserDefinedDate2, cmtbc.UserDefinedDate3, cmtbc.UserDefinedDate4, cmtbc.UserDefinedDate5, cmtbc.UserDefinedText1,
        cmtbc.UserDefinedText2, cmtbc.UserDefinedText3, cmtbc.UserDefinedText4, cmtbc.UserDefinedText5, cmtbc.SearchName, cmtbc.UserDefinedSearch1,cmtbc.UserDefinedSearch2,
        cmtbc.DateLastVerified, cmta.ExternalKey AS AddressExternalKey, cmta.NickName, cmta.AddressRelationship, cmta.AddressStatus, cmta.SeasonalAddressFrom, cmta.SeasonalAddressTo,
        cmta.AddressBlockInd, cmta.PrefferredAddressInd, cmta.CreditBureauAddress, cmta.CreditBureauAddressIndicatorDateUpdated,
        cmta.AddressLine1, cmta.AddressLine2, cmta.AddressLine3, cmta.City, cmta.State, cmta.PostalCode, cmta.County, cmta.Country,cmta.AddressTimezone, cmta.ChangeDate AS PriAddressChangeDate,
        cmte.EmailAddress
FROM    Custom_MT_Temp_ContactAcct cmtca WITH ( NOLOCK )
        INNER JOIN Custom_MT_Temp_BaseContact cmtbc WITH ( NOLOCK ) ON cmtca.ContactId = cmtbc.ContactId AND cmtca.AcctNum = cmtbc.AcctNumber
        LEFT OUTER JOIN Custom_MT_Temp_Address cmta WITH (NOLOCK) ON cmtca.ContactId = cmta.ContactId AND cmta.PrefferredAddressInd = 'Y' AND cmtca.AcctNum = cmta.AcctNumber
        LEFT OUTER JOIN Custom_MT_Temp_Emails cmte WITH (NOLOCK) ON cmtca.ContactId = cmte.ContactId AND cmte.PreferredEmailAddressInd = 'Y' AND cmte.EmailAvailability NOT IN ('I', 'N') AND cmtca.AcctNum = cmte.AcctNumber
WHERE LeadContactInd = 'Y'
AND (cmtca.TransCode IN ('210', '211', '110', '111') or cmtbc.TransCode IN ('210', '211', '110', '111') or cmta.TransCode IN ('210', '211', '110', '111')
or cmte.TransCode IN ('210', '211', '110', '111'))


ORDER BY cmtca.AcctNum

--Secondary account names contactid - NationalIDNumber
SELECT DISTINCT cmtca.AgencyId, cmtca.LocationCode, cmtca.AcctNum, cmtca.TransCode, cmtca.TransDate, cmtca.ContactId, cmtca.ContactRecType,
        cmtca.NameRelationship, cmtca.LeadContactInd, cmtca.ResponsibleParty, cmtca.PreferredCurrency, cmtbc.ContactRecType, cmtbc.Filler,
        cmtbc.ActionCode, cmtbc.Name, cmtbc.Prefix, cmtbc.FirsstName, cmtbc.MiddleName, cmtbc.LastName, cmtbc.Suffix, cmtbc.MaternalName,
        cmtbc.NationalIDNumber, cmtbc.NationalIDNumberType, cmtbc.DateofBirth,cmtbc.PreferredContactMethod1,cmtbc.PreferredContactMethod2,cmtbc.PreferredContactMethod3, cmtbc.RighttoPrivacy, cmtbc.ISOLanguageCode,
        cmtbc.AddressDisplayFormat, cmtbc.Notes, cmtbc.Employer, cmtbc.CustomerSinceDate, cmtbc.UserDefinedStatus1,
        cmtbc.UserDefinedStatus2, cmtbc.UserDefinedStatus3, cmtbc.UserDefinedStatus4, cmtbc.UserDefinedStatus5, cmtbc.UserDefinedDate1,
        cmtbc.UserDefinedDate2, cmtbc.UserDefinedDate3, cmtbc.UserDefinedDate4, cmtbc.UserDefinedDate5, cmtbc.UserDefinedText1,
        cmtbc.UserDefinedText2, cmtbc.UserDefinedText3, cmtbc.UserDefinedText4, cmtbc.UserDefinedText5, cmtbc.SearchName, cmtbc.UserDefinedSearch1,cmtbc.UserDefinedSearch2,
        cmtbc.DateLastVerified, cmta.ExternalKey AS AddressExternalKey, cmta.NickName, cmta.AddressRelationship, cmta.AddressStatus, cmta.SeasonalAddressFrom, cmta.SeasonalAddressTo,
        cmta.AddressBlockInd, cmta.PrefferredAddressInd, cmta.CreditBureauAddress, cmta.CreditBureauAddressIndicatorDateUpdated,
        cmta.AddressLine1, cmta.AddressLine2, cmta.AddressLine3, cmta.City, cmta.State, cmta.PostalCode, cmta.County, cmta.Country,cmta.AddressTimezone, cmta.ChangeDate AS PriAddressChangeDate,
        cmte.EmailAddress
FROM    Custom_MT_Temp_ContactAcct cmtca WITH ( NOLOCK )
        INNER JOIN Custom_MT_Temp_BaseContact cmtbc WITH ( NOLOCK ) ON cmtca.ContactId = cmtbc.ContactId
        INNER JOIN Custom_MT_Temp_Address cmta WITH (NOLOCK) ON cmtca.ContactId = cmta.ContactId AND cmta.PrefferredAddressInd = 'Y'
        LEFT OUTER JOIN Custom_MT_Temp_Emails cmte WITH (NOLOCK) ON cmtca.ContactId = cmte.ContactId AND cmte.PreferredEmailAddressInd = 'Y' AND cmte.EmailAvailability NOT IN ('I', 'N')
WHERE LeadContactInd <> 'Y' AND cmtca.NameRelationship IN ('A', 'B', 'C') AND cmtca.AcctNum = cmtbc.AcctNumber
AND (cmtca.TransCode IN ('210', '211', '110', '111') or cmtbc.TransCode IN ('210', '211', '110', '111') or cmta.TransCode IN ('210', '211', '110', '111')
or cmte.TransCode IN ('210', '211', '110', '111'))

ORDER BY cmtca.AcctNum

--Other account names contactid - NationalIDNumber
SELECT DISTINCT cmtca.AgencyId, cmtca.LocationCode, cmtca.AcctNum, cmtca.TransCode, cmtca.TransDate, cmtca.ContactId, cmtca.ContactRecType,
        cmtca.NameRelationship, cmtca.LeadContactInd, cmtca.ResponsibleParty, cmtca.PreferredCurrency, cmtbc.ContactRecType, cmtbc.Filler,
        cmtbc.ActionCode, cmtbc.Name, cmtbc.Prefix, cmtbc.FirsstName, cmtbc.MiddleName, cmtbc.LastName, cmtbc.Suffix, cmtbc.MaternalName,
        cmtbc.NationalIDNumber, cmtbc.NationalIDNumberType, cmtbc.DateofBirth, cmtbc.PreferredContactMethod1,cmtbc.PreferredContactMethod2,cmtbc.PreferredContactMethod3,cmtbc.RighttoPrivacy, cmtbc.ISOLanguageCode,
        cmtbc.AddressDisplayFormat, cmtbc.Notes, cmtbc.Employer, cmtbc.CustomerSinceDate, cmtbc.UserDefinedStatus1,
        cmtbc.UserDefinedStatus2, cmtbc.UserDefinedStatus3, cmtbc.UserDefinedStatus4, cmtbc.UserDefinedStatus5, cmtbc.UserDefinedDate1,
        cmtbc.UserDefinedDate2, cmtbc.UserDefinedDate3, cmtbc.UserDefinedDate4, cmtbc.UserDefinedDate5, cmtbc.UserDefinedText1,
        cmtbc.UserDefinedText2, cmtbc.UserDefinedText3, cmtbc.UserDefinedText4, cmtbc.UserDefinedText5, cmtbc.SearchName, cmtbc.UserDefinedSearch1,cmtbc.UserDefinedSearch2,
        cmtbc.DateLastVerified, cmta.ExternalKey AS AddressExternalKey, cmta.NickName, cmta.AddressRelationship, cmta.AddressStatus, cmta.SeasonalAddressFrom, cmta.SeasonalAddressTo,
        cmta.AddressBlockInd, cmta.PrefferredAddressInd, cmta.CreditBureauAddress, cmta.CreditBureauAddressIndicatorDateUpdated,
        cmta.AddressLine1, cmta.AddressLine2, cmta.AddressLine3, cmta.City, cmta.State, cmta.PostalCode, cmta.County, cmta.Country,cmta.AddressTimezone, cmta.ChangeDate AS PriAddressChangeDate,
        cmte.EmailAddress
FROM    Custom_MT_Temp_ContactAcct cmtca WITH ( NOLOCK )
        INNER JOIN Custom_MT_Temp_BaseContact cmtbc WITH ( NOLOCK ) ON cmtca.ContactId = cmtbc.ContactId
        INNER JOIN Custom_MT_Temp_Address cmta WITH (NOLOCK) ON cmtca.ContactId = cmta.ContactId AND cmta.PrefferredAddressInd = 'Y'
        LEFT OUTER JOIN Custom_MT_Temp_Emails cmte WITH (NOLOCK) ON cmtca.ContactId = cmte.ContactId AND cmte.PreferredEmailAddressInd = 'Y' AND cmte.EmailAvailability NOT IN ('I', 'N')
WHERE LeadContactInd <> 'Y' AND cmtca.NameRelationship NOT IN ('A', 'B', 'C') AND cmtca.AcctNum = cmtbc.AcctNumber
AND (cmtca.TransCode IN ('210', '211', '110', '111') or cmtbc.TransCode IN ('210', '211', '110', '111') or cmta.TransCode IN ('210', '211', '110', '111')
or cmte.TransCode IN ('210', '211', '110', '111'))

ORDER BY cmtca.AcctNum

--All Addresses - must map externalkey
SELECT DISTINCT cmta.AgencyId, cmta.LocationCode, cmta.AcctNumber, cmta.TransCode, cmta.TransDate, cmta.ContactId, ContactRecordType, ExternalKey, cmta.ActionCode,
        NickName, AddressRelationship, AddressStatus, SeasonalAddressFrom, SeasonalAddressTo, AddressBlockInd,
        PrefferredAddressInd, CreditBureauAddress, CreditBureauAddressIndicatorDateUpdated, AddressLine1, AddressLine2,
        AddressLine3, City, State, PostalCode, County, Country, AddressTimezone,ChangeDate
FROM    Custom_MT_Temp_Address cmta WITH ( NOLOCK ) 
WHERE cmta.TransCode IN ('210', '211', '110', '111') AND PrefferredAddressInd <> 'Y'

--All Emails - must map externalkey
SELECT DISTINCT  cmte.AgencyId, cmte.LocationCode, cmte.AcctNumber, cmte.TransCode, cmte.TransDate, cmte.ContactId, ContactRecordType, ExternalKey, cmte.ActionCode,
        NickName, EmailAddress, EmailType, EmailAvailability, PreferredEmailAddressInd, ChangeDate,ConsentToContact,TypeOfConsent,SourceOfConsent,DateOfConsent
FROM    Custom_MT_Temp_Emails cmte WITH ( NOLOCK ) 
WHERE cmte.TransCode IN ('210', '211', '110', '111') AND PreferredEmailAddressInd <> 'Y'

--All Phones - must map externalkey
SELECT DISTINCT cmtp.AgencyId, cmtp.LocationCode, cmtp.AcctNumber, cmtp.TransCode, cmtp.TransDate, cmtp.ContactId, cmtp.ContactRecordType, cmtp.ExternalKey, cmtp.ActionCode,
        cmtp.NickName, cmtp.PhoneNumber, cmtp.Extension,cmtp.Priority, cmtp.PhoneType, cmtp.PhoneFormat, cmtp.PhoneAvailability, cmtp.PreferredPhoneNumberInd,
        cmtp.ServiceType, cmtp.DoNotContact, cmtp.ChangeDate, cmtp.CustomerConsent, cmtp.CustomerConsentType, cmtp.CustomerConsentSource, cmtp.DateOfConsent,cmtp.PartyGivingConsent,
		cmtttc.Monday, cmtttc.Tuesday, cmtttc.Wednesday, cmtttc.Thursday, cmtttc.Friday, cmtttc.Saturday, cmtttc.Sunday, cmtttc.AnyTime, cmtttc.StartTime, cmtttc.EndTime, cmtttc.TimeZone
FROM    Custom_MT_Temp_Phones cmtp WITH ( NOLOCK ) INNER JOIN Custom_MT_Temp_TimeToCall cmtttc ON cmtp.ExternalKey = cmtttc.ExternalKey
WHERE cmtp.TransCode IN ('210', '211', '110', '111')

SELECT cmtld.AgencyId, cmtld.LocationCode, cmtld.AcctNumber, cmtld.TransCode, cmtld.TransDate, cmtld.FilingFees, cmtld.StipulationBalance, cmtld.FirstStipPayDueD, cmtld.StipulationPayCnt, 
cmtld.DayStipulationPay, cmtld.FinalStipulationPa, cmtld.FinalStipulationAm, cmtld.StipContractSentD, cmtld.StipContractSigned, cmtld.MTHStipulationAmt, cmtld.FinanceChargePercent, 
cmtld.AttorneyFee, cmtld.AttorneyDataText1, cmtld.AttorneyDataText2, cmtld.AttorneyDataText3, cmtld.AttorneyDataText4, cmtld.AttorneyDataText5, cmtld.AttorneyDataText6, cmtld.AttorneyDataText7, 
cmtld.CourtName, cmtld.AbstractDate, cmtld.PostJudgementExpen, cmtld.JudgementAmt, cmtld.JudgementDate, cmtld.DismissSatisfiedCo, cmtld.DismissSatisfiedDa, cmtld.LevyType, cmtld.LevyAmt, cmtld.LevyDate, 
cmtld.CountyName, cmtld.LevyRequestDate, cmtld.LevyRequestAmt, cmtld.PrincipalAmt, cmtld.OthDelinqAmt, cmtld.IntOwingAtCo, cmtld.ChargeOffDate, cmtld.COAmount, cmtld.AcctOpenDate, cmtld.ModelYear, 
cmtld.Manufacturer, cmtld.Model, cmtld.ReposessionDate, cmtld.SaleDate, cmtld.GrossProceeds, cmtld.BBRepoDate, cmtld.BBSaleDate, cmtld.BBSoldAmount, cmtld.CreditScore, cmtld.OfficerNum, 
cmtld.CollateralCode, cmtld.DateOfDeathPrimary, cmtld.DateOfDeathSSCoMaker, cmtld.DateOfDeathGuarantor, cmtld.TotalCOBalance, cmtld.PmtsCrdtsSinceCO
FROM Custom_MT_Temp_LegalData cmtld
WHERE cmtld.TransCode IN ('213', '113')
		
END
GO

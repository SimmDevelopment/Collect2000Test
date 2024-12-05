SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Export_Transaction_File] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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

SELECT  cc.AgencyId, cc.LocationCode, cc.AcctNum, cc.TransCode, cc.TransDate, cc.ContactId, cc.ContactRecType,
        cc.NameRelationship, cc.LeadContactInd, cc.ResponsibleParty, cc.PreferredCurrency, cb.ContactRecType, cb.Filler,
        cb.ActionCode, cb.Name, cb.Prefix, cb.FirsstName, cb.MiddleName, cb.LastName, cb.Suffix, cb.MaternalName,
        cb.NationalIDNumber, cb.NationalIDNumberType, cb.DateofBirth, cb.RighttoPrivacy, cb.ISOLanguageCode,
        cb.AddressDisplayFormat, cb.Notes, cb.Employer, cb.CustomerSinceDate, cb.UserDefinedStatus1,
        cb.UserDefinedStatus2, cb.UserDefinedStatus3, cb.UserDefinedStatus4, cb.UserDefinedStatus5, cb.UserDefinedDate1,
        cb.UserDefinedDate2, cb.UserDefinedDate3, cb.UserDefinedDate4, cb.UserDefinedDate5, cb.UserDefinedText1,
        cb.UserDefinedText2, cb.UserDefinedText3, cb.UserDefinedText4, cb.UserDefinedText5, cb.SearchName, cb.Fill,
        cb.DateLastVerified
FROM    Custom_USBank_Temp_ContactAcct cc WITH ( NOLOCK )
        INNER JOIN Custom_USBank_Temp_BaseContact cb WITH ( NOLOCK ) ON cc.ContactId = cb.ContactId
ORDER BY cc.AcctNum

SELECT  AgencyId, LocationCode, AcctNumber, TransCode, TransDate, ContactId, ContactRecordType, ExternalKey, ActionCode,
        NickName, AddressRelationship, AddressStatus, SeasonalAddressFrom, SeasonalAddressTo, AddressBlockInd,
        PrefferredAddressInd, CreditBureauAddress, CreditBureauAddressIndicatorDateUpdated, AddressLine1, AddressLine2,
        AddressLine3, City, State, PostalCode, County, Country, ChangeDate
FROM    Custom_USBank_Temp_Address cubta WITH ( NOLOCK )

SELECT  AgencyId, LocationCode, AcctNumber, TransCode, TransDate, ContactId, ContactRecordType, ExternalKey, ActionCode,
        NickName, EmailAddress, EmailType, EmailAvailability, PreferredEmailAddressInd, ChangeDate
FROM    Custom_USBank_Temp_Emails cubte WITH ( NOLOCK )

SELECT  AgencyId, LocationCode, AcctNumber, TransCode, TransDate, ContactId, ContactRecordType, ExternalKey, ActionCode,
        NickName, PhoneNumber, Extension, PhoneType, PhoneFormat, PhoneAvailability, PreferredPhoneNumberInd,
        ServiceType, DoNotContact, ChangeDate, Filler
FROM    Custom_USBank_Temp_Phones cubtp WITH ( NOLOCK )

SELECT  AgencyId, LocationCode, AcctNumber, TransCode, TransDate, ContactId, ContactRecType, ExternalKey, TimePref,
        Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, AnyTime, StartTime, EndTime, TimeZone
FROM    Custom_USBank_Temp_TimeToCall cubtttc WITH ( NOLOCK )

END
GO

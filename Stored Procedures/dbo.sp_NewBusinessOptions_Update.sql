SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_NewBusinessOptions_Update*/
CREATE Procedure [dbo].[sp_NewBusinessOptions_Update]
@NewBusinessOptionsID int,
@CustomerID varchar(10),
@AllowZipcodeEntry bit,
@SkipExtraData bit,
@SkipMiscExtraData bit,
@AutoZip bit,
@MultipleFieldSchedules bit,
@LinkOnSsn bit,
@AllowDupeCustomerAccount bit,
@SkipDates bit,
@FieldWorkPhone bit,
@FieldFax bit,
@FieldEmail bit,
@FieldPager bit,
@FieldDriverLicense bit,
@FieldSsn bit,
@FieldInterestRateAndDate bit,
@FieldDob bit,
@FieldUserDate1 bit,
@FieldUserDate2 bit,
@FieldUserDate3 bit,
@FieldDelinqDate bit,
@FieldBucket2 bit,
@FieldBucket3 bit,
@FieldBucket4 bit,
@FieldBucket5 bit,
@FieldBucket6 bit,
@FieldBucket7 bit,
@FieldBucket8 bit,
@FieldBucket9 bit
AS

UPDATE NewBusinessOptions
SET
CustomerID = @CustomerID,
AllowZipcodeEntry = @AllowZipcodeEntry,
SkipExtraData = @SkipExtraData,
SkipMiscExtraData = @SkipMiscExtraData,
AutoZip = @AutoZip,
MultipleFieldSchedules = @MultipleFieldSchedules,
LinkOnSsn = @LinkOnSsn,
AllowDupeCustomerAccount = @AllowDupeCustomerAccount,
SkipDates = @SkipDates,
FieldWorkPhone = @FieldWorkPhone,
FieldFax = @FieldFax,
FieldEmail = @FieldEmail,
FieldPager = @FieldPager,
FieldDriverLicense = @FieldDriverLicense,
FieldSsn = @FieldSsn,
FieldInterestRateAndDate = @FieldInterestRateAndDate,
FieldDob = @FieldDob,
FieldUserDate1 = @FieldUserDate1,
FieldUserDate2 = @FieldUserDate2,
FieldUserDate3 = @FieldUserDate3,
FieldDelinqDate = @FieldDelinqDate,
FieldBucket2 = @FieldBucket2,
FieldBucket3 = @FieldBucket3,
FieldBucket4 = @FieldBucket4,
FieldBucket5 = @FieldBucket5,
FieldBucket6 = @FieldBucket6,
FieldBucket7 = @FieldBucket7,
FieldBucket8 = @FieldBucket8,
FieldBucket9 = @FieldBucket9
WHERE NewBusinessOptionsID = @NewBusinessOptionsID

GO

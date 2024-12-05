SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*sp_NewBusinessOptions_Add*/
CREATE  Procedure [dbo].[sp_NewBusinessOptions_Add]
@NewBusinessOptionsID int OUTPUT,
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

INSERT INTO NewBusinessOptions
(
CustomerID,
AllowZipcodeEntry,
SkipExtraData,
SkipMiscExtraData,
AutoZip,
MultipleFieldSchedules,
LinkOnSsn,
AllowDupeCustomerAccount,
SkipDates,
FieldWorkPhone,
FieldFax,
FieldEmail,
FieldPager,
FieldDriverLicense,
FieldSsn,
FieldInterestRateAndDate,
FieldDob,
FieldUserDate1,
FieldUserDate2,
FieldUserDate3,
FieldDelinqDate,
FieldBucket2,
FieldBucket3,
FieldBucket4,
FieldBucket5,
FieldBucket6,
FieldBucket7,
FieldBucket8,
FieldBucket9
)
VALUES
(
@CustomerID,
@AllowZipcodeEntry,
@SkipExtraData,
@SkipMiscExtraData,
@AutoZip,
@MultipleFieldSchedules,
@LinkOnSsn,
@AllowDupeCustomerAccount,
@SkipDates,
@FieldWorkPhone,
@FieldFax,
@FieldEmail,
@FieldPager,
@FieldDriverLicense,
@FieldSsn,
@FieldInterestRateAndDate,
@FieldDob,
@FieldUserDate1,
@FieldUserDate2,
@FieldUserDate3,
@FieldDelinqDate,
@FieldBucket2,
@FieldBucket3,
@FieldBucket4,
@FieldBucket5,
@FieldBucket6,
@FieldBucket7,
@FieldBucket8,
@FieldBucket9
)

SET @NewBusinessOptionsID = SCOPE_IDENTITY()



GO

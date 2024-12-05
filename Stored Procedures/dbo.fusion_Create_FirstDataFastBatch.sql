SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.fusion_Create_FirstDataFastBatch.sql*/
Create  PROCEDURE [dbo].[fusion_Create_FirstDataFastBatch]
AS--fusion_Create_FirstDataFastBatch.sql
-- Name:		fusion_Create_FirstDataFastBatch.sql
-- Function:		This procedure will create required database objects to
--			implement firstdata fastbatch 
-- Creation:		05/15/2008 DRG
--			 FirstData FastBatch 
-- Change History:	
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_Main' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_Main(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
InputName varchar(48) null, 
InputUrbanization varchar(28) null, 
InputDeliveryAddress varchar(48) null, 
InputOptionalAddress varchar(48) null, 
InputCity varchar(28) null, 
InputState varchar(2) null, 
InputZIPCodeTM varchar(5) null, 
InputPhoneNumber varchar(10) null, 
InputSSN varchar(9) null, 
UserReferenceArea varchar(30) null, 
SecondaryUserReferenceArea varchar(30) null,
ReturnPremium1ResultCode varchar(2) null, 
ReturnPremium2ResultCode varchar(2) null, 
ReturnPremium3ResultCode varchar(2) null, 
ReturnPremium4ResultCode varchar(2) null, 
ReturnPremium5ResultCode varchar(2) null, 
ZIP41ResultCode varchar(2) null, 
NCOA2ResultCode varchar(2) null, 
Reservedforfutureuse varchar(2) null, 
NeighborResultCode varchar(2) null, 
DAResultCode varchar(2) null, 
NameAddressVerificationResultCode varchar(2) null, 
NameAddressAppendResultCodePhoneSearch varchar(2) null, 
DPVTMResultCode varchar(2) null, 
RelativesResultCode varchar(2) null, 
AddressHistoryResultCode varchar(2) null, 
SSNSearchResultCode varchar(2) null, 
AssociatesResultCode varchar(2) 
CONSTRAINT [PK_Services_FirstData_FastBatch_Main] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_ZIP4' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_ZIP4(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
ZIP4Urbanization varchar(28) null, 
ZIP4StandardizedDeliveryAddress varchar(48) null, 
ZIP4StandardizedOptionalAddress varchar(48) null, 
ZIP4StandardizedCity varchar(28) null, 
ZIP4StandardizedState varchar(2) null, 
ZIP45DigitZIPCode varchar(5) null, 
ZIP44DigitAddOnCode varchar(4) null, 
ZIP4DeliveryPointCode varchar(3) null, 
ZIP4CarrierRoute varchar(4) null, 
ZIP4MatchLevel varchar(1) null, 
ZIP4Footnotes varchar(10) null, 
ZIP4RecordType varchar(2) null, 
ZIP4CountyCode varchar(3) null, 
ZIP4DwellingUnits varchar(1) null, 
ZIP4LACSIndicator varchar(1) null, 
ZIP4PMB varchar(12) null, 
DPVTMReturnCode varchar(1) null, 
DPVTMFootnotes varchar(8) null, 
EWSIndicator varchar(1)
 CONSTRAINT [PK_Services_FirstData_FastBatch_ZIP4] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)

if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_PhoneAppend' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_PhoneAppend(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
 PhoneAppendLevelofMatch varchar(1) null, 
MultipleResponseCount varchar(3) null, 
AppendedPhoneNumberSource varchar(1) null, 
PhoneAppendVerificationCode varchar(1) null, 
DALevelofMatchCode varchar(2) null, 
NCOAOriginalInputAddressPhone varchar(10)
 CONSTRAINT [PK_Services_FirstData_FastBatch_PhoneAppend] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_ReturnInformation' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_ReturnInformation(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
Seq int null,
OutputName varchar(40) null, 
OutputAddress varchar(48) null, 
OutputCity varchar(30) null, 
OutputState varchar(2) null, 
Output5DigitZIPCode varchar(5) null, 
Output4DigitAddOnCode varchar(4) null, 
ReturnedPhoneNumber varchar(10) null, 
LastReportDate varchar(6) null, 
FirstReportDate varchar(6) null, 
DateofBirth varchar(8) null, 
DeceasedFlag varchar(1)
 CONSTRAINT [PK_Services_FirstData_FastBatch_ReturnInformation] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_AdditionalData' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_AdditionalData(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
OutputDwellingUnits varchar(2) null, 
Age varchar(2) null, 
GenderCode varchar(1) null, 
LengthofResidence varchar(2) null, 
ReservedforFutureUse varchar(4) null, 
PremiumResultCodes varchar(3)
 CONSTRAINT [PK_Services_FirstData_FastBatch_AdditionalData] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_AdditionalHouseholdMembers' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_AdditionalHouseholdMembers(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
HouseholdMember1Name varchar(9) null, 
HouseholdMember1AgeCode varchar(2) null, 
HouseholdMember1GenderCode varchar(1) null, 
HouseholdMember2Name varchar(9) null, 
HouseholdMember2AgeCode varchar(2) null, 
HouseholdMember2GenderCode varchar(1) null, 
HouseholdMember3Name varchar(9) null, 
HouseholdMember3AgeCode varchar(2) null, 
HouseholdMember3GenderCode varchar(1) null, 
HouseholdMember4Name varchar(9) null, 
HouseholdMember4AgeCode varchar(2) null, 
HouseholdMember4GenderCode varchar(1) null, 
HouseholdMember5Name varchar(9) null, 
HouseholdMember5AgeCode varchar(2) null, 
HouseholdMember5GenderCode varchar(1) null, 
SESIIndicator varchar(2) null, 
IncomeRange varchar(1) null, 
ClusterCode varchar(2) null, 
DesignatedMarketArea varchar(3) null, 
AreaDominantInfluence varchar(3) null, 
LACSLinkTMReturnCode varchar(2) null, 
ReservedforFutureUse varchar(3)
 CONSTRAINT [PK_Services_FirstData_FastBatch_AdditionalHouseholdMembers] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)



if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_NCOA' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_NCOA(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
NCOAFootnotes varchar(50) null, 
NCOAUrbanization varchar(28) null, 
NCOAAddress varchar(48) null, 
NCOACity varchar(28) null, 
NCOAState varchar(2) null, 
NCOA5DigitZIPCodeTM varchar(5) null, 
NCOA4DigitAddOnCode varchar(4) null, 
NCOADeliveryPointCode varchar(3) null, 
NCOAMoveType varchar(1) null, 
NCOAMoveEffectiveDateCCYYMM varchar(6) null, 
NCOACarrierRoute varchar(4) null, 
NCOACountyCode varchar(3) null, 
DirectMarketingAssociationDMASuppressionCode varchar(1) null, 
NCOAMatchRangeFlag varchar(1) null, 
ReservedForFutureUse varchar(3) null, 
FirstDatause varchar(6) null, 
NumberofNeighborsRequested varchar(2) null, 
NumberofMultiplesRequested varchar(2)
 CONSTRAINT [PK_Services_FirstData_FastBatch_NCOA] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_Neighbors' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_Neighbors(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
seq int null,
NumberofNeighborsReturned varchar(2) null, 
NeighborName varchar(25) null, 
NeighborAddress varchar(25) null, 
NeighborZipCode varchar(5) null, 
NeighborPhoneNumber varchar(10) null, 
NeighborDwellingUnits varchar(2) null, 
NeighborLengthofResidence varchar(2)
 CONSTRAINT [PK_Services_FirstData_FastBatch_Neighbors] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)



if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_Multiples' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_Multiples(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
seq int null,
NumberofMultiplesReturned varchar(2) null, 
MultipleName varchar(25) null, 
MultipleAddress varchar(25) null, 
MultipleCity varchar(28) null, 
MultipleState varchar(2) null, 
MultipleZipCode varchar(5) null, 
MultiplePhoneNumber varchar(10) null, 
MultipleLastReportDateCCYYMM varchar(6) null, 
MultipleFirstReportDateCCYYMM varchar(6) null, 
MultipleDateofBirthCCYYMM varchar(6) null, 
MultipleDeceasedFlag varchar(1)
 CONSTRAINT [PK_Services_FirstData_FastBatch_Multiples] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_PublicRecords' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_PublicRecords(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
 PublicInformationResultCodes varchar(2) null, 
DeceasedMatchResultCodes varchar(2) null, 
CorrectionalMatchResultCodes varchar(2) null, 
BankruptcyCount varchar(2) null, 
 TaxLienCount varchar(2) null, 
JudgmentCount varchar(2) null, 
MatchedSSN varchar(9)
 CONSTRAINT [PK_Services_FirstData_FastBatch_PublicRecords] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_Deceased' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_Deceased(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
MatchedSSN varchar(9) null, 
MatchedSurname varchar(12) null, 
MatchedFirstName varchar(10) null, 
DateOfDeathMMDDCCYY varchar(8) null, 
DateOfBirthMMDDCCYY varchar(8) null, 
Addressifavailable varchar(39) null, 
Cityifavailable varchar(25) null, 
Stateifavailable varchar(2) null, 
ZipCodeifavailable varchar(5)
 CONSTRAINT [PK_Services_FirstData_FastBatch_Deceased] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)



if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_Bankruptcy' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_Bankruptcy(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
Matchtyperesultcode varchar(2) null, 
TypeofRecord varchar(2) null, 
AssociationCode1Single2Joint varchar(1) null, 
CourtID varchar(7) null, 
CourtName varchar(35) null, 
CourtAddress varchar(35) null, 
CourtCity varchar(20) null, 
CourtState varchar(2) null, 
CourtZip varchar(5) null, 
CourtPhoneNumber varchar(10) null, 
OriginalChapter varchar(2) null, 
CaseNumber varchar(17) null, 
Filler varchar(6) null, 
FilingDateMMDDYYYY varchar(8) null, 
DispositionCodeDDischargeRDismissal varchar(1) null, 
ConvertedChapter varchar(2) null, 
DismissalDischargeDateMMDDYYYY varchar(8) null, 
Liability varchar(9) null, 
Assets varchar(9) null, 
AttorneyFirm varchar(32) null, 
AttorneyName varchar(25) null, 
AttorneyAddress varchar(32) null, 
AttorneyCity varchar(24) null, 
AttorneyState varchar(2) null, 
AttorneyZip varchar(5) null, 
AttorneyPhone varchar(10) null, 
AssetsAvailableYYesNNoUUnknown varchar(1) null, 
Scheduled341DateMMDDYYYY varchar(8) null, 
Scheduled341TimeHHMM varchar(4) null, 
Scheduled341Location varchar(30) null, 
JudgesInitials varchar(3) null, 
OtherCaseNumber varchar(13) null, 
DefendantSSN varchar(9) null, 
DefendantName varchar(32) null, 
DefendantGenerationCode varchar(1) null, 
DefendantAddress varchar(32) null, 
DefendantCity varchar(24) null, 
DefendantState varchar(2) null, 
DefendantZip varchar(5) null, 
TrusteeName varchar(25) null, 
TrusteeAddress varchar(28) null, 
TrusteeCity varchar(18) null, 
TrusteeState varchar(2) null, 
TrusteeZip varchar(5) null, 
TrusteePhone varchar(10) null, 
BankruptcyAddedUpdatedDateMMDDYYYY varchar(8) null, 
BankruptcyFileTypeCode varchar(2) null, 
CodefendantSSNNumber varchar(9) null, 
CodefendantName varchar(32) null, 
CodefendantAddress varchar(32) null, 
CodefendantCity varchar(24) null, 
CodefendantState varchar(2) null, 
CodefendantZip varchar(5) null, 
ConfirmationHearingDateYYMMDD varchar(6) null, 
OriginalAssetsAvailable varchar(1) null, 
ProofofClaimDateYYMMDD varchar(6) null, 
ComplaintDeadlineDateYYMMDD varchar(6)
 CONSTRAINT [PK_Services_FirstData_FastBatch_Bankruptcy] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)

if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_Relatives' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_Relatives(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
seq int null,
NumberofRelativesReturned varchar(2) null, 
Relative varchar(25) null, 
RelativeAddress varchar(25) null, 
RelativeCity varchar(15) null, 
RelativeState varchar(2) null, 
RelativeZipCode varchar(10) null, 
RelativePhoneNumber varchar(10) null, 
RelativeLastReportedDateCCYYMM varchar(8) null, 
RelativeFirstReportedDateCCYYMM varchar(8) null, 
RelativeDateofBirthMMCCYY varchar(8) null, 
Filler varchar(17) null, 
DegreeofRelative varchar(1)
 CONSTRAINT [PK_Services_FirstData_FastBatch_Relatives] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_AddressHistory' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_AddressHistory(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
seq int null,
NumberofPreviousAddressesReturned varchar(2) null, 
PreviousAddressName varchar(25) null, 
PreviousAddress varchar(25) null, 
PreviousAddressCity varchar(15) null, 
PreviousState varchar(2) null, 
PreviousZipCode varchar(10) null, 
PreviousAddressLastReportedDateCCYYMM varchar(8) null, 
PreviousAddressFirstReportedDateCCYYMM varchar(8) null, 
PreviousAddressSSN varchar(9) null, 
Filler varchar(8)
 CONSTRAINT [PK_Services_FirstData_FastBatch_AddressHistory] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


if  not  exists( select * from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME='Services_FirstData_FastBatch_Associates' )

CREATE TABLE [dbo].Services_FirstData_FastBatch_Associates(

[ID] [int] IDENTITY(1,1) NOT NULL,
RequestId int  null,
seq int null,
NumberofAssociatesReturned varchar(2) null, 
Associate varchar(25) null, 
AssociateAddress varchar(25) null, 
AssociateCity varchar(15) null, 
AssociateState varchar(2) null, 
AssociateZipCode varchar(10) null, 
AssociatePhoneNumber varchar(10) null, 
AssociateLastReportedDateCCYYMM varchar(8) null, 
AssociateFirstReportedDateCCYYMM varchar(8) null, 
AssociateDateofBirthMMCCYY varchar(8) null, 
Filler varchar(17) null, 
Filler1 varchar(1) null,
Filler2 varchar(18)
 CONSTRAINT [PK_Services_FirstData_FastBatch_Associates] PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	) ON [PRIMARY]
	)


-- Conditions Script File, exported on 5/16/2008 10:20 AM
-- Age
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'Age') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'Age';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData', 'Age', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalData].[Age]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Age</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalData]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalData</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalData].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- GenderCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'GenderCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'GenderCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData', 'GenderCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalData].[GenderCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">GenderCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalData]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalData</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalData].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_AdditionalData].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_AdditionalData]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_AdditionalData</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalData].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LengthofResidence
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'LengthofResidence') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'LengthofResidence';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData', 'LengthofResidence', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalData].[LengthofResidence]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LengthofResidence</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalData]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalData</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalData].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OutputDwellingUnits
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'OutputDwellingUnits') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'OutputDwellingUnits';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData', 'OutputDwellingUnits', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalData].[OutputDwellingUnits]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OutputDwellingUnits</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalData]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalData</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalData].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PremiumResultCodes
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'PremiumResultCodes') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'PremiumResultCodes';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData', 'PremiumResultCodes', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalData].[PremiumResultCodes]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PremiumResultCodes</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalData]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalData</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalData].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_AdditionalData].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_AdditionalData]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_AdditionalData</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalData].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReservedforFutureUse
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'ReservedforFutureUse') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData' AND [Description] = 'ReservedforFutureUse';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalData', 'ReservedforFutureUse', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalData].[ReservedforFutureUse]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReservedforFutureUse</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalData]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalData</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalData].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AreaDominantInfluence
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'AreaDominantInfluence') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'AreaDominantInfluence';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'AreaDominantInfluence', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[AreaDominantInfluence]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AreaDominantInfluence</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ClusterCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'ClusterCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'ClusterCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'ClusterCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[ClusterCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ClusterCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DesignatedMarketArea
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'DesignatedMarketArea') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'DesignatedMarketArea';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'DesignatedMarketArea', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[DesignatedMarketArea]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DesignatedMarketArea</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember1AgeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember1AgeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember1AgeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember1AgeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember1AgeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember1AgeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember1GenderCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember1GenderCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember1GenderCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember1GenderCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember1GenderCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember1GenderCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember1Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember1Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember1Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember1Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember1Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember1Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember2AgeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember2AgeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember2AgeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember2AgeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember2AgeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember2AgeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember2GenderCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember2GenderCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember2GenderCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember2GenderCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember2GenderCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember2GenderCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember2Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember2Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember2Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember2Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember2Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember2Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember3AgeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember3AgeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember3AgeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember3AgeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember3AgeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember3AgeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember3GenderCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember3GenderCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember3GenderCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember3GenderCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember3GenderCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember3GenderCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember3Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember3Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember3Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember3Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember3Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember3Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember4AgeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember4AgeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember4AgeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember4AgeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember4AgeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember4AgeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember4GenderCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember4GenderCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember4GenderCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember4GenderCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember4GenderCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember4GenderCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember4Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember4Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember4Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember4Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember4Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember4Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember5AgeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember5AgeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember5AgeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember5AgeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember5AgeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember5AgeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember5GenderCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember5GenderCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember5GenderCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember5GenderCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember5GenderCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember5GenderCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- HouseholdMember5Name
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember5Name') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'HouseholdMember5Name';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'HouseholdMember5Name', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[HouseholdMember5Name]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">HouseholdMember5Name</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- IncomeRange
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'IncomeRange') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'IncomeRange';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'IncomeRange', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[IncomeRange]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">IncomeRange</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LACSLinkTMReturnCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'LACSLinkTMReturnCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'LACSLinkTMReturnCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'LACSLinkTMReturnCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[LACSLinkTMReturnCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LACSLinkTMReturnCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReservedforFutureUse
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'ReservedforFutureUse') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'ReservedforFutureUse';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'ReservedforFutureUse', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[ReservedforFutureUse]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReservedforFutureUse</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SESIIndicator
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'SESIIndicator') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers' AND [Description] = 'SESIIndicator';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AdditionalHouseholdMembers', 'SESIIndicator', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AdditionalHouseholdMembers].[SESIIndicator]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">SESIIndicator</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AdditionalHouseholdMembers]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AdditionalHouseholdMembers</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AdditionalHouseholdMembers].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Filler
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'Filler') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'Filler';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'Filler', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[Filler]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Filler</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_AddressHistory].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NumberofPreviousAddressesReturned
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'NumberofPreviousAddressesReturned') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'NumberofPreviousAddressesReturned';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'NumberofPreviousAddressesReturned', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[NumberofPreviousAddressesReturned]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NumberofPreviousAddressesReturned</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PreviousAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'PreviousAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[PreviousAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PreviousAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PreviousAddressCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'PreviousAddressCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[PreviousAddressCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PreviousAddressCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PreviousAddressFirstReportedDateCCYYMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressFirstReportedDateCCYYMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressFirstReportedDateCCYYMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'PreviousAddressFirstReportedDateCCYYMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[PreviousAddressFirstReportedDateCCYYMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PreviousAddressFirstReportedDateCCYYMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PreviousAddressLastReportedDateCCYYMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressLastReportedDateCCYYMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressLastReportedDateCCYYMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'PreviousAddressLastReportedDateCCYYMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[PreviousAddressLastReportedDateCCYYMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PreviousAddressLastReportedDateCCYYMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PreviousAddressName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'PreviousAddressName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[PreviousAddressName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PreviousAddressName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PreviousAddressSSN
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressSSN') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousAddressSSN';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'PreviousAddressSSN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[PreviousAddressSSN]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PreviousAddressSSN</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PreviousState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'PreviousState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[PreviousState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PreviousState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PreviousZipCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousZipCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'PreviousZipCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'PreviousZipCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_AddressHistory].[PreviousZipCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PreviousZipCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_AddressHistory].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- seq
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'seq') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory' AND [Description] = 'seq';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_AddressHistory', 'seq', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_AddressHistory].[seq]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">seq</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_AddressHistory]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_AddressHistory</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_AddressHistory].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Associate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'Associate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'Associate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'Associate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[Associate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Associate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociateAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'AssociateAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[AssociateAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociateAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociateCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'AssociateCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[AssociateCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociateCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociateDateofBirthMMCCYY
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateDateofBirthMMCCYY') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateDateofBirthMMCCYY';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'AssociateDateofBirthMMCCYY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[AssociateDateofBirthMMCCYY]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociateDateofBirthMMCCYY</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociateFirstReportedDateCCYYMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateFirstReportedDateCCYYMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateFirstReportedDateCCYYMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'AssociateFirstReportedDateCCYYMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[AssociateFirstReportedDateCCYYMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociateFirstReportedDateCCYYMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociateLastReportedDateCCYYMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateLastReportedDateCCYYMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateLastReportedDateCCYYMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'AssociateLastReportedDateCCYYMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[AssociateLastReportedDateCCYYMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociateLastReportedDateCCYYMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociatePhoneNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociatePhoneNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociatePhoneNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'AssociatePhoneNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[AssociatePhoneNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociatePhoneNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociateState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'AssociateState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[AssociateState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociateState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociateZipCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateZipCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'AssociateZipCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'AssociateZipCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[AssociateZipCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociateZipCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Filler
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'Filler') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'Filler';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'Filler', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[Filler]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Filler</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Filler1
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'Filler1') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'Filler1';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'Filler1', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[Filler1]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Filler1</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Filler2
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'Filler2') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'Filler2';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'Filler2', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[Filler2]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Filler2</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Associates].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NumberofAssociatesReturned
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'NumberofAssociatesReturned') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'NumberofAssociatesReturned';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'NumberofAssociatesReturned', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Associates].[NumberofAssociatesReturned]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NumberofAssociatesReturned</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Associates].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- seq
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'seq') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates' AND [Description] = 'seq';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Associates', 'seq', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Associates].[seq]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">seq</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Associates]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Associates</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Associates].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Assets
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Assets') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Assets';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'Assets', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[Assets]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Assets</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssetsAvailableYYesNNoUUnknown
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AssetsAvailableYYesNNoUUnknown') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AssetsAvailableYYesNNoUUnknown';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AssetsAvailableYYesNNoUUnknown', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AssetsAvailableYYesNNoUUnknown]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssetsAvailableYYesNNoUUnknown</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociationCode1Single2Joint
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AssociationCode1Single2Joint') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AssociationCode1Single2Joint';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AssociationCode1Single2Joint', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AssociationCode1Single2Joint]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociationCode1Single2Joint</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AttorneyAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AttorneyAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AttorneyCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AttorneyCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyFirm
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyFirm') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyFirm';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AttorneyFirm', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AttorneyFirm]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyFirm</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AttorneyName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AttorneyName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AttorneyPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AttorneyPhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AttorneyState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AttorneyState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AttorneyZip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyZip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'AttorneyZip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'AttorneyZip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[AttorneyZip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AttorneyZip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- BankruptcyAddedUpdatedDateMMDDYYYY
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'BankruptcyAddedUpdatedDateMMDDYYYY') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'BankruptcyAddedUpdatedDateMMDDYYYY';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'BankruptcyAddedUpdatedDateMMDDYYYY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[BankruptcyAddedUpdatedDateMMDDYYYY]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">BankruptcyAddedUpdatedDateMMDDYYYY</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- BankruptcyFileTypeCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'BankruptcyFileTypeCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'BankruptcyFileTypeCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'BankruptcyFileTypeCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[BankruptcyFileTypeCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">BankruptcyFileTypeCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CaseNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CaseNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CaseNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CaseNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CaseNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CaseNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CodefendantAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CodefendantAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CodefendantAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CodefendantAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CodefendantCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CodefendantCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CodefendantCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CodefendantCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CodefendantName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CodefendantName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CodefendantName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CodefendantName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CodefendantSSNNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantSSNNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantSSNNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CodefendantSSNNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CodefendantSSNNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CodefendantSSNNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CodefendantState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CodefendantState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CodefendantState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CodefendantState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CodefendantZip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantZip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CodefendantZip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CodefendantZip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CodefendantZip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CodefendantZip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ComplaintDeadlineDateYYMMDD
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ComplaintDeadlineDateYYMMDD') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ComplaintDeadlineDateYYMMDD';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'ComplaintDeadlineDateYYMMDD', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[ComplaintDeadlineDateYYMMDD]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ComplaintDeadlineDateYYMMDD</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ConfirmationHearingDateYYMMDD
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ConfirmationHearingDateYYMMDD') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ConfirmationHearingDateYYMMDD';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'ConfirmationHearingDateYYMMDD', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[ConfirmationHearingDateYYMMDD]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ConfirmationHearingDateYYMMDD</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ConvertedChapter
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ConvertedChapter') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ConvertedChapter';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'ConvertedChapter', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[ConvertedChapter]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ConvertedChapter</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CourtAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CourtAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CourtAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CourtAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CourtCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CourtCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CourtCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CourtCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CourtID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CourtID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CourtID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CourtID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CourtName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CourtName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CourtName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CourtName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CourtPhoneNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtPhoneNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtPhoneNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CourtPhoneNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CourtPhoneNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CourtPhoneNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CourtState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CourtState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CourtState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CourtState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CourtZip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtZip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'CourtZip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'CourtZip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[CourtZip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CourtZip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DefendantAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DefendantAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DefendantAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DefendantAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DefendantCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DefendantCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DefendantCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DefendantCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DefendantGenerationCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantGenerationCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantGenerationCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DefendantGenerationCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DefendantGenerationCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DefendantGenerationCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DefendantName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DefendantName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DefendantName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DefendantName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DefendantSSN
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantSSN') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantSSN';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DefendantSSN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DefendantSSN]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DefendantSSN</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DefendantState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DefendantState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DefendantState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DefendantState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DefendantZip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantZip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DefendantZip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DefendantZip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DefendantZip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DefendantZip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DismissalDischargeDateMMDDYYYY
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DismissalDischargeDateMMDDYYYY') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DismissalDischargeDateMMDDYYYY';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DismissalDischargeDateMMDDYYYY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DismissalDischargeDateMMDDYYYY]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DismissalDischargeDateMMDDYYYY</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DispositionCodeDDischargeRDismissal
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DispositionCodeDDischargeRDismissal') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'DispositionCodeDDischargeRDismissal';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'DispositionCodeDDischargeRDismissal', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[DispositionCodeDDischargeRDismissal]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DispositionCodeDDischargeRDismissal</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FilingDateMMDDYYYY
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'FilingDateMMDDYYYY') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'FilingDateMMDDYYYY';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'FilingDateMMDDYYYY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[FilingDateMMDDYYYY]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FilingDateMMDDYYYY</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Filler
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Filler') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Filler';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'Filler', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[Filler]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Filler</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Bankruptcy].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- JudgesInitials
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'JudgesInitials') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'JudgesInitials';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'JudgesInitials', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[JudgesInitials]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">JudgesInitials</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Liability
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Liability') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Liability';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'Liability', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[Liability]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Liability</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Matchtyperesultcode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Matchtyperesultcode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Matchtyperesultcode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'Matchtyperesultcode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[Matchtyperesultcode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Matchtyperesultcode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OriginalAssetsAvailable
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'OriginalAssetsAvailable') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'OriginalAssetsAvailable';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'OriginalAssetsAvailable', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[OriginalAssetsAvailable]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OriginalAssetsAvailable</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OriginalChapter
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'OriginalChapter') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'OriginalChapter';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'OriginalChapter', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[OriginalChapter]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OriginalChapter</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OtherCaseNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'OtherCaseNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'OtherCaseNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'OtherCaseNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[OtherCaseNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OtherCaseNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ProofofClaimDateYYMMDD
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ProofofClaimDateYYMMDD') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'ProofofClaimDateYYMMDD';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'ProofofClaimDateYYMMDD', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[ProofofClaimDateYYMMDD]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ProofofClaimDateYYMMDD</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Bankruptcy].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Scheduled341DateMMDDYYYY
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Scheduled341DateMMDDYYYY') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Scheduled341DateMMDDYYYY';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'Scheduled341DateMMDDYYYY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[Scheduled341DateMMDDYYYY]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Scheduled341DateMMDDYYYY</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Scheduled341Location
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Scheduled341Location') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Scheduled341Location';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'Scheduled341Location', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[Scheduled341Location]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Scheduled341Location</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Scheduled341TimeHHMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Scheduled341TimeHHMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'Scheduled341TimeHHMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'Scheduled341TimeHHMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[Scheduled341TimeHHMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Scheduled341TimeHHMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TrusteeAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'TrusteeAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[TrusteeAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TrusteeAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TrusteeCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'TrusteeCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[TrusteeCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TrusteeCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TrusteeName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'TrusteeName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[TrusteeName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TrusteeName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TrusteePhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteePhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteePhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'TrusteePhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[TrusteePhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TrusteePhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TrusteeState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'TrusteeState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[TrusteeState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TrusteeState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TrusteeZip
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeZip') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TrusteeZip';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'TrusteeZip', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[TrusteeZip]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TrusteeZip</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TypeofRecord
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TypeofRecord') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy' AND [Description] = 'TypeofRecord';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Bankruptcy', 'TypeofRecord', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Bankruptcy].[TypeofRecord]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TypeofRecord</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Bankruptcy]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Bankruptcy</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Bankruptcy].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Addressifavailable
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'Addressifavailable') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'Addressifavailable';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'Addressifavailable', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[Addressifavailable]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Addressifavailable</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Cityifavailable
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'Cityifavailable') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'Cityifavailable';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'Cityifavailable', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[Cityifavailable]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Cityifavailable</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DateOfBirthMMDDCCYY
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'DateOfBirthMMDDCCYY') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'DateOfBirthMMDDCCYY';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'DateOfBirthMMDDCCYY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[DateOfBirthMMDDCCYY]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DateOfBirthMMDDCCYY</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DateOfDeathMMDDCCYY
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'DateOfDeathMMDDCCYY') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'DateOfDeathMMDDCCYY';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'DateOfDeathMMDDCCYY', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[DateOfDeathMMDDCCYY]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DateOfDeathMMDDCCYY</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Deceased].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MatchedFirstName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'MatchedFirstName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'MatchedFirstName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'MatchedFirstName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[MatchedFirstName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MatchedFirstName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MatchedSSN
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'MatchedSSN') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'MatchedSSN';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'MatchedSSN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[MatchedSSN]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MatchedSSN</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MatchedSurname
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'MatchedSurname') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'MatchedSurname';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'MatchedSurname', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[MatchedSurname]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MatchedSurname</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Deceased].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Stateifavailable
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'Stateifavailable') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'Stateifavailable';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'Stateifavailable', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[Stateifavailable]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Stateifavailable</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZipCodeifavailable
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'ZipCodeifavailable') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased' AND [Description] = 'ZipCodeifavailable';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Deceased', 'ZipCodeifavailable', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Deceased].[ZipCodeifavailable]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZipCodeifavailable</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Deceased]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Deceased</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Deceased].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AddressHistoryResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'AddressHistoryResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'AddressHistoryResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'AddressHistoryResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[AddressHistoryResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AddressHistoryResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AssociatesResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'AssociatesResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'AssociatesResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'AssociatesResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[AssociatesResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AssociatesResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DAResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'DAResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'DAResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'DAResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[DAResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DAResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DPVTMResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'DPVTMResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'DPVTMResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'DPVTMResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[DPVTMResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DPVTMResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Main].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputDeliveryAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputDeliveryAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputDeliveryAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputDeliveryAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputDeliveryAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputDeliveryAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputOptionalAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputOptionalAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputOptionalAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputOptionalAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputOptionalAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputOptionalAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputPhoneNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputPhoneNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputPhoneNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputPhoneNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputPhoneNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputPhoneNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputSSN
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputSSN') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputSSN';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputSSN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputSSN]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputSSN</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputUrbanization
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputUrbanization') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputUrbanization';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputUrbanization', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputUrbanization]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputUrbanization</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- InputZIPCodeTM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputZIPCodeTM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'InputZIPCodeTM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'InputZIPCodeTM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[InputZIPCodeTM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">InputZIPCodeTM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NameAddressAppendResultCodePhoneSearch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'NameAddressAppendResultCodePhoneSearch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'NameAddressAppendResultCodePhoneSearch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'NameAddressAppendResultCodePhoneSearch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[NameAddressAppendResultCodePhoneSearch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NameAddressAppendResultCodePhoneSearch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NameAddressVerificationResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'NameAddressVerificationResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'NameAddressVerificationResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'NameAddressVerificationResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[NameAddressVerificationResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NameAddressVerificationResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOA2ResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'NCOA2ResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'NCOA2ResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'NCOA2ResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[NCOA2ResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOA2ResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NeighborResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'NeighborResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'NeighborResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'NeighborResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[NeighborResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NeighborResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RelativesResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'RelativesResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'RelativesResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'RelativesResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[RelativesResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">RelativesResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Main].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Reservedforfutureuse
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'Reservedforfutureuse') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'Reservedforfutureuse';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'Reservedforfutureuse', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[Reservedforfutureuse]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Reservedforfutureuse</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReturnPremium1ResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium1ResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium1ResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'ReturnPremium1ResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[ReturnPremium1ResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReturnPremium1ResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReturnPremium2ResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium2ResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium2ResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'ReturnPremium2ResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[ReturnPremium2ResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReturnPremium2ResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReturnPremium3ResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium3ResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium3ResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'ReturnPremium3ResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[ReturnPremium3ResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReturnPremium3ResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReturnPremium4ResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium4ResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium4ResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'ReturnPremium4ResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[ReturnPremium4ResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReturnPremium4ResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReturnPremium5ResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium5ResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ReturnPremium5ResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'ReturnPremium5ResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[ReturnPremium5ResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReturnPremium5ResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SecondaryUserReferenceArea
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'SecondaryUserReferenceArea') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'SecondaryUserReferenceArea';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'SecondaryUserReferenceArea', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[SecondaryUserReferenceArea]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">SecondaryUserReferenceArea</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- SSNSearchResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'SSNSearchResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'SSNSearchResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'SSNSearchResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[SSNSearchResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">SSNSearchResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- UserReferenceArea
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'UserReferenceArea') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'UserReferenceArea';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'UserReferenceArea', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[UserReferenceArea]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">UserReferenceArea</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP41ResultCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ZIP41ResultCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main' AND [Description] = 'ZIP41ResultCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main', 'ZIP41ResultCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Main].[ZIP41ResultCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP41ResultCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Main]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Main</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Main].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DirectMarketingAssociationDMASuppressionCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'DirectMarketingAssociationDMASuppressionCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'DirectMarketingAssociationDMASuppressionCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'DirectMarketingAssociationDMASuppressionCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[DirectMarketingAssociationDMASuppressionCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DirectMarketingAssociationDMASuppressionCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FirstDatause
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'FirstDatause') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'FirstDatause';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'FirstDatause', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[FirstDatause]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FirstDatause</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_NCOA].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOA4DigitAddOnCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOA4DigitAddOnCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOA4DigitAddOnCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOA4DigitAddOnCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOA4DigitAddOnCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOA4DigitAddOnCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOA5DigitZIPCodeTM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOA5DigitZIPCodeTM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOA5DigitZIPCodeTM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOA5DigitZIPCodeTM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOA5DigitZIPCodeTM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOA5DigitZIPCodeTM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOAAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOAAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOACarrierRoute
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOACarrierRoute') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOACarrierRoute';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOACarrierRoute', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOACarrierRoute]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOACarrierRoute</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOACity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOACity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOACity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOACity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOACity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOACity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOACountyCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOACountyCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOACountyCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOACountyCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOACountyCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOACountyCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOADeliveryPointCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOADeliveryPointCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOADeliveryPointCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOADeliveryPointCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOADeliveryPointCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOADeliveryPointCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAFootnotes
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAFootnotes') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAFootnotes';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOAFootnotes', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOAFootnotes]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAFootnotes</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAMatchRangeFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAMatchRangeFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAMatchRangeFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOAMatchRangeFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOAMatchRangeFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAMatchRangeFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAMoveEffectiveDateCCYYMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAMoveEffectiveDateCCYYMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAMoveEffectiveDateCCYYMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOAMoveEffectiveDateCCYYMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOAMoveEffectiveDateCCYYMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAMoveEffectiveDateCCYYMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAMoveType
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAMoveType') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAMoveType';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOAMoveType', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOAMoveType]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAMoveType</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOAState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOAState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAUrbanization
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAUrbanization') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NCOAUrbanization';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NCOAUrbanization', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NCOAUrbanization]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAUrbanization</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NumberofMultiplesRequested
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NumberofMultiplesRequested') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NumberofMultiplesRequested';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NumberofMultiplesRequested', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NumberofMultiplesRequested]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NumberofMultiplesRequested</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NumberofNeighborsRequested
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NumberofNeighborsRequested') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'NumberofNeighborsRequested';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'NumberofNeighborsRequested', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[NumberofNeighborsRequested]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NumberofNeighborsRequested</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_NCOA].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReservedForFutureUse
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'ReservedForFutureUse') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA' AND [Description] = 'ReservedForFutureUse';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Main\Services_FirstData_FastBatch_NCOA', 'ReservedForFutureUse', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_NCOA].[ReservedForFutureUse]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReservedForFutureUse</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_NCOA]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_NCOA</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_NCOA].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Neighbors].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NeighborAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'NeighborAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Neighbors].[NeighborAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NeighborAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NeighborDwellingUnits
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborDwellingUnits') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborDwellingUnits';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'NeighborDwellingUnits', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Neighbors].[NeighborDwellingUnits]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NeighborDwellingUnits</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NeighborLengthofResidence
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborLengthofResidence') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborLengthofResidence';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'NeighborLengthofResidence', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Neighbors].[NeighborLengthofResidence]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NeighborLengthofResidence</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NeighborName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'NeighborName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Neighbors].[NeighborName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NeighborName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NeighborPhoneNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborPhoneNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborPhoneNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'NeighborPhoneNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Neighbors].[NeighborPhoneNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NeighborPhoneNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NeighborZipCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborZipCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NeighborZipCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'NeighborZipCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Neighbors].[NeighborZipCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NeighborZipCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NumberofNeighborsReturned
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NumberofNeighborsReturned') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'NumberofNeighborsReturned';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'NumberofNeighborsReturned', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Neighbors].[NumberofNeighborsReturned]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NumberofNeighborsReturned</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Neighbors].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- seq
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'seq') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors' AND [Description] = 'seq';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Neighbors', 'seq', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Neighbors].[seq]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">seq</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Neighbors]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Neighbors</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Neighbors].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- AppendedPhoneNumberSource
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'AppendedPhoneNumberSource') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'AppendedPhoneNumberSource';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend', 'AppendedPhoneNumberSource', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PhoneAppend].[AppendedPhoneNumberSource]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">AppendedPhoneNumberSource</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PhoneAppend]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PhoneAppend</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PhoneAppend].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DALevelofMatchCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'DALevelofMatchCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'DALevelofMatchCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend', 'DALevelofMatchCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PhoneAppend].[DALevelofMatchCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DALevelofMatchCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PhoneAppend]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PhoneAppend</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PhoneAppend].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_PhoneAppend].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_PhoneAppend]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_PhoneAppend</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PhoneAppend].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleResponseCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'MultipleResponseCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'MultipleResponseCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend', 'MultipleResponseCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PhoneAppend].[MultipleResponseCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleResponseCount</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PhoneAppend]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PhoneAppend</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PhoneAppend].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NCOAOriginalInputAddressPhone
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'NCOAOriginalInputAddressPhone') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'NCOAOriginalInputAddressPhone';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend', 'NCOAOriginalInputAddressPhone', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PhoneAppend].[NCOAOriginalInputAddressPhone]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NCOAOriginalInputAddressPhone</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PhoneAppend]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PhoneAppend</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PhoneAppend].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PhoneAppendLevelofMatch
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'PhoneAppendLevelofMatch') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'PhoneAppendLevelofMatch';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend', 'PhoneAppendLevelofMatch', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PhoneAppend].[PhoneAppendLevelofMatch]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PhoneAppendLevelofMatch</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PhoneAppend]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PhoneAppend</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PhoneAppend].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PhoneAppendVerificationCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'PhoneAppendVerificationCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'PhoneAppendVerificationCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend', 'PhoneAppendVerificationCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PhoneAppend].[PhoneAppendVerificationCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PhoneAppendVerificationCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PhoneAppend]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PhoneAppend</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PhoneAppend].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PhoneAppend', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_PhoneAppend].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_PhoneAppend]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_PhoneAppend</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PhoneAppend].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- BankruptcyCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'BankruptcyCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'BankruptcyCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'BankruptcyCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PublicRecords].[BankruptcyCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">BankruptcyCount</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- CorrectionalMatchResultCodes
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'CorrectionalMatchResultCodes') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'CorrectionalMatchResultCodes';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'CorrectionalMatchResultCodes', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PublicRecords].[CorrectionalMatchResultCodes]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">CorrectionalMatchResultCodes</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DeceasedMatchResultCodes
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'DeceasedMatchResultCodes') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'DeceasedMatchResultCodes';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'DeceasedMatchResultCodes', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PublicRecords].[DeceasedMatchResultCodes]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DeceasedMatchResultCodes</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_PublicRecords].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- JudgmentCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'JudgmentCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'JudgmentCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'JudgmentCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PublicRecords].[JudgmentCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">JudgmentCount</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MatchedSSN
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'MatchedSSN') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'MatchedSSN';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'MatchedSSN', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PublicRecords].[MatchedSSN]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MatchedSSN</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- PublicInformationResultCodes
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'PublicInformationResultCodes') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'PublicInformationResultCodes';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'PublicInformationResultCodes', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PublicRecords].[PublicInformationResultCodes]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">PublicInformationResultCodes</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_PublicRecords].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- TaxLienCount
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'TaxLienCount') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords' AND [Description] = 'TaxLienCount';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_PublicRecords', 'TaxLienCount', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_PublicRecords].[TaxLienCount]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">TaxLienCount</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_PublicRecords]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_PublicRecords</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_PublicRecords].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Multiples].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleDateofBirthCCYYMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleDateofBirthCCYYMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleDateofBirthCCYYMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleDateofBirthCCYYMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleDateofBirthCCYYMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleDateofBirthCCYYMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleDeceasedFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleDeceasedFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleDeceasedFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleDeceasedFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleDeceasedFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleDeceasedFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleFirstReportDateCCYYMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleFirstReportDateCCYYMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleFirstReportDateCCYYMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleFirstReportDateCCYYMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleFirstReportDateCCYYMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleFirstReportDateCCYYMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleLastReportDateCCYYMM
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleLastReportDateCCYYMM') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleLastReportDateCCYYMM';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleLastReportDateCCYYMM', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleLastReportDateCCYYMM]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleLastReportDateCCYYMM</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultiplePhoneNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultiplePhoneNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultiplePhoneNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultiplePhoneNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultiplePhoneNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultiplePhoneNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- MultipleZipCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleZipCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'MultipleZipCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'MultipleZipCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[MultipleZipCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">MultipleZipCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- NumberofMultiplesReturned
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'NumberofMultiplesReturned') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples' AND [Description] = 'NumberofMultiplesReturned';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Multiples', 'NumberofMultiplesReturned', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_Multiples].[NumberofMultiplesReturned]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">NumberofMultiplesReturned</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_Multiples]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_Multiples</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Multiples].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Relatives' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Relatives' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Relatives', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Relatives].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Relatives]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Relatives</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Relatives].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- seq
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Relatives' AND [Description] = 'seq') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Relatives' AND [Description] = 'seq';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_Relatives', 'seq', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_Relatives].[seq]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">seq</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_Relatives]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_Relatives</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_Relatives].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DateofBirth
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'DateofBirth') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'DateofBirth';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'DateofBirth', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[DateofBirth]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DateofBirth</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DeceasedFlag
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'DeceasedFlag') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'DeceasedFlag';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'DeceasedFlag', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[DeceasedFlag]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DeceasedFlag</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- FirstReportDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'FirstReportDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'FirstReportDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'FirstReportDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[FirstReportDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">FirstReportDate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_ReturnInformation].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- LastReportDate
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'LastReportDate') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'LastReportDate';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'LastReportDate', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[LastReportDate]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">LastReportDate</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Output4DigitAddOnCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'Output4DigitAddOnCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'Output4DigitAddOnCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'Output4DigitAddOnCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[Output4DigitAddOnCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Output4DigitAddOnCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Output5DigitZIPCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'Output5DigitZIPCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'Output5DigitZIPCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'Output5DigitZIPCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[Output5DigitZIPCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">Output5DigitZIPCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OutputAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'OutputAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'OutputAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'OutputAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[OutputAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OutputAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OutputCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'OutputCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'OutputCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'OutputCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[OutputCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OutputCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OutputName
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'OutputName') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'OutputName';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'OutputName', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[OutputName]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OutputName</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- OutputState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'OutputState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'OutputState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'OutputState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[OutputState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">OutputState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_ReturnInformation].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ReturnedPhoneNumber
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'ReturnedPhoneNumber') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'ReturnedPhoneNumber';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'ReturnedPhoneNumber', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ReturnInformation].[ReturnedPhoneNumber]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ReturnedPhoneNumber</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- Seq
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'Seq') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation' AND [Description] = 'Seq';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ReturnInformation', 'Seq', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_ReturnInformation].[Seq]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">Seq</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_ReturnInformation]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_ReturnInformation</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ReturnInformation].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DPVTMFootnotes
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'DPVTMFootnotes') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'DPVTMFootnotes';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'DPVTMFootnotes', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[DPVTMFootnotes]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DPVTMFootnotes</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- DPVTMReturnCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'DPVTMReturnCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'DPVTMReturnCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'DPVTMReturnCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[DPVTMReturnCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">DPVTMReturnCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- EWSIndicator
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'EWSIndicator') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'EWSIndicator';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'EWSIndicator', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[EWSIndicator]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">EWSIndicator</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ID
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ID') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ID';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ID', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_ZIP4].[ID]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">ID</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- RequestId
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'RequestId') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'RequestId';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'RequestId', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:NumericCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<format>None</format>
<comparison>EqualTo</comparison>
<lowValue>
<value>0</value>
<condition xsi:null="1"/>
</lowValue>
<highValue>
<value>0</value>
<condition xsi:null="1"/>
</highValue>
<ColumnConditionBase_x002B_column id="ref-3">[Services_FirstData_FastBatch_ZIP4].[RequestId]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-4">RequestId</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-5"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:NumericCondition>
<a1:JoinTableCollection id="ref-5" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-6"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-6" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-7"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-7" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-8"/>
<item href="#ref-9"/>
<item href="#ref-10"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-8" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-11">[dbo].[Debtors]</expression>
<alias id="ref-12">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-13">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-14">[dbo].[ServiceHistory]</expression>
<alias id="ref-15">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-16">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-17">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-18">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-19">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP44DigitAddOnCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP44DigitAddOnCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP44DigitAddOnCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP44DigitAddOnCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP44DigitAddOnCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP44DigitAddOnCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP45DigitZIPCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP45DigitZIPCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP45DigitZIPCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP45DigitZIPCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP45DigitZIPCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP45DigitZIPCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4CarrierRoute
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4CarrierRoute') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4CarrierRoute';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4CarrierRoute', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4CarrierRoute]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4CarrierRoute</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4CountyCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4CountyCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4CountyCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4CountyCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4CountyCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4CountyCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4DeliveryPointCode
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4DeliveryPointCode') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4DeliveryPointCode';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4DeliveryPointCode', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4DeliveryPointCode]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4DeliveryPointCode</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4DwellingUnits
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4DwellingUnits') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4DwellingUnits';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4DwellingUnits', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4DwellingUnits]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4DwellingUnits</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4Footnotes
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4Footnotes') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4Footnotes';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4Footnotes', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4Footnotes]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4Footnotes</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4LACSIndicator
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4LACSIndicator') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4LACSIndicator';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4LACSIndicator', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4LACSIndicator]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4LACSIndicator</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4MatchLevel
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4MatchLevel') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4MatchLevel';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4MatchLevel', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4MatchLevel]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4MatchLevel</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4PMB
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4PMB') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4PMB';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4PMB', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4PMB]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4PMB</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4RecordType
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4RecordType') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4RecordType';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4RecordType', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4RecordType]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4RecordType</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4StandardizedCity
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4StandardizedCity') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4StandardizedCity';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4StandardizedCity', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4StandardizedCity]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4StandardizedCity</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4StandardizedDeliveryAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4StandardizedDeliveryAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4StandardizedDeliveryAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4StandardizedDeliveryAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4StandardizedDeliveryAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4StandardizedDeliveryAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4StandardizedOptionalAddress
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4StandardizedOptionalAddress') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4StandardizedOptionalAddress';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4StandardizedOptionalAddress', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4StandardizedOptionalAddress]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4StandardizedOptionalAddress</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4StandardizedState
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4StandardizedState') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4StandardizedState';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4StandardizedState', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4StandardizedState]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4StandardizedState</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


-- ZIP4Urbanization
IF EXISTS (SELECT * FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4Urbanization') BEGIN
	DELETE FROM [dbo].[QueryDesignerConditions] WHERE [Path] = 'Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4' AND [Description] = 'ZIP4Urbanization';
END;


INSERT INTO [dbo].[QueryDesignerConditions] ([Path], [Description], [Data])
VALUES ('Latitude Fusion\FirstData\FastBatch\Services_FirstData_FastBatch_ZIP4', 'ZIP4Urbanization', '<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:clr="http://schemas.microsoft.com/soap/encoding/clr/1.0" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Body>
<a1:TextCondition id="ref-1" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<comparison>EqualTo</comparison>
<value id="ref-3"></value>
<ColumnConditionBase_x002B_column id="ref-4">[Services_FirstData_FastBatch_ZIP4].[ZIP4Urbanization]</ColumnConditionBase_x002B_column>
<ConditionBase_x002B_description id="ref-5">ZIP4Urbanization</ConditionBase_x002B_description>
<ConditionBase_x002B_caption xsi:null="1"/>
<ConditionBase_x002B_optional>false</ConditionBase_x002B_optional>
<ConditionBase_x002B_joins href="#ref-6"/>
<ConditionBase_x002B_descending>false</ConditionBase_x002B_descending>
</a1:TextCondition>
<a1:JoinTableCollection id="ref-6" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<CollectionBase_x002B_list href="#ref-7"/>
</a1:JoinTableCollection>
<a3:ArrayList id="ref-7" xmlns:a3="http://schemas.microsoft.com/clr/ns/System.Collections">
<_items href="#ref-8"/>
<_size>3</_size>
<_version>3</_version>
</a3:ArrayList>
<SOAP-ENC:Array id="ref-8" SOAP-ENC:arrayType="xsd:anyType[16]">
<item href="#ref-9"/>
<item href="#ref-10"/>
<item href="#ref-11"/>
</SOAP-ENC:Array>
<a1:JoinTable id="ref-9" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-12">[dbo].[Debtors]</expression>
<alias id="ref-13">Debtors</alias>
<joinType>Inner</joinType>
<conditions id="ref-14">[master].[number] = [Debtors].[number]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-10" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-15">[dbo].[ServiceHistory]</expression>
<alias id="ref-16">ServiceHistory</alias>
<joinType>Inner</joinType>
<conditions id="ref-17">[master].[number] = [ServiceHistory].[AcctID] AND [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]</conditions>
</a1:JoinTable>
<a1:JoinTable id="ref-11" xmlns:a1="http://schemas.microsoft.com/clr/nsassem/GSSI.QueryDesigner.Conditions/GSSI.QueryDesigner">
<expression id="ref-18">[dbo].[Services_FirstData_FastBatch_ZIP4]</expression>
<alias id="ref-19">Services_FirstData_FastBatch_ZIP4</alias>
<joinType>LeftOuter</joinType>
<conditions id="ref-20">[ServiceHistory].[RequestID] = [Services_FirstData_FastBatch_ZIP4].[RequestId]</conditions>
</a1:JoinTable>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
');


 
IF not exists (select * from Services where ManifestId='C8DBBEEB-BDF7-46EA-8D4B-042ACE77BE1F')
	INSERT INTO [Services]
	([Description],[Enabled],[UpdateAccounts],[ManifestID],[MinBalance],[TransformationSchema])
	 VALUES
 ('FirstData FastBatch',1,0,'C8DBBEEB-BDF7-46EA-8D4B-042ACE77BE1F',0,
	'<?xml version="1.0"?>
	<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
		<head>
			<title>FirstData FasctBatch for Collections Data</title>
		</head>
		<body>
			<xsl:for-each select=".//DataRows/DataRow">
				<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial FONT-SIZE: 10pt">
					<tr align="left" bgcolor="#b0c4de" width="98%">
						<th><xsl:text>FirstData FastBatch</xsl:text></th>
					</tr>
				</table>	
				<table border="1" cellspacing="0" bgcolor="#b0c4de" cellpadding="1" width="100%" borderColor="b0c4de" style="WIDTH: 100%FONT-FAMILY: Verdana, Tahoma, Helvetica, Arial FONT-SIZE: 10pt">
					<tbody>
							<xsl:for-each select="node()">
								<tr>
									<td align="left" bgcolor="eee8aa" width="30%">
										<xsl:value-of select="translate(name(), ''_'', '' '')"/>
									</td>
									<td align="left" bgcolor="eee8aa" width="70%">
										<xsl:value-of select="text()"/>
									</td>							
								</tr>
							</xsl:for-each>			
					</tbody>
				</table>
				<br></br>			
			</xsl:for-each>													
		</body>
	</html>'
	)


	DECLARE @ServiceID INTEGER
	SET @ServiceID = @@IDENTITY

	INSERT INTO [dbo].[ServicesCustomers] ([ServiceID], [CustomerID], [ProfileID], [MinBalance]) 
	SELECT @ServiceID, [Customer].[CCustomerID], NULL, 0 FROM [dbo].[Customer] AS [Customer] 
	WHERE [Customer].[CCustomerID] NOT IN ( SELECT [ServicesCustomers1].[CustomerID] FROM [dbo].[ServicesCustomers] AS [ServicesCustomers1] WHERE [ServicesCustomers1].[ServiceID] = @ServiceID)

 
end
GO

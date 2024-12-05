SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 10/07/2019
-- Description:	Loads extra debtor information phone numbers and 
-- Added address External key to Spouse Job name for home address
-- Added employer address external key to debtor job memo
-- Added in language code conversion.
-- 01/21/2021 BGM Updated Language code for Not Verified code UN
-- 10/01/2021 BGM Added phone type B to be loaded as POE type
-- 02/08/2022 BGM Updated address line 1 2 3 so they are no longer than 30 characters
-- 05/24/2022 BGM Added order to phones being loaded so that the work phone is loaded before cell phone types, this is in order to allow the work phone to be sent for a cell scrub.
-- 06/20/2022 BGM Updated Debtor Name field import into Debtors table to only send the first 30 characters.
-- 04/04/2023 BGM Prepared for Email Express Consent Changes
-- 04/07/2023 BGM Updated to load all emails into email table
-- 04/13/2023 BGM Updated email insert to only insert when the email address is not loaded already.
-- 10/10/2023 BGM Ready for production
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Import_PostProcess]

--EXEC Custom_USBank_CACS_Import_PostProcess

AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @CustGroupID INT
--SET @CustGroupID = 382 --Production
SET @CustGroupID = 113 --Test


DECLARE @CoDebtors TABLE (number int, CACSAcct varchar(50), ContactID varchar(50), AccountHolder_nationalid varchar(50),	
	AccountHolder_firstName varchar(50), AccountHolder_middlename varchar(50), 
	AccountHolder_lastName varchar(50),	AccountHolder_suffix varchar(50), AccountHolder_dateOfBirth datetime, AccountHolder_languageSpoken varchar(100), AccountHolder_isResponsible varchar(20),
	AccountHolder_Name VARCHAR(45), AccountHolder_Employer VARCHAR(45), AccountHolder_Address1 VARCHAR(50), AccountHolder_Address2 VARCHAR(50), AccountHolder_Address3 VARCHAR(50),
	AccountHolder_City VARCHAR(30), AccountHolder_State varchar(2), AccountHolder_Zip VARCHAR(30), AccountHolder_County VARCHAR(35), AccountHolder_Country VARCHAR(35), 
	Address_ExternalKey varchar(35))

--Load temp table with remaining debtors which are codebtors
--Load Secondary CO-Debtor
INSERT INTO @CoDebtors
SELECT DISTINCT m.number,c.AcctNum,c.ContactId,c.NationalIDNumber,c.FirsstName,c.MiddleName,c.LastName,
	c.Suffix, CASE WHEN c.DateofBirth = '00000000' THEN '' ELSE c.DateofBirth END AS DateofBirth ,c.ISOLanguageCode,c.ResponsibleParty, c.Name, c.Employer, LEFT(c.AddressLine1, 30) AS AddressLine1, LEFT(c.AddressLine2, 30) AS AddressLine2, LEFT(c.AddressLine3, 30) AS AddressLine3,
	c.City, c.State, c.PostalCode, c.County, c.Country, c.AddressExternalKey
FROM Custom_USBank_CACS_SecondaryContact_Import  c 
INNER JOIN master m ON c.AcctNum=m.account
INNER JOIN debtors d ON m.number=d.number AND d.seq=0
WHERE CONVERT(VARCHAR(100),d.debtormemo)<>c.ContactId
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 
AND ResponsibleParty = 'Y'
AND DATEDIFF(DAY,m.received,GETDATE())=0

UNION ALL

--INSERT INTO @CoDebtors
--Load Other debtors
SELECT DISTINCT m.number,c.AcctNum,c.ContactId,c.NationalIDNumber,c.FirsstName,c.MiddleName,c.LastName,
	c.Suffix,CASE WHEN c.DateofBirth = '00000000' THEN '' ELSE c.DateofBirth END AS DateofBirth,c.ISOLanguageCode,c.ResponsibleParty, c.Name, c.Employer, c.AddressLine1, c.AddressLine2, c.AddressLine3,
	c.City, c.State, c.PostalCode, c.County, c.Country, c.AddressExternalKey
FROM Custom_USBank_CACS_OtherContact_Import c 
INNER JOIN master m ON c.AcctNum=m.account
INNER JOIN debtors d ON m.number=d.number AND d.seq=0
WHERE CONVERT(VARCHAR(100),d.debtormemo)<>c.ContactId
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 
AND ResponsibleParty = 'Y'
AND DATEDIFF(DAY,m.received,GETDATE())=0
ORDER BY c.ContactId

--Load the debtors table with the co-debtors information
INSERT INTO debtors (number,seq,name,ssn,dob,debtormemo,language,datecreated,dateupdated,datetimeentered,responsible,firstname,
					middlename,lastname,suffix,othername, JobName, Street1, Street2, City, State, Zipcode, County, Country, SpouseJobName)
SELECT number,ROW_NUMBER() OVER(PARTITION BY CACSAcct order by  ContactID),
	LEFT(CASE WHEN AccountHolder_firstName = '' AND AccountHolder_lastName = '' THEN AccountHolder_Name ELSE
	AccountHolder_lastName+', '+AccountHolder_firstName+' '+AccountHolder_middlename+' '+AccountHolder_suffix END, 30),AccountHolder_nationalid,
	AccountHolder_dateOfBirth,ContactID,
	
	CASE AccountHolder_languageSpoken	
	WHEN 'AF' THEN '0036 - AFRIKAANS'
	WHEN 'AR' THEN '0004 - ARABIC'
	WHEN 'BE' THEN '0025 - BENGALI'
	WHEN 'CE' THEN '0026 - CZECH'
	WHEN 'CH' THEN '0006 - CHINESE'
	WHEN 'CM' THEN '0027 - MANDARIN'
	WHEN 'DE' THEN '0009 - GERMAN'
	WHEN 'DU' THEN '0034 - DUTCH'
	WHEN 'EL' THEN '0010 - GREEK'
	WHEN 'EN' THEN '0001 - ENGLISH'
	WHEN 'ES' THEN '0028 - ESTONIAN'
	WHEN 'FR' THEN '0008 - FRENCH'
	WHEN 'HA' THEN '0029 - CREOLE'
	WHEN 'HI' THEN '0012 - HINDI'
	WHEN 'HM' THEN '0037 - HMONG'
	WHEN 'HY' THEN '0005 - ARMENIAN'
	WHEN 'IT' THEN '0014 - ITALIAN'
	WHEN 'JP' THEN '0015 - JAPANESE'
	WHEN 'KO' THEN '0016 - KOREAN'
	WHEN 'LI' THEN '0030 - LITHUANIAN'
	WHEN 'PO' THEN '0018 - POLISH'
	WHEN 'PT' THEN '0019 - PORTUGUESE'
	WHEN 'PR' THEN '0031 - FARSI'
	WHEN 'RU' THEN '0020 - RUSSIAN'
	WHEN 'SO' THEN '0038 - SOMALI'
	WHEN 'SP' THEN '0002 - SPANISH'
	WHEN 'SQ' THEN '0032 - ALBANIAN'
	WHEN 'SW' THEN '0039 - SWEDISH'
	WHEN 'TG' THEN '0021 - TAGALOG'
	WHEN 'VI' THEN '0022 - VIETNAMESE'
	WHEN 'YU' THEN '0033 - CANTONESE'
	WHEN 'ZX' THEN '0003 - OTHER'
	WHEN 'UN' THEN '0024 - NOT VERIFIED'
	ELSE '0003 - OTHER'	
	 
END AS
	AccountHolder_languageSpoken,
	
	GETDATE(),GETDATE(),GETDATE(), CASE WHEN AccountHolder_isResponsible = 'Y' THEN 1 ELSE 0 END,
	CASE WHEN AccountHolder_firstName = '' AND AccountHolder_Name <> '' THEN dbo.GetFirstName(AccountHolder_Name) ELSE AccountHolder_firstName END AS AccountHolder_firstName ,
	CASE WHEN AccountHolder_middlename = '' AND AccountHolder_Name <> '' THEN dbo.GetMiddleName(AccountHolder_middlename) ELSE AccountHolder_middlename END AS AccountHolder_middlename,
	CASE WHEN AccountHolder_lastName = '' AND AccountHolder_Name <> '' THEN dbo.GetLastName(AccountHolder_lastName) ELSE AccountHolder_lastName END AS AccountHolder_lastName,
	CASE WHEN AccountHolder_suffix = '' AND AccountHolder_Name <> '' THEN dbo.GetSuffixEx(AccountHolder_suffix) ELSE AccountHolder_suffix END AS AccountHolder_suffix,'', c.AccountHolder_Employer, c.AccountHolder_Address1,
	c.AccountHolder_Address2 + c.AccountHolder_Address3, c.AccountHolder_City, c.AccountHolder_State, c.AccountHolder_Zip, c.AccountHolder_County,
	c.AccountHolder_Country, c.Address_ExternalKey
FROM @CoDebtors c
ORDER BY ContactID

--WORK ADDRESS
----DEBTORS TABLE add work address to debtors table
UPDATE debtors
SET JobAddr1 =	LEFT(c.AddressLine1,50),
	JobAddr2 =	LEFT(c.AddressLine2,50),
	JobCSZ	=	LEFT(c.City,30) + ', ' + LEFT(ISNULL((c.State),''),2) + ' ' + LEFT(REPLACE(c.PostalCode,'-',''),10),
	JobMemo =	c.ExternalKey
FROM debtors d, Custom_USBank_CACS_Contact_Address c 
INNER JOIN master m ON c.AcctNumber=m.account
WHERE 
m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND m.number=d.number
AND CONVERT(VARCHAR(100),d.debtormemo)=c.ContactId
AND c.AddressRelationship = '4' AND AddressBlockInd <> 'Y'

--PHONES
INSERT INTO phones_master (Number,PhoneTypeID,PhoneStatusID,OnHold,PhoneNumber,PhoneExt,DebtorID,DateAdded,LoginName, PhoneName)
SELECT d.number,
	CASE WHEN c.PhoneType IN ('P') THEN 1
		 WHEN c.PhoneType IN ('B', 'E') THEN 2
		 WHEN c.PhoneType= 'C' THEN 3
		 WHEN c.PhoneType= 'X' THEN 4
		 WHEN c.PhoneType= 'A' THEN 47
		 WHEN c.PhoneType= 'F'  THEN 14
		 WHEN c.PhoneType= 'G' THEN 63
		 WHEN c.PhoneType= 'O' THEN 65
		 WHEN c.PhoneType= 'R' THEN 7
		 WHEN c.PhoneType= 'Y' THEN 49 
		 ELSE 65 END AS PhoneTypeID,
	0 AS PhoneStatusID,
	'' AS OnHold,
	c.PhoneNumber AS PhoneNumber,
	ISNULL(c.Extension,'') AS PhoneExt,
	d.debtorID as DebtorId,
	GETDATE() AS DateAdded,
	'SYNC' AS LoginName,
	c.ExternalKey
FROM Custom_USBank_CACS_Contact_Phone c
INNER JOIN master m ON c.AcctNumber=m.account
INNER JOIN debtors d ON m.number=d.number and CONVERT(VARCHAR(100),d.debtormemo)=c.ContactID
WHERE 
m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND c.PhoneNumber NOT IN (SELECT phonenumber FROM Phones_Master pm WITH (NOLOCK) WHERE pm.DebtorID = d.DebtorID)
ORDER BY CASE WHEN c.PhoneType IN ('P') THEN 2
		 WHEN c.PhoneType IN ('B', 'E') THEN 1
		 WHEN c.PhoneType= 'C' THEN 3
		 WHEN c.PhoneType= 'X' THEN 4
		 WHEN c.PhoneType= 'A' THEN 47
		 WHEN c.PhoneType= 'F'  THEN 14
		 WHEN c.PhoneType= 'G' THEN 63
		 WHEN c.PhoneType= 'O' THEN 65
		 WHEN c.PhoneType= 'R' THEN 7
		 WHEN c.PhoneType= 'Y' THEN 49 
		 ELSE 65 END

--Update primary debtors language.
UPDATE Debtors
SET language = CASE ISOLANGUAGECODE	
	WHEN 'AF' THEN '0036 - AFRIKAANS'
	WHEN 'AR' THEN '0004 - ARABIC'
	WHEN 'BE' THEN '0025 - BENGALI'
	WHEN 'CE' THEN '0026 - CZECH'
	WHEN 'CH' THEN '0006 - CHINESE'
	WHEN 'CM' THEN '0027 - MANDARIN'
	WHEN 'DE' THEN '0009 - GERMAN'
	WHEN 'DU' THEN '0034 - DUTCH'
	WHEN 'EL' THEN '0010 - GREEK'
	WHEN 'EN' THEN '0001 - ENGLISH'
	WHEN 'ES' THEN '0028 - ESTONIAN'
	WHEN 'FR' THEN '0008 - FRENCH'
	WHEN 'HA' THEN '0029 - CREOLE'
	WHEN 'HI' THEN '0012 - HINDI'
	WHEN 'HM' THEN '0037 - HMONG'
	WHEN 'HY' THEN '0005 - ARMENIAN'
	WHEN 'IT' THEN '0014 - ITALIAN'
	WHEN 'JP' THEN '0015 - JAPANESE'
	WHEN 'KO' THEN '0016 - KOREAN'
	WHEN 'LI' THEN '0030 - LITHUANIAN'
	WHEN 'PO' THEN '0018 - POLISH'
	WHEN 'PT' THEN '0019 - PORTUGUESE'
	WHEN 'PR' THEN '0031 - FARSI'
	WHEN 'RU' THEN '0020 - RUSSIAN'
	WHEN 'SO' THEN '0038 - SOMALI'
	WHEN 'SP' THEN '0002 - SPANISH'
	WHEN 'SQ' THEN '0032 - ALBANIAN'
	WHEN 'SW' THEN '0039 - SWEDISH'
	WHEN 'TG' THEN '0021 - TAGALOG'
	WHEN 'VI' THEN '0022 - VIETNAMESE'
	WHEN 'YU' THEN '0033 - CANTONESE'
	WHEN 'ZX' THEN '0003 - OTHER'
	WHEN 'UN' THEN '0024 - NOT VERIFIED'
	ELSE '0003 - OTHER'	
	 
END
FROM dbo.Custom_USBank_CACS_PrimaryContact_Import C WITH (NOLOCK) INNER JOIN master m ON c.AcctNum = m.account
INNER JOIN debtors d WITH (NOLOCK)  ON m.number = d.number AND d.seq = 0
WHERE debtorid = d.DebtorID AND (d.language = '' OR d.language IS NULL)
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 


INSERT INTO email 
(debtorid, email, typecd, statuscd, active, [primary], consentgiven, writtenconsent, consentsource
 , createdwhen, createdby, modifiedwhen, modifiedby, comment, debtorassociationid)
SELECT D.debtorid, e.emailaddr, e.emailtype, 'Unknown' AS estatus, 0 AS eactive, CASE e.preferredemailind WHEN 'Y' THEN 1 ELSE 0 END AS prefmailind, NULL AS congiven, 0 AS wgiven,
'US Bank' AS consource, GETDATE() AS createwhen, 'US Bank' AS createby, GETDATE() AS modwhen, 'US Bank' AS modby, e.externalkey, d.debtorid
FROM custom_usbank_cacs_contact_email e WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON e.acctnumber = m.account 
INNER JOIN debtors d WITH (NOLOCK) ON e.contactid = CONVERT(VARCHAR(100),d.debtormemo)
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 
AND email NOT IN (SELECT email FROM email WITH (NOLOCK) WHERE d.debtorid = debtorid)

END
GO

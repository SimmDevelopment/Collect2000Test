SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Added address External key to Spouse Job name for home address
-- Added employer address external key to debtor job memo
-- 09/15/2021 BGM Updated Phone number load code to not check for duplicate numbers.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_SunTrust_CACS_C360_RMS_Import_PostProcess]

AS
BEGIN

	SET NOCOUNT ON;


DECLARE @CoDebtors TABLE (number int, CACSAcct varchar(50), ContactID varchar(50), AccountHolder_nationalid varchar(50),	
	AccountHolder_firstName varchar(50), AccountHolder_middlename varchar(50), 
	AccountHolder_lastName varchar(50),	AccountHolder_suffix varchar(50), AccountHolder_dateOfBirth datetime, AccountHolder_languageSpoken varchar(100), AccountHolder_isResponsible varchar(20),
	AccountHolder_Name VARCHAR(45), AccountHolder_Employer VARCHAR(45), AccountHolder_Address1 VARCHAR(50), AccountHolder_Address2 VARCHAR(50), AccountHolder_Address3 VARCHAR(50),
	AccountHolder_City VARCHAR(30), AccountHolder_State varchar(2), AccountHolder_Zip VARCHAR(30), AccountHolder_County VARCHAR(35), AccountHolder_Country VARCHAR(35), AccountHolder_Email VARCHAR(255),
	Address_ExternalKey varchar(35))

--Load temp table with remaining debtors which are codebtors
--Load Secondary CO-Debtor
INSERT INTO @CoDebtors
SELECT DISTINCT m.number,c.AcctNum,c.ContactId,c.NationalIDNumber,c.FirsstName,c.MiddleName,c.LastName,
	c.Suffix,CASE WHEN c.DateofBirth = '00000000' THEN '' ELSE c.DateofBirth END AS DateofBirth,c.ISOLanguageCode,c.ResponsibleParty, c.Name, c.Employer, c.AddressLine1, c.AddressLine2, c.AddressLine3,
	c.City, c.State, c.PostalCode, c.County, c.Country, c.EmailAddress, c.AddressExternalKey
FROM Custom_SunTrust_CACS_SecondaryContact_Import  c 
INNER JOIN master m ON c.AcctNum=m.account
INNER JOIN debtors d ON m.number=d.number AND d.seq=0
WHERE CONVERT(VARCHAR(100),d.debtormemo)<>c.ContactId
AND ((m.customer IN (Select customerid from fact where customgroupid = 312)) or (m.customer in ('0001280','0001281','0001317','0001410')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))
AND DATEDIFF(DAY,m.received,GETDATE())=0

UNION ALL

--INSERT INTO @CoDebtors
--Load Other debtors
SELECT DISTINCT m.number,c.AcctNum,c.ContactId,c.NationalIDNumber,c.FirsstName,c.MiddleName,c.LastName,
	c.Suffix,CASE WHEN c.DateofBirth = '00000000' THEN '' ELSE c.DateofBirth END AS DateofBirth,c.ISOLanguageCode,c.ResponsibleParty, c.Name, c.Employer, c.AddressLine1, c.AddressLine2, c.AddressLine3,
	c.City, c.State, c.PostalCode, c.County, c.Country, c.EmailAddress, c.AddressExternalKey
FROM Custom_SunTrust_CACS_OtherContact_Import c 
INNER JOIN master m ON c.AcctNum=m.account
INNER JOIN debtors d ON m.number=d.number AND d.seq=0
WHERE CONVERT(VARCHAR(100),d.debtormemo)<>c.ContactId
AND ((m.customer IN (Select customerid from fact where customgroupid = 312)) or (m.customer in ('0001280','0001281','0001317','0001410')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))
AND DATEDIFF(DAY,m.received,GETDATE())=0
ORDER BY c.ContactId



--Load the debtors table with the co-debtors information
INSERT INTO debtors (number,seq,name,ssn,dob,debtormemo,language,datecreated,dateupdated,datetimeentered,responsible,firstname,
					middlename,lastname,suffix,othername, JobName, Street1, Street2, City, State, Zipcode, County, Country, Email, SpouseJobName)
SELECT number,ROW_NUMBER() OVER(PARTITION BY CACSAcct order by  ContactID),
	LEFT(AccountHolder_lastName+', '+AccountHolder_firstName+' '+AccountHolder_middlename+' '+AccountHolder_suffix, 30),AccountHolder_nationalid,
	AccountHolder_dateOfBirth,ContactID,AccountHolder_languageSpoken,GETDATE(),GETDATE(),GETDATE(), CASE WHEN AccountHolder_isResponsible = 'Y' THEN 1 ELSE 0 END,
	AccountHolder_firstName,AccountHolder_middlename,AccountHolder_lastName,AccountHolder_suffix,'', c.AccountHolder_Employer, c.AccountHolder_Address1,
	c.AccountHolder_Address2 + c.AccountHolder_Address3, c.AccountHolder_City, c.AccountHolder_State, c.AccountHolder_Zip, c.AccountHolder_County,
	c.AccountHolder_Country, c.AccountHolder_Email, c.Address_ExternalKey
FROM @CoDebtors c
ORDER BY ContactID

--WORK ADDRESS
----DEBTORS TABLE add work address to debtors table
UPDATE debtors
SET JobAddr1 =	LEFT(c.AddressLine1,50),
	JobAddr2 =	LEFT(c.AddressLine2,50),
	JobCSZ	=	LEFT(c.City,30) + ', ' + LEFT(ISNULL((c.State),''),2) + ' ' + LEFT(REPLACE(c.PostalCode,'-',''),10),
	JobMemo =	c.ExternalKey
FROM debtors d, Custom_SunTrust_CACS_Contact_Address c 
INNER JOIN master m ON c.AcctNumber=m.account
WHERE ((m.customer IN (Select customerid from fact where customgroupid = 312)) or (m.customer in ('0001280','0001281','0001317','0001410')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))
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
		 WHEN c.PhoneType= 'G' THEN 60
		 WHEN c.PhoneType= 'O' THEN 55
		 WHEN c.PhoneType= 'R' THEN 7
		 WHEN c.PhoneType= 'Y' THEN 49 
		 ELSE 55 END AS PhoneTypeID,
	0 AS PhoneStatusID,
	'' AS OnHold,
	c.PhoneNumber AS PhoneNumber,
	ISNULL(c.Extension,'') AS PhoneExt,
	d.debtorID as DebtorId,
	GETDATE() AS DateAdded,
	'SYNC' AS LoginName,
	c.ExternalKey
FROM Custom_SunTrust_CACS_Contact_Phone c
INNER JOIN master m ON c.AcctNumber=m.account
INNER JOIN debtors d ON m.number=d.number and CONVERT(VARCHAR(100),d.debtormemo)=c.ContactID
WHERE ((m.customer IN (Select customerid from fact where customgroupid = 312)) or (m.customer in ('0001280','0001281','0001317','0001410')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND c.PhoneNumber NOT IN (SELECT PhoneNumber FROM dbo.Phones_Master pm WITH (NOLOCK) WHERE d.debtorid = debtorid)
AND c.DoNotContact = 'N'
AND c.PhoneNumber NOT IN (SELECT c.PhoneNumber AS PhoneNumber
FROM Custom_SunTrust_CACS_Contact_Phone c
INNER JOIN master m ON c.AcctNumber=m.account
INNER JOIN debtors d ON m.number=d.number and CONVERT(VARCHAR(100),d.debtormemo)=c.ContactID
LEFT OUTER JOIN Phones_Master pm ON d.DebtorID = pm.DebtorID AND pm.PhoneNumber = c.PhoneNumber
WHERE ((m.customer IN (Select customerid from fact where customgroupid = 312)) or (m.customer in ('0001280','0001281','0001317','0001410')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))
AND DATEDIFF(DAY,m.received,GETDATE())=0 AND DoNotContact = 'N'
GROUP BY c.PhoneNumber
HAVING COUNT(*) > 1)

END
GO

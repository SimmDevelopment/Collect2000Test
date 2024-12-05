SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CCI_Custom_OutSourcer_Post_NewBiz]

AS
BEGIN

	SET NOCOUNT ON;

--ACCOUNTHOLDER
DELETE CCI_Custom_OutSourcer_Post_AccountHolder
WHERE AccountHolder_accountHolderRef IN
	(select CONVERT(VARCHAR(100),d.debtormemo)
	FROM CCI_Custom_OutSourcer_Post_AccountHolder c
	INNER JOIN master M ON c.AccountHolder_outSourcerAccountId=m.id1
	INNER JOIN debtors d ON m.number=d.number AND c.AccountHolder_accountHolderRef<>CONVERT(VARCHAR(100),d.debtormemo) 
		AND m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183) AND DATEDIFF(DAY,m.received,GETDATE())=0)

DECLARE @CoDebtors TABLE (number int, outSourcerAccountID varchar(50), Accountholder_accountholderref varchar(50), AccountHolder_nationalid varchar(50),	
	AccountHolder_firstName varchar(50), AccountHolder_middlename varchar(50), 
	AccountHolder_lastName varchar(50),	AccountHolder_suffix varchar(50), AccountHolder_dateOfBirth datetime, AccountHolder_languageSpoken varchar(100), AccountHolder_isResponsible varchar(20))

INSERT INTO @CoDebtors
SELECT DISTINCT m.number,c.AccountHolder_outSourcerAccountId,c.accountholder_accountholderref,c.AccountHolder_nationalid,c.AccountHolder_firstName,c.AccountHolder_middlename,c.AccountHolder_lastName,
	c.AccountHolder_suffix,c.AccountHolder_dateOfBirth,c.AccountHolder_languageSpoken,c.AccountHolder_isResponsible
FROM CCI_Custom_OutSourcer_Post_AccountHolder c 
INNER JOIN master m ON c.accountHolder_outsourceraccountid=m.id1
INNER JOIN debtors d ON m.number=d.number AND d.seq=0
WHERE CONVERT(VARCHAR(100),d.debtormemo)<>c.accountholder_accountholderref
AND m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND DATEDIFF(DAY,m.received,GETDATE())=0
ORDER BY c.accountholder_accountholderref

INSERT INTO debtors (number,seq,name,ssn,dob,debtormemo,language,datecreated,dateupdated,datetimeentered,responsible,firstname,middlename,lastname,suffix,othername)
SELECT number,ROW_NUMBER() OVER(PARTITION BY outSourcerAccountID order by  Accountholder_accountholderref),
	AccountHolder_firstName+' '+AccountHolder_middlename+' '+AccountHolder_lastName+' '+AccountHolder_suffix,AccountHolder_nationalid,
	AccountHolder_dateOfBirth,Accountholder_accountholderref,AccountHolder_languageSpoken,GETDATE(),GETDATE(),GETDATE(),AccountHolder_isResponsible,
	AccountHolder_firstName,AccountHolder_middlename,AccountHolder_lastName,AccountHolder_suffix,''
FROM @CoDebtors c
ORDER BY Accountholder_accountholderref

--ADDRESSES
--HOME ADDRESS
----DEBTORS TABLE
UPDATE debtors
SET Street1 =	LEFT(c.Addresses_street1,30),
	Street2 =	LEFT(c.Addresses_street2,30),
	City	=	LEFT(c.Addresses_city,30),
	State	=	LEFT(ISNULL((SELECT s.Code FROM states s WHERE c.Addresses_State=s.description),''),3),
	Country =	REPLACE(LEFT(c.Addresses_country,50),'"',''),
	ZipCode	=	LEFT(REPLACE(c.Addresses_zipcode,'-',''),10)
FROM debtors d, CCI_Custom_OutSourcer_Post_Address c 
INNER JOIN master m ON c.Addresses_outSourcerAccountId=m.ID1
WHERE m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND CONVERT(VARCHAR(100),d.debtormemo)=c.Addresses_accountRef
AND c.Addresses_address_type = 'home'

----MASTER TABLE
UPDATE MASTER
SET Street1 =	d.street1,
	Street2 =	d.street2,
	City	=	d.city,
	State	=	d.state,
	Zipcode	=	d.zipcode
FROM master m, debtors d 
WHERE m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND d.number=m.number
AND d.seq=0

--WORK ADDRESS
----DEBTORS TABLE
UPDATE debtors
SET JobAddr1 =	LEFT(c.Addresses_street1,50),
	JobAddr2 =	LEFT(c.Addresses_street2,50),
	JobCSZ	=	LEFT(c.Addresses_city,30) + LEFT(ISNULL((SELECT s.Code FROM states s WHERE c.Addresses_State=s.description),''),3) + LEFT(REPLACE(c.Addresses_zipcode,'-',''),10)
FROM debtors d, CCI_Custom_OutSourcer_Post_Address c 
INNER JOIN master m ON c.Addresses_outSourcerAccountId=m.ID1
WHERE m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND m.number=d.number
AND CONVERT(VARCHAR(100),d.debtormemo)=c.Addresses_accountRef
AND c.Addresses_address_type = 'Work'

--SERVICE ADDRESS
----CUSTOMUTLILITYDATA TABLE
INSERT INTO customutlilitydata (Number,CreatedBy,Created,ServiceAddress1,ServiceAddress2,ServiceCity,ServiceState,ServiceZipCode)
SELECT m.number,'EXG',GETDATE(),LEFT(c.Addresses_street1,50),LEFT(c.Addresses_street2,50),LEFT(c.Addresses_city,30),
	LEFT(ISNULL((SELECT s.Code FROM states s WHERE c.Addresses_State=s.description),''),3),LEFT(REPLACE(c.Addresses_zipcode,'-',''),10)
FROM CCI_Custom_OutSourcer_Post_Address c 
INNER JOIN master m ON c.Addresses_outSourcerAccountId=m.ID1
INNER JOIN debtors d ON m.number=d.number 
WHERE m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND m.number=d.number
AND CONVERT(VARCHAR(100),d.debtormemo)=c.Addresses_accountRef
AND c.Addresses_address_type = 'Service'

--VACATION & UNKNOWN ADDRESS
----MISCEXTRA TABLE
INSERT INTO MISCEXTRA (Number,Title,TheData)
SELECT m.number,(CASE WHEN c.Addresses_address_type='Vacation' THEN 'ADDR_Vacation '+CONVERT(VARCHAR,m.number) ELSE 'ADDR_Unknown '+CONVERT(VARCHAR,m.number) END) AS Title,
	LEFT(c.Addresses_street1,50)+', '+LEFT(c.Addresses_street2,48) AS TheData
FROM CCI_Custom_OutSourcer_Post_Address c 
INNER JOIN master m ON c.Addresses_outSourcerAccountId=m.ID1
INNER JOIN debtors d ON m.number=d.number AND d.seq=0
WHERE m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND m.number=d.number
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND CONVERT(VARCHAR(100),d.debtormemo)=c.Addresses_accountRef
AND c.Addresses_address_type IN ('Vacation','Unknown')

INSERT INTO MISCEXTRA (Number,Title,TheData)
SELECT m.number,(CASE WHEN c.Addresses_address_type='Vacation' THEN 'ADDR_Vacation '+CONVERT(VARCHAR,m.number) ELSE 'ADDR_Unknown '+CONVERT(VARCHAR,m.number) END) AS Title,
	LEFT(c.Addresses_city,30)+' '+LEFT(ISNULL((SELECT s.Code FROM states s WHERE c.Addresses_State=s.description),''),3)+' '+LEFT(REPLACE(c.Addresses_zipcode,'-',''),10) AS TheData
FROM CCI_Custom_OutSourcer_Post_Address c 
INNER JOIN master m ON c.Addresses_outSourcerAccountId=m.ID1
INNER JOIN debtors d ON m.number=d.number AND d.seq=0
WHERE m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND m.number=d.number
AND DATEDIFF(DAY,m.received,GETDATE())=0
AND CONVERT(VARCHAR(100),d.debtormemo)=c.Addresses_accountRef
AND c.Addresses_address_type IN ('Vacation','Unknown')

--EMAILS
UPDATE debtors
SET Email = c.AccountHolder_Emails_email
FROM debtors d, CCI_Custom_OutSourcer_Post_Emails c
INNER JOIN master m ON c.AccountHolder_Emails_OutSourcerAccountId=m.ID1
WHERE m.number=d.number and CONVERT(VARCHAR(100),d.debtormemo)=c.AccountHolder_Emails_accountRef
AND m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND DATEDIFF(DAY,m.received,GETDATE())=0

--PHONES
INSERT INTO phones_master (Number,PhoneTypeID,PhoneStatusID,OnHold,PhoneNumber,PhoneExt,DebtorID,DateAdded,LoginName)
SELECT d.number,
	CASE WHEN c.AccountHolder_Phones_Phone_Type IN (1,6,7) THEN 1
		 WHEN AccountHolder_Phones_Phone_Type=2 THEN 2
		 WHEN AccountHolder_Phones_Phone_Type=3 THEN 3
		 WHEN AccountHolder_Phones_Phone_Type=4 THEN 4
		 WHEN AccountHolder_Phones_Phone_Type=5 THEN 19 END AS PhoneTypeID,
	0 AS PhoneStatusID,
	'' AS OnHold,
	c.AccountHolder_phones_phonenumber AS PhoneNumber,
	ISNULL(c.AccountHolder_Phones_extension,'') AS PhoneExt,
	d.debtorID as DebtorId,
	GETDATE() AS DateAdded,
	'SYNC' AS LoginName
FROM CCI_Custom_OutSourcer_Post_Phones c
INNER JOIN master m ON c.AccountHolder_Phones_outSourcerAccountId=m.ID1
INNER JOIN debtors d ON m.number=d.number and CONVERT(VARCHAR(100),d.debtormemo)=c.AccountHolder_phones_accountHolderRef
WHERE m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND DATEDIFF(DAY,m.received,GETDATE())=0

--EXTENDED PROPERTIES
INSERT INTO MISCEXTRA (Number,Title,TheData)
SELECT m.number,LEFT(c.Extended_ExtendedProperty,25)+'-DB '+CONVERT(VARCHAR,d.seq+1) AS Title,LEFT(c.Extended_ExtendedProperty_value,100) AS TheData
FROM CCI_Custom_OutSourcer_Post_Extended c 
INNER JOIN master m ON c.Extended_outSourceAccountId=m.ID1
INNER JOIN debtors d ON m.number=d.number AND CONVERT(VARCHAR(100),d.debtormemo)=c.Extended_AccountRef
WHERE m.customer IN (SELECT customerid FROM fact WHERE customgroupid=1183)
AND DATEDIFF(DAY,m.received,GETDATE())=0




END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 5/19/2019
-- Description:	Import and Updates any demographic changes to USBank accounts coming from CACS
-- Changes:		10/31/2019 updated phone insert to place null in phone status id field and remove spaces from extension.
--				07/19/2021 updated newStreet 1, 2 and city to import only first 30 characters.
--				10/01/2021 BGM Added phone type B to be loaded as POE type
--				04/04/2023 BGM Prepared for Email Express Consent Changes
--				04/13/2023 BGM Added code to either update or insert emails into email table and update the history
--				04/20/2023 BGM Updated email code to make an email active based on emailavailibility
--				10/10/2023 BGM Ready for Production
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Import_Maintenance_PostProcess]

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CustGroupID INT
--SET @CustGroupID = 382 --Production
SET @CustGroupID = 113 --Test	

--Create temp table for codebtor insert
DECLARE @CoDebtors TABLE (number int, LastSEQ NUMERIC, CACSAcct varchar(50), ContactID varchar(50), AccountHolder_nationalid varchar(50),	
AccountHolder_firstName varchar(50), AccountHolder_middlename varchar(50), 
AccountHolder_lastName varchar(50),	AccountHolder_suffix varchar(50), AccountHolder_dateOfBirth datetime, AccountHolder_languageSpoken varchar(100), AccountHolder_isResponsible varchar(20),
AccountHolder_Name VARCHAR(45), AccountHolder_Employer VARCHAR(45), AccountHolder_Address1 VARCHAR(50), AccountHolder_Address2 VARCHAR(50), AccountHolder_Address3 VARCHAR(50),
AccountHolder_City VARCHAR(30), AccountHolder_State varchar(2), AccountHolder_Zip VARCHAR(30), AccountHolder_County VARCHAR(35), AccountHolder_Country VARCHAR(35), AccountHolder_Email VARCHAR(255),
	Address_ExternalKey varchar(35)
)

--Load temp table with new codebtors
INSERT INTO @CoDebtors
SELECT m.number, (SELECT MAX(seq) FROM debtors WITH (NOLOCK) WHERE Number = m.number) AS LastSEQ, c.AcctNum,c.ContactId,cbd.NationalIDNumber,cbd.FirstName,cbd.MiddleName,cbd.LastName,
	cbd.Suffix,CASE WHEN cbd.DateofBirth = '00000000' THEN NULL ELSE cbd.DateOfBirth END AS DateOfBirth,cbd.ISOLanguageCode,c.ResponsibleParty, cbd.Name, cbd.Employer, ca.AddressLine1, ca.AddressLine2, ca.AddressLine3,
	ca.City, ca.State, ca.PostalCode, ca.County, ca.Country, ce.EmailAddr, ca.ExternalKey
FROM Custom_USBank_CACS_Contact_Account_Data_Maintenance c WITH (NOLOCK)
INNER JOIN Custom_USBank_CACS_Contact_Base_Data_Maintenance cbd WITH (NOLOCK) ON c.ContactID = cbd.contactid
LEFT OUTER JOIN Custom_USBank_CACS_Contact_Email_Maintenance ce WITH (NOLOCK) ON c.ContactID = ce.ContactID
LEFT OUTER JOIN Custom_USBank_CACS_Contact_Address_Maintenance ca WITH (NOLOCK) ON c.ContactID = ca.ContactId
INNER JOIN master m WITH (NOLOCK) ON c.AcctNum = m.account
WHERE c.ContactID NOT IN (SELECT CONVERT(VARCHAR(35), debtormemo) FROM Debtors d WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON d.number = m.number 
WHERE 
m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)) 

AND NameRelationship <> 'J' AND PrefferredAddressInd = 'Y' AND ResponsibleParty = 'Y'


--Load the debtors table with the new co-debtors information
INSERT INTO debtors (number,seq,name,ssn,dob,debtormemo,language,datecreated,dateupdated,datetimeentered,responsible,firstname,
					middlename,lastname,suffix,othername, JobName, Street1, Street2, City, State, Zipcode, County, Country, Email, SpouseJobName)
SELECT number,ROW_NUMBER() OVER(PARTITION BY CACSAcct order by  ContactID) + CONVERT(INT, LastSEQ) ,
	AccountHolder_lastName+', '+AccountHolder_firstName+' '+AccountHolder_middlename+' '+AccountHolder_suffix,AccountHolder_nationalid,
	AccountHolder_dateOfBirth,ContactID,AccountHolder_languageSpoken,GETDATE(),GETDATE(),GETDATE(), CASE WHEN AccountHolder_isResponsible = 'Y' THEN 1 ELSE 0 END,
	AccountHolder_firstName,AccountHolder_middlename,AccountHolder_lastName,AccountHolder_suffix,'', c.AccountHolder_Employer, c.AccountHolder_Address1,
	c.AccountHolder_Address2 + c.AccountHolder_Address3, c.AccountHolder_City, c.AccountHolder_State, c.AccountHolder_Zip, c.AccountHolder_County,
	c.AccountHolder_Country, c.AccountHolder_Email, c.Address_ExternalKey
FROM @CoDebtors c
ORDER BY ContactID

--Insert note stating a new debtor was added
INSERT INTO notes ( number, created, user0, action, result, comment)
SELECT number, GETDATE(), 'USB', 'CODBTR', 'ADD', 'New Responsible party added'
FROM @CoDebtors cd

DECLARE @Phones TABLE (Number INT, PhoneTypeID INT, PhoneStatusID INT,OnHold BIT,PhoneNumber VARCHAR(30),PhoneExt VARCHAR(10)
							,DebtorID INT,DateAdded DATETIME,LoginName VARCHAR(10), PhoneName VARCHAR(50))

--Insert New Phone numbers sent from US Bank
INSERT INTO @Phones (Number,PhoneTypeID,PhoneStatusID,OnHold,PhoneNumber,PhoneExt,DebtorID,DateAdded,LoginName, PhoneName)
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
		 ELSE 59 END AS PhoneTypeID,
	NULL AS PhoneStatusID,
	'' AS OnHold,
	c.PhoneNumber AS PhoneNumber,
	REPLACE(ISNULL(c.Extension,''), ' ', '') AS PhoneExt,
	d.debtorID as DebtorId,
	GETDATE() AS DateAdded,
	'USBUPDT' AS LoginName,
	c.ExternalKey
FROM Custom_USBank_CACS_Contact_Phone_Maintenance c
INNER JOIN master m ON c.AcctNumber=m.account
INNER JOIN debtors d ON m.number=d.number and CONVERT(VARCHAR(100),d.debtormemo)=c.ContactID
WHERE 
m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)
AND c.PhoneNumber NOT IN (SELECT phonenumber FROM Phones_Master pm WITH (NOLOCK) WHERE DebtorID = d.DebtorID)

INSERT INTO Phones_Master ( Number, PhoneTypeID, PhoneStatusID, OnHold, PhoneNumber, PhoneExt, DebtorID,
                             DateAdded, LoginName, PhoneName)
SELECT  Number, PhoneTypeID, PhoneStatusID, OnHold, PhoneNumber, PhoneExt, DebtorID, DateAdded, LoginName, PhoneName 
FROM @Phones

INSERT INTO notes ( number, created, user0, action, result, comment)
SELECT number, GETDATE(), 'USB', 'PHONES', 'ADD', 'New Phone Numbers added by client'
FROM @Phones


--iNsert and Update Email Addresses
--Insert new email address for debtor
INSERT INTO email 
(debtorid, email, typecd, statuscd, active, [primary], consentgiven, writtenconsent, consentsource
 , createdwhen, createdby, modifiedwhen, modifiedby, comment, debtorassociationid)
SELECT D.debtorid, e.emailaddr, e.emailtype, 'Unknown' AS estatus, CASE WHEN e.emailavailibility = 'R' THEN 0 ELSE 1 END AS eactive, CASE e.preferredemailind WHEN 'Y' THEN 1 ELSE 0 END AS prefmailind, NULL AS congiven, 0 AS wgiven,
'US Bank' AS consource, GETDATE() AS createwhen, 'US Bank' AS createby, GETDATE() AS modwhen, 'US Bank' AS modby, e.externalkey, d.debtorid
FROM Custom_USBank_CACS_Contact_Email_Maintenance e WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON e.acctnumber = m.account 
INNER JOIN debtors d WITH (NOLOCK) ON e.contactid = CONVERT(VARCHAR(100),d.debtormemo)
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 
AND email NOT IN (SELECT email FROM email WITH (NOLOCK) WHERE d.debtorid = debtorid)

--Update current email information
DECLARE @EmailId INT, @Active BIT, @Comment VARCHAR(MAX), @ConsentBy VARCHAR(255), @ConsentGiven BIT, @ConsentSource VARCHAR(255), 
@Primary BIT, @WrittenConsent BIT, @ModifiedBy VARCHAR(255), @StatusCd VARCHAR(10), @TypeCd VARCHAR(10), @modifiedwhen DATETIME,
@number INT

DECLARE cur CURSOR FOR

	SELECT em.emailid, e.emailtype, CASE e.emailavailibility WHEN 'C' THEN 'Good' ELSE 'Unknown' END AS statuscd, 
	CASE e.preferredemailind WHEN 'Y' THEN 1 ELSE 0 END AS [primary], CASE e.emailavailibility WHEN 'C' THEN 1 WHEN 'R' THEN 0 ELSE NULL END AS consentgiven,
	CASE e.emailavailibility WHEN 'C' THEN 'US Bank UPD' ELSE NULL END AS counsentsource, GETDATE() AS modifiedwhen, 'US Bank UPD' AS modifiedby,
	m.number, CASE WHEN e.emailavailibility = 'R' THEN 0 ELSE 1 END AS active, e.externalkey
	FROM Custom_USBank_CACS_Contact_Email_Maintenance e WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON e.acctnumber = m.account 
	INNER JOIN debtors d WITH (NOLOCK) ON e.contactid = CONVERT(VARCHAR(100),d.debtormemo) 
	INNER JOIN email em WITH (NOLOCK) ON d.debtorid = em.debtorid AND e.emailaddr = em.email
	WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 
	AND (CASE e.emailavailibility WHEN 'C' THEN 1 WHEN 'R' THEN 0 ELSE NULL END <> em.consentgiven OR em.consentgiven IS NULL
	OR CASE e.emailavailibility WHEN 'C' THEN 1 WHEN 'R' THEN 0 ELSE NULL END <> em.active)
	AND e.emailavailibility IN ('C', 'R', 'U')

OPEN cur
FETCH NEXT FROM cur
INTO @EmailId, @TypeCd, @StatusCd, @Primary, @ConsentGiven, @ConsentSource, @modifiedwhen, @ModifiedBy, @number, @Active, @Comment

WHILE @@fetch_status = 0
BEGIN

	UPDATE email
	SET typecd = @TypeCd, statuscd = @StatusCd, [primary] = @Primary, consentgiven = @ConsentGiven, 
	consentsource = @ConsentSource, modifiedwhen =  @modifiedwhen, modifiedby = @ModifiedBy, comment = @Comment
	WHERE @EmailId = emailid

	EXEC emailconsentupdate @EmailId, @Active, @Comment, @ConsentBy, @ConsentGiven, @ConsentSource, @Primary, @WrittenConsent, @ModifiedBy, @StatusCd

	INSERT INTO notes ( number, created, user0, action, result, comment)
	SELECT @number, GETDATE(), 'USB', 'EMAIL', 'UPD', 'Email Address Added or Updated by client'

FETCH NEXT FROM cur
INTO @EmailId, @TypeCd, @StatusCd, @Primary, @ConsentGiven, @ConsentSource, @modifiedwhen, @ModifiedBy, @number, @Active, @Comment

END
CLOSE cur
DEALLOCATE cur

--Update Debtor Address
DECLARE @address TABLE (AccountID INT, DebtorID INT, SEQ INT, DateChanged DATETIME, UserChanged VARCHAR(50), 
	OldStreet1 VARCHAR(50), OldStreet2 VARCHAR(50), OldCity VARCHAR(50), OldState VARCHAR(50), OldZipcode VARCHAR(50), 
	NewStreet1 VARCHAR(50), NewStreet2 VARCHAR(50),	NewCity VARCHAR(50), NewState VARCHAR(50), NewZipcode VARCHAR(50))
	
INSERT INTO @address ( AccountID, DebtorID, SEQ, DateChanged, UserChanged, OldStreet1, OldStreet2, OldCity, OldState,
                        OldZipcode, NewStreet1, NewStreet2, NewCity, NewState, NewZipcode )
                        
SELECT DISTINCT d.Number, d.DebtorID, d.seq, GETDATE(), 'USBANK', d.Street1, d.Street2, d.City, d.state, d.Zipcode, 
	c.AddressLine1, c.AddressLine2 + ' ' + c.AddressLine3,  c.City,  c.State, REPLACE(c.PostalCode, '-', '')
FROM Debtors d WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON d.number = m.number
INNER JOIN Custom_USBank_CACS_Contact_Address_Maintenance c WITH (NOLOCK) ON CONVERT(VARCHAR(35), DebtorMemo) = c.ContactId
WHERE d.Street1 <> c.AddressLine1 OR d.street2 <> c.AddressLine2 + ' ' + c.AddressLine3 OR d.City <> c.City OR d.State <> c.State
OR REPLACE(d.Zipcode, '-', '') <> REPLACE(c.PostalCode, '-', '') 
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) 
AND d.mr = 'Y' AND c.PrefferredAddressInd = 'Y'


INSERT INTO AddressHistory(AccountID, DebtorID, DateChanged, UserChanged, 
	OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1, NewStreet2,
	NewCity, NewState, NewZipcode)
SELECT  AccountID, DebtorID, DateChanged, UserChanged, OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1,
        NewStreet2, NewCity, NewState, NewZipcode
FROM @address

UPDATE Debtors
SET Street1 = SUBSTRING(a.NewStreet1, 1, 30), street2 = SUBSTRING(a.NewStreet2, 1, 30), City = SUBSTRING(a.NewCity, 1, 30), State = a.NewState, Zipcode = a.NewZipcode
FROM @address a
WHERE debtors.DebtorID = a.DebtorID


UPDATE MASTER
SET Street1 = SUBSTRING(a.NewStreet1, 1, 30),
	Street2 = SUBSTRING(a.NewStreet2, 1, 30),
    City = SUBSTRING(a.NewCity, 1, 30),
    State = a.NewState,
    ZipCode = a.NewZipcode
    FROM @address a
WHERE NUMBER = AccountID AND a.seq = 0

INSERT INTO notes ( number, created, user0, action, result, comment)
SELECT AccountID, GETDATE(), 'USB', 'ADDR', 'UPD', 'Address Updated by client'
FROM @address a

END
GO

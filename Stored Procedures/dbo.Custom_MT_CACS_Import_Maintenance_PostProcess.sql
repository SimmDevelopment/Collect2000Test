SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 5/19/2019
-- Description:	Import and Updates any demographic changes to USBank accounts coming from CACS
-- =============================================
CREATE PROCEDURE [dbo].[Custom_MT_CACS_Import_Maintenance_PostProcess]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
SELECT m.number, (SELECT MAX(seq) FROM debtors WITH (NOLOCK) WHERE Number = m.number) AS LastSEQ, cmccadm.AcctNum,cmccadm.ContactId,cmccbdm.NationalIDNumber,cmccbdm.FirstName,cmccbdm.MiddleName,cmccbdm.LastName,
	cmccbdm.Suffix,CASE WHEN cmccbdm.DateofBirth = '00000000' THEN NULL ELSE cmccbdm.DateOfBirth END AS DateOfBirth,cmccbdm.ISOLanguageCode,cmccadm.ResponsibleParty, cmccbdm.Name, cmccbdm.Employer, cmccam.AddressLine1, cmccam.AddressLine2, cmccam.AddressLine3,
	cmccam.City, cmccam.State, cmccam.PostalCode, cmccam.County, cmccam.Country, cmccem.EmailAddr, cmccam.ExternalKey
FROM Custom_MT_CACS_Contact_Account_Data_Maintenance cmccadm WITH (NOLOCK)
INNER JOIN Custom_MT_CACS_Contact_Base_Data_Maintenance cmccbdm  WITH (NOLOCK) ON cmccadm.ContactID = cmccbdm.contactid
LEFT OUTER JOIN Custom_MT_CACS_Contact_Email_Maintenance cmccem WITH (NOLOCK) ON cmccadm.ContactID = cmccem.ContactID
LEFT OUTER JOIN Custom_MT_CACS_Contact_Address_Maintenance cmccam WITH (NOLOCK) ON cmccadm.ContactID = cmccam.ContactId
INNER JOIN master m WITH (NOLOCK) ON cmccadm.AcctNum = m.account
WHERE cmccadm.ContactID NOT IN (SELECT CONVERT(VARCHAR(35), debtormemo) FROM Debtors d WITH (NOLOCK) 
	INNER JOIN master m WITH (NOLOCK) ON d.number = m.number 
		WHERE m.customer in ('0003107','0003109'))
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
SELECT number, GETDATE(), 'M&T', 'CODBTR', 'ADD', 'New Responsible party added'
FROM @CoDebtors cd

DECLARE @Phones TABLE (Number INT, PhoneTypeID INT, PhoneStatusID INT,OnHold BIT,PhoneNumber VARCHAR(30),PhoneExt VARCHAR(10)
							,DebtorID INT,DateAdded DATETIME,LoginName VARCHAR(10), PhoneName VARCHAR(50))
						
--Insert New Phone numbers sent from US Bank
INSERT INTO @Phones (Number,PhoneTypeID,PhoneStatusID,OnHold,PhoneNumber,PhoneExt,DebtorID,DateAdded,LoginName, PhoneName)
SELECT d.number,
	CASE WHEN cmccpm.PhoneType IN ('P') THEN 1
		 WHEN cmccpm.PhoneType= 'E' THEN 2
		 WHEN cmccpm.PhoneType= 'C' THEN 3
		 WHEN cmccpm.PhoneType= 'X' THEN 4
		 WHEN cmccpm.PhoneType= 'A' THEN 47
		 WHEN cmccpm.PhoneType= 'F'  THEN 14
		 WHEN cmccpm.PhoneType= 'G' THEN 60
		 WHEN cmccpm.PhoneType= 'O' THEN 55
		 WHEN cmccpm.PhoneType= 'R' THEN 7
		 WHEN cmccpm.PhoneType= 'Y' THEN 49 
		 ELSE 55 END AS PhoneTypeID,
	0 AS PhoneStatusID,
	'' AS OnHold,
	cmccpm.PhoneNumber AS PhoneNumber,
	ISNULL(cmccpm.Extension,'') AS PhoneExt,
	d.debtorID as DebtorId,
	GETDATE() AS DateAdded,
	'M&TUPDT' AS LoginName,
	cmccpm.ExternalKey
FROM Custom_MT_CACS_Contact_Phone_Maintenance cmccpm
INNER JOIN master m ON cmccpm.AcctNumber=m.account
INNER JOIN debtors d ON m.number=d.number and CONVERT(VARCHAR(100),d.debtormemo)=cmccpm.ContactID
WHERE m.customer in ('0003107','0003109')
AND cmccpm.PhoneNumber NOT IN (SELECT phonenumber FROM Phones_Master pm WITH (NOLOCK) WHERE DebtorID = pm.DebtorID)

INSERT INTO Phones_Master ( Number, PhoneTypeID, PhoneStatusID, OnHold, PhoneNumber, PhoneExt, DebtorID,
                             DateAdded, LoginName, PhoneName)
SELECT  Number, PhoneTypeID, PhoneStatusID, OnHold, PhoneNumber, PhoneExt, DebtorID, DateAdded, LoginName, PhoneName 
FROM @Phones

INSERT INTO notes ( number, created, user0, action, result, comment)
SELECT number, GETDATE(), 'M&T', 'PHONES', 'ADD', 'New Phone Numbers added by client'
FROM @Phones

--Update Email Address
DECLARE @email TABLE (Number INT, DebtorID INT, DateAdded DATETIME, UserChanged VARCHAR(50), OldEmail VARCHAR(50), NewEmail VARCHAR(50))

INSERT INTO @email (Number , DebtorID , DateAdded, UserChanged , OldEmail , NewEmail )
SELECT DISTINCT m.number, d.DebtorID, GETDATE(), 'M&TBank', d.Email, cmccem.EmailAddr	
FROM Debtors d WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON d.number = m.number INNER JOIN Custom_MT_CACS_Contact_Email_Maintenance cmccem WITH (NOLOCK) ON CONVERT(VARCHAR(35), DebtorMemo) = cmccem.ContactId
WHERE d.Email <> cmccem.EmailAddr


INSERT INTO EmailHistory
	(AccountID, DebtorID, DateChanged, UserChanged, OldEmail, NewEmail)
SELECT *
FROM @email

UPDATE Debtors
SET email = newemail
FROM @email e
WHERE debtors.DebtorID = e.debtorid

INSERT INTO notes ( number, created, user0, action, result, comment)
SELECT number, GETDATE(), 'M&T', 'EMAIL', 'UPD', 'Email Address Added or Updated by client'
FROM @email

--Update Debtor Address
DECLARE @address TABLE (AccountID INT, DebtorID INT, SEQ INT, DateChanged DATETIME, UserChanged VARCHAR(50), 
	OldStreet1 VARCHAR(50), OldStreet2 VARCHAR(50), OldCity VARCHAR(50), OldState VARCHAR(50), OldZipcode VARCHAR(50), 
	NewStreet1 VARCHAR(50), NewStreet2 VARCHAR(50),	NewCity VARCHAR(50), NewState VARCHAR(50), NewZipcode VARCHAR(50))
	
INSERT INTO @address ( AccountID, DebtorID, SEQ, DateChanged, UserChanged, OldStreet1, OldStreet2, OldCity, OldState,
                        OldZipcode, NewStreet1, NewStreet2, NewCity, NewState, NewZipcode )
                        
SELECT DISTINCT d.Number, d.DebtorID, d.seq, GETDATE(), 'M&TBank', d.Street1, d.Street2, d.City, d.state, d.Zipcode, 
	cmccam.AddressLine1, cmccam.AddressLine2 + ' ' + cmccam.AddressLine3,  cmccam.City,  cmccam.State, REPLACE(cmccam.PostalCode, '-', '')
FROM Debtors d WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON d.number = m.number 
INNER JOIN Custom_MT_CACS_Contact_Address_Maintenance cmccam  WITH (NOLOCK) ON CONVERT(VARCHAR(35), DebtorMemo) = cmccam.ContactId
WHERE d.Street1 <> cmccam.AddressLine1 OR d.street2 <> cmccam.AddressLine2 + ' ' + cmccam.AddressLine3 OR d.City <> cmccam.City OR d.State <> cmccam.State
OR REPLACE(d.Zipcode, '-', '') <> REPLACE(cmccam.PostalCode, '-', '')


INSERT INTO AddressHistory(AccountID, DebtorID, DateChanged, UserChanged, 
	OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1, NewStreet2,
	NewCity, NewState, NewZipcode)
SELECT  AccountID, DebtorID, DateChanged, UserChanged, OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1,
        NewStreet2, NewCity, NewState, NewZipcode
FROM @address

UPDATE Debtors
SET Street1 = a.NewStreet1, street2 = a.NewStreet2, City = a.NewCity, State = a.NewState, Zipcode = a.NewZipcode
FROM @address a
WHERE debtors.DebtorID = a.DebtorID


UPDATE MASTER
SET Street1 = a.NewStreet1,
	Street2 = a.NewStreet2,
    City = a.NewCity,
    State = a.NewState,
    ZipCode = a.NewZipcode
    FROM @address a
WHERE NUMBER = AccountID AND a.seq = 0

INSERT INTO notes ( number, created, user0, action, result, comment)
SELECT AccountID, GETDATE(), 'M&TBank', 'ADDR', 'UPD', 'Address Updated by client'
FROM @address a

END
GO

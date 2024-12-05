SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 12/06/2023
-- Description:	Export via Exchange Consumer Detail doc for Equabli
-- Changes:		12/8/2023 BGM Configured for V3.4
--		01/04/2024 BGM per results of 12/20/23 return file, adjusted client consumer number to return max 10 digits
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_ConDetail_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	Exec Custom_Equabli_Export_ConDetail_V34 '20231219', '20231219'

SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
	SELECT 'condetail' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.equabliClientID') AS equabliClientId
	, CASE WHEN D.seq = 0 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.clientConsumerNumber') 
			WHEN d.seq = 1 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.1.clientConsumerNumber') 
			WHEN d.seq = 2 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.2.clientConsumerNumber') END AS clientConsumerNumber
	, d.DebtorMemo AS equabliConsumerId
	, CASE WHEN D.seq = 0 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.contactType') 
			WHEN d.seq = 1 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.1.contactType')
			WHEN d.seq = 2 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.2.contactType') END AS contactType
, ISNULL(d.firstName, '') AS firstName
, ISNULL(d.middleName, '') AS middleName
, ISNULL(d.lastName, '') AS lastName
, ISNULL(d.businessName, '') AS businessName
, ISNULL(d.suffix, '') AS contactSuffix
, ISNULL(d.SSN, '') AS identificationNumber
, FORMAT(d.DOB, 'yyyy-MM-dd') AS dateOfBirth
, CASE WHEN status = 'DEC' THEN (SELECT TOP 1 FORMAT(DOD, 'yyyy-MM-dd') FROM deceased WITH (NOLOCK) WHERE DebtorID = d.DebtorID) ELSE '' END AS dateOfDeath
, '' AS serviceBranch
, CASE WHEN status = 'MIL' THEN 'Y' ELSE 'N' END AS militaryStatus
, CASE WHEN status = 'MIL' THEN ISNULL(FORMAT(csh.ActiveDutyBeginDate, 'yyyy-MM-dd'), '') ELSE '' END AS activeDutyStartDate
, CASE WHEN status = 'MIL' THEN ISNULL(FORMAT(csh.ActiveDutyEndDate, 'yyyy-MM-dd'), '') ELSE '' END AS activeDutyEndDate
, '' AS contactAlias
, CASE WHEN SUBSTRING(D.DLNum, 1, 2) IN (SELECT code FROM states WITH (NOLOCK) ) THEN SUBSTRING(D.dlnum, 4, LEN(d.DLNum)) ELSE '' END AS driversLicenseNumber
, CASE WHEN SUBSTRING(D.DLNum, 1, 2) IN (SELECT code FROM states WITH (NOLOCK) ) THEN SUBSTRING(D.DLNum, 1, 2) ELSE '' END AS driversLicenseStateCode
, CASE d.language
			WHEN '0001 - ENGLISH' THEN 'EN'
			WHEN '0002 - SPANISH' THEN 'ES'
			WHEN '0009 - GERMAN' THEN 'DE'
			WHEN '0008 - FRENCH' THEN 'FR'
			ELSE '' END AS preferredLanguage
, '' AS contactDescription
, ISNULL(d.Street1, '') AS address1
, ISNULL(d.Street2, '') AS address2
, ISNULL(d.City, '') AS city
, '' AS country
, ISNULL(d.State, '') AS stateCode
, ISNULL(d.Zipcode, '') AS zip
, '' AS addressStatus
, '' AS addressType
, '' AS addressUpdateDate
, '' AS primaryAddress
, '' AS phoneNumber
, '' AS phoneType
, '' AS isPrimaryPhone
, '' AS doNotCallFlag
, '' AS isPhoneConsent
, '' AS phoneConsentDateTime
, '' AS phoneStatus
, '' AS phoneUpdateDateTime
, '' AS emailAddress
, '' AS emailWorkflag
, '' AS emailOptoutFlag
, '' AS emailValidity
, '' AS isEmailConsent
, '' AS emailConsentDateTime
, '' AS statusCode
, '' AS isPrimaryEmail
, '' AS isConsumerActive
, '' AS isAuthorisedPayer
, '' AS isSCRA
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
LEFT OUTER JOIN Custom_SCRA_History csh WITH (NOLOCK) ON d.DebtorID = csh.DebtorID
WHERE m.customer IN (3101, 3102, 3103, 3104, 3105)
--m.customer IN (Select customerid from fact where customgroupid = 381) 
AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND status IN ('DEC', 'MIL')

UNION ALL

--Attorney Info
SELECT 'condetail' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.equabliClientID') AS equabliClientId
, RIGHT(CONVERT(VARCHAR(10), da.ID), 10) AS clientConsumerNumber
--, CASE WHEN D.seq = 0 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.clientConsumerNumber') 
--			WHEN d.seq = 1 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.1.clientConsumerNumber') 
--			WHEN d.seq = 2 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.2.clientConsumerNumber') END AS clientConsumerNumber
, d.DebtorMemo AS equabliConsumerId
, CASE WHEN m.status IN ('LIT') THEN '12' ELSE '42' END AS contactType
, dbo.GetFirstName(da.Name) AS firstName
, '' AS middleName
, dbo.GetLastName(da.Name) AS lastName
, ISNULL(da.Firm, '') AS businessName
, '' AS contactSuffix
, '' AS identificationNumber
, '' AS dateOfBirth
, '' AS dateOfDeath
, '' AS serviceBranch
, 'N' AS militaryStatus
, '' AS activeDutyStartDate
, '' AS activeDutyEndDate
, '' AS contactAlias
, '' AS driversLicenseNumber
, '' AS driversLicenseStateCode
, '' AS preferredLanguage
, '' AS contactDescription
, ISNULL(da.Addr1, '') AS address1
, ISNULL(da.Addr2, '') AS address2
, ISNULL(da.City, '') AS city
, '' AS country
, ISNULL(da.State, '') AS stateCode
, ISNULL(da.Zipcode, '') AS zip
, '' AS addressStatus
, '' AS addressType
, '' AS addressUpdateDate
, '' AS primaryAddress
, ISNULL(da.Phone, '') AS phoneNumber
, '' AS phoneType
, '' AS isPrimaryPhone
, '' AS doNotCallFlag
, '' AS isPhoneConsent
, '' AS phoneConsentDateTime
, '' AS phoneStatus
, '' AS phoneUpdateDateTime
, ISNULL(da.Email, '') AS emailAddress
, '' AS emailWorkflag
, '' AS emailOptoutFlag
, '' AS emailValidity
, '' AS isEmailConsent
, '' AS emailConsentDateTime
, '' AS statusCode
, '' AS isPrimaryEmail
, '' AS isConsumerActive
, '' AS isAuthorisedPayer
, '' AS isSCRA
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE m.customer IN (3101, 3102, 3103, 3104, 3105)
--m.customer IN (Select customerid from fact where customgroupid = 381) 
AND ((d.DebtorID IN (SELECT b.DebtorID FROM Bankruptcy b WITH (NOLOCK) WHERE d.Number = b.AccountID AND 
(CAST(b.CreatedDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)) OR (CAST(b.UpdatedDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)))
AND (CAST(da.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) OR (CAST(da.DateUpdated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))))
OR
(m.status = 'LIT' AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)) )
UNION ALL

--Debt Settlement or CCCS added or updated
SELECT 'condetail' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.equabliClientID') AS equabliClientId
, RIGHT(CONVERT(VARCHAR(10), c.ID), 10) AS clientConsumerNumber
--, CASE WHEN D.seq = 0 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.clientConsumerNumber') 
--			WHEN d.seq = 1 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.1.clientConsumerNumber') 
--			WHEN d.seq = 2 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.2.clientConsumerNumber') END AS clientConsumerNumber
, d.DebtorMemo AS equabliConsumerId
, '42' AS contactType
, dbo.GetFirstName(c.Contact) AS firstName
, '' AS middleName
, dbo.GetLastName(c.Contact) AS lastName
, ISNULL(c.CompanyName, '') AS businessName
, '' AS contactSuffix
, '' AS identificationNumber
, '' AS dateOfBirth
, '' AS dateOfDeath
, '' AS serviceBranch
, 'N' AS militaryStatus
, '' AS activeDutyStartDate
, '' AS activeDutyEndDate
, '' AS contactAlias
, '' AS driversLicenseNumber
, '' AS driversLicenseStateCode
, '' AS preferredLanguage
, '' AS contactDescription
, ISNULL(c.Street1, '') AS address1
, ISNULL(c.Street2, '') AS address2
, ISNULL(c.City, '') AS city
, '' AS country
, ISNULL(c.State, '') AS stateCode
, ISNULL(c.Zipcode, '') AS zip
, '' AS addressStatus
, '' AS addressType
, '' AS addressUpdateDate
, '' AS primaryAddress
, '' AS phoneNumber
, '' AS phoneType
, '' AS isPrimaryPhone
, '' AS doNotCallFlag
, '' AS isPhoneConsent
, '' AS phoneConsentDateTime
, '' AS phoneStatus
, '' AS phoneUpdateDateTime
, '' AS emailAddress
, '' AS emailWorkflag
, '' AS emailOptoutFlag
, '' AS emailValidity
, '' AS isEmailConsent
, '' AS emailConsentDateTime
, '' AS statusCode
, '' AS isPrimaryEmail
, '' AS isConsumerActive
, '' AS isAuthorisedPayer
, '' AS isSCRA
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number INNER JOIN CCCS c WITH (NOLOCK) ON d.DebtorID = c.DebtorID
WHERE m.customer IN (3101, 3102, 3103, 3104, 3105)
--Bankruptcy Attorney Added
AND (CAST(c.datecreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) OR 
CAST(c.DateModified AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
--m.customer IN (Select customerid from fact where customgroupid = 381) 
--AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND status IN ('DEC', 'MIL')


END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Custom_SunTrust_CACS_Demographic_File_Outgoing] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--exec Custom_USBank_Demographic_File_Outgoing '20190425', '20190425'
--SET @startDate = '20190411'
--SET @endDate = '20190411'

SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

--Address Changes
SELECT DISTINCT CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID, '2' AS ContactRecordType, d.SpouseJobName AS ExternalKey,--'SIMM    ' AS ExtKeyPT1, CONVERT(VARCHAR(19), m.account) AS ExtKeyPT2, CONVERT(VARCHAR(9), ah.ID) AS ExtKeyPT3,
'C' AS ActionCode, '' AS NickName, '1' AS AddressRelation, 'C' AS AddressStatus, '' AS SeasonalFrom, '' AS SeasonalTo, 'N' AS AddressBlock, '1' AS PrefAddressInd,
'Y' AS CBRAddress, CONVERT(VARCHAR(8), ah.DateChanged, 112) AS CBRAddressDateUpdated, ah.NewStreet1 AS Address1, ISNULL(ah.newstreet2, '') AS Address2, '' AS Address3, ah.NewCity AS City, ah.NewState AS [State],
ah.NewZipcode AS PostalCode, '' AS County, 'US' AS Country, CONVERT(VARCHAR(8), ah.DateChanged, 112) AS ChangeDate, '' AS Filler
FROM master m WITH (NOLOCK) INNER JOIN AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID
INNER JOIN Debtors d WITH (NOLOCK) ON ah.DebtorID = d.DebtorID
WHERE ah.DateChanged BETWEEN @startDate AND @endDate
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 107)

--Phone Changes
SELECT DISTINCT CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID, '3' AS ContactRecordType, d.SpouseJobName AS ExternalKey,--'SIMM    ' AS ExtKeyPT1, CONVERT(VARCHAR(19), m.account) AS ExtKeyPT2, CONVERT(VARCHAR(9), ph.ID) AS ExtKeyPT3,
CASE WHEN ph.NewNumber = '' THEN 'D' WHEN pm.DateAdded BETWEEN @startDate AND @endDate THEN 'A' END  AS ActionCode, '' AS NickName, COALESCE(ph.OldNumber, pm.PhoneNumber) AS PhoneNumber, '' AS Extension, 
CASE COALESCE(ph.Phonetype, pm.PhoneTypeID) WHEN 1 THEN 'P' WHEN 2 THEN 'E' WHEN 3 THEN 'C' WHEN 4 THEN 'X' WHEN 14 THEN 'F' WHEN 60 THEN 'G' ELSE 'O' END AS PhoneType, '01' AS PhoneFormat, 
'V' AS PhoneAvail, CASE WHEN Pm.PhoneStatusID = 1 THEN '0' ELSE '1' END AS PrefPhoneInd, CASE pt.PhoneTypeMapping WHEN 2 THEN 'C' WHEN 3 THEN 'F' ELSE 'L' END  AS ServiceType, CONVERT(VARCHAR(8), COALESCE(ph.DateChanged, pm.DateAdded), 112) AS PhoneChangeDate, 
' ' AS ChangeInd, CASE WHEN pm.PhoneStatusID = 3 THEN 'Y' ELSE 'N' END AS DoNotCont
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
LEFT OUTER JOIN PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
LEFT OUTER JOIN Phones_Master pm WITH (NOLOCK) ON d.DebtorID = pm.DebtorID
INNER JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE (ph.DateChanged BETWEEN @startDate AND @endDate OR pm.DateAdded BETWEEN @startDate AND @endDate)
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 107)
AND pm.LoginName <> 'SYNC'

--Email Changes
--SELECT DISTINCT CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID, '4' AS ContactRecordType, 'SIMM    ' AS ExtKeyPT1, CONVERT(VARCHAR(19), m.account) AS ExtKeyPT2, CONVERT(VARCHAR(9), eh.ID) AS ExtKeyPT3,
--'TBD' AS ActionCode, '' AS NickName, COALESCE(eh.OldEmail, eh.NewEmail) AS Email, 'P' AS EmailType, 'P' AS EmailAvail, 
--'1' AS PrefEmailInd, CONVERT(VARCHAR(8), eh.DateChanged, 112) AS EmailChangeDate, ' ' AS ChangeInd
--FROM master m WITH (NOLOCK) INNER JOIN EmailHistory eh WITH (NOLOCK) ON m.number = eh.AccountID
--INNER JOIN Debtors d WITH (NOLOCK) ON eh.DebtorID = d.DebtorID
--WHERE eh.DateChanged BETWEEN @startDate AND @endDate
--AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 106)

--Email Add
SELECT CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID, '4' AS ContactRecordType, ISNULL((SELECT DISTINCT externalkey FROM Custom_SunTrust_CACS_Contact_Email_History WITH (NOLOCK) WHERE AcctNumber = m.account AND ContactID = CONVERT(VARCHAR(25), d.DebtorMemo) AND eh.oldemail = EmailAddr), 
 'SIMM    ' + CONVERT(VARCHAR(19), m.account) + CONVERT(VARCHAR(9), eh.ID)) AS ExternalKey,
CASE WHEN OldEmail = '' AND newemail <> '' THEN 'A' WHEN OldEmail <> '' AND NewEmail = '' THEN 'D' ELSE 'C' END AS ActionCode, '' AS NickName, 
CASE WHEN OldEmail = '' AND newemail <> '' THEN eh.NewEmail WHEN OldEmail <> '' AND NewEmail = '' THEN eh.OldEmail WHEN eh.NewEmail = '' THEN eh.OldEmail ELSE eh.NewEmail END  AS Email, 'P' AS EmailType, 'P' AS EmailAvail, 
CASE WHEN d.Email = eh.NewEmail THEN 1 ELSE 0 END AS PrefEmailInd, CONVERT(VARCHAR(8), eh.DateChanged, 112) AS EmailChangeDate, ' ' AS ChangeInd
FROM master m WITH (NOLOCK) INNER JOIN EmailHistory eh WITH (NOLOCK) ON m.number = eh.AccountID
INNER JOIN Debtors d WITH (NOLOCK) ON eh.DebtorID = d.DebtorID
WHERE eh.DateChanged BETWEEN @startDate AND @endDate AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 107)




END
GO
